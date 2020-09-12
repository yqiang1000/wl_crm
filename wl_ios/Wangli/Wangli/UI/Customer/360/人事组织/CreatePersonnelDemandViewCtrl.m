//
//  CreatePersonnelDemandViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/3.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CreatePersonnelDemandViewCtrl.h"
#import "CommonRowMo.h"
#import "CommonAutoViewCtrl.h"
#import "MyCommonCell.h"
#import "MemberSelectViewCtrl.h"
#import "WSDatePickerView.h"
#import "JYUserMoSelectViewCtrl.h"
#import "BottomView.h"
#import "ListSelectViewCtrl.h"
#import "PersonalSelectViewCtrl.h"

@interface CreatePersonnelDemandViewCtrl () <UITableViewDelegate, UITableViewDataSource, MemberSelectViewCtrlDelegate, ListSelectViewCtrlDelegate, DefaultInputCellDelegate, MyTextViewCellDelegate, JYUserMoSelectViewCtrlDelegate, PersonalSelectViewCtrlDelegate>

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UITextView *currentTextView;

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;

@property (nonatomic, strong) CommonRowMo *rowPerson;
@property (nonatomic, strong) CommonRowMo *rowDate;

@end

@implementation CreatePersonnelDemandViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self setUI];
    [self configRowMos];
}

