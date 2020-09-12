//
//  PersonnelCreateViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "PersonnelCreateViewCtrl.h"
#import "MyCommonCell.h"
#import "BottomView.h"
#import "WSDatePickerView.h"
#import "MemberSelectViewCtrl.h"
#import "LinkManOfficeMo.h"
#import "ListSelectViewCtrl.h"

@interface PersonnelCreateViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyTextFieldCellDelegate, MemberSelectViewCtrlDelegate, MyDefaultCellDelegate, ListSelectViewCtrlDelegate>

{
    NSInteger _topCount;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) UITextField *txtField;

@property (nonatomic, strong) NSMutableArray *arrTel;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, assign) long long customerId;

@property (nonatomic, assign) long long officeId;

@end

@implementation PersonnelCreateViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _topCount = 3;
    [self setUI];
    if (_mo) {
        self.title = @"修改联系人";
        [self getUserDetail];
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    } else {
        self.title = @"新建联系人";
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    [self.rightBtn setTitleColor:COLOR_B4 forState:UIControlStateNormal];
}


- (void)getUserDetail {
    [[JYUserApi sharedInstance] getPersonalDetailId:_mo.id param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.mo = [[ContactMo alloc] initWithDictionary:responseObject error:&error];
        [_arrValues removeAllObjects];
        _arrValues = nil;
        [_arrTel removeAllObjects];
        _arrTel = nil;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _mo ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? (self.arrRight.count + self.arrTel.count - 1) : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.arrValues.count + self.arrTel.count - 2) {
            static NSString *identifier = @"defaultCell";
            MyDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MyDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.cellDelegate = self;
                [cell setLeftText:self.arrLeft[11]];
                cell.lineView.hidden = YES;
            }
            [cell.btnSwitch setOn:[self.arrValues[11] boolValue] animated:YES];
            return cell;
        }
        
        static NSString *identifier = @"MyTextFieldCell";
        MyTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.cellDelegate = self;
        }
        cell.imgArrow.hidden = YES;
        cell.btnRight.hidden = YES;
        cell.indexPath = indexPath;
        if (indexPath.row < _topCount) {
            if (indexPath.row == 1 || indexPath.row == 2) {
                cell.imgArrow.hidden = NO;
            }
            [cell setLeftText:self.arrLeft[indexPath.row]];
            cell.txtRight.placeholder = self.arrRight[indexPath.row];
            ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrValues[indexPath.row]];
            cell.txtRight.text = showTextMo.text;
        } else if (indexPath.row >= _topCount && indexPath.row < _topCount+self.arrTel.count) {
            // row从 _topCount(3) 往后 _arrTel.count 个
            cell.labLeft.hidden = indexPath.row == _topCount ? NO : YES;
            cell.btnRight.hidden = NO;
            [cell.btnRight setImage:[UIImage imageNamed:indexPath.row == _topCount ? @"client_add" : @"phone_delete"] forState:UIControlStateNormal];
            [cell setLeftText:self.arrLeft[_topCount]];
            cell.txtRight.placeholder = indexPath.row == _topCount ? self.arrRight[_topCount] : @"请输入手机号";
            ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrTel[indexPath.row - _topCount]];
            cell.txtRight.text = showTextMo.text;
        }
        else {
            cell.labLeft.hidden = NO;
            cell.btnRight.hidden = YES;
            // row 从 _topCount(3) + _arrTele.count 往后
            NSInteger index = indexPath.row - self.arrTel.count + 1;
            [cell setLeftText:self.arrLeft[index]];
            cell.txtRight.placeholder = self.arrRight[index];
            ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrValues[index]];
            cell.txtRight.text = showTextMo.text;
            if ([self.arrLeft[index] isEqualToString:@"客户"]) {
                if (_mo) cell.txtRight.textColor = COLOR_B2;
                cell.imgArrow.hidden = NO;
            } else {
                cell.imgArrow.hidden = YES;
            }
        }
        return cell;
    } else {
        static NSString *identifier = @"MyCommonCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.imgArrow.hidden = YES;
        cell.labRight.hidden = YES;
        cell.labLeft.text = @"删除联系人";
        cell.labLeft.textColor = COLOR_C2;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [Utils commonDeleteTost:@"提示" msg:@"确定删除该联系人？" cancelTitle:nil confirmTitle:nil confirm:^{
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] deletePersonalDetailId:_mo.id param:nil success:^(id responseObject) {
                [Utils showToastMessage:@"删除成功"];
//                if (self.updateSuccess) {
//                    self.updateSuccess(@"delete");
//                }
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CONTACT_UPDATE object:nil];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
                [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            }];
        } cancel:^{
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_txtField resignFirstResponder];
}

