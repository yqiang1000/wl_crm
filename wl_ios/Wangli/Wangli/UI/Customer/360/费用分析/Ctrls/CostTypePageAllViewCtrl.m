//
//  CostTypePageAllViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CostTypePageAllViewCtrl.h"
#import "CostTypeAllCell.h"

@interface CostTypePageAllViewCtrl ()

@end

@implementation CostTypePageAllViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.top.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
    
    self.tableView.layer.cornerRadius = 5;
    self.tableView.clipsToBounds = YES;
    
    for (int i = 0; i < 10; i++) {
        CoastAllMo *mo = [[CoastAllMo alloc] init];
        [self.arrData addObject:mo];
    }
    
    [self.tableView reloadData];
    
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CostTypeAllCell";
    CostTypeAllCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CostTypeAllCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - public

- (void)tableViewFooterRefreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
        int count = self.arrData.count;
        for (int i = 0; i < 5; i++) {
            CoastAllMo *mo = [[CoastAllMo alloc] init];
            [self.arrData addObject:mo];
        }
        [self.tableView reloadData];
    });
}

#pragma mark - lazy

@end