- (void)configRowMos {
    
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_MEMBER;
    rowMo0.nullAble = NO;
    rowMo0.leftContent = @"客户名称";
    rowMo0.rightContent = @"请选择";
    rowMo0.key = @"member";
    if (!self.fromTab) {
        rowMo0.member = TheCustomer.customerMo;
        rowMo0.strValue = TheCustomer.customerMo.orgName;
        rowMo0.editAble = NO;
    } else {
        rowMo0.editAble = YES;
    }
    [self.arrData addObject:rowMo0];
    
    CommonRowMo *rowMo = [[CommonRowMo alloc] init];
    rowMo.rowType = K_INPUT_SELECT_OTHER;
    rowMo.editAble = YES;
    rowMo.nullAble = NO;
    rowMo.leftContent = @"联系人";
    rowMo.rightContent = @"请选择";
    rowMo.key = @"linkMan";
    if (self.contactMo) {
        rowMo.m_obj = self.contactMo;
        rowMo.strValue = self.contactMo.name;
    }
    [self.arrData addObject:rowMo];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_TEXT;
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.keyBoardType = K_DEFAULT;
    rowMo1.editAble = YES;
    rowMo1.nullAble = NO;
    rowMo1.leftContent = @"需求痛点";
    rowMo1.rightContent = @"请输入";
    rowMo1.key = @"desp";
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_RADIO;
    rowMo2.editAble = YES;
    rowMo2.nullAble = NO;
    rowMo2.leftContent = @"是否需要回复";
    rowMo2.rightContent = @"否";
    rowMo2.defaultValue = NO;
    rowMo2.trueDesp = @"是";
    rowMo2.falseDesp = @"否";
    rowMo2.key = @"needFeedBack";
    rowMo2.strValue = @"否";
    [self.arrData addObject:rowMo2];
    
    [self.tableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    return rowMo.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == self.arrData.count-1) ? 100.0 : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
        if ([rowMo.inputType isEqualToString:K_SHORT_TEXT]) {
            // 默认输入框
            static NSString *identifier = @"DefaultInputCell";
            DefaultInputCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[DefaultInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.cellDelegate = self;
            }
            cell.indexPath = indexPath;
            [cell setLeftText:rowMo.leftContent];
            cell.txtRight.placeholder = rowMo.rightContent;
            cell.txtRight.keyboardType = rowMo.iosKeyBoardType;
            cell.txtRight.enabled = rowMo.editAble;
            ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:rowMo.strValue];
            cell.txtRight.text = showTextMo.text;
            return cell;
        } else if ([rowMo.inputType isEqualToString:K_LONG_TEXT]) {
            // 备注输入框
            static NSString *cellId = @"contentCell";
            MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.cellDelegate = self;
            }
            [cell setLeftText:rowMo.leftContent];
            cell.placeholder = rowMo.rightContent;
            cell.txtView.keyboardType = rowMo.iosKeyBoardType;
            cell.txtView.editable = rowMo.editAble;
            cell.indexPath = indexPath;
            cell.txtView.text = [Utils showTextRightStr:@"" valueStr:rowMo.strValue].text;
            return cell;
        } else if ([rowMo.inputType isEqualToString:K_NUMBER_A_TEXT]) {
            // 价格输入框
            return [[UITableViewCell alloc] init];
        } else {
            return [[UITableViewCell alloc] init];
        }
    }
    else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT] || [rowMo.rowType isEqualToString:K_DATE_SELECT] || [rowMo.rowType isEqualToString:K_INPUT_MEMBER] || [rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER] || [rowMo.rowType isEqualToString:K_INPUT_PRODUCT_TYPE] || [rowMo.rowType isEqualToString:K_INPUT_DEPARTMENT] || [rowMo.rowType isEqualToString:K_INPUT_RADIO] || [rowMo.rowType isEqualToString:K_INPUT_OPERATOR]) {
        // 选择列表 || 时间选择
        static NSString *cellId = @"commonCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell setLeftText:rowMo.leftContent];
        ShowTextMo *showTextMo = [Utils showTextRightStr:rowMo.rightContent valueStr:rowMo.strValue];
        cell.labRight.textColor = rowMo.editAble ? showTextMo.color : COLOR_B2;
        cell.labRight.text = showTextMo.text;
        cell.labLeft.textColor = COLOR_B1;
        return cell;
    }
    // 标题
    else if ([rowMo.rowType isEqualToString:K_INPUT_TITLE]) {
        static NSString *cellId = @"DefaultHeaderCell";
        DefaultHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[DefaultHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.labLeft.text = rowMo.leftContent;
        return cell;
    }
    else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    if (!rowMo.editAble) {
        return;
    }
    // 标题
    if ([rowMo.rowType isEqualToString:K_INPUT_TITLE]) {
        
    } else if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
        
    } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {

    } else if ([rowMo.rowType isEqualToString:K_DATE_SELECT]) {
        // 时间选择
        [self hidenKeyboard];
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:rowMo.pattern];
        NSDate *scrollToDate = [minDateFormater dateFromString:rowMo.strValue];
        
        WSDateStyle style = DateStyleShowYearMonthDay;
        // 日期格式  "yyyy-MM", "yyyy-MM-dd", "yyyy-MM-dd hh", "yyyy-MM-dd HH:mm:ss"等
        if ([rowMo.pattern isEqualToString:@"yyyy-MM"]) {
            style = DateStyleShowYearMonth;
        } else if ([rowMo.pattern isEqualToString:@"yyyy-MM-dd"]) {
            style = DateStyleShowYearMonthDay;
        } else if ([rowMo.pattern isEqualToString:@"yyyy-MM-dd HH:mm:ss"] || [rowMo.pattern isEqualToString:@"yyyy-MM-dd HH:mm"]) {
            style = DateStyleShowYearMonthDayHourMinute;
        }
        
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:style scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:rowMo.pattern];
            NSLog(@"选择的日期：%@",date);
            rowMo.strValue = [Utils saveToValues:date];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    } else if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
        [self hidenKeyboard];
    } else if ([rowMo.rowType isEqualToString:K_INPUT_MEMBER]) {
        // 客户选择
        [self hidenKeyboard];
        MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
        vc.needRules = NO;
        vc.VcDelegate = self;
        vc.defaultId = rowMo.member.id;
        vc.indexPath = indexPath;
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
        [self hidenKeyboard];
    }
    // 简单选择
    else if ([rowMo.rowType isEqualToString:K_INPUT_RADIO]) {
        [self hidenKeyboard];
        __weak typeof(self) weakself = self;
        BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[STRING(rowMo.trueDesp), STRING(rowMo.falseDesp)] defaultItem:-1 itemClick:^(NSInteger index) {
            __strong typeof(self) strongself = weakself;
            rowMo.defaultValue = index==0?YES:NO;
            rowMo.strValue = rowMo.defaultValue?rowMo.trueDesp:rowMo.falseDesp;
            [strongself needReply:rowMo.defaultValue];
        } cancelClick:^(BottomView *obj) {
            if (obj) {
                obj = nil;
            }
        }];
        [bottomView show];
    } else if ([rowMo.rowType isEqualToString:K_INPUT_OPERATOR]) {
        [self hidenKeyboard];
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.indexPath = indexPath;
        vc.VcDelegate = self;
        vc.isMultiple = NO;
        JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
        if (userMo) vc.defaultValues = [NSMutableArray arrayWithObject:@(userMo.id)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER]) {
        [self hidenKeyboard];
        if ([rowMo.key isEqualToString:@"linkMan"]) {
            CommonRowMo *rowMember = self.arrData[0];
            if (rowMember.member.id == 0) {
                [Utils showToastMessage:@"请先选择客户"];
                return;
            }
            [Utils showHUDWithStatus:nil];
            PersonalSelectViewCtrl *vc = [[PersonalSelectViewCtrl alloc] init];
            vc.indexPath = indexPath;
            vc.vcDelegate = self;
            vc.memberId = rowMember.member.id;
            ContactMo *userMo = (ContactMo *)rowMo.m_obj;
            if (userMo) vc.defaultId = userMo.id;
            
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:navi animated:YES completion:nil];
            
//            [[JYUserApi sharedInstance] getConfigDicByName:rowMo.dictName success:^(id responseObject) {
//                [Utils dismissHUD];
//                [_selectArr removeAllObjects];
//                _selectArr = nil;
//                [_selectShowArr removeAllObjects];
//                _selectShowArr = nil;
//                self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
//                for (int i = 0; i < self.selectArr.count; i++) {
//                    DicMo *tmpDic = self.selectArr[i];
//                    if ([tmpDic.key isEqualToString:@"all"]) {
//                        [_selectArr removeObject:tmpDic];
//                        break;
//                    }
//                }
//                for (DicMo *tmpDic in self.selectArr) {
//                    ListSelectMo *mo = [[ListSelectMo alloc] init];
//                    mo.moId = tmpDic.id;
//                    mo.moText = tmpDic.value;
//                    mo.moKey = tmpDic.key;
//                    [self.selectShowArr addObject:mo];
//                }
//                [self pushToSelectVC:indexPath];
//            } failure:^(NSError *error) {
//                [Utils dismissHUD];
//            }];
        }
    }
}

