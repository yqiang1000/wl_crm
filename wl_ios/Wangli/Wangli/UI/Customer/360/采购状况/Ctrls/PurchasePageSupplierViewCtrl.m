//
//  PurchasePageSupplierViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchasePageSupplierViewCtrl.h"
#import "PurchaseSupplierCell.h"
#import "PurchaseCommonCreateViewCtrl.h"
#import "SalesCustomerMo.h"

@interface PurchasePageSupplierViewCtrl ()

@end

@implementation PurchasePageSupplierViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_footer = nil;
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
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PersonBusinessCell";
    PurchaseSupplierCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PurchaseSupplierCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SupplierCustomerMo *suppMo = self.arrData[indexPath.row];
    cell.labSort.text = [NSString stringWithFormat:@"第%@名", suppMo.rank];
    cell.labSortType.text = [NSString stringWithFormat:@"%@排名", suppMo.businessTypeValue];
    cell.labSort.hidden = NO;
    cell.labSortType.hidden = NO;
    [cell loadData:suppMo];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerMo *model = self.arrData[indexPath.row];
    PurchaseCommonCreateViewCtrl *vc = [[PurchaseCommonCreateViewCtrl alloc] init];
    vc.isUpdate = YES;
    vc.fromTab = NO;
    vc.dynamicId = K_PURCHASE_SUPPLIER;
    vc.detailId = model.id;
    vc.title = [NSString stringWithFormat:@"%@", self.segTitle];
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself addHeaderRefresh];
    };
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - public

//- (void)tableViewFooterRefreshAction {
//    if (self.arrData.count == 0) {
//        [self.tableView.mj_footer endRefreshing];
//        return;
//    }
//    [self getList:self.page+1];
//}

- (void)addHeaderRefresh {
    
    self.page = 0;
    [self getList:self.page];
}

- (void)getList:(NSInteger)page {

    [[JYUserApi sharedInstance] getSupplierDirectoryPageByMemberId:TheCustomer.customerMo.id subId:self.currentDic.key param:nil success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        self.arrData = [SupplierCustomerMo arrayOfModelsFromDictionaries:responseObject error:&error];
//        if (page == 0) {
//            [self.arrData removeAllObjects];
//            self.arrData = nil;
//            self.arrData = tmpArr;
//        } else {
//            if (tmpArr.count > 0) {
//                self.page = page;
//                [self.arrData addObjectsFromArray:tmpArr];
//            } else {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}


@end
