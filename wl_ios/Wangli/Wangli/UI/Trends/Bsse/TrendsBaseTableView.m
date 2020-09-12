
//
//  TrendsBaseTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseTableView.h"
#import "EmptyView.h"
#import "TrendsBaseTableViewCell.h"

@interface TrendsBaseTableView () <UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}

@end

@implementation TrendsBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = COLOR_B0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        self.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
        
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.width.height.equalTo(self);
        }];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"TrendsBaseTableViewCell";
    TrendsBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TrendsBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendsBaseMo *tmpMo = self.arrData[indexPath.row];
    tmpMo.read = YES;
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    self.page = 0;
    
//    [self.arrData removeAllObjects];
//    _arrData = nil;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self headerFooterEndRefreshing];
//        NSInteger count = self.arrData.count;
//        for (int i = 0; i < 5; i++) {
//            TrendsBaseMo *mo = [[TrendsBaseMo alloc] init];
//            mo.title = [NSString stringWithFormat:@"类型：媒体活动 %ld", i+count];
//            mo.content = @"行业网站“光伏者们”组织11月2号到3号举行行业峰会，邀请我司参加";
//            mo.person = @"市场部：刘芳  |  重要性：一般";
//            mo.date = @"3分钟前";
//            mo.read = NO;
//            mo.state = _sourceString;
//            [self.arrData addObject:mo];
//        }
//        [self reloadData];
//    });
}

- (void)tableViewFooterRefreshAction {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self headerFooterEndRefreshing];
//        NSInteger count = self.arrData.count;
//        for (int i = 0; i < 5; i++) {
//            TrendsBaseMo *mo = [[TrendsBaseMo alloc] init];
//            mo.title = [NSString stringWithFormat:@"类型：媒体活动 %ld", i+count];
//            mo.content = @"行业网站“光伏者们”组织11月2号到3号举行行业峰会，邀请我司参加";
//            mo.person = @"市场部：刘芳  |  重要性：一般";
//            mo.date = @"3分钟前";
//            mo.read = NO;
//            mo.state = _sourceString;
//            [self.arrData addObject:mo];
//        }
//        [self reloadData];
//    });
}



#pragma mark - public

- (void)headerFooterEndRefreshing {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

#pragma mark - lazy

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary new];
    }
    return _param;
}

@end
