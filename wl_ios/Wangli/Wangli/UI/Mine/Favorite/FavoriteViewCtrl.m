//
//  FavoriteViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "FavoriteViewCtrl.h"
#import "EmptyView.h"

@interface FavoriteViewCtrl () <UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}

@end

@implementation FavoriteViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden = YES;
    [self setUI];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.tableView);
            make.width.height.equalTo(self.tableView);
        }];
    }
    return 1;
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getListPage:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getListPage:_page+1];
}

- (void)tableViewEndRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)getListPage:(NSInteger)page {
    
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B0;
    }
    return _tableView;
}

@end
