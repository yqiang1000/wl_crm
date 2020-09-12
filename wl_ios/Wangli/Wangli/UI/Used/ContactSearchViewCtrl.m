//
//  ContactSearchViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ContactSearchViewCtrl.h"
#import "MyCommonCell.h"
#import "EmptyView.h"
#import "ContactDetailViewCtrl.h"

@interface ContactSearchViewCtrl ()
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) NSMutableArray *arrOperators;
@property (nonatomic, strong) NSMutableArray *arrContacts;

@end

@implementation ContactSearchViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrContacts.count == 0 && self.arrOperators.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.tableView);
            make.width.height.equalTo(self.tableView);
        }];
    }
    if (self.arrContacts.count != 0 && self.arrOperators.count != 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 只有 联系人
    if (self.arrContacts.count != 0 && self.arrOperators.count == 0) {
        return self.arrContacts.count;
    }
    // 只有 操作员
    else if (self.arrContacts.count == 0 && self.arrOperators.count != 0) {
        return self.arrOperators.count;
    }
    // 都有 或者没有
    else {
        if (section == 0) {
            return self.arrContacts.count;
        } else {
            return self.arrOperators.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = nil;
    // 只有 联系人
    if (self.arrContacts.count != 0 && self.arrOperators.count == 0) {
        model = self.arrContacts[indexPath.row];
    }
    // 只有 操作员
    else if (self.arrContacts.count == 0 && self.arrOperators.count != 0) {
        model = self.arrOperators[indexPath.row];
    }
    // 都有
    else if (self.arrContacts.count != 0 && self.arrOperators.count != 0) {
        if (indexPath.section == 0) {
            model = self.arrContacts[indexPath.row];
        } else {
            model = self.arrOperators[indexPath.row];
        }
    }
    
    static NSString *cellId = @"contactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell loadDataWith:model];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SearchHeaderView *headerView = [[SearchHeaderView alloc] init];
    // 只有 联系人
    if (self.arrContacts.count != 0 && self.arrOperators.count == 0) {
        headerView.labTitle.text = [NSString stringWithFormat:@"共找到%ld个和关键词\"%@\"有关的%@", self.arrContacts.count, self.searchKey, @"客户联系人"];
    }
    // 只有 操作员
    else if (self.arrContacts.count == 0 && self.arrOperators.count != 0) {
        headerView.labTitle.text = [NSString stringWithFormat:@"共找到%ld个和关键词\"%@\"有关的%@", self.arrOperators.count, self.searchKey, @"公司联系人"];
    }
    // 都有 或者没有
    else if (self.arrContacts.count != 0 && self.arrOperators.count != 0) {
        if (section == 0) {
            headerView.labTitle.text = [NSString stringWithFormat:@"共找到%ld个和关键词\"%@\"有关的%@", self.arrContacts.count, self.searchKey, @"客户联系人"];
        } else {
            headerView.labTitle.text = [NSString stringWithFormat:@"共找到%ld个和关键词\"%@\"有关的%@", self.arrOperators.count, self.searchKey, @"公司联系人"];
        }
    } else {
        headerView.labTitle.text = GET_LANGUAGE_KEY(@"联系人");
    }
    return headerView;
}

- (void)searchPage:(NSInteger)page searchKey:(NSString *)searchKey {
    if (page != 0) {
        [Utils dismissHUD];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    [[JYUserApi sharedInstance] searchContactListByKeyword:searchKey success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSError *error = nil;
        self.arrContacts = [ContactMo arrayOfModelsFromDictionaries:responseObject[@"contacts"] error:&error];
        self.arrOperators = [JYUserMo arrayOfModelsFromDictionaries:responseObject[@"operators"] error:&error];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = nil;
    // 只有 联系人
    if (self.arrContacts.count != 0 && self.arrOperators.count == 0) {
        model = self.arrContacts[indexPath.row];
    }
    // 只有 操作员
    else if (self.arrContacts.count == 0 && self.arrOperators.count != 0) {
        model = self.arrOperators[indexPath.row];
    }
    // 都有
    else if (self.arrContacts.count != 0 && self.arrOperators.count != 0) {
        if (indexPath.section == 0) {
            model = self.arrContacts[indexPath.row];
        } else {
            model = self.arrOperators[indexPath.row];
        }
    }
    ContactDetailViewCtrl *vc = [[ContactDetailViewCtrl alloc] init];
    if ([model isKindOfClass:[ContactMo class]]) {
        vc.mo = model;
    } else {
        vc.userMo = model;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setter getter

- (NSMutableArray *)arrContacts {
    if (!_arrContacts) {
        _arrContacts = [NSMutableArray new];
    }
    return _arrContacts;
}

- (NSMutableArray *)arrOperators {
    if (!_arrOperators) {
        _arrOperators = [NSMutableArray new];
    }
    return _arrOperators;
}

@end
