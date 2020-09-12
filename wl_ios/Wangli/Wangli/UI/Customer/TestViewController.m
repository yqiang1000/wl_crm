//
//  TestViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/11/30.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TestViewController.h"
#import "QiniuFileMo.h"
#import "MyCommonCell.h"
#import "AttachmentCell.h"
#import "EditTextViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "QiNiuUploadHelper.h"
#import "WSDatePickerView.h"
#import "CommonRowMo.h"
#import "MemberSelectViewCtrl.h"

@interface TestViewController () <EditTextViewCtrlDelegate, ListSelectViewCtrlDelegate, MyTextViewCellDelegate, UITableViewDelegate, UITableViewDataSource, MemberSelectViewCtrlDelegate, MyTextFieldCellDelegate>

@property (nonatomic, strong) UITableView *tableView;           // 显示的列表
@property (nonatomic, strong) NSMutableArray *totalData;        // 模拟原始数据
@property (nonatomic, strong) NSMutableArray *arrData;          // 数据

@property (nonatomic, strong) NSMutableArray *selectArr;        // 点击选择的原始数据
@property (nonatomic, strong) NSMutableArray *selectShowArr;    // 点击选择的现实数据

@property (nonatomic, strong) NSMutableArray *attachments;      // 附件缩略数组
@property (nonatomic, strong) NSMutableArray *attachUrls;       // 附件原图数组

@property (nonatomic, strong) UITextView *currentTextView;
@property (nonatomic, strong) UITextField *currentTextField;

@property (nonatomic, strong) UITextField *txtField;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用列表测试";
    
    [self setUI];
    [self config];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)config {
    NSError *error = nil;
    self.arrData = [CommonRowMo arrayOfModelsFromDictionaries:self.totalData error:&error];
    for (CommonRowMo *rowMo in self.arrData) {
        if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            [_attachUrls removeAllObjects];
            [_attachments removeAllObjects];
            for (QiniuFileMo *tmpMo in rowMo.attachments) {
                [self.attachments addObject:STRING(tmpMo.thumbnail)];
                [self.attachUrls addObject:STRING(tmpMo.url)];
            }
        }
    }
    [self.tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];

    if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
        if ([rowMo.inputType isEqualToString:K_SHORT_TEXT] || [rowMo.inputType isEqualToString:K_EMAIL_TEXT]) {
            // 默认输入框 || 邮箱输入框
            static NSString *identifier = @"MyTextFieldCell";
            MyTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[MyTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.cellDelegate = self;
            }
            cell.imgArrow.hidden = YES;
            cell.btnRight.hidden = YES;
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
                [cell setLeftText:rowMo.leftContent];
                cell.placeholder = rowMo.rightContent;
                cell.cellDelegate = self;
            }
            cell.txtView.keyboardType = rowMo.iosKeyBoardType;
            cell.txtView.editable = rowMo.editAble;
            cell.indexPath = indexPath;
            cell.txtView.text = [Utils showTextRightStr:@"" valueStr:rowMo.strValue].text;
            return cell;
        } else if ([rowMo.inputType isEqualToString:K_NUMBER_A_TEXT]) {
            // 价格输入框
            return [[UITableViewCell alloc] init];
        } else if ([rowMo.inputType isEqualToString:K_PHONE_TEXT]) {
            // 手机号
//            static NSString *identifier = @"phoneFieldCell";
//            MyTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (cell == nil) {
//                cell = [[MyTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                cell.cellDelegate = self;
//            }
//            cell.imgArrow.hidden = YES;
//            cell.btnRight.hidden = YES;
//            cell.indexPath = indexPath;
//            [cell setLeftText:rowMo.leftContent];
//            cell.txtRight.placeholder = rowMo.rightContent;
//            cell.txtRight.keyboardType = rowMo.iosKeyBoardType;
//            cell.txtRight.enabled = rowMo.editAble;
//            cell.btnRight.hidden = NO;
//
//            [cell.btnRight setImage:[UIImage imageNamed:indexPath.row == _topCount ? @"client_add" : @"phone_delete"] forState:UIControlStateNormal];
//
//            ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:rowMo.strValue];
//            cell.txtRight.text = showTextMo.text;
//            return cell;
//
//            cell.labLeft.hidden = indexPath.row == _topCount ? NO : YES;
//            cell.btnRight.hidden = NO;
//            [cell.btnRight setImage:[UIImage imageNamed:indexPath.row == _topCount ? @"client_add" : @"phone_delete"] forState:UIControlStateNormal];
//            [cell setLeftText:self.arrLeft[_topCount]];
//            cell.txtRight.placeholder = indexPath.row == _topCount ? self.arrRight[_topCount] : @"请输入手机号";
//            ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrTel[indexPath.row - _topCount]];
//            cell.txtRight.text = showTextMo.text;
            
            return [[UITableViewCell alloc] init];
            
        } else {
            return [[UITableViewCell alloc] init];
        }
    }
    else if ([rowMo.rowType isEqualToString:K_DATE_SELECT] || [rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
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
    else if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
        static NSString *cellId = @"attachmentCell";
        AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.count = 9;
            cell.attachments = rowMo.attachments;
            [cell refreshView];
        }
        return cell;
    }
