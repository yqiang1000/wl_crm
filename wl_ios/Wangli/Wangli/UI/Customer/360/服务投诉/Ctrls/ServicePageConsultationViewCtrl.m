//
//  ServicePageConsultationViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ServicePageConsultationViewCtrl.h"
#import "ServiceConsultationCell.h"

@interface ServicePageConsultationViewCtrl ()

@end

@implementation ServicePageConsultationViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
}

- (void)setUI {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.top.equalTo(self.view);
    }];
    
    [self.view layoutIfNeeded];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
//    self.tableView.backgroundColor = COLOR_B4;
//    [self.tableView reloadData];
}

- (void)loadData {
    for (int i = 0; i < 10; i++) {
        [self.arrData addObject:@"111"];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ServiceConsultationCell";
    ServiceConsultationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ServiceConsultationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:@""];
    cell.lineView.hidden = (indexPath.row == self.arrData.count-1) ? YES : NO;
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - public

- (void)tableViewFooterRefreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
        int count = self.arrData.count;
        for (int i = 0; i < 5; i++) {
            [self.arrData addObject:@"111"];
        }
        [self.tableView reloadData];
    });
}

#pragma mark - lazy

@end
