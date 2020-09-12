//
//  ProducePageViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ProducePageViewCtrl.h"
#import "PurchaseListTitleView.h"
#import "ProducePageStandardViewCtrl.h"
#import "ProducePageProductViewCtrl.h"
#import "ProducePageFactoryViewCtrl.h"
#import "ProducePageCapacityViewCtrl.h"
#import "ProducePageComponentViewCtrl.h"
#import "ProducePageQualityViewCtrl.h"
#import "ProducePageIQCViewCtrl.h"
#import "ProducePageStatusViewCtrl.h"
#import "ProducePageCTMViewCtrl.h"
#import "PurchaseCollectionView.h"
#import "ProduceCommonCreateViewCtrl.h"

@interface ProducePageViewCtrl () <UIScrollViewDelegate, PurchaseCollectionViewDelegate>

@property (nonatomic, strong) PurchaseListTitleView *segmentView;
@property (nonatomic, strong) PurchaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrCardData;
@property (nonatomic, assign) NSInteger currentTag;

@end

@implementation ProducePageViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_B0;
    _currentTag = 0;
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initHeader];
    [self.pageScrollView reloadData];
    [self addMainRefresh];
    [self.pageScrollView.mainTableView.mj_header beginRefreshing];
}

- (void)addMainRefresh {
    self.pageScrollView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //创建队列组
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            [self selfRefresh];
        });
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            [self childVCRefresh];
        });
        //当所有的任务都完成后会发送这个通知
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self.pageScrollView.mainTableView.mj_header endRefreshing];
            for (int i = 0; i < self.childVCs.count; i++) {
                PurchaseItemMo *tmpMo = self.arrCardData[i];
                GKBaseListViewController *vc = _childVCs[i];
                vc.segTitle = tmpMo.fieldValue;
            }
            PurchaseItemMo *purchaseItemMo = self.arrCardData[_currentTag];
            [self.segmentView setupTitle:purchaseItemMo.fieldValue count:purchaseItemMo.count];
        });
    }];
}

- (void)selfRefresh {
    NSLog(@"获取九宫格数据");
    [[JYUserApi sharedInstance] getProductSummaryNumberByMemberId:TheCustomer.customerMo.id key:self.currentDic.key param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.arrCardData = [PurchaseItemMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self initHeader];
    } failure:^(NSError *error) {
        [self initHeader];
    }];
}

- (void)initHeader {
    self.collectionView.arrCardData = self.arrCardData;
    [self.collectionView reloadData];
    if (self.arrCardData.count > 0) {
        PurchaseItemMo *purchaseItemMo = self.arrCardData[_currentTag];
        [self.segmentView setupTitle:purchaseItemMo.fieldValue count:purchaseItemMo.count];
    }
    self.topHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, _collectionView.collectionViewLayout.collectionViewContentSize.height);
    [self.pageScrollView refreshHeaderView];
}

- (void)childVCRefresh {
    // 取出当前显示的listView
    GKBaseListViewController *currentListVC = self.childVCs[_currentTag];
    currentListVC.currentDic = self.currentDic;
    [currentListVC addHeaderRefresh];
}

#pragma mark - GKPageScrollViewDelegate
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.topHeader;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.pageView;
}

- (NSArray<id<GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.childVCs;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
    
    if (_contentScrollView == scrollView) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        if (index >= 0 && index < self.arrCardData.count) {
            if (_currentTag != index) {
                _currentTag = index;
                PurchaseItemMo *purchaseItemMo = self.arrCardData[_currentTag];
                [self.segmentView setupTitle:purchaseItemMo.fieldValue count:purchaseItemMo.count];
                [self refreshIfNoData];
            }
        }
    }
}

#pragma mark - PurchaseCollectionViewDelegate

