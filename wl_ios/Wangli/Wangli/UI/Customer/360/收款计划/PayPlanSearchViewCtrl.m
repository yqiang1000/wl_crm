//
//  PayPlanSearchViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PayPlanSearchViewCtrl.h"
#import "PayPlanCell.h"
#import "PayPlanMo.h"
#import "EmptyView.h"

@interface PayPlanSearchViewCtrl ()
{
    EmptyView *_emptyView;
}
@end

@implementation PayPlanSearchViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 111;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SearchHeaderView *headerView = [[SearchHeaderView alloc] init];
    headerView.labTitle.text = [NSString stringWithFormat:@"共找到%@个和关键词\"%@\"有关的收款计划", self.totalElements, self.searchKey];
    return headerView;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"dealPlanCell";
    PayPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PayPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    PayPlanMo *tmpMo = self.arrData[indexPath.row];
    [cell loadDataWith:self.arrData[indexPath.row] orgName:STRING(tmpMo.member[@"orgName"])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    CreateDealPlanViewCtrl *vc = [[CreateDealPlanViewCtrl alloc] init];
//    vc.mo = self.arrData[indexPath.row];
//    __weak typeof(self) weakself = self;
//    vc.createSuccess = ^{
//        [weakself.tableView.mj_header beginRefreshing];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - network

- (void)searchPage:(NSInteger)page searchKey:(NSString *)searchKey {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    
//    [rules addObject:@{@"field":@"operator.id",
//                       @"option":@"IN",
//                       @"values":@[@(TheUser.userMo.id)]}];
    
    [params setObject:@"ASC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    
    NSMutableArray *arrSpecialConditions = [[NSMutableArray alloc] initWithObjects:searchKey, nil];
    
    [[JYUserApi sharedInstance] getGatheringPlanPageByParam:params page:page size:10 rules:rules specialConditions:arrSpecialConditions success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [PayPlanMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        self.totalElements = responseObject[@"totalElements"];
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
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

@end
