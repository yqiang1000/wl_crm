//
//  XLCardSwitch.m
//  XLCardSwitchDemo
//
//  Created by Apple on 2017/1/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XLCardSwitch.h"
#import "XLCardSwitchFlowLayout.h"
#import "XLCard.h"
#import <XZMRefresh/XZMRefresh.h>

@interface XLCardSwitch ()<UICollectionViewDelegate,UICollectionViewDataSource> {
//    UICollectionView *_collectionView;
    
    CGFloat _dragStartX;
    
    CGFloat _dragEndX;
}

@property (nonatomic, strong) UIView *topGgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL zeroPage;    // 针对第一页第一条刷新时，动画摇摆得到第二条数据bug
@property (nonatomic, assign) BOOL lastPage;    // 针对最后一页刷新时，动画摇摆得到前一条数据bug

@end

@implementation XLCardSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    
    [self addCollectionView];
}

- (void)addCollectionView {
    [self addSubview:self.topGgView];
    [self.topGgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@215);
    }];
    
    //避免UINavigation对UIScrollView产生的便宜问题
    [self addSubview:[UIView new]];
    XLCardSwitchFlowLayout *flowLayout = [[XLCardSwitchFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[XLCard class] forCellWithReuseIdentifier:@"XLCard"];
    _collectionView.userInteractionEnabled = true;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
}

- (void)setForbidRefresh:(BOOL)forbidRefresh {
    _forbidRefresh = forbidRefresh;
    
    if (!_forbidRefresh) {
        [_collectionView xzm_addNormalHeaderWithTarget:self action:@selector(loadNewDataWithHeader:)];
        [_collectionView xzm_addNormalFooterWithTarget:self action:@selector(loadMoreDataWithFooter:)];
    }
}

- (void)loadNewDataWithHeader:(XZMRefreshHeader *)header
{
    // 重新加载数据
    NSLog(@"重新加载数据");
    TheCustomer.page = 0;
    [self getList:TheCustomer.page];
}

- (void)loadMoreDataWithFooter:(XZMRefreshFooter *)footer
{
    // 下一页
    NSLog(@"加载数据下一页");
    [self getList:TheCustomer.page+1];
}

- (void)getList:(NSInteger)page {
    [Utils showHUDWithStatus:nil];
    
    if (TheCustomer.fromTab == 0) {
        [[JYUserApi sharedInstance] getCustomerListDirection:nil property:nil size:10 rules:nil page:page specialDirection:nil specialConditions:nil success:^(id responseObject) {
            [self dealwithResultPage:page success:responseObject fialed:nil];
        } failure:^(NSError *error) {
            [self dealwithResultPage:page success:nil fialed:error];
        }];
    } else if(TheCustomer.fromTab == 1) {
        [[JYUserApi sharedInstance] searchCustomerListPage:page size:10 rules:nil keyword:nil specialConditions:nil success:^(id responseObject) {
            [self dealwithResultPage:page success:responseObject fialed:nil];
        } failure:^(NSError *error) {
            [self dealwithResultPage:page success:nil fialed:nil];
        }];
    } else if(TheCustomer.fromTab == 2) {
        [[JYUserApi sharedInstance] getFavoriteMemberPage:page success:^(id responseObject) {
            [self dealwithResultPage:page success:responseObject fialed:nil];
        } failure:^(NSError *error) {
            [self dealwithResultPage:page success:nil fialed:nil];
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToCenter];
    });
}

- (void)dealwithResultPage:(NSInteger)page success:(id)responseObject fialed:(NSError *)error {
    [Utils dismissHUD];
    [self.collectionView.xzm_header endRefreshing];
    [self.collectionView.xzm_footer endRefreshing];
    _zeroPage = NO;
    _lastPage = NO;
    if (error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    } else {
        NSError *error = nil;
        NSMutableArray *tmpArr = [CustomerMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.items removeAllObjects];
            for (int i = 0; i < tmpArr.count; i++) {
                XLCardItem *item = [[XLCardItem alloc] init];
                item.mo = tmpArr[i];
                [self.items addObject:item];
            }
            _selectedIndex = 0;
            _zeroPage = YES;
        } else {
            if (tmpArr.count > 0) {
                for (int i = 0; i < tmpArr.count; i++) {
                    XLCardItem *item = [[XLCardItem alloc] init];
                    item.mo = tmpArr[i];
                    [self.items addObject:item];
                }
                _selectedIndex++;
            } else {
                _lastPage = YES;
            }
        }
        TheCustomer.page = page;
        [self.collectionView reloadData];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToCenter];
    });
}

#pragma mark -
#pragma mark Setter
-(void)setItems:(NSMutableArray<XLCardItem *> *)items {
    _items = items;
    [_collectionView reloadData];
}

#pragma mark -
#pragma mark CollectionDelegate
//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _selectedIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _selectedIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
    [self scrollToCenter];
}

//滚动到中间
- (void)scrollToCenter {
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self performDelegateMethod];
}

#pragma mark -
#pragma mark CollectionDelegate
//在不使用分页滚动的情况下需要手动计算当前选中位置 -> _selectedIndex
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_pagingEnabled) {return;}
    if (!_collectionView.visibleCells.count) {return;}
    if (!scrollView.isDragging) {return;}
    CGRect currentRect = _collectionView.bounds;
    currentRect.origin.x = _collectionView.contentOffset.x;
    for (XLCard *card in _collectionView.visibleCells) {
        if (CGRectContainsRect(currentRect, card.frame)) {
            NSInteger index = [_collectionView indexPathForCell:card].row;
            if (index != _selectedIndex) {
                _selectedIndex = index;
            }
        }
    }
}

//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
    _zeroPage = NO;
    _lastPage = NO;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_pagingEnabled) {return;}
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self scrollToCenter];
}

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString* cellId = @"XLCard";
//    XLCard* card = (XLCard *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
//    [card.tableView removeFromSuperview];
//    card.tableView = nil;
//}


//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    [((XLCard *)cell).tableView setContentOffset:CGPointMake(0, 0)];
//}

#pragma mark -
#pragma mark CollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"XLCard";
    XLCard *card = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (_zeroPage) {
        card.item = [_items firstObject];
    } else if (_lastPage) {
        card.item = [_items lastObject];
    } else {
        card.item = _items[indexPath.row];
    }
    return  card;
}

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    XLCard *card = (XLCard *)[collectionView cellForItemAtIndexPath:indexPath];
//    card.item = _items[indexPath.row];
//    [self layoutIfNeeded];
//}

#pragma mark -
#pragma mark 功能方法

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self switchToIndex:selectedIndex animated:false];
}

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    [self performDelegateMethod];
}

- (void)performDelegateMethod {
    if ([_delegate respondsToSelector:@selector(XLCardSwitchDidSelectedAt:)]) {
        [_delegate XLCardSwitchDidSelectedAt:_selectedIndex];
    }
}

- (UIView *)topGgView {
    if (!_topGgView) {
        _topGgView = [[UIView alloc] init];
        _topGgView.backgroundColor = COLOR_C1;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)COLOR_0279E3.CGColor, (__bridge id)COLOR_62B2F9.CGColor];
//        gradientLayer.locations = @[@0.3, @0.5, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0,1.0);
        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 215);
        [_topGgView.layer addSublayer:gradientLayer];
    }
    return _topGgView;
}

@end
