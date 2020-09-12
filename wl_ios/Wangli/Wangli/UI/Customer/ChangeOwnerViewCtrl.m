
//
//  ChangeOwnerViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/9.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ChangeOwnerViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "AssistListViewCtrl.h"

@interface ChangeOwnerViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyButtonCellDelegate, MyTextViewCellDelegate, ListSelectViewCtrlDelegate, AssistListViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSMutableArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) UITextView *txtView;
@property (nonatomic, strong) JYUserMo *selectUser;

@end

@implementation ChangeOwnerViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_ownerType == OwnerChangeType) {
        self.title = @"转移客户";
    } else if (_ownerType == OwnerReleaseType) {
        self.title = @"释放客户";
    } else if (_ownerType == OwnerClaimType) {
        self.title = @"认领客户";
        _selectUser = TheUser.userMo;
        [self.arrValues replaceObjectAtIndex:3 withObject:STRING(TheUser.userMo.name)];
    }
    
    [self setUI];
    [self.tableView reloadData];
}


- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

//- (void)getOperatorAssistListSuccess:(void (^)(id responseObject))success
//                             failure:(void (^)(NSError *error))fail {
//    [Utils showHUDWithStatus:nil];
//    [[JYUserApi sharedInstance] getOperatorAssistListSuccess:^(id responseObject) {
//        [Utils dismissHUD];
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        [Utils dismissHUD];
//        if (fail) {
//            fail(error);
//        }
//    }];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count - 1) {
        return 94;
    } else if (indexPath.row == self.arrLeft.count - 2) {
        return 76;
    }
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count - 1) {
        static NSString *cellId = @"btnCell";
        MyButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell.btnSave setTitle:self.arrLeft[indexPath.row] forState:UIControlStateNormal];
            cell.cellDelegate = self;
        }
        cell.indexPath = indexPath;
        return cell;
    } else if (indexPath.row == self.arrLeft.count - 2) {
        static NSString *cellId = @"txtViewCell";
        MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell setLeftText:self.arrLeft[indexPath.row]];
            cell.placeholder = self.arrRight[indexPath.row];
            cell.cellDelegate = self;
        }
        ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrValues[indexPath.row]];
        cell.txtView.text = showTextMo.text;
        cell.indexPath = indexPath;
        return cell;
    }
    static NSString *cellId = @"commonCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setLeftText:self.arrLeft[indexPath.row]];    
    ShowTextMo *showTextMo = [Utils showTextRightStr:self.arrRight[indexPath.row] valueStr: self.arrValues[indexPath.row]];
    cell.labRight.textColor = showTextMo.color;
    cell.labRight.text = showTextMo.text;
    cell.labLeft.textColor = COLOR_B1;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerId = @"headerId";
    MyCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[MyCommonHeaderView alloc] initWithReuseIdentifier:headerId isHidenLine:NO];
    }
    header.labLeft.text = self.title;
    return header;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_txtView resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 新负责人
    if (indexPath.row == 3) {
        if (_ownerType != OwnerChangeType) {
            return;
        }
        
        AssistListViewCtrl *vc = [[AssistListViewCtrl alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.VcDelegate = self;
        vc.indexPath = indexPath;
        vc.defaultId = _selectUser.id;
        [self.navigationController pushViewController:vc animated:YES];
        
//        if (_selectArr.count == 0) {
//            [self getOperatorAssistListSuccess:^(id responseObject) {
//                self.selectArr = [JYUserMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
//                for (JYUserMo *tmpMo in self.selectArr) {
//                    ListSelectMo *mo = [[ListSelectMo alloc] init];
//                    mo.moId = [NSString stringWithFormat:@"%ld", tmpMo.id];
//                    mo.moText = tmpMo.name;
//                    [self.selectShowArr addObject:mo];
//                }
//                [self pushToSelectVC:indexPath];
//            } failure:^(NSError *error) {
//            }];
//        } else {
//            [self pushToSelectVC:indexPath];
//        }
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.arrData = self.selectShowArr;
    vc.indexPath = indexPath;
    vc.title = @"联系人列表";
    vc.listVCdelegate = self;
    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:self.arrValues[3], nil];
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyy-MM-dd";
    NSString *today = [formate stringFromDate:[NSDate date]];
    if (_ownerType == OwnerChangeType) {
        if (!_selectUser) {
            [Utils showToastMessage:@"请选择新负责人"];
            return;
        }
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] applyTransferMemberId:_mo.id originalSaleman:_mo.salesmanId targetSaleman:_selectUser.id remark:_txtView.text infoDate:today success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"申请提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_MEMBER_CHANGE_OPERATOR object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            [Utils dismissHUD];
        }];
    } else if (_ownerType == OwnerReleaseType) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] applyReleaseMemberId:_mo.id originalSaleman:_mo.salesmanId remark:_txtView.text infoDate:today success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"申请提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_MEMBER_CHANGE_OPERATOR object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            [Utils dismissHUD];
        }];
    } else if (_ownerType == OwnerClaimType) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] applyClaimMemberId:_mo.id targetSaleman:_selectUser.id remark:_txtView.text infoDate:today success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"申请提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_MEMBER_CHANGE_OPERATOR object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            [Utils dismissHUD];
        }];
    }
}

#pragma mark - MyTextViewCellDelegate

- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:textView.text]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    _txtView = textView;
}

#pragma mark - AssistListViewCtrlDelegate

- (void)assistListViewCtrl:(AssistListViewCtrl *)assistListViewCtrl selectedModel:(JYUserMo *)model indexPath:(NSIndexPath *)indexPath {
    _selectUser = model;
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:_selectUser.name]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

}

- (void)assistListViewCtrlDismiss:(AssistListViewCtrl *)assistListViewCtrl {
    
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {

    _selectUser = self.selectArr[index];
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:_selectUser.name]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event


#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"客户",
                     @"日期",
                     @"原负责人",
                     @"新负责人",
                     @"备注",
                     
                     @"提交申请"];
    }
    return _arrLeft;
}

- (NSMutableArray *)arrRight {
    if (!_arrRight) {
        _arrRight = [[NSMutableArray alloc] initWithArray:@[@"请选择客户",
                                                            @"请选日期",
                                                            @"无",
                                                            @"无",
                                                            @"请输入备注",
                                                            
                                                            @"提交申请"]];
        if (_ownerType == OwnerClaimType) {
        } else if (_ownerType == OwnerChangeType) {
            [_arrRight replaceObjectAtIndex:3 withObject:@"请选择负责人"];
        } else if (_ownerType == OwnerReleaseType) {
        }
    }
    return _arrRight;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0 ; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@"demo"];
        }
        [_arrValues replaceObjectAtIndex:0 withObject:STRING(_mo.orgName)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];;
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        [_arrValues replaceObjectAtIndex:1 withObject:dateStr];
        [_arrValues replaceObjectAtIndex:2 withObject:STRING(_mo.salesmanName)];
    }
    return _arrValues;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [NSMutableArray new];
    }
    return _selectArr;
}

- (NSMutableArray *)selectShowArr {
    if (!_selectShowArr) {
        _selectShowArr = [NSMutableArray new];
    }
    return _selectShowArr;
}

@end