//    else if (rowMo.iosRowType == RowMember) {
//        return [[UITableViewCell alloc] init];
//    }
//    else if (rowMo.iosRowType == RowOperator) {
//        return [[UITableViewCell alloc] init];
//    }
    else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CommonRowMo *rowMo = self.arrData[indexPath.row];
    if (!rowMo.editAble) {
        return;
    }
    
    if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
//        if (rowMo.iosInputType == JYInputDefault || rowMo.iosInputType == JYInputEmailText) {
//            // 默认输入框 || 邮箱输入框
//        } else if (rowMo.iosInputType == JYInputLongText) {
//            // 备注输入框
//        } else if (rowMo.iosInputType == JYInputSmallText) {
//            // 价格输入框
//        } else if (rowMo.iosInputType == JYInputPhoneText) {
//            // 手机号
//        }
    } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
        // 字典项选择
        [self hidenKeyboard];
//        if ([rowMo.selectType isEqualToString:K_JYSelectDict]) {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] getConfigDicByName:rowMo.dictName success:^(id responseObject) {
                [Utils dismissHUD];
                [_selectArr removeAllObjects];
                _selectArr = nil;
                [_selectShowArr removeAllObjects];
                _selectShowArr = nil;
                self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
                for (int i = 0; i < self.selectArr.count; i++) {
                    DicMo *tmpDic = self.selectArr[i];
                    if ([tmpDic.key isEqualToString:@"all"]) {
                        [_selectArr removeObject:tmpDic];
                        break;
                    }
                }
                for (DicMo *tmpDic in self.selectArr) {
                    ListSelectMo *mo = [[ListSelectMo alloc] init];
                    mo.moId = tmpDic.id;
                    mo.moText = tmpDic.value;
                    mo.moKey = tmpDic.key;
                    [self.selectShowArr addObject:mo];
                }
                [self pushToSelectVC:indexPath rowMo:rowMo];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
            }];
//        } else {
//
//        }
    } else if ([rowMo.rowType isEqualToString:K_DATE_SELECT]) {
        // 时间选择
        [self hidenKeyboard];
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:rowMo.pattern];
        NSDate *scrollToDate = [minDateFormater dateFromString:rowMo.strValue];
        
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
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
    }
//    else if (rowMo.iosRowType == RowMember) {
//        [self hidenKeyboard];
//        MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
//        vc.needRules = NO;
//        vc.VcDelegate = self;
//        vc.defaultId = TheCustomer.customerMo.id;
//        vc.indexPath = indexPath;
//        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
//        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
//        }];
//    } else if (rowMo.iosRowType == RowOperator) {
//        [self hidenKeyboard];
//    } else if (rowMo.iosRowType == RowOther) {
//        [self hidenKeyboard];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hidenKeyboard];
}

