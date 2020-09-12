//
//  TabTrendsTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TabTrendsTableView.h"
#import "EmptyView.h"
#import "TabTrendsTableViewCell.h"

@interface TabTrendsTableView () <UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}

@end

@implementation TabTrendsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = COLOR_B0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 148;
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
    static NSString *cellId = @"TabTrendsTableViewCell";
    TabTrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TabTrendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell loadDataModel:self.arrData[indexPath.row] source:self.source];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (_planDelegate && [_planDelegate respondsToSelector:@selector(planTableView:didSelectIndexPath:)]) {
//        [_planDelegate planTableView:self didSelectIndexPath:indexPath];
//    }
}

#pragma mark - public

- (void)headerFooterEndRefreshing {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)tableViewHeaderRefreshAction {
    self.page = 0;
    [self getDataBySourceKey:self.source.key page:self.page];
}

- (void)tableViewFooterRefreshAction {
    [self getDataBySourceKey:self.source.key page:self.page+1];
}

- (void)getDataBySourceKey:(NSString *)sourceKey page:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"10" forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    [param setObject:@(page) forKey:@"number"];
    if (sourceKey.length == 0) {
        [param setObject:@[] forKey:@"rules"];
    } else {
        [param setObject:@[@{@"field":@"fkType",
                             @"option":@"EQ",
                             @"values":@[STRING(sourceKey)]}] forKey:@"rules"];
    }
    
    [[JYUserApi sharedInstance] getFeedLowPageTrendParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TrendsFeedMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrData removeAllObjects];
            _arrData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                self.page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self reloadData];
    } failure:^(NSError *error) {
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - lazy

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
