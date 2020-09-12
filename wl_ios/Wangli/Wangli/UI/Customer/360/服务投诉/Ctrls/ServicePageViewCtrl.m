

//
//  ServicePageViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ServicePageViewCtrl.h"
#import "PurchaseCollectionView.h"
#import "PurchaseListTitleView.h"
#import "ServicePageConsultationViewCtrl.h"
#import "ServicePageComplaintViewCtrl.h"
#import "ServicePageApplicationViewCtrl.h"
#import "ServicePageProblemViewCtrl.h"
#import "CreateComplaintViewCtrl.h"
//#import "PersonnelPageDemandViewCtrl.h"
#import "CreateConsulationViewCtrl.h"

@interface ServicePageViewCtrl () <UIScrollViewDelegate, PurchaseCollectionViewDelegate>

@property (nonatomic, strong) PurchaseListTitleView *segmentView;
@property (nonatomic, strong) PurchaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrCardData;
@property (nonatomic, assign) NSInteger currentTag;

@end

@implementation ServicePageViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_B0;
    _currentTag = 0;
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.pageScrollView reloadData];
    
    self.pageScrollView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kRefreshDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pageScrollView.mainTableView.mj_header endRefreshing];
            
            // 取出当前显示的listView
            GKBaseListViewController *currentListVC = self.childVCs[_currentTag];
            
            // 模拟下拉刷新
            currentListVC.count = 30;
            [currentListVC.tableView reloadData];
        });
    }];
    
    self.collectionView.arrCardData = self.arrCardData;
    [self.collectionView reloadData];
    if (self.arrCardData.count > 0) {
        PurchaseItemMo *purchaseItemMo = self.arrCardData[0];
        [self.segmentView setupTitle:purchaseItemMo.fieldValue count:purchaseItemMo.count];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.topHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, _collectionView.collectionViewLayout.collectionViewContentSize.height);
        [self.pageScrollView refreshHeaderView];
    });
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
//    _segmentView.btnAdd.hidden = _currentTag == 1 ? NO : YES;
}

#pragma mark - event

- (void)itemAddClick:(UIButton *)sender {
    if (_currentTag == 0) {
        CreateConsulationViewCtrl *vc = [[CreateConsulationViewCtrl alloc] init];
        vc.title = @"新建咨询";
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
    if (_currentTag == 1) {
        CreateComplaintViewCtrl *vc = [[CreateComplaintViewCtrl alloc] init];
        vc.title = @"新建投诉";
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
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
        CGFloat scrollH = kScreenH - kNavBarHeight - kBaseSegmentHeight;
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
//        PersonnelPageDemandViewCtrl *page00 = [PersonnelPageDemandViewCtrl new];
        ServicePageConsultationViewCtrl *page0 = [ServicePageConsultationViewCtrl new];
        ServicePageComplaintViewCtrl *page1 = [ServicePageComplaintViewCtrl new];
        ServicePageApplicationViewCtrl *page2 = [ServicePageApplicationViewCtrl new];
        ServicePageProblemViewCtrl *page3 = [ServicePageProblemViewCtrl new];
        _childVCs = @[page0, page1, page2, page3];
    }
    return _childVCs;
}

- (NSMutableArray *)arrCardData {
    if (!_arrCardData) {
        _arrCardData = [NSMutableArray new];
        
//        PurchaseItemMo *mo0 = [[PurchaseItemMo alloc] init];
//        mo0.iconUrl = @"customer_consultation";
//        mo0.fieldValue = @"客户咨询测试";
//        mo0.count = 0;
//        [_arrCardData addObject:mo0];
        
        PurchaseItemMo *mo1 = [[PurchaseItemMo alloc] init];
        mo1.iconUrl = @"customer_consultation";
        mo1.fieldValue = @"客户咨询";
        mo1.count = 0;
        [_arrCardData addObject:mo1];
        
        PurchaseItemMo *mo2 = [[PurchaseItemMo alloc] init];
        mo2.iconUrl = @"customer_complaints";
        mo2.fieldValue = @"客户投诉";
        mo2.count = 1;
        [_arrCardData addObject:mo2];
        
        PurchaseItemMo *mo3 = [[PurchaseItemMo alloc] init];
        mo3.iconUrl = @"returned_goods";
        mo3.fieldValue = @"退货-换货-补片-降档申请";
        mo3.count = 2;
        [_arrCardData addObject:mo3];
        
        PurchaseItemMo *mo4 = [[PurchaseItemMo alloc] init];
        mo4.iconUrl = @"common_problem";
        mo4.fieldValue = @"常见问题";
        mo4.count = 0;
        [_arrCardData addObject:mo4];
    }
    return _arrCardData;
}

@end