- (void)hidenKeyboard {
    if (_currentTextView) {
        [_currentTextView resignFirstResponder];
        _currentTextView = nil;
    }
    if (_currentTextField) {
        [_currentTextField resignFirstResponder];
        _currentTextField = nil;
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath rowMo:(CommonRowMo *)rowMo {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = rowMo.leftContent;
    vc.isMultiple = rowMo.mutiAble;
    if (!rowMo.mutiAble) {
        vc.defaultValues = [[NSMutableArray alloc] initWithObjects:rowMo.strValue, nil];
    } else {
        NSMutableArray *orgValue = (NSMutableArray *)rowMo.mutipleValue;
        NSMutableArray *arr = [NSMutableArray new];
        
//        if ([rowMo.selectType isEqualToString:K_JYSelectDict]) {
            for (int i = 0; i < orgValue.count; i++) {
                NSDictionary *dic = orgValue[i];
                [arr addObject:STRING(dic[@"value"])];
            }
//        } else if ([rowMo.selectType isEqualToString:K_JYSelectEnum]) {
//            for (int i = 0; i < orgValue.count; i++) {
//                NSString *dic = orgValue[i];
//                [arr addObject:STRING(dic)];
//            }
//        }
        vc.defaultValues = [[NSMutableArray alloc] initWithArray:arr];
    }
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
//    if ([rowMo.selectType isEqualToString:K_JYSelectDict]) {
        DicMo *tmpDic = self.selectArr[index];
        NSDictionary *dic = @{@"id":STRING(tmpDic.id),
                              @"key":STRING(tmpDic.key),
                              @"value":STRING(tmpDic.value)};
        rowMo.singleValue = dic;
//    } else if ([rowMo.selectType isEqualToString:K_JYSelectEnum]) {
//        NSString *tmpDic = self.selectArr[index];
//        rowMo.singleValue = tmpDic;
//    }
    rowMo.strValue = selectMo.moText;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    NSMutableArray *mutipleValue = [NSMutableArray new];
    NSString *value = @"";
    
//    if ([rowMo.selectType isEqualToString:K_JYSelectDict]) {
        for (int i = 0; i < selectIndexPaths.count; i++) {
            NSIndexPath *tmpIndexPath = selectIndexPaths[i];
            DicMo *selectMo = self.selectArr[tmpIndexPath.row];
            NSDictionary *dic = @{@"id":STRING(selectMo.id),
                                  @"key":STRING(selectMo.key),
                                  @"value":STRING(selectMo.value)};
            [mutipleValue addObject:dic];
            value = [value stringByAppendingString:selectMo.value];
            if (i != selectIndexPaths.count - 1) {
                value = [value stringByAppendingString:@","];
            }
        }
        rowMo.mutipleValue = mutipleValue;
        rowMo.strValue = value;
//    } else if ([rowMo.selectType isEqualToString:K_JYSelectEnum]) {
//        for (int i = 0; i < selectIndexPaths.count; i++) {
//            NSIndexPath *tmpIndexPath = selectIndexPaths[i];
//            NSString *selectMo = self.selectShowArr[tmpIndexPath.row];
//            [mutipleValue addObject:STRING(selectMo)];
//            value = [value stringByAppendingString:selectMo];
//            if (i != selectIndexPaths.count - 1) {
//                value = [value stringByAppendingString:@","];
//            }
//        }
//        rowMo.mutipleValue = mutipleValue;
//        rowMo.strValue = value;
//
//    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

//#pragma mark - EditTextViewCtrlDelegate
//
//- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
//    CommonRowMo *rowMo = self.arrData[indexPath.row];
//    rowMo.strValue = [Utils saveToValues:content];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}

#pragma mark - MyTextViewCellDelegate

- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    if (_currentTextField) {
        [_currentTextField resignFirstResponder];
        _currentTextField = nil;
    }
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

- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.strValue = [Utils saveToValues:textView.text];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - MyTextFieldCellDelegate

- (void)cell:(MyTextFieldCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
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

- (void)cell:(MyTextFieldCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.strValue = [Utils saveToValues:(textField.text)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    if (indexPath.row < _topCount) {
//        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:(textField.text)]];
//    } else if (indexPath.row >= _topCount && indexPath.row < _topCount+self.arrTel.count) {
//        NSString *tel = textField.text;
//        if (tel.length >= 11) {
//            tel = [tel substringToIndex:11];
//        }
//        [self.arrTel replaceObjectAtIndex:indexPath.row-_topCount withObject:[Utils saveToValues:tel]];
//    } else {
//        NSInteger index = indexPath.row - self.arrTel.count + 1;
//        [self.arrValues replaceObjectAtIndex:index withObject:[Utils saveToValues:(textField.text)]];
//    }
}

- (void)cell:(MyTextFieldCell *)cell btnClick:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 3) {
//        if (self.arrTel.count < 4) {
//            [self.arrTel addObject:@"demo"];
//        } else {
//            [Utils showToastMessage:@"手机号码数量超过限制"];
//            return;
//        }
//    } else {
//        [self.arrTel removeObjectAtIndex:indexPath.row - 3];
//    }
    [self.tableView reloadData];
}


#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        TheCustomer.customerMo = model;
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.strValue = [Utils saveToValues:model.orgName];

        if (indexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadData];
        }
    }
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
        // 特殊的情况先处理
        if ([rowMo.otherTag isEqualToString:@"member"]) {
        }
//        // 客户
//        else if (rowMo.iosRowType == RowMember) {
//            [param setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
//        }
        // 输入框
        else if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
            // 手机号
            if ([rowMo.inputType isEqualToString:K_PHONE_TEXT]) {
                
            } else {
                // 其他输入框
                if ([Utils uploadToValues:rowMo.strValue])
                    [param setObject:rowMo.strValue forKey:rowMo.key];
            }
        }
        // 字典项
//        if ([rowMo.selectType isEqualToString:K_JYSelectDict]) {
            // 多选
            if (rowMo.mutiAble) {
                if (rowMo.mutipleValue) [param setObject:rowMo.mutipleValue forKey:rowMo.key];
            } else {
                // 单选
                if (rowMo.singleValue) [param setObject:rowMo.singleValue forKey:rowMo.key];
            }
//        }
        if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            attachIndex = i;
        }
    }

    AttachmentCell *cell = nil;
    if (attachIndex >= 0) {
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:attachIndex inSection:0]];
    }
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        [Utils showHUDWithStatus:nil];
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self createCommonListParam:param attachementList:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self createCommonListParam:param attachementList:@[]];
    }
}

