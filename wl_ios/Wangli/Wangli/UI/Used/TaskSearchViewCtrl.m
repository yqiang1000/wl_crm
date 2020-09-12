//
//  TaskSearchViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TaskSearchViewCtrl.h"
#import "TaskCell.h"
#import "EmptyView.h"
#import "TaskMo.h"
#import "CreateTaskViewCtrl.h"
#import "WebDetailViewCtrl.h"

@interface TaskSearchViewCtrl ()
{
    EmptyView *_emptyView;
}

@end

@implementation TaskSearchViewCtrl

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
    return 167;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SearchHeaderView *headerView = [[SearchHeaderView alloc] init];
    headerView.labTitle.text = [NSString stringWithFormat:@"共找到%@个和关键词\"%@\"有关的任务", self.totalElements, self.searchKey];
    return headerView;
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
    // 任务详情
    TaskMo *tmpMo = self.arrData[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@loginid=%ld&id=%ld&token=%@", TASK_DETAIL_URL, TheUser.userMo.id, tmpMo.id, [Utils token]];
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.urlStr = urlStr;
    vc.titleStr = @"任务详情";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchPage:(NSInteger)page searchKey:(NSString *)searchKey {
    [JYUserApi releaseSearchParamsCache];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSMutableArray *rules = [NSMutableArray new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(10) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"createdDate" forKey:@"property"];
    [rules addObject: @{@"field": @"title",
                        @"option": @"LIKE_ANYWHERE",
                        @"values":@[searchKey]}];
    [[JYUserApi sharedInstance] getTaskPageParam:param rules:rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TaskMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
