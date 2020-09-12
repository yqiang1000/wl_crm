//
//  MyTableView.m
//  CustomTableView
//
//  Created by yeqiang on 2018/4/19.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "MyTableView.h"
#import "RightTableView.h"
#import "TopScrollView.h"

@interface MyTableView () <RightTableViewDelegate, TopScrollViewDelegate>

@property (nonatomic, strong) TopScrollView *scrollViewTop;
@property (nonatomic, strong) RightTableView *tableViewRight;

@end

@implementation MyTableView

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellHeight = kCELL_HEIGHT;
        _cellWidth = kCELL_WIDTH;
        [self initSetting];
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cellHeight = kCELL_HEIGHT;
        _cellWidth = kCELL_WIDTH;
        [self initSetting];
        [self setUI];
    }
    return self;
}

- (void)initSetting {
    self.scrollViewTop.arrData = self.arrTopTitle;
    self.tableViewRight.arrData = self.arrData;
    self.layer.borderColor = COLOR_LINE.CGColor;
    self.layer.borderWidth = 0.5;
    [self.tableViewRight reloadData];
}

- (void)setUI {
    [self addSubview:self.scrollViewTop];
    [self addSubview:self.tableViewRight];
    
    [self.scrollViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(self.cellHeight));
    }];
    
    [self.tableViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollViewTop.mas_bottom);
        make.left.equalTo(self.scrollViewTop);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    UIView *lineView = [Utils getLineView];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(_cellHeight);
        make.height.equalTo(@0.5);
    }];
    
    [self tableViewRefresh];
}

- (void)tableViewRefresh {
    self.tableViewRight.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
    self.tableViewRight.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
    
    CGRect frame = self.tableViewRight.mj_header.frame;
    frame.origin.x = frame.origin.x + 5;
    self.tableViewRight.mj_header.frame = frame;
    
    frame = self.tableViewRight.mj_footer.frame;
    frame.origin.x = frame.origin.x + 5;
    self.tableViewRight.mj_footer.frame = frame;
}

#pragma mark - TopScrollViewDelegate

- (void)topScrollView:(TopScrollView *)topScrollView selectIndex:(NSInteger)index {
    if (_myViewDelegate && [_myViewDelegate respondsToSelector:@selector(myTableView:selectTopIndex:)]) {
        [_myViewDelegate myTableView:self selectTopIndex:index];
    }
}

#pragma mark - RightTableViewDelegate

- (void)rightTableView:(RightTableView *)rightTableView selectIndexPath:(NSIndexPath *)indexPath {
    if (_myViewDelegate && [_myViewDelegate respondsToSelector:@selector(myTableView:selectItemIndexPath:)]) {
        [_myViewDelegate myTableView:self selectItemIndexPath:indexPath];
    }
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    if (_myViewDelegate && [_myViewDelegate respondsToSelector:@selector(myTableViewHeaderRefresh:)]) {
        [_myViewDelegate myTableViewHeaderRefresh:self];
    } else {
        [self endRefresh];
    }
}

- (void)tableViewFooterRefreshAction {
    
    if (_myViewDelegate && [_myViewDelegate respondsToSelector:@selector(myTableViewFooterRefresh:)]) {
        [_myViewDelegate myTableViewFooterRefresh:self];
    } else {
        [self endRefresh];
    }
}

- (void)endRefresh {
    [self.tableViewRight.mj_header endRefreshing];
    [self.tableViewRight.mj_footer endRefreshing];
}

- (void)nomoreData {
    [self.tableViewRight.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - setter getter

- (RightTableView *)tableViewRight {
    if (!_tableViewRight) {
        _tableViewRight = [[RightTableView alloc] initWithFrame:CGRectZero];
        _tableViewRight.cellWidth = _cellWidth;
        _tableViewRight.cellHeight = _cellHeight;
        _tableViewRight.rightTableViewDelegate = self;
    }
    return _tableViewRight;
}

- (TopScrollView *)scrollViewTop {
    if (!_scrollViewTop) {
        _scrollViewTop = [[TopScrollView alloc] init];
        _scrollViewTop.contentSize = CGSizeZero;
        _scrollViewTop.topScrollViewDelegate = self;
    }
    return _scrollViewTop;
}

- (NSMutableArray *)arrTopTitle {
    if (!_arrTopTitle) {
        _arrTopTitle = [NSMutableArray new];
    }
    return _arrTopTitle;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