- (void)needReply:(BOOL)reply {
    if (reply) {
        if (![self.arrData containsObject:self.rowPerson]) [self.arrData addObject:self.rowPerson];
        if (![self.arrData containsObject:self.rowDate]) [self.arrData addObject:self.rowDate];
    } else {
        if ([self.arrData containsObject:self.rowPerson]) [self.arrData removeObject:self.rowPerson];
        if ([self.arrData containsObject:self.rowDate]) [self.arrData removeObject:self.rowDate];
        self.rowDate = nil;
        self.rowPerson = nil;
    }
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    [self hidenKeyboard];
}

- (void)hidenKeyboard {
    if (_currentTextField) [_currentTextField resignFirstResponder];
    if (_currentTextView) [_currentTextView resignFirstResponder];
}

//- (void)pushToSelectVC:(NSIndexPath *)indexPath {
//    CommonRowMo *rowMo = self.arrData[indexPath.row];
//    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
//    vc.indexPath = indexPath;
//    vc.listVCdelegate = self;
//    vc.arrData = self.selectShowArr;
//    vc.title = rowMo.leftContent;
//    vc.byText = YES;
//    NSMutableArray *arrValue = [NSMutableArray new];
//    if (rowMo.mutiAble) {
//        // 多选
//        vc.isMultiple = YES;
//        for (DicMo *tmpMo in rowMo.mutipleValue) {
//            [arrValue addObject:STRING(tmpMo.key)];
//        }
//    } else {
//        // 单选
//        [arrValue addObject:STRING(rowMo.singleValue.key)];
//    }
//    vc.defaultValues = [[NSMutableArray alloc] initWithArray:arrValue copyItems:YES];
//    [self.navigationController pushViewController:vc animated:YES];
//}

//#pragma mark - ListSelectViewCtrlDelegate
//
//- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
//    CommonRowMo *rowMo = self.arrData[indexPath.row];
//    DicMo *dicMo = [self.selectArr objectAtIndex:index];
//    rowMo.singleValue = dicMo;
//    rowMo.strValue = selectMo.moText;
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}

#pragma mark - DefaultInputCellDelegate

- (void)cell:(DefaultInputCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    _currentTextField = textField;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (rowMo.editAble) {
            [_currentTextField becomeFirstResponder];
        } else {
            [_currentTextField resignFirstResponder];
        }
    });
}

