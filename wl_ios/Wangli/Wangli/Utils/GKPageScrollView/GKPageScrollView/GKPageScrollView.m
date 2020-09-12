//
//  GKPageScrollView.m
//  GKPageScrollView
//
//  Created by QuintGao on 2018/10/26.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKPageScrollView.h"

// 是否是iPhone X系列
#define GKPAGE_IS_iPhoneX       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)



// 屏幕宽高
#define GKPAGE_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define GKPAGE_SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
// 导航栏+状态栏高度
#define GKPAGE_NAVBAR_HEIGHT    (GKPAGE_IS_iPhoneX ? 88.0f : 64.0f)

@interface GKPageScrollView()<UITableViewDataSource, UITableViewDelegate>

// 是否滑动到临界点
@property (nonatomic, assign) BOOL              isCriticalPoint;
// mainTableView是否可滑动
@property (nonatomic, assign) BOOL              isMainCanScroll;
// listScrollView是否可滑动
@property (nonatomic, assign) BOOL              isListCanScroll;

// 是否加载
@property (nonatomic, assign) BOOL              isLoaded;

// 当前滑动的listView
@property (nonatomic, weak) UIScrollView        *currentListScrollView;

@end

@implementation GKPageScrollView

- (instancetype)initWithDelegate:(id<GKPageScrollViewDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.ceilPointHeight = GKPAGE_NAVBAR_HEIGHT;
        
        [self initSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mainTableView.frame = self.bounds;
}

- (void)initSubviews {
    self.isCriticalPoint = NO;
    self.isMainCanScroll = YES;
    self.isListCanScroll = NO;
    
    self.mainTableView = [[GKPageTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.backgroundColor = COLOR_B0;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.tableHeaderView = [self.delegate headerViewInPageScrollView:self];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.mainTableView];
    
    // listScrollview滑动处理
    [self configListViewScroll];
}

#pragma mark - Public Methods
- (void)refreshHeaderView {
    self.mainTableView.tableHeaderView = [self.delegate headerViewInPageScrollView:self];
}

- (void)reloadData {
    self.isLoaded = YES;
    
    [self.mainTableView reloadData];
}

- (void)horizonScrollViewWillBeginScroll {
    self.mainTableView.scrollEnabled = NO;
}

- (void)horizonScrollViewDidEndedScroll {
    self.mainTableView.scrollEnabled = YES;
}

#pragma mark - Private Methods
- (void)configListViewScroll {
    [[self.delegate listViewsInPageScrollView:self] enumerateObjectsUsingBlock:^(id<GKPageListViewDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __weak typeof(self) weakSelf = self;
        [obj listViewDidScrollCallback:^(UIScrollView * _Nonnull scrollView) {
            [weakSelf listScrollViewDidScroll:scrollView];
        }];
    }];
}

- (void)listScrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentListScrollView = scrollView;
    
    // 获取listScrollview偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // listScrollView下滑至offsetY小于0，禁止其滑动，让mainTableView可下滑
    if (offsetY <= 0) {
        if (self.isAllowListRefresh && offsetY < 0 && self.mainTableView.contentOffset.y == 0) {
            self.isMainCanScroll = NO;
            self.isListCanScroll = YES;
        }else {
            self.isMainCanScroll = YES;
            self.isListCanScroll = NO;
            
            scrollView.contentOffset = CGPointZero;
            scrollView.showsVerticalScrollIndicator = NO;
        }
    }else {
        if (self.isListCanScroll) {
            scrollView.showsVerticalScrollIndicator = YES;
            
            // 如果此时mianTableView并没有滑动，则禁止listView滑动
            if (self.mainTableView.contentOffset.y == 0) {
                self.isMainCanScroll = YES;
                self.isListCanScroll = NO;
                
                scrollView.contentOffset = CGPointZero;
                scrollView.showsHorizontalScrollIndicator = NO;
            }else { // 矫正mainTableView的位置
                CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.ceilPointHeight;
                self.mainTableView.contentOffset = CGPointMake(0, criticalPoint);
            }
        }else {
            scrollView.contentOffset = CGPointZero;
        }
    }
}

- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取mainScrollview偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    // 临界点
    CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.ceilPointHeight;
    
    // 根据偏移量判断是否上滑到临界点
    if (offsetY >= criticalPoint) {
        self.isCriticalPoint = YES;
    }else {
        self.isCriticalPoint = NO;
    }
    
    if (self.isCriticalPoint) {
        // 上滑到临界点后，固定其位置
        scrollView.contentOffset = CGPointMake(0, criticalPoint);
        self.isMainCanScroll = NO;
        self.isListCanScroll = YES;
        
    }else {
        // 如果允许列表刷新，并且mainTableView的offsetY小于0 或者 当前列表的offsetY小于0
        if (self.isAllowListRefresh && (offsetY <= 0 || self.currentListScrollView.contentOffset.y < 0)) {
            scrollView.contentOffset = CGPointZero;
        }else {
            if (self.isMainCanScroll) {
                // 未达到临界点，mainScrollview可滑动，需要重置所有listScrollView的位置
                [self listScrollViewOffsetFixed];
            }else {
                // 未到达临界点，mainScrollView不可滑动，固定mainScrollView的位置
                [self mainScrollViewOffsetFixed];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(mainTableViewDidScroll:isMainCanScroll:)]) {
        [self.delegate mainTableViewDidScroll:scrollView isMainCanScroll:self.isMainCanScroll];
    }
}

// 修正mainTableView的位置
- (void)mainScrollViewOffsetFixed {
    // 获取临界点位置
    CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.ceilPointHeight;
    
    [[self.delegate listViewsInPageScrollView:self] enumerateObjectsUsingBlock:^(id<GKPageListViewDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView *listScrollView = [obj listScrollView];
        if (listScrollView.contentOffset.y != 0) {
            self.mainTableView.contentOffset = CGPointMake(0, criticalPoint);
        }
    }];
}

// 修正listScrollView的位置
- (void)listScrollViewOffsetFixed {
    [[self.delegate listViewsInPageScrollView:self] enumerateObjectsUsingBlock:^(id<GKPageListViewDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView *listScrollView = [obj listScrollView];
        listScrollView.contentOffset = CGPointZero;
        listScrollView.showsVerticalScrollIndicator = NO;
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isLoaded ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *pageView = [self.delegate pageViewInPageScrollView:self];
    pageView.frame = CGRectMake(0, 0, GKPAGE_SCREEN_WIDTH, GKPAGE_SCREEN_HEIGHT - self.ceilPointHeight);
    [cell.contentView addSubview:pageView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GKPAGE_SCREEN_HEIGHT - self.ceilPointHeight;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(mainTableViewWillBeginDragging:)]) {
        [self.delegate mainTableViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self mainScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(mainTableViewDidEndDragging:willDecelerate:)]) {
        [self.delegate mainTableViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(mainTableViewDidEndDecelerating:)]) {
        [self.delegate mainTableViewDidEndDecelerating:scrollView];
    }
}

@end
