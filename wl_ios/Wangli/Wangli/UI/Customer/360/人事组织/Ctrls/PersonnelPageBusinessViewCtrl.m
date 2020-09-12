//
//  PersonnelPageBusinessViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PersonnelPageBusinessViewCtrl.h"
#import "PersonBusinessCell.h"
#import "LinkManBusinessMo.h"

@interface PersonnelPageBusinessViewCtrl ()

@end

@implementation PersonnelPageBusinessViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PersonBusinessCell";
    PersonBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PersonBusinessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    cell.lineView.hidden = (indexPath.row == self.arrData.count-1) ? YES : NO;
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - public

- (void)tableViewFooterRefreshAction {
    if (self.arrData.count == 0) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    [self getList:self.page+1];
}

- (void)addHeaderRefresh {
    self.page = 0;
    [self getList:self.page];
}

- (void)getList:(NSInteger)page {
    if (!self.contactMo) {
        [self.arrData removeAllObjects];
        self.arrData = nil;
        [self.tableView reloadData];
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.totalElements = 0;
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"10" forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"createdDate" forKey:@"property"];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@"" forKey:@"specialDirection"];
    [param setObject:@[@{@"field":@"customerContact",
                         @"option":@"EQ",
                         @"values":@[STRING(self.contactMo.name)]}] forKey:@"rules"];
    [[JYUserApi sharedInstance] getLinkManBusinessPageParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        self.totalElements = [responseObject[@"totalElements"] integerValue];
        NSMutableArray *tmpArr = [LinkManBusinessMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                self.page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - lazy

@end
