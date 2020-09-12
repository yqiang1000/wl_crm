//
//  VisitProcessView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "VisitProcessView.h"
#import "VisitProcessCell.h"
#import "BaseViewCtrl.h"
#import "CommunicationRecordVIewCtrl.h"
#import "EditTextViewCtrl.h"
#import "AttendanceViewCtrl.h"

@interface VisitProcessView () <VisitProcessCellDelegate, EditTextViewCtrlDelegate>

@end

@implementation VisitProcessView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 80.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"VisitProcessCell";
    VisitProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VisitProcessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.visitProcessCellDelegate = self;
    }
    cell.indexPath = indexPath;
    NSString *content = self.arrData[indexPath.row];
    [cell loadData:(VisitProcessCellType)indexPath.row content:content];//.length==0?@"":content];
    return cell;
}

#pragma mark - VisitProcessCellDelegate

- (void)visitProcessCell:(VisitProcessCell *)visitProcessCell btnActionIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AttendanceViewCtrl *vc = [[AttendanceViewCtrl alloc] init];
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(NSString *obj) {
            __strong typeof(self) strongself = weakself;
            [strongself signAction:obj];
        };
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        CommunicationRecordVIewCtrl *vc = [[CommunicationRecordVIewCtrl alloc] init];
        vc.title = @"新建沟通记录";
        vc.model = self.model;
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(NSString *obj) {
            __strong typeof(self) strongself = weakself;
            strongself.model.communicateRecord = obj;
            if (self.updateReportBlock) {
                self.updateReportBlock();
            }
        };
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.editVCDelegate = self;
        vc.placeholder = @"请输入拜访备注";
        vc.max_length = 1000;
        NSString *reportStr = self.arrData[indexPath.row];
        vc.title = reportStr.length == 0 ? @"新建拜访报告" : @"编辑拜访报告";
        vc.currentText = reportStr;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)eidtVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath btnRightClick:(UIButton *)sender complete:(void (^)(BOOL, NSString *))complete {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(self.model.id) forKey:@"id"];
    [param setObject:STRING(content) forKey:@"visitReport"];
    [[JYUserApi sharedInstance] updateVisitActivityStatus:nil param:param success:^(id responseObject) {
        BusinessVisitActivityMo *tmpMo = [[BusinessVisitActivityMo alloc] initWithDictionary:responseObject error:nil];
        self.model.visitReport = tmpMo.visitReport;
        complete(YES, @"保存成功");
        if (self.updateReportBlock) {
            self.updateReportBlock();
        }
    } failure:^(NSError *error) {
        complete(NO, STRING(error.userInfo[@"message"]));
    }];
}

- (void)signAction:(NSString *)signInfo {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(self.model.id) forKey:@"id"];
    [param setObject:STRING(signInfo) forKey:@"signInInfo"];
    [[JYUserApi sharedInstance] updateVisitActivityStatus:nil param:param success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"拜访签到成功"];
        BusinessVisitActivityMo *tmpMo = [[BusinessVisitActivityMo alloc] initWithDictionary:responseObject error:nil];
        self.model.signInInfo = tmpMo.signInInfo;
        if (self.updateReportBlock) {
            self.updateReportBlock();
        }
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:error.userInfo[@"message"]];
    }];
}

@end
