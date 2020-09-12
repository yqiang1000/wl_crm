//
//  ContractPageViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ContractPageViewCtrl.h"
#import "PurchaseCollectionView.h"
#import "PurchaseListTitleView.h"
#import "ContractPageContractViewCtrl.h"
#import "ContractPageOrderViewCtrl.h"
#import "ContractPageShipViewCtrl.h"
#import "ContractPageInvoiceViewCtrl.h"
#import "ContractPageReceiptViewCtrl.h"
#import "ContractPageReconciliationViewCtrl.h"

@interface ContractPageViewCtrl () <UIScrollViewDelegate, PurchaseCollectionViewDelegate>

@property (nonatomic, strong) PurchaseListTitleView *segmentView;
@property (nonatomic, strong) PurchaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrCardData;
@property (nonatomic, assign) NSInteger currentTag;

@end

@implementation ContractPageViewCtrl

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
    [[JYUserApi sharedInstance] getContractSummaryNumberByMemberId:TheCustomer.customerMo.id param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.arrCardData = [PurchaseItemMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self initHeader];
    } failure:^(NSError *error) {
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_contentScrollView == scrollView) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        if (index >= 0 && index < self.arrCardData.count) {
            _currentTag = index;
            PurchaseItemMo *purchaseItemMo = self.arrCardData[_currentTag];
            [self.segmentView setupTitle:purchaseItemMo.fieldValue count:purchaseItemMo.count];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

#pragma mark - PurchaseCollectionViewDelegate

- (void)purchaseCollectionView:(PurchaseCollectionView *)purchaseCollectionView didSelectedIndexPath:(NSIndexPath *)indexPath purchaseItemMo:(PurchaseItemMo *)purchaseItemMo {
    _currentTag = indexPath.item;
    [self.contentScrollView setContentOffset:CGPointMake(_currentTag*kScreenW, 0) animated:NO];
    [_segmentView setupTitle:purchaseItemMo.fieldValue count:purchaseItemMo.count];
    
    GKBaseListViewController *vc = self.childVCs[_currentTag];
    SEL selector = NSSelectorFromString(@"resetFilterAndSwitchView");
    if (vc && [vc respondsToSelector:selector]) {
        [vc performSelector:selector withObject:nil];
    }
}

#pragma mark - event

- (void)itemAddClick:(UIButton *)sender {
    BaseViewCtrl *vc = [BaseViewCtrl new];
    PurchaseItemMo *mo = self.arrCardData[_currentTag];
    vc.title = [NSString stringWithFormat:@"新建%@", mo.fieldValue];
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
        _segmentView.btnAdd.hidden = YES;
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
        ContractPageContractViewCtrl *page0 = [ContractPageContractViewCtrl new];
        ContractPageOrderViewCtrl *page1 = [ContractPageOrderViewCtrl new];
        ContractPageShipViewCtrl *page2 = [ContractPageShipViewCtrl new];
        ContractPageInvoiceViewCtrl *page3 = [ContractPageInvoiceViewCtrl new];
        ContractPageReceiptViewCtrl *page4 = [ContractPageReceiptViewCtrl new];
        ContractPageReconciliationViewCtrl *page5 = [ContractPageReconciliationViewCtrl new];
        _childVCs = @[page0, page1, page2, page3, page4, page5];
        
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
        mo1.iconUrl = @"contract";
        mo1.fieldValue = @"合同";
        mo1.count = 0;
        [_arrCardData addObject:mo1];
        
        PurchaseItemMo *mo2 = [[PurchaseItemMo alloc] init];
        mo2.iconUrl = @"order";
        mo2.fieldValue = @"订单";
        mo2.count = 1;
        [_arrCardData addObject:mo2];
        
        PurchaseItemMo *mo3 = [[PurchaseItemMo alloc] init];
        mo3.iconUrl = @"delivery";
        mo3.fieldValue = @"发货";
        mo3.count = 2;
        [_arrCardData addObject:mo3];
        
        PurchaseItemMo *mo4 = [[PurchaseItemMo alloc] init];
        mo4.iconUrl = @"invoice";
        mo4.fieldValue = @"发票";
        mo4.count = 0;
        [_arrCardData addObject:mo4];
        
        PurchaseItemMo *mo5 = [[PurchaseItemMo alloc] init];
        mo5.iconUrl = @"receivables";
        mo5.fieldValue = @"收款";
        mo5.count = 0;
        [_arrCardData addObject:mo5];
        
        PurchaseItemMo *mo6 = [[PurchaseItemMo alloc] init];
        mo6.iconUrl = @"reconciliation";
        mo6.fieldValue = @"对账";
        mo6.count = 0;
        [_arrCardData addObject:mo6];
    }
    return _arrCardData;
}

@end