- (void)createCommonListParam:(NSDictionary *)param attachementList:(NSArray *)attachementList {
    
    if (self.createBlock) {
        self.createBlock(param, attachementList);
    }
    
    
    
//    NSDictionary *dic = @{@"type":@{@"id":STRING(_dicMo.id),
//                                    @"value":STRING(_dicMo.value),
//                                    @"key":STRING(_dicMo.key)}};
//    if (_mo) {
//        [[JYUserApi sharedInstance] updateRiskWarnByRiskId:_mo.id riskManageHandleDate:self.arrValues[3] type:dic title:_dicMo.value content:self.arrValues[4] riskManageComments:@"未知" attachmentList:[Utils filterUrls:attachementList arrFile:_mo.attachmentList] success:^(id responseObject) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:@"修改成功"];
//            RiskFollowMo *tmpMo = [[RiskFollowMo alloc] initWithDictionary:responseObject error:nil];
//            if (self.createUpdateSuccess) {
//                self.createUpdateSuccess(tmpMo);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//        }];
//    } else {
//        [[JYUserApi sharedInstance] createRiskWarnParam:param  attachmentList:attachementList success:^(id responseObject) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:@"创建成功"];
////            if (self.createUpdateSuccess) {
////                self.createUpdateSuccess(nil);
////            }
//            [self.navigationController popViewControllerAnimated:YES];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//        }];
//    }
    
}

#pragma mark - lazy

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

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [NSMutableArray new];
    }
    return _attachments;
}

