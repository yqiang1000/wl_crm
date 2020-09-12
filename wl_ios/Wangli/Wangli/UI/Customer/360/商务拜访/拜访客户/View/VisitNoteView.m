//
//  VisitNoteView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "VisitNoteView.h"
#import "VisitNoteCell.h"
#import "EditTextViewCtrl.h"

@interface VisitNoteView () <VisitNoteCellDelegate, EditTextViewCtrlDelegate>

@end

@implementation VisitNoteView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    VisitNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VisitNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.visitNoteCellDelegate = self;
    }
    
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}


#pragma mark - VisitNoteCellDelegate

- (void)visitNoteCell:(VisitNoteCell *)visitNoteCell btnActionIndexPath:(NSIndexPath *)indexPath {
    VisitNoteMo *noteMo = self.arrData[indexPath.row];
    EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
    vc.editVCDelegate = self;
    vc.placeholder = @"请输入拜访备注";
    vc.max_length = 1000;
    vc.title = noteMo.content.length == 0 ? @"新建拜访备注" : @"编辑拜访备注";
    vc.currentText = noteMo.content;
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)eidtVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath btnRightClick:(UIButton *)sender complete:(void (^)(BOOL, NSString *))complete {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(self.model.id) forKey:@"id"];
    [param setObject:STRING(content) forKey:@"remark"];
    [[JYUserApi sharedInstance] updateVisitActivityStatus:nil param:param success:^(id responseObject) {
        BusinessVisitActivityMo *tmpMo = [[BusinessVisitActivityMo alloc] initWithDictionary:responseObject error:nil];
        self.model.remark = tmpMo.remark;
        complete(YES, @"保存成功");
        if (self.updateRemarkBlock) {
            self.updateRemarkBlock();
        }
    } failure:^(NSError *error) {
        complete(NO, STRING(error.userInfo[@"message"]));
    }];
}

@end
