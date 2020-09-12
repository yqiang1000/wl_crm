//
//  CreatePayPlanViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreatePayPlanViewCtrl.h"
#import "MyCommonCell.h"
#import "WSDatePickerView.h"
#import "MemberSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "CustDeptMo.h"

@interface CreatePayPlanViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyTextFieldCellDelegate, MemberSelectViewCtrlDelegate, EditTextViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *currentField;

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;

@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;

@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) CustDeptMo *custDeptMo;
@property (nonatomic, assign) CGFloat planValue;

@end

@implementation CreatePayPlanViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _planValue = 0;
    if (_mo) {
        self.title = @"收款计划详情";
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        // 已审批不可修改
        if ([_mo.status isEqualToString:@"APPROVALED"]) {
            self.rightBtn.hidden = YES;
            self.canEdit = NO;
        } else {
            self.canEdit = YES;
        }
        [self getPayPlanDetail];
    } else {
        _canEdit = YES;
        self.title = @"新建收款计划";
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    [self config];
    [self setUI];
    
    if (_mo.member[@"id"]) {
        [self getDeptMemberId:[_mo.member[@"id"] integerValue]];
    } else {
        [self getDeptMemberId:TheCustomer.customerMo.id];
    }
}

- (void)config {
    if (!_fromChat) {
        [self.arrValues replaceObjectAtIndex:1 withObject:STRING(TheCustomer.customerMo.orgName)];
        [self.arrValues replaceObjectAtIndex:2 withObject:[Utils getPriceFrom:TheCustomer.customerMo.owedTotalAmount]];
    }
    if (_mo) {
        [self.arrValues replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@-%@", _mo.year, _mo.month]];
        [self.arrValues replaceObjectAtIndex:9 withObject:[Utils saveToValues:_mo.remark]];
        [self.arrValues replaceObjectAtIndex:7 withObject:[Utils saveToValues:[Utils getPriceFrom:_mo.quantity]]];
        _planValue = _mo.quantity;
        if (_mo.member) {
            [self.arrValues replaceObjectAtIndex:1 withObject:_mo.member[@"orgName"]];
            [self.arrValues replaceObjectAtIndex:2 withObject:[Utils getPriceFrom:[_mo.member[@"owedTotalAmount"] floatValue]]];
        }
    } else {
        NSString *date = [[NSDate date] stringWithFormat:@"yyyy-MM"];
        [self.arrValues replaceObjectAtIndex:0 withObject:STRING(date)];
    }
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)getPayPlanDetail {
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getPayPlanDetail:_mo.id success:^(id responseObject) {
        [Utils dismissHUD];
        NSError *error = nil;
        _mo = [[PayPlanMo alloc] initWithDictionary:responseObject error:&error];
        TheCustomer.customerMo = [[CustomerMo alloc] initWithDictionary:_mo.member error:&error];
        // 已审批不可修改
        if ([_mo.status isEqualToString:@"APPROVALED"]) {
            self.rightBtn.hidden = YES;
            self.canEdit = NO;
        } else {
            self.canEdit = YES;
        }
        if (_mo.member[@"id"]) {
            [self getDeptMemberId:[_mo.member[@"id"] integerValue]];
        }
        [self config];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getDeptMemberId:(NSInteger)memberId {
    if (memberId != 0) {
        [[JYUserApi sharedInstance] getReceiveCountCustomerId:memberId yearMonth:STRING(self.arrValues[0]) success:^(id responseObject) {
            NSError *error = nil;
            self.custDeptMo = [[CustDeptMo alloc] initWithDictionary:responseObject error:&error];
            [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:[Utils getPriceFrom:self.custDeptMo.zeroToAccount]]];
            [self.arrValues replaceObjectAtIndex:4 withObject:[Utils saveToValues:[Utils getPriceFrom:self.custDeptMo.accountToNinety]]];
            [self.arrValues replaceObjectAtIndex:5 withObject:[Utils saveToValues:[Utils getPriceFrom:self.custDeptMo.moreThanNinety]]];
            [self.arrValues replaceObjectAtIndex:6 withObject:[Utils saveToValues:[Utils getPriceFrom:self.custDeptMo.receivedAmount]]];
            [self refreshAllReceiveMoney];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
        }];
    }
}

- (void)refreshAllReceiveMoney {
    CGFloat total = _planValue + self.custDeptMo.receivedAmount;
    [self.arrValues replaceObjectAtIndex:8 withObject:[Utils saveToValues:[Utils getPriceFrom:total]]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.arrLeft.count - 3) {
        static NSString *cellId = @"textCell";
        MyTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.cellDelegate = self;
            cell.imgArrow.hidden = YES;
        }
        cell.indexPath = indexPath;
        cell.txtRight.keyboardType = UIKeyboardTypeDecimalPad;
        cell.txtRight.placeholder = self.arrRight[indexPath.row];
        [cell setLeftText:self.arrLeft[indexPath.row]];
        cell.txtRight.text = [Utils showTextRightStr:nil valueStr:self.arrValues[indexPath.row]].text;
        return cell;
    }
    
    static NSString *cellId = @"payPlanCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setLeftText:self.arrLeft[indexPath.row]];
    ShowTextMo *showTextMo = [Utils showTextRightStr:self.arrRight[indexPath.row] valueStr: self.arrValues[indexPath.row]];
    cell.labRight.textColor = showTextMo.color;
    cell.labRight.text = showTextMo.text;
    cell.labLeft.textColor = COLOR_B1;
    if ((indexPath.row >= 2 && indexPath.row <= 6) || indexPath.row == 8) {
        cell.labRight.textColor = COLOR_B2;   
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.currentField resignFirstResponder];
    if (indexPath.row == 0) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM"];
        NSDate *scrollToDate = [minDateFormater dateFromString:self.arrValues[indexPath.row]];
        __weak typeof(self) weakself = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM"];
            NSLog(@"选择的日期：%@",date);
            [weakself.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:date])];
            if (TheCustomer.customerMo.id != 0) {
                [weakself getDeptMemberId:TheCustomer.customerMo.id];
            }
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    } else if (indexPath.row == 1) {
        if (_fromChat) {
            MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
            vc.needRules = YES;
            vc.knkli = YES;
            vc.VcDelegate = self;
            vc.indexPath = indexPath;
            vc.defaultId = TheCustomer.customerMo.id;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
        }
    }
    else if (indexPath.row == self.arrLeft.count - 1) {
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 20;
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.currentField resignFirstResponder];
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        TheCustomer.customerMo = model;
        [self getDeptMemberId:model.id];
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:model.orgName])];
        [self.arrValues replaceObjectAtIndex:2 withObject:[Utils getPriceFrom:TheCustomer.customerMo.owedTotalAmount]];
        [self refreshAllReceiveMoney];
        [self.tableView reloadData];
    }
}

