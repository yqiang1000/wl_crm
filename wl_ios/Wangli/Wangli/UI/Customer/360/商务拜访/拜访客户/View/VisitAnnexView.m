//
//  VisitAnnexView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "VisitAnnexView.h"
#import "CreateBusinessVisitAnnexViewCtrl.h"
#import "VisitAnnexCell.h"

@interface VisitAnnexView () <VisitAnnexCellDelegate>

@end

@implementation VisitAnnexView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"VisitAnnexCell";
    VisitAnnexCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VisitAnnexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.visitAnnexCellDelegate = self;
    }
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}


#pragma mark - VisitAnnexCellDelegate

- (void)visitAnnexCell:(VisitAnnexCell *)visitAnnexCell btnActionIndexPath:(NSIndexPath *)indexPath {
    CreateBusinessVisitAnnexViewCtrl *vc = [[CreateBusinessVisitAnnexViewCtrl alloc] init];
    vc.model = self.arrData[indexPath.row];
    vc.title = @"上传附件";
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself.tableView reloadData];
    };
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}


@end
