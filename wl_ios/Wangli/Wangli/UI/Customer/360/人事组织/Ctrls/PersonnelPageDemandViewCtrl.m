//
//  PersonnelPageDemandViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PersonnelPageDemandViewCtrl.h"
#import "PersonDemandCell.h"
#import "BottomView.h"
#import "EditTextViewCtrl.h"

@interface PersonnelPageDemandViewCtrl () <EditTextViewCtrlDelegate>

{
    LinkManDemandMo *_demanMo;
}
@end

@implementation PersonnelPageDemandViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PersonDemandCell";
    PersonDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PersonDemandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    cell.lineView.hidden = (indexPath.row == self.arrData.count-1) ? YES : NO;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LinkManDemandMo *model = self.arrData[indexPath.row];
    if (model.needFeedBack) {
        _demanMo = model;
        BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"回复"] defaultItem:-1 itemClick:^(NSInteger index) {
            EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
            vc.title = @"回复";
            vc.max_length = 200;
            vc.placeholder = @"请输入回复内容";
            vc.indexPath = indexPath;
            vc.currentText = model.reply;
            vc.editVCDelegate = self;
            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        } cancelClick:^(BottomView *obj) {
            _demanMo = nil;
            if (obj) {
                obj = nil;
            }
        }];
        [bottomView show];
    }
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)eidtVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath btnRightClick:(UIButton *)sender complete:(void (^)(BOOL, NSString *))complete {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_demanMo.id) forKey:@"id"];
    [param setObject:STRING(content) forKey:@"value"];
    [param setObject:@"reply" forKey:@"field"];
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] updateReplayPointMessageParam:param success:^(id responseObject) {
        complete(YES, @"保存成功");
        [Utils dismissHUD];
        _demanMo.reply = content;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        _demanMo = nil;
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        complete(NO, STRING(error.userInfo[@"message"]));
    }];
}

#pragma mark - public

- (void)tableViewFooterRefreshAction {
    if (self.arrData.count == 0) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    [self getList:self.page+1];
}

- (void)addHeaderRefresh {
    self.page = 0;
    [self getList:self.page];
}

- (void)getList:(NSInteger)page {
    if (!self.contactMo) {
        [self.arrData removeAllObjects];
        self.arrData = nil;
        [self.tableView reloadData];
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.totalElements = 0;
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"10" forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"createdDate" forKey:@"property"];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@"" forKey:@"specialDirection"];
    [param setObject:@[@{@"field":@"linkMan.id",
                         @"option":@"EQ",
                         @"values":@[@(self.contactMo.id)]}] forKey:@"rules"];
    [[JYUserApi sharedInstance] getLinkManPainPointPageParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        self.totalElements = [responseObject[@"totalElements"] integerValue];
        NSMutableArray *tmpArr = [LinkManDemandMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - lazy

@end
