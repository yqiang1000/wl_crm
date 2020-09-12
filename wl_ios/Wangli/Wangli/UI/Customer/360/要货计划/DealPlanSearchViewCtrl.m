
//
//  DealPlanSearchViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "DealPlanSearchViewCtrl.h"
#import "DealPlanCell.h"
#import "DealPlanMo.h"
#import "CreateDealPlanViewCtrl.h"
#import "EmptyView.h"

@interface DealPlanSearchViewCtrl ()
{
    EmptyView *_emptyView;
}

@property (nonatomic, strong) NSMutableDictionary *modelDic;

@end

@implementation DealPlanSearchViewCtrl

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
    headerView.labTitle.text = [NSString stringWithFormat:@"共找到%@个和关键词\"%@\"有关的要货计划", self.totalElements, self.searchKey];
    return headerView;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"dealPlanCell";
    DealPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DealPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell loadDataWith:self.arrData[indexPath.row] orgName:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateDealPlanViewCtrl *vc = [[CreateDealPlanViewCtrl alloc] init];
    vc.mo = self.arrData[indexPath.row];
    __weak typeof(self) weakself = self;
    vc.createSuccess = ^{
        [weakself.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - network

- (void)searchPage:(NSInteger)page searchKey:(NSString *)searchKey {
    
    
    if (!_fromCollection) {
        NSMutableArray *rules = [NSMutableArray new];
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@"ASC" forKey:@"direction"];
        [param setObject:@"id" forKey:@"property"];
        
        [rules addObject:@{@"field":@"member.id",
                           @"option":@"EQ",
                           @"values":@[@(TheCustomer.customerMo.id)]}];
        
        NSMutableArray *arrSpecialConditions = [[NSMutableArray alloc] initWithObjects:searchKey, nil];
        [[JYUserApi sharedInstance] getDemandPlanPageByParam:param page:page size:10 rules:rules specialConditions:arrSpecialConditions success:^(id responseObject) {
            [Utils dismissHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSError *error = nil;
            NSMutableArray *tmpArr = [DealPlanMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            self.totalElements = responseObject[@"totalElements"];
            if (page == 0) {
                [self.arrData removeAllObjects];
                self.arrData = nil;
                self.arrData = tmpArr;
            } else {
                if (tmpArr.count > 0) {
                    self.page = page;
                    [self.arrData addObjectsFromArray:tmpArr];
                }
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@"ASC" forKey:@"direction"];
        [param setObject:@"id" forKey:@"property"];
        [param setObject:@"10" forKey:@"size"];
        [param setObject:@(page) forKey:@"number"];
        [param setObject:@[STRING(searchKey)] forKey:@"specialConditions"];
        [param setObject:@[] forKey:@"rules"];
        
        [[JYUserApi sharedInstance] getDemandPlanDetailPageByPager:param operatorCollectBean:self.modelDic success:^(id responseObject) {
            [Utils dismissHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSError *error = nil;
            NSMutableArray *tmpArr = [DealPlanMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            self.totalElements = responseObject[@"totalElements"];
            if (page == 0) {
                [self.arrData removeAllObjects];
                self.arrData = nil;
                self.arrData = tmpArr;
            } else {
                if (tmpArr.count > 0) {
                    self.page = page;
                    [self.arrData addObjectsFromArray:tmpArr];
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
}

- (NSMutableDictionary *)modelDic {
    if (_modelDic.count == 0) {
        _modelDic = [[NSMutableDictionary alloc] initWithDictionary:[_model toDictionary]];
    }
    return _modelDic;;
}

@end