- (void)purchaseCollectionView:(PurchaseCollectionView *)purchaseCollectionView didSelectedIndexPath:(NSIndexPath *)indexPath purchaseItemMo:(PurchaseItemMo *)purchaseItemMo {
    _currentTag = indexPath.item;
    [self.contentScrollView setContentOffset:CGPointMake(_currentTag*kScreenW, 0) animated:NO];
    [_segmentView setupTitle:purchaseItemMo.fieldValue count:purchaseItemMo.count];
    if ([purchaseItemMo.field isEqualToString:@"IqcMaterial"]||
        [purchaseItemMo.field isEqualToString:@"PutIntoProduct"]||
        [purchaseItemMo.field isEqualToString:@"CtmReport"]) {
        _segmentView.btnAdd.hidden = YES;
    } else {
        _segmentView.btnAdd.hidden = NO;
    }
    [self refreshIfNoData];
}

- (void)refreshIfNoData {
    // 如果没有数据就刷新
    GKBaseListViewController *currentListVC = self.childVCs[_currentTag];
    if (currentListVC.arrData.count == 0) {
        //创建队列组
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            [self childVCRefresh];
        });
        //当所有的任务都完成后会发送这个通知
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            PurchaseItemMo *purchaseItemMo = self.arrCardData[_currentTag];
            [self.segmentView setupTitle:purchaseItemMo.fieldValue count:purchaseItemMo.count];
        });
    }
}

- (void)setCurrentDic:(DicMo *)currentDic {
    _currentDic = currentDic;
    for (GKBaseListViewController *vc in self.childVCs) {
        vc.currentDic = _currentDic;
    }
}

#pragma mark - event

- (void)itemAddClick:(UIButton *)sender {
    NSArray *dynamicIds = @[K_PRODUCT_STANDARD,
                            K_PRODUCT_PRODUCT,
                            K_PRODUCT_FACTORY,
                            K_PRODUCT_CAPACITY,
                            K_PRODUCT_COMPONENT,
                            K_PRODUCT_QUALITY,
                            K_PRODUCT_IQC,
                            K_PRODUCT_PUTINTO,
                            K_PRODUCT_CTM];
    
    PurchaseItemMo *mo = self.arrCardData[_currentTag];
    ProduceCommonCreateViewCtrl *vc = [[ProduceCommonCreateViewCtrl alloc] init];
    vc.fromTab = NO;
    vc.dynamicId = STRING(dynamicIds[_currentTag]);
    vc.title = [NSString stringWithFormat:@"新建%@", mo.fieldValue];
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself.pageScrollView.mainTableView.mj_header beginRefreshing];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载

- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageScrollView.ceilPointHeight = 0;
        _pageScrollView.backgroundColor = COLOR_B0;
    }
    return _pageScrollView;
}

- (UIView *)topHeader {
    if (!_topHeader) {
        _topHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _topHeader.backgroundColor = COLOR_C2;
        [_topHeader addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(_topHeader);
        }];
    }
    return _topHeader;
}

- (PurchaseCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[PurchaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.purchaseCollectionViewDelegate = self;
        _collectionView.arrCardData = self.arrCardData;
    }
    return _collectionView;
}

- (PurchaseListTitleView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[PurchaseListTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kBaseSegmentHeight)];
        [_segmentView.btnAdd addTarget:self action:@selector(itemAddClick:) forControlEvents:UIControlEventTouchUpInside];
        _segmentView.backgroundColor = COLOR_B0;
//        _segmentView.btnAdd.hidden = YES;
    }
    return _segmentView;
}

- (UIView *)pageView {
    if (!_pageView) {
        _pageView = [UIView new];
        [_pageView addSubview:self.segmentView];
        [_pageView addSubview:self.contentScrollView];
    }
    return _pageView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        CGFloat scrollW = kScreenW;
        CGFloat scrollH = kScreenH - kNavBarHeight - kBaseSegmentHeight-kBaseSwitchHeight;
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kBaseSegmentHeight, scrollW, scrollH)];
        _contentScrollView.backgroundColor = COLOR_B0;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
        
        [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:vc];
            [self->_contentScrollView addSubview:vc.view];
            vc.view.frame = CGRectMake(idx * scrollW, 0, scrollW, scrollH);
        }];
        _contentScrollView.contentSize = CGSizeMake(scrollW * self.childVCs.count, 0);
    }
    return _contentScrollView;
}

