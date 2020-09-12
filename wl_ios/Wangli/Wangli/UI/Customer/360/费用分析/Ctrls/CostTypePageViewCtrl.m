//
//  CostTypePageViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CostTypePageViewCtrl.h"
#import "PurchaseListTitleView.h"
#import "CostTypePageAllViewCtrl.h"
#import "CostTypePageApprovalViewCtrl.h"
#import "CostTypePageApprovedViewCtrl.h"
#import "CostTypeBarView.h"
#import "SwitchView.h"

@interface CostTypePageViewCtrl () <UIScrollViewDelegate, SwitchViewDelegate>

@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) NSMutableArray *arrCardData;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) CostTypeBarView *barView;

@end

@implementation CostTypePageViewCtrl

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

    [self loadData];
    [self.switchView selectIndex:_currentTag];
}

- (void)loadData {
    [self.barView loadData];
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
        if (index >= 0 && index < self.childVCs.count) {
            _currentTag = index;
            [self.switchView selectIndex:_currentTag];
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

#pragma mark - SwitchViewDelegate

- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
    _currentTag = index;
    [switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
    [self.contentScrollView setContentOffset:CGPointMake(_currentTag*kScreenW, 0) animated:NO];
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
        _topHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
        _topHeader.backgroundColor = COLOR_B0;
        [_topHeader addSubview:self.barView];
        [_barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(_topHeader);
        }];
    }
    return _topHeader;
}

- (UIView *)pageView {
    if (!_pageView) {
        _pageView = [UIView new];
        _pageView.backgroundColor = COLOR_B0;
        [_pageView addSubview:self.switchView];
        [_pageView addSubview:self.contentScrollView];
    }
    return _pageView;
}

- (CostTypeBarView *)barView {
    if (!_barView) {
        _barView = [[CostTypeBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
    }
    return _barView;
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
        CostTypePageAllViewCtrl *page0 = [CostTypePageAllViewCtrl new];
        CostTypePageApprovalViewCtrl *page1 = [CostTypePageApprovalViewCtrl new];
        CostTypePageApprovedViewCtrl *page2 = [CostTypePageApprovedViewCtrl new];
        _childVCs = @[page0, page1, page2];
    }
    return _childVCs;
}

- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 42)
                                                 titles:@[@"所有", @"OA审批中", @"已审批"]
                                              imgNormal:@[@"", @"", @""]
                                              imgSelect:@[@"", @"", @""]];
        _switchView.delegate = self;
        _switchView.layer.mask = [Utils drawContentFrame:_switchView.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadius:5];
    }
    return _switchView;
}

@end
