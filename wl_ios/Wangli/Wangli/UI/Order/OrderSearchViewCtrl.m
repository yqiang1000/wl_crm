//
//  OrderSearchViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "OrderSearchViewCtrl.h"
#import "TabOrderCell.h"
#import "EmptyView.h"
#import "WebDetailViewCtrl.h"

@interface OrderSearchViewCtrl ()
{
    EmptyView *_emptyView;
}

@end

@implementation OrderSearchViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 143.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SearchHeaderView *headerView = [[SearchHeaderView alloc] init];
    headerView.labTitle.text = [NSString stringWithFormat:@"共找到%@个和关键词\"%@\"有关的订单", self.totalElements, self.searchKey];
    return headerView;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TabOrderCell";
    TabOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TabOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 订单详情
    OrderMo *tmpMo = self.arrData[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@orderID=%ld&token=%@", ORDER_DETAIL_URL, tmpMo.id, [Utils token]];
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.urlStr = urlStr;
    vc.titleStr = @"订单详情";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchPage:(NSInteger)page searchKey:(NSString *)searchKey {
    [JYUserApi releaseSearchParamsCache];
    NSMutableArray *arrSpecialConditions = [[NSMutableArray alloc] initWithObjects:searchKey, nil];
    
    [[JYUserApi sharedInstance] getOrderPage:page size:10 rules:nil specialConditions:arrSpecialConditions success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [OrderMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        self.totalElements = responseObject[@"totalElements"];
        if (page == 0) {
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