- (NSArray *)childVCs {
    if (!_childVCs) {
        ProducePageStandardViewCtrl *page0 = [ProducePageStandardViewCtrl new];
        ProducePageProductViewCtrl *page1 = [ProducePageProductViewCtrl new];
        ProducePageFactoryViewCtrl *page2 = [ProducePageFactoryViewCtrl new];
        ProducePageCapacityViewCtrl *page3 = [ProducePageCapacityViewCtrl new];
        ProducePageComponentViewCtrl *page8 = [ProducePageComponentViewCtrl new];
        ProducePageQualityViewCtrl *page4 = [ProducePageQualityViewCtrl new];
        ProducePageIQCViewCtrl *page5 = [ProducePageIQCViewCtrl new];
        ProducePageStatusViewCtrl *page6 = [ProducePageStatusViewCtrl new];
        ProducePageCTMViewCtrl *page7 = [ProducePageCTMViewCtrl new];
        _childVCs = @[page0, page1, page2, page3,page8, page4, page5, page6, page7];
        
        for (int i = 0; i < _childVCs.count; i++) {
            PurchaseItemMo *tmpMo = self.arrCardData[i];
            GKBaseListViewController *vc = _childVCs[i];
            vc.segTitle = tmpMo.fieldValue;
        }
    }
    return _childVCs;
}

- (NSMutableArray *)arrCardData {
    if (!_arrCardData) {
        _arrCardData = [NSMutableArray new];
        
        PurchaseItemMo *mo1 = [[PurchaseItemMo alloc] init];
        mo1.iconUrl = @"c_production_standard";
        mo1.fieldValue = @"生产标准";
        mo1.count = 0;
        mo1.newCount = 1;
        [_arrCardData addObject:mo1];
        
        PurchaseItemMo *mo2 = [[PurchaseItemMo alloc] init];
        mo2.iconUrl = @"c_poduct_information";
        mo2.fieldValue = @"产品信息";
        mo2.count = 1;
        mo2.newCount = 10;
        [_arrCardData addObject:mo2];
        
        PurchaseItemMo *mo3 = [[PurchaseItemMo alloc] init];
        mo3.iconUrl = @"c_poduct_equipment";
        mo3.fieldValue = @"工厂设备";
        mo3.count = 2;
        mo3.newCount = 31;
        [_arrCardData addObject:mo3];
        
        PurchaseItemMo *mo4 = [[PurchaseItemMo alloc] init];
        mo4.iconUrl = @"c_poduct_capacity";
        mo4.fieldValue = @"产能信息";
        mo4.count = 0;
        mo4.newCount = 55;
        [_arrCardData addObject:mo4];
        
        PurchaseItemMo *mo9 = [[PurchaseItemMo alloc] init];
        mo9.iconUrl = @"c_poduct_component_reliability";
        mo9.fieldValue = @"组件可靠性认证要求";
        mo9.count = 0;
        mo9.newCount = 55;
        [_arrCardData addObject:mo9];
        
        PurchaseItemMo *mo5 = [[PurchaseItemMo alloc] init];
        mo5.iconUrl = @"c_poduct_quality_standard";
        mo5.fieldValue = @"品质标准";
        mo5.count = 0;
        mo5.newCount = 89;
        [_arrCardData addObject:mo5];
        
        PurchaseItemMo *mo6 = [[PurchaseItemMo alloc] init];
        mo6.iconUrl = @"c_iqc";
        mo6.fieldValue = @"IQC来料";
        mo6.count = 0;
        mo6.newCount = 99;
        [_arrCardData addObject:mo6];
        
        PurchaseItemMo *mo7 = [[PurchaseItemMo alloc] init];
        mo7.iconUrl = @"c_poduct_dynamic";
        mo7.fieldValue = @"投诉状况";
        mo7.count = 0;
        mo7.newCount = 100;
        [_arrCardData addObject:mo7];
        
        PurchaseItemMo *mo8 = [[PurchaseItemMo alloc] init];
        mo8.iconUrl = @"ctm";
        mo8.fieldValue = @"CTM报告";
        mo8.count = 0;
        mo8.newCount = 199;
        [_arrCardData addObject:mo8];
    }
    return _arrCardData;
}

@end