#pragma mark - MyTextFieldCellDelegate

- (void)cell:(MyTextFieldCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    self.currentField = textField;
    if (!_canEdit) {
        [textField resignFirstResponder];
        return;
    }
}

- (void)cell:(MyTextFieldCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    
    [self dealResult:textField indexPath:indexPath];
}

- (void)cell:(MyTextFieldCell *)cell textFieldShouldReturn:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    [self dealResult:textField indexPath:indexPath];
}

- (void)dealResult:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    if (!_canEdit) {
        [textField resignFirstResponder];
        return;
    }
    
    _planValue = [textField.text floatValue];
    if (_planValue == 0) {
        textField.text = @"";
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:@"demo"];
    } else {
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:[Utils getPriceFrom:_planValue]])];
        textField.text = [Utils getPriceFrom:_planValue];
    }
    [self refreshAllReceiveMoney];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    [_currentField resignFirstResponder];
//    if (_currentField) {
//        [self.arrValues replaceObjectAtIndex:6 withObject:STRING([Utils saveToValues:_currentField.text])];
//    }
    for (int i = 0 ; i < self.arrValues.count; i++) {
        if (i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 9) {
            continue;
        }
        if ([self.arrValues[i] isEqualToString:@"demo"]) {
            [Utils showToastMessage:@"请完善信息"];
            return;
        }
    }
    
    NSMutableArray *uploadArr = [Utils uploadText:self.arrValues];
    
    if (_mo) {
        // 修改收款计划
        [self updatePayPlan:uploadArr];
    } else {
        // 新建收款计划
        [self createPayPlan:uploadArr];
    }
}

- (void)createPayPlan:(NSMutableArray *)uploadArr {
    [Utils showHUDWithStatus:nil];
    NSString *date = uploadArr[0];
    NSArray *arr = [date componentsSeparatedByString:@"-"];
    
    [[JYUserApi sharedInstance] createPayPlanByCustomerId:TheCustomer.customerMo.id year:[arr firstObject] month:[arr lastObject] quantity:uploadArr[7] receivedAmount:uploadArr[6] planTotalAmount:uploadArr[8] remark:uploadArr[9] success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"创建成功"];
        if (self.createSuccess) {
            self.createSuccess();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)updatePayPlan:(NSMutableArray *)uploadArr {
    NSString *date = uploadArr[0];
    NSArray *arr = [date componentsSeparatedByString:@"-"];
    
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] updateGatheringPlanByPlanId:_mo.id memberId:TheCustomer.customerMo.id year:arr[0] month:arr[1] quantity:uploadArr[7] receivedAmount:uploadArr[6] planTotalAmount:uploadArr[8] remark:uploadArr[9] success:^(id responseObject) {
        
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
        if (self.createSuccess) {
            self.createSuccess();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

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
        _arrLeft = @[@"计划月份",
                     @"客户名称",
                     @"欠款总额",
                     @"0-账期",
                     @"账期-90天",
                     
                     @"90天以上",
                     @"截止今日已收款",
                     @"预计收款",
                     @"计划总额",
                     @"备注"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择",
                      @"请选择",
                      @"自动带出",
                      @"自动带出",
                      @"自动带出",
                      
                      @"自动带出",
                      @"自动带出",
                      @"请输入预计收款金额",
                      @"自动计算",
                      @"请输入"];
    }
    return _arrRight;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@"demo"];
        }
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

- (CustDeptMo *)custDeptMo {
    if (!_custDeptMo) {
        _custDeptMo = [[CustDeptMo alloc] init];
    }
    return _custDeptMo;
}

@end
