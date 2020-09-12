
//
//  GKMainRefreshViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "GKMainRefreshViewController.h"

@interface GKMainRefreshViewController ()

@end

@implementation GKMainRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageScrollView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kRefreshDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pageScrollView.mainTableView.mj_header endRefreshing];
            
            // 取出当前显示的listView
            GKBaseListViewController *currentListVC = self.childVCs[0];
            
            // 模拟下拉刷新
            currentListVC.count = 30;
            [currentListVC.tableView reloadData];
        });
    }];
    
    [self.pageScrollView reloadData];
}


@end