#pragma mark - MyTextFieldCellDelegate

- (void)cell:(MyTextFieldCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    [_txtField resignFirstResponder];
    _txtField = textField;
    [_txtField becomeFirstResponder];
    __block NSArray *arrTitle = nil;
    if (indexPath.row == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_txtField resignFirstResponder];
            arrTitle = @[@"男", @"女"];
            BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"男", @"女"] defaultItem:-1 itemClick:^(NSInteger index) {
                [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:arrTitle[index]]];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } cancelClick:^(BottomView *obj) {
                if (obj) {
                    obj = nil;
                }
            }];
            [bottomView show];
        });
    }
    else if (indexPath.row == 2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_txtField resignFirstResponder];
            NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
            [minDateFormater setDateFormat:@"yyyy-MM-dd"];
            NSDate *scrollToDate = [minDateFormater dateFromString:self.arrValues[2]];
            __weak typeof(self) weakself = self;
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
                
                NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
                NSLog(@"选择的日期：%@",date);
                [weakself.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:date]];
                [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
            datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
            datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            [datepicker show];
        });
    }
    // 客户列表
    else if (indexPath.row == self.arrValues.count + self.arrTel.count - 5) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_txtField resignFirstResponder];
        });
        // 有客户不能修改客户
        if (!_mo && !_from360) {
            //            NSInteger index = indexPath.row - self.arrTel.count + 1;
            // 获取客户列表
            MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
            vc.needRules = NO;
            vc.VcDelegate = self;
            vc.defaultId = _customerId;
            vc.indexPath = indexPath;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
        }
    }
    else if (indexPath.row == self.arrValues.count + self.arrTel.count - 4) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_txtField resignFirstResponder];
        });
        if (_customerId != 0) {
            [[JYUserApi sharedInstance] getLinkManOfficeByMemberId:_customerId success:^(id responseObject) {
                NSError *error = nil;
                [_selectArr removeAllObjects];
                _selectArr = nil;
                [_selectShowArr removeAllObjects];
                _selectShowArr = nil;
                self.selectArr = [LinkManOfficeMo arrayOfModelsFromDictionaries:responseObject error:&error];
                for (LinkManOfficeMo *tmpDic in self.selectArr) {
                    ListSelectMo *mo = [[ListSelectMo alloc] init];
                    mo.moId = [NSString stringWithFormat:@"%lld", tmpDic.id];
                    mo.moText = tmpDic.name;
                    mo.moKey = [NSString stringWithFormat:@"%lld", tmpDic.id];
                    [self.selectShowArr addObject:mo];
                }
                [self pushToSelectVC:indexPath];
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        } else {
            [Utils showToastMessage:@"请先选择客户"];
        }
    }
    else if (indexPath.row >= _topCount && indexPath.row < _topCount+self.arrTel.count) {
        // row从 _topCount(3) 往后 _arrTel.count 个
        _txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [_txtField becomeFirstResponder];
    }
    else {
        _txtField.keyboardType = UIReturnKeyDefault;
        [_txtField becomeFirstResponder];
    }
}

