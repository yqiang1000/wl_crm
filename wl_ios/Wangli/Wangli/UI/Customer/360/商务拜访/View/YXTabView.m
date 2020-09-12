//
//  YXTabView.m
//  仿造淘宝商品详情页
//
//  Created by yixiang on 16/3/25.
//  Copyright © 2016年 yixiang. All rights reserved.
//

#import "YXTabView.h"
#import "YXTabTitleView.h"
#import "YXTabItemBaseView.h"
#import "YX.h"
#import "YXTabConfigMo.h"

@interface YXTabView()<UIScrollViewDelegate>

@property (nonatomic, strong) YXTabTitleView *tabTitleView;
@property (nonatomic, strong) UIScrollView *tabContentView;

@end

@implementation YXTabView

-(instancetype)initWithTabConfigArray:(NSMutableArray<YXTabConfigMo *> *)tabConfigArray {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        _tabConfigArray = tabConfigArray;
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-Height_NavBar-KMagrinBottom-44-5);
        
        NSMutableArray *titleArray = [NSMutableArray array];
        for (int i=0; i<_tabConfigArray.count; i++) {
            YXTabConfigMo *itemDic = _tabConfigArray[i];
            [titleArray addObject:STRING(itemDic.title)];
        }
        _tabTitleView = [[YXTabTitleView alloc] initWithTitleArray:titleArray];
        
        _index = 0;
        __weak typeof(self) weakSelf = self;
        _tabTitleView.titleClickBlock = ^(NSInteger row) {
            //NSLog(@"当前点击%zi",row);
            weakSelf.index = row;
            if (weakSelf.tabContentView) {
                weakSelf.tabContentView.contentOffset = CGPointMake((SCREEN_WIDTH - 20)*row, 0);
            }
        };
        
        [self addSubview:_tabTitleView];
        
        _tabContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_tabTitleView.frame), SCREEN_WIDTH-20, CGRectGetHeight(self.frame) - CGRectGetHeight(_tabTitleView.frame))];
        _tabContentView.contentSize = CGSizeMake(CGRectGetWidth(_tabContentView.frame)*titleArray.count, CGRectGetHeight(_tabContentView.frame));
        _tabContentView.layer.cornerRadius = 5;
        _tabContentView.clipsToBounds = YES;
        _tabContentView.pagingEnabled = YES;
        _tabContentView.bounces = NO;
        _tabContentView.showsHorizontalScrollIndicator = NO;
        _tabContentView.delegate = self;
        [self addSubview:_tabContentView];
        
        for (int i=0; i<_tabConfigArray.count; i++) {
            YXTabConfigMo *itemBaseView = _tabConfigArray[i];
            if (itemBaseView.yxTabItemBaseView) {
                [_tabContentView addSubview:itemBaseView.yxTabItemBaseView];
            }
        }
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX/(SCREEN_WIDTH-20);
    //NSLog(@"pageNum == %zi",pageNum);
    _index = pageNum;
    [_tabTitleView setItemSelected:pageNum];
}

- (void)updateTitle:(NSString *)title index:(NSInteger)index {
    [self.tabTitleView updateTitle:title index:index];
}

#pragma mark - lazy

- (NSMutableArray<YXTabItemBaseView *> *)arrTableViews {
    if (!_arrTableViews) {
        _arrTableViews = [NSMutableArray new];
    }
    return _arrTableViews;
}



@end
