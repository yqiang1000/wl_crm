//
//  FTaskViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "FTaskViewCtrl.h"
#import "TaskMo.h"
#import "TaskCell.h"
#import "WebDetailViewCtrl.h"

@interface FTaskViewCtrl ()

@end

@implementation FTaskViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    [Utils showHUDWithStatus:nil];
    [self getListPage:self.page];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 167;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"taskCell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskMo *tmpMo = self.arrData[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@loginid=%ld&id=%ld&token=%@", TASK_DETAIL_URL, TheUser.userMo.id, tmpMo.id, [Utils token]];
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.urlStr = urlStr;
    vc.titleStr = @"任务详情";
    vc.hidesBottomBarWhenPushed = YES;
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - private

- (void)getListPage:(NSInteger)page {
    [[JYUserApi sharedInstance] getFavoriteTaskPage:page success:^(id responseObject) {
        [Utils dismissHUD];
        [self tableViewEndRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TaskMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        [self tableViewEndRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

@end
