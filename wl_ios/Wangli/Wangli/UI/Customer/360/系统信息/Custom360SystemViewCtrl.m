
//
//  Custom360SystemViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360SystemViewCtrl.h"
#import "MyCommonCell.h"
#import "HelpListViewCtrl.h"
#import "SystemInfoMo.h"
#import "SystemHelpListViewCtrl.h"

@interface Custom360SystemViewCtrl ()

@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) SystemInfoMo *systemInfo;

@end

@implementation Custom360SystemViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [Utils showHUDWithStatus:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getSystemInfo];
}

- (void)getSystemInfo {
    [[JYUserApi sharedInstance] getMemberSystemInfoByMemberId:TheCustomer.customerMo.id success:^(id responseObject) {
        [Utils dismissHUD];
        self.systemInfo = [[SystemInfoMo alloc] initWithDictionary:responseObject error:nil];
        [self config];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
    }];
}

- (void)config {
    [self.arrValues replaceObjectAtIndex:0 withObject:STRING(self.systemInfo.sapNumber)];
    [self.arrValues replaceObjectAtIndex:1 withObject:STRING(self.systemInfo.createOperator)];
    [self.arrValues replaceObjectAtIndex:2 withObject:STRING(self.systemInfo.createDate)];
    [self.arrValues replaceObjectAtIndex:3 withObject:STRING(self.systemInfo.lastModify)];
    [self.arrValues replaceObjectAtIndex:4 withObject:STRING(self.systemInfo.modifyDate)];
    [self.arrValues replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%lld", self.systemInfo.memberAssistSet.count]];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"customCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.labLeft.textColor = COLOR_B1;
        cell.labRight.textColor = COLOR_B2;
    }
    cell.labLeft.text = self.arrLeft[indexPath.row];
    cell.labRight.text = self.arrValues[indexPath.row];
    cell.lineView.hidden = (indexPath.row == self.arrLeft.count - 1) ? YES : NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count - 1) {
        SystemHelpListViewCtrl *vc = [[SystemHelpListViewCtrl alloc] init];
        vc.title = @"协助人列表";
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(NSString *obj) {
            __strong typeof(self) strongself = weakself;
            [strongself.arrValues replaceObjectAtIndex:5 withObject:STRING(obj)];
            [strongself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    static NSString *headerId = @"headerId";
//    MyCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
//    if (!header) {
//        header = [[MyCommonHeaderView alloc] initWithReuseIdentifier:headerId isHidenLine:NO];
//    }
//    NSDictionary *dic = self.arrData[section];
//    header.labLeft.text = dic[@"title"];
//    return header;
//}

- (SystemInfoMo *)systemInfo {
    if (!_systemInfo) {
        _systemInfo = [[SystemInfoMo alloc] init];
    }
    return _systemInfo;
}

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"SAP账户",
                     @"创建人",
                     @"创建日期",
                     @"最后修改人",
                     @"修改日期",
                     
                     @"协助人"];
    }
    return _arrLeft;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0 ; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@" "];
        }
    }
    return _arrValues;
}

@end