- (void)cell:(MyTextFieldCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _topCount) {
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:(textField.text)]];
    } else if (indexPath.row >= _topCount && indexPath.row < _topCount+self.arrTel.count) {
        NSString *tel = textField.text;
        if (tel.length >= 20) {
            tel = [tel substringToIndex:20];
        }
        [self.arrTel replaceObjectAtIndex:indexPath.row-_topCount withObject:[Utils saveToValues:tel]];
    } else {
        NSInteger index = indexPath.row - self.arrTel.count + 1;
        [self.arrValues replaceObjectAtIndex:index withObject:[Utils saveToValues:(textField.text)]];
    }
    [self.tableView reloadData];
}

- (void)cell:(MyTextFieldCell *)cell btnClick:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        if (self.arrTel.count < 4) {
            [self.arrTel addObject:@"demo"];
        } else {
            [Utils showToastMessage:@"手机号码数量超过限制"];
            return;
        }
    } else {
        [self.arrTel removeObjectAtIndex:indexPath.row - 3];
    }
    [self.tableView reloadData];
}

#pragma mark - MyDefaultCellDelegate

- (void)defaultCell:(MyDefaultCell *)cell isDefault:(BOOL)isDefault {
    [self.arrValues replaceObjectAtIndex:11 withObject:@(isDefault)];
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        [self.arrValues replaceObjectAtIndex:8 withObject:[Utils saveToValues:model.orgName]];
        if (indexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadData];
        }
        if (_mo.id != _customerId) {
            [self.arrValues replaceObjectAtIndex:9 withObject:@"demo"];
            self.officeId = 0;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:9 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        _customerId = model.id;
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = @"请选择部门";
    vc.byText = NO;
    NSMutableArray *arrValue = [NSMutableArray new];
//    if (rowMo.mutiAble) {
//        // 多选
//        vc.isMultiple = YES;
//        for (DicMo *tmpMo in rowMo.mutipleValue) {
//            [arrValue addObject:STRING(tmpMo.key)];
//        }
//    } else {
//        // 单选
        [arrValue addObject:STRING(self.arrValues[self.arrValues.count + self.arrTel.count - 4])];
//    }
    if (_officeId!=0) vc.defaultValues = [[NSMutableArray alloc] initWithObjects:@(self.officeId), nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    LinkManOfficeMo *office = self.selectArr[index];
    [self.arrValues replaceObjectAtIndex:self.arrValues.count + self.arrTel.count - 4 withObject:office.name];
    _officeId = office.id;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    if (_txtField) {
        [_txtField resignFirstResponder];
    }
    
    NSMutableArray *newTel = [NSMutableArray new];
    for (int i = 0; i < self.arrTel.count; i++) {
        if ([Utils uploadToValues:self.arrTel[i]]) {
            [newTel addObject:self.arrTel[i]];
        }
    }
    if (newTel.count == 0) {
        [Utils showToastMessage:@"请完善手机号"];
        return;
    }
    
    for (int i = 0; i < self.arrValues.count; i++) {
        if (i==0 || i==1 || i==5 || i==8 || i==10) {
            if ([self.arrValues[i] isEqualToString:@"demo"]||[self.arrValues[i] isEqualToString:@""]) {
                [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@", self.arrLeft[i]]];
                return;
            }
        }
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSMutableArray *uploadArr = [self uploadText];
    
    NSArray *arrPhone = @[@"phone", @"phoneTwo", @"phoneThree", @"phoneFour"];
    for (int i = 0; i < newTel.count; i++) {
        [param setObject:STRING(newTel[i]) forKey:STRING(arrPhone[i])];
    }
    
    [param setObject:uploadArr[0] forKey:@"name"];
    [param setObject:uploadArr[1] forKey:@"sex"];
    [param setObject:uploadArr[2] forKey:@"birthday"];
    [param setObject:uploadArr[4] forKey:@"email"];
    [param setObject:uploadArr[5] forKey:@"officeAddress"];
    [param setObject:uploadArr[6] forKey:@"address"];
    [param setObject:uploadArr[7] forKey:@"favorite"];
    if (_customerId != 0) [param setObject:@{@"id":@(_customerId)} forKey:@"member"];
    if (_officeId != 0) [param setObject:@{@"id":@(_officeId)} forKey:@"office"];
    [param setObject:uploadArr[10] forKey:@"duty"];
    [param setObject:@([uploadArr[11] boolValue]) forKey:@"incumbency"];
    
    [Utils showHUDWithStatus:nil];
    if (_mo) {
        [param setObject:@(_mo.id) forKey:@"id"];
        [[JYUserApi sharedInstance] updatePersonalParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"保存成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CONTACT_UPDATE object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
        
    } else {
        // 新建
        [[JYUserApi sharedInstance] createPersonalParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"创建成功"];
//            if (self.updateSuccess) {
//                self.updateSuccess(nil);
//            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CONTACT_UPDATE object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (NSMutableArray *)uploadText {
    NSMutableArray *newValue = [NSMutableArray new];
    for (int i = 0 ; i < self.arrValues.count; i++) {
        if (i == 11) {
            [newValue addObject:self.arrValues[i]];
        } else {
            [newValue addObject:[self.arrValues[i] isEqualToString:@"demo"]?@"":self.arrValues[i]];
        }
    }
    return newValue;
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请输入姓名(必填)",
                      @"请选择(必填)",
                      @"请选择",
                      @"请输入手机号(必填)",
                      @"请输入邮箱",
                      
                      @"请输入(必填)",
                      @"请输入",
                      @"请输入",
                      @"请选择(必填)",
                      @"请输入",
                      
                      @"请输入(必填)",
                      @"在职状态"];
    }
    return _arrRight;
}

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"姓名",
                     @"性别",
                     @"生日",
                     @"手机",
                     @"邮箱",
                     
                     @"常用办公地址",
                     @"备用地址",
                     @"爱好",
                     @"客户",
                     @"部门",
                     
                     @"职务",
                     @"在职状态"];
    }
    return _arrLeft;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@"demo"];
        }
        
        if (_mo) {
            [_arrValues replaceObjectAtIndex:0 withObject:STRING(_mo.name)];
            [_arrValues replaceObjectAtIndex:1 withObject:STRING(_mo.sex)];
            
            NSArray *arr = [_mo.birthday componentsSeparatedByString:@"T"];
            [_arrValues replaceObjectAtIndex:2 withObject:STRING([arr firstObject])];
            [_arrValues replaceObjectAtIndex:4 withObject:STRING(_mo.email)];
            [_arrValues replaceObjectAtIndex:5 withObject:STRING(_mo.officeAddress)];
            [_arrValues replaceObjectAtIndex:6 withObject:STRING(_mo.address)];
            [_arrValues replaceObjectAtIndex:7 withObject:STRING(_mo.favorite)];
            [_arrValues replaceObjectAtIndex:8 withObject:STRING(_mo.member[@"orgName"])];
            if (_mo.office) [_arrValues replaceObjectAtIndex:9 withObject:STRING(_mo.office[@"name"])];
            [_arrValues replaceObjectAtIndex:10 withObject:STRING(_mo.duty)];
            [_arrValues replaceObjectAtIndex:11 withObject:@(_mo.incumbency)];
            _customerId = [_mo.member[@"id"] longLongValue];
            _officeId = [_mo.office[@"id"] longLongValue];
        } else {
            [_arrValues replaceObjectAtIndex:11 withObject:@(YES)];
            
            if (_from360) {
                [_arrValues replaceObjectAtIndex:8 withObject:STRING(TheCustomer.customerMo.orgName)];
                _customerId = TheCustomer.customerMo.id;
            }
        }
    }
    return _arrValues;
}

- (NSMutableArray *)arrTel {
    if (!_arrTel) {
        _arrTel = [[NSMutableArray alloc] init];
        if (_mo.phone) [_arrTel addObject:STRING(_mo.phone)];
        if (_mo.phoneTwo) [_arrTel addObject:STRING(_mo.phoneTwo)];
        if (_mo.phoneThree) [_arrTel addObject:STRING(_mo.phoneThree)];
        if (_mo.phoneFour) [_arrTel addObject:STRING(_mo.phoneFour)];
        if (_arrTel.count == 0) {
            [_arrTel addObject:@"demo"];
        }
    }
    return _arrTel;
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