- (NSMutableArray *)attachUrls {
    if (!_attachUrls) {
        _attachUrls = [NSMutableArray new];
    }
    return _attachUrls;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableArray *)totalData {
    if (!_totalData) {
        _totalData = [[NSMutableArray alloc] initWithArray:
                      @[@{
                            @"nullAble": @"false",
                            @"editAble": @"false",
                            @"rowType": @"INPUT_TEXT",
                            @"index": @"0",
                            @"leftContent": @"普通输入",
                            @"rightContent": @"请输入",
                            @"key": @"id",
                            @"value": @"",
                            @"inputType": @"SHORT_TEXT",
                            @"keyBoardType": @"INTEGER"
                            },
                        @{
                            @"nullAble": @"false",
                            @"editAble": @"true",
                            @"rowType": @"DATE_SELECT",
                            @"index": @"1",
                            @"leftContent": @"日期选择",
                            @"rightContent": @"请输入",
                            @"key": @"birthday",
                            @"value": @"2018-12-05",
                            @"pattern": @"yyyy-MM-dd"
                            },
                        @{
                            @"nullAble": @"false",
                            @"editAble": @"true",
                            @"rowType": @"INPUT_TEXT",
                            @"index": @"2",
                            @"leftContent": @"备注输入",
                            @"rightContent": @"请输入",
                            @"key": @"userName",
                            @"value": @"",
                            @"inputType": @"LONG_TEXT",
                            @"keyBoardType": @"INTEGER"
                            },
                        @{
                            @"nullAble": @"true",
                            @"editAble": @"true",
                            @"rowType": @"INPUT_SELECT",
                            @"index": @"3",
                            @"leftContent": @"课程单选",
                            @"rightContent": @"请选择",
                            @"key": @"course",
                            @"value": @"",
                            @"mutiAble": @"false",
                            @"dictName": @"",
                            @"singleValue": @"",
                            @"multipleValue":@"",
                            },
                        @{
                            @"nullAble": @"true",
                            @"editAble": @"true",
                            @"rowType": @"INPUT_SELECT",
                            @"index": @"4",
                            @"leftContent": @"课程多选",
                            @"rightContent": @"请选择",
                            @"key": @"course1",
                            @"value": @"",
                            @"mutiAble": @"true",
                            @"dictName": @"",
                            @"singleValue": @"",
                            @"multipleValue":@"",
                            },
                        @{
                            @"nullAble": @"false",
                            @"editAble": @"true",
                            @"rowType": @"INPUT_SELECT",
                            @"index": @"5",
                            @"leftContent": @"字典单选",
                            @"rightContent": @"请选择",
                            @"key": @"dict",
                            @"value": @"",
                            @"mutiAble": @"false",
                            @"dictName": @"risk_type",
                            @"singleValue": @"",
                            @"multipleValue": @""
                            },
                        @{
                            @"nullAble": @"false",
                            @"editAble": @"true",
                            @"rowType": @"INPUT_SELECT",
                            @"index": @"6",
                            @"leftContent": @"字典多选",
                            @"rightContent": @"请选择",
                            @"key": @"dict1",
                            @"value": @"",
                            @"mutiAble": @"true",
                            @"dictName": @"risk_type",
                            @"singleValue": @"",
                            @"multipleValue": @""
                            },
                        @{
                            @"nullAble": @"false",
                            @"editAble": @"true",
                            @"rowType": @"INPUT_TEXT",
                            @"index": @"7",
                            @"leftContent": @"手机号",
                            @"rightContent": @"请输入",
                            @"key": @"phone",
                            @"value": @"",
                            @"inputType": @"PHONE_TEXT",
                            @"keyBoardType": @"INTEGER"
                            },
                        @{
                            @"nullAble": @"false",
                            @"editAble": @"true",
                            @"rowType": @"INPUT_TEXT",
                            @"index": @"8",
                            @"leftContent": @"邮箱",
                            @"rightContent": @"请输入",
                            @"key": @"email",
                            @"value": @"",
                            @"inputType": @"EMAIL_TEXT",
                            @"keyBoardType": @"INTEGER"
                            },
                        @{
                            @"nullAble": @"false",
                            @"editAble": @"true",
                            @"rowType": @"INPUT_TEXT",
                            @"index": @"9",
                            @"leftContent": @"邮箱",
                            @"rightContent": @"请输入",
                            @"key": @"email",
                            @"value": @"",
                            @"inputType": @"EMAIL_TEXT",
                            @"keyBoardType": @"INTEGER"
                            },
                        @{
                            @"nullAble": @"false",
                            @"editAble": @"false",
                            @"rowType": @"FILE_INPUT",
                            @"index": @"10",
                            @"leftContent": @"附件",
                            @"rightContent": @"请输入",
                            @"key": @"fujian",
                            @"value": @"",
                            @"inputType": @"SHORT_TEXT",
                            @"keyBoardType": @"DEFAULT"
                            }]];
        
    }
    return _totalData;
}

@end
