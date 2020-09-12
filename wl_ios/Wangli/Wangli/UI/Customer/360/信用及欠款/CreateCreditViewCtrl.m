//
//  CreateCreditViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/7/27.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateCreditViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "DicMo.h"

@interface CreateCreditViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyTextFieldCellDelegate, MyTextViewCellDelegate, MyButtonCellDelegate, ListSelectViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) UITextField *currentTxtField;
@property (nonatomic, strong) UITextView *currentTxtView;

@property (nonatomic, strong) NSMutableArray *arrValues;
// 地址
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation CreateCreditViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改信用额度";
    [self config];
    [self setUI];
}

- (void)config {
    [self.arrValues replaceObjectAtIndex:0 withObject:STRING(TheCustomer.customerMo.orgName)];
    [self.arrValues replaceObjectAtIndex:1 withObject:[TheCustomer.customerMo.credit stringByAppendingString:@"元"]];
    [self.arrValues replaceObjectAtIndex:2 withObject:[TheCustomer.customerMo.creditModifyDate stringByAppendingString:@"天"]];
    [self.arrValues replaceObjectAtIndex:3 withObject:STRING(TheCustomer.customerMo.credit)];
    [self.arrValues replaceObjectAtIndex:4 withObject:STRING(TheCustomer.customerMo.creditModifyDate)];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.bottom.right.left.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 110.0;
    } else if (indexPath.row == 6) {
        return 94.0;
    } else {
        return 45.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
        static NSString *identifier = @"textFieldCell";
        MyTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setLeftText:self.arrLeft[indexPath.row]];
        cell.txtRight.placeholder = self.arrRight[indexPath.row];
        cell.txtRight.text = [Utils showTextRightStr:nil valueStr:self.arrValues[indexPath.row]].text;
        cell.cellDelegate = self;
        cell.indexPath = indexPath;
        cell.imgArrow.hidden = YES;
        return cell;
    }
    else if (indexPath.row == 5) {
        static NSString *identifier = @"textViewCell";
        MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setLeftText:self.arrLeft[indexPath.row]];
        cell.placeholder = self.arrRight[indexPath.row];
        cell.txtView.text = [Utils showTextRightStr:nil valueStr:self.arrValues[indexPath.row]].text;
        cell.cellDelegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
    else if (indexPath.row == 6) {
        static NSString *identifier = @"btnCell";
        MyButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.btnSave setTitle:self.arrLeft[indexPath.row] forState:UIControlStateNormal];
        cell.cellDelegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerId = @"headerId";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerId];
        header.backgroundColor = COLOR_B0;
    }
    return header;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.currentTxtView resignFirstResponder];
    [self.currentTxtField resignFirstResponder];
}

#pragma mark - MyTextFieldCellDelegate

- (void)cell:(MyTextFieldCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    NSString *str = [_currentTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:str]];
//    if (indexPath.row == 3) {
//        CGFloat value = [str floatValue];
//        if (value - 0 <= 0.001 || value - 0 >= -0.001) {
//            [self.arrValues replaceObjectAtIndex:indexPath.row withObject:@"demo"];
//        } else {
//            [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:[NSString stringWithFormat:@"%.2lf", value]]];
//        }
//    } else if (indexPath.row == 4) {
//        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:str]];
//    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)cell:(MyTextFieldCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    [_currentTxtField resignFirstResponder];
    [_currentTxtView resignFirstResponder];
    _currentTxtField = textField;
    _currentIndexPath = indexPath;
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_currentTxtField) [_currentTxtField resignFirstResponder];
            if (_currentTxtView) [_currentTxtView resignFirstResponder];
        });
        return;
    }
    if (indexPath.row == 3) {
        _currentTxtField.keyboardType = UIKeyboardTypeDecimalPad;
    } else if (indexPath.row == 4) {
//        _currentTxtField.keyboardType = UIKeyboardTypeNumberPad;
        // 字典项
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getConfigDicByName:@"new_account" success:^(id responseObject) {
            [Utils dismissHUD];
            [_currentTxtField resignFirstResponder];
            [_currentTxtView resignFirstResponder];
            NSMutableArray *selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
            NSMutableArray *selectShowArr = [NSMutableArray new];
            for (DicMo *tmpMo in selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = tmpMo.id;
                mo.moText = tmpMo.value;
                [selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath data:selectShowArr];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [_currentTxtField resignFirstResponder];
            [_currentTxtView resignFirstResponder];
        }];
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath data:(NSMutableArray *)selectShowArr {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = selectShowArr;
    vc.title = self.arrLeft[indexPath.row];
    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:STRING(self.arrValues[indexPath.row]), nil];
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:selectMo.moText])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - MyTextViewCellDelegate

- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        NSString *str = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:str])];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    _currentTxtView = textView;
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    if (_currentTxtView) {
        [_currentTxtView resignFirstResponder];
    }
    if (_currentTxtField) {
        [_currentTxtField resignFirstResponder];
    }
    
//    "oldAccount":10,原账期
//    "newAccount":20,新帐期
//    "oldAmount":200000,原额度
//    "newAmount":400000,新额度
//    "remark":"申请说明"
    NSMutableDictionary *param = [NSMutableDictionary new];
    CGFloat money = [self.arrValues[3] floatValue];
    NSInteger date = [self.arrValues[4] integerValue];
    [param setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    [param setObject:STRING(TheCustomer.customerMo.credit) forKey:@"oldAmount"];
    [param setObject:STRING(TheCustomer.customerMo.creditModifyDate) forKey:@"oldAccount"];
    [param setObject:@(money) forKey:@"newAmount"];
    [param setObject:@(date) forKey:@"newAccount"];
    [param setObject:[self.arrValues[5] isEqualToString:@"demo"] ? @"" : STRING(self.arrValues[5]) forKey:@"remark"];
    
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] createAccountApplyByParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"申请提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"客户",
                     @"原额度",
                     @"原账期",
                     @"新额度",
                     @"新账期",
                     
                     @"备注",
                     @"提交申请"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择客户",
                      @"清输入原额度",
                      @"清输入原账期",
                      @"清输入新额度(元)",
                      @"请输入新账期(天)",
                      
                      @"请输入备注",
                      @"提交申请"];
    }
    return _arrRight;
}


- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0; i < self.arrRight.count; i++) {
            [_arrValues addObject:@"demo"];
        }
    }
    return _arrValues;
}


@end