- (void)cell:(DefaultInputCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.strValue = [Utils saveToValues:(textField.text)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MyTextViewCellDelegate

- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.strValue = [Utils saveToValues:(textView.text)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    _currentTextView = textView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (rowMo.editAble) {
            [_currentTextView becomeFirstResponder];
        } else {
            [_currentTextView resignFirstResponder];
        }
    });
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.member = model;
        rowMo.strValue = model.orgName;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - JYUserMoSelectViewCtrlDelegate

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(JYUserMo *)selectMo {
    if (selectMo) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.m_obj = selectMo;
        rowMo.strValue = selectMo.name;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)jyUserMoSelectViewCtrlDismiss:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl {
    jyUserMoSelectViewCtrl = nil;
}

#pragma mark - PersonalSelectViewCtrlDelegate

- (void)personalSelectViewCtrl:(PersonalSelectViewCtrl *)personalSelectViewCtrl didSelect:(ContactMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.m_obj = model;
        rowMo.strValue = model.name;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)personalSelectViewCtrlDismiss:(PersonalSelectViewCtrl *)personalSelectViewCtrl {
    personalSelectViewCtrl = nil;
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    [self hidenKeyboard];
    NSInteger attachIndex = -1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    // 先判断是否可以后续操作，所以两个循环
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *rowMo = self.arrData[i];
        if (!rowMo.nullAble && rowMo.editAble) {
            if (rowMo.strValue.length == 0) {
                [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@", rowMo.leftContent]];
                return;
            }
        }
    }
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *rowMo = self.arrData[i];
        // 客户
        if ([rowMo.rowType isEqualToString:K_INPUT_MEMBER]) {
            if (rowMo.member.id != 0) {
                [param setObject:@{@"id":@(rowMo.member.id)} forKey:rowMo.key];
            }
        }
        // 输入
        else if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
            if ([Utils uploadToValues:rowMo.strValue]) {
                // 有Key才传值
                if (rowMo.key.length != 0) {
                    [param setObject:rowMo.strValue forKey:rowMo.key];
                }
            }
        }
        // 时间
        if ([rowMo.rowType isEqualToString:K_DATE_SELECT]) {
            if ([Utils uploadToValues:rowMo.strValue]) [param setObject:rowMo.strValue forKey:rowMo.key];
        }
        // 选择
        else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
            
            if (rowMo.mutiAble) {
                // 多选
                NSMutableArray *arrValue = [NSMutableArray new];
                for (DicMo *tmpMo in rowMo.mutipleValue) {
                    [arrValue addObject:STRING(tmpMo.key)];
                }
                if (arrValue.count > 0) [param setObject:arrValue forKey:rowMo.key];
            } else {
                // 单选
                if (rowMo.singleValue) [param setObject:rowMo.singleValue.key forKey:rowMo.key];
            }
        }
        else if ([rowMo.rowType isEqualToString:K_INPUT_PRODUCT_TYPE]) {
            if (rowMo.mutiAble) {
                NSMutableArray *arr = [NSMutableArray new];
                for (MaterialMo *tmpMo in rowMo.m_objs) {
                    [arr addObject:@{@"id":@(tmpMo.id)}];
                }
                if (arr.count > 0) [param setObject:arr forKey:rowMo.key];
            } else {
                if (rowMo.m_obj) [param setObject:@{@"id":@(((MaterialMo *)rowMo.m_obj).id)} forKey:rowMo.key];
            }
        }
        // 简单选择
        else if ([rowMo.rowType isEqualToString:K_INPUT_RADIO]) {
            [param setObject:@(rowMo.defaultValue) forKey:rowMo.key];
        }
        // 操作员
        else if ([rowMo.rowType isEqualToString:K_INPUT_OPERATOR]) {
            JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
            if (userMo) [param setObject:@{@"id":@(userMo.id)} forKey:rowMo.key];
        }
        
        else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER]) {
            // 联系人
            if ([rowMo.key isEqualToString:@"linkMan"]) {
                ContactMo *userMo = (ContactMo *)rowMo.m_obj;
                if (userMo) [param setObject:@{@"id":@(userMo.id)} forKey:rowMo.key];
            }
            // 回复人
            else if ([rowMo.key isEqualToString:@"operator"]) {
                JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
                if (userMo) [param setObject:@{@"id":@(userMo.id)} forKey:rowMo.key];
            }
        }
        
        if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            attachIndex = i;
        }
    }

    [self createParams:param attachementList:@[]];
}

- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    
    [[JYUserApi sharedInstance] createPainPointParam:params success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"创建成功"];
        if (self.updateSuccess) {
            self.updateSuccess(nil);
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

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (CommonRowMo *)rowPerson {
    if (!_rowPerson) {
        _rowPerson = [[CommonRowMo alloc] init];
        _rowPerson.rowType = K_INPUT_OPERATOR;
        _rowPerson.editAble = YES;
        _rowPerson.nullAble = NO;
        _rowPerson.leftContent = @"回复人";
        _rowPerson.rightContent = @"请选择";
        _rowPerson.key = @"operator";
    }
    return _rowPerson;
}

- (CommonRowMo *)rowDate {
    if (!_rowDate) {
        _rowDate = [[CommonRowMo alloc] init];
        _rowDate.rowType = K_DATE_SELECT;
        _rowDate.editAble = YES;
        _rowDate.nullAble = NO;
        _rowDate.pattern = @"yyyy-MM-dd";
        _rowDate.leftContent = @"回复截止日期";
        _rowDate.rightContent = @"请选择";
        _rowDate.key = @"closingDate";
    }
    return _rowDate;
}


@end
