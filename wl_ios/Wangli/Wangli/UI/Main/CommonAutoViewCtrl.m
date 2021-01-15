//
//  CommonAutoViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CommonAutoViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "AttachmentCell.h"
#import "MemberSelectViewCtrl.h"
#import "WSDatePickerView.h"
#import "UIButton+ShortCut.h"
#import "NewComplaintCell.h"
#import "QiNiuUploadHelper.h"
#import "MaterialPageSelectViewCtrl.h"
#import "BottomView.h"
#import "DepartmentSelectViewCtrl.h"
#import "JYUserMoSelectViewCtrl.h"
#import "StoreBandsSelectViewCtrl.h"
#import "BaseWebViewCtrl.h"

@interface CommonAutoViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, MyTextViewCellDelegate, DefaultInputCellDelegate, MemberSelectViewCtrlDelegate, MyButtonCellDelegate, MaterialPageSelectViewCtrlDelegate, DepartmentSelectViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, MySwitchCellDelegate, StoreBandsSelectViewCtrlDelegate>

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UITextView *currentTextView;

// 重用之后，如果滑动隐藏了附件之后，拿不到原先的单元格，所以单独创建保留
@property (nonatomic, strong) AttachmentCell *attCell;

@end

@implementation CommonAutoViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化选项
    [self configRowMos];
    // 初始化数据
    [self config];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.rightBtn.hidden = self.forbidEdit;
    [self setUI];
    
    // 监听键盘高度变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hidenKeyboard];
}

- (void)configRowMos {
}

- (void)config {
}

#pragma mark - 键盘相关

- (void)onKeyboardWillHide:(NSNotification *)note
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

- (void)onKeyboardWillShow:(NSNotification *)note
{
    CGRect keyboardFrame;
    [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    float verticalOffset = CGRectGetHeight(keyboardFrame);
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-verticalOffset);
    }];
    [self.view layoutIfNeeded];
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
    static NSString *headerId = @"headerId";
    MyCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[MyCommonHeaderView alloc] initWithReuseIdentifier:headerId isHidenLine:YES];
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MyCommonHeaderView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (!footer) {
        footer = [[MyCommonHeaderView alloc] initWithReuseIdentifier:@"footer" isHidenLine:YES];
        footer.isHidenLine = YES;
    }
    return footer;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
        if ([rowMo.inputType isEqualToString:K_SHORT_TEXT] ||
            [rowMo.inputType isEqualToString:K_PHONE_TEXT]) {
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
            cell.txtRight.textColor = rowMo.editAble ? showTextMo.color : COLOR_B2;
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
    else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT] ||
             [rowMo.rowType isEqualToString:K_DATE_SELECT] ||
             [rowMo.rowType isEqualToString:K_INPUT_MEMBER] ||
             [rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER] ||
             [rowMo.rowType isEqualToString:K_INPUT_PRODUCT_TYPE] ||
             [rowMo.rowType isEqualToString:K_INPUT_DEPARTMENT] ||
             [rowMo.rowType isEqualToString:K_INPUT_RADIO] ||
             [rowMo.rowType isEqualToString:K_INPUT_OPERATOR] ||
             [rowMo.rowType isEqualToString:K_INPUT_BRAND_SELECT] ||
             [rowMo.rowType isEqualToString:K_INPUT_LINK]) {
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
    else if ([rowMo.rowType isEqualToString:K_INPUT_TOGGLEBUTTON]) {
        // 单选按钮
        static NSString *cellId = @"MySwitchCell";
        MySwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MySwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.cellDelegate = self;
        }
        [cell setLeftText:rowMo.leftContent];
        cell.labLeft.textColor = COLOR_B1;
        [cell.btnRight setOn:rowMo.defaultValue];
        cell.indexPath = indexPath;
        return cell;
    }
    else if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
//        static NSString *cellId = @"attachmentCell";
//        AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (!cell) {
//            cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//            cell.count = 9;
//            cell.attachments = rowMo.attachments;
//            [cell refreshView];
//        }
//        return cell;
        if (!self.attCell) {
            self.attCell = [[AttachmentCell alloc] init];
            self.attCell.count = 9;
            self.attCell.attachments = rowMo.attachments;
            self.attCell.forbidDelete = self.forbidEdit;
            if (rowMo.leftContent.length != 0) self.attCell.labTitle.text = rowMo.leftContent;
            [self.attCell refreshView];
        }
        return self.attCell;
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
    // 按钮
    else if ([rowMo.rowType isEqualToString:K_INPUT_BUTTON]) {
        static NSString *cellId = @"MyButtonCell";
        MyButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.cellDelegate = self;
        }
        [cell.btnSave setTitle:rowMo.leftContent forState:UIControlStateNormal];
        return cell;
    }
    else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    if (!rowMo.editAble || self.forbidEdit) {
        // 链接
        if ([rowMo.rowType isEqualToString:K_INPUT_LINK]) {
            BaseWebViewCtrl *vc = [[BaseWebViewCtrl alloc] init];
            NSString *url = (NSString *)rowMo.value;
            NSString *urlStr = [NSString stringWithFormat:@"%@?id=%ld&officeName=%@&token=%@", url, (long)TheUser.userMo.id, [Utils officeName], [Utils token]];
            vc.urlStr = urlStr;
            vc.titleStr = rowMo.leftContent;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (_currentTextView) [_currentTextView resignFirstResponder];
        if (_currentTextField) [_currentTextField resignFirstResponder];
        return;
    }
    // 标题
    if ([rowMo.rowType isEqualToString:K_INPUT_TITLE]) {
        
    } else if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {

    } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
        // 字典项选择
        [self hidenKeyboard];
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
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
        }];
    } else if ([rowMo.rowType isEqualToString:K_DATE_SELECT]) {
        // 时间选择
        [self hidenKeyboard];
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:rowMo.pattern];
        NSDate *scrollToDate = [minDateFormater dateFromString:rowMo.strValue];
        NSString *scrollTODateString = rowMo.strValue;
        WSDateStyle style = DateStyleShowYearMonthDay;
        // 日期格式  "yyyy-MM", "yyyy-MM-dd", "yyyy-MM-dd hh", "yyyy-MM-dd HH:mm:ss"等
        if ([rowMo.pattern isEqualToString:@"yyyy-MM"]) {
            style = DateStyleShowYearMonth;
        } else if ([rowMo.pattern isEqualToString:@"yyyy-MM-dd"]) {
            style = DateStyleShowYearMonthDay;
        } else if ([rowMo.pattern isEqualToString:@"yyyy-MM-dd HH:mm:ss"] || [rowMo.pattern isEqualToString:@"yyyy-MM-dd HH:mm"]) {
            style = DateStyleShowYearMonthDayHourMinute;
        }
        __weak typeof(self) weakself = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:style scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            __weak typeof(self) strongself = weakself;
            NSString *date = [selectDate stringWithFormat:rowMo.pattern];
            NSLog(@"选择的日期：%@",date);
            rowMo.strValue = [Utils saveToValues:date];
            [strongself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [strongself continueTodo:rowMo.key selName:scrollTODateString indexPath:indexPath];
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
        NSMutableArray *memberRules = self.customRules[@"member"];
        if (memberRules.count > 0) vc.customRules = memberRules;
        vc.needRules = NO;
        vc.VcDelegate = self;
        vc.defaultId = rowMo.member.id;
        vc.indexPath = indexPath;
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
//    } else if (rowMo.iosRowType == RowOperator) {
//        [self hidenKeyboard];
//    } else if (rowMo.iosRowType == RowOther) {
        [self hidenKeyboard];
    } else if ([rowMo.rowType isEqualToString:K_INPUT_PRODUCT_TYPE]) {
        MaterialPageSelectViewCtrl *vc = [[MaterialPageSelectViewCtrl alloc] init];
        vc.vcDelegate = self;
        vc.indexPath = indexPath;
        vc.isSignal = !rowMo.mutiAble;
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
        [self hidenKeyboard];
    }
    // 部门
    else if ([rowMo.rowType isEqualToString:K_INPUT_DEPARTMENT]) {
        [self hidenKeyboard];
        DepartmentSelectViewCtrl *vc = [[DepartmentSelectViewCtrl alloc] init];
        vc.vcDelegate = self;
        vc.indexPath = indexPath;
        DepartmentMo *tmpMo = (DepartmentMo *)rowMo.m_obj;
        if (tmpMo) vc.defaultId = tmpMo.id;
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
            [strongself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } cancelClick:^(BottomView *obj) {
            if (obj) {
                obj = nil;
            }
        }];
        [bottomView show];
    } else if ([rowMo.rowType isEqualToString:K_INPUT_OPERATOR]) {
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.indexPath = indexPath;
        vc.VcDelegate = self;
        vc.isMultiple = NO;
        vc.selectType = self.userselectType;
        JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
        if (userMo) vc.defaultValues = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%ld", (long)userMo.id]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 经营品牌
    else if ([rowMo.rowType isEqualToString:K_INPUT_BRAND_SELECT]) {
        StoreBandsSelectViewCtrl *vc = [[StoreBandsSelectViewCtrl alloc] init];
        vc.indexPath = indexPath;
        vc.VcDelegate = self;
        vc.isMultiple = rowMo.mutiAble;
        if (rowMo.m_objs.count > 0) {
            NSMutableArray *arr = [NSMutableArray new];
            for (StoreBandsMo *tmpMo in rowMo.m_objs) {
                [arr addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
            }
            vc.defaultValues = arr;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self hidenKeyboard];
}

- (void)hidenKeyboard {
    if (_currentTextField) [_currentTextField resignFirstResponder];
    if (_currentTextView) [_currentTextView resignFirstResponder];
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = rowMo.leftContent;
    vc.byText = YES;
    NSMutableArray *arrValue = [NSMutableArray new];
    if (rowMo.mutiAble) {
        // 多选
        vc.isMultiple = YES;
        for (DicMo *tmpMo in rowMo.mutipleValue) {
            [arrValue addObject:STRING(tmpMo.key)];
        }
    } else {
        // 单选
        [arrValue addObject:STRING(rowMo.singleValue.key)];
    }
    vc.defaultValues = [[NSMutableArray alloc] initWithArray:arrValue copyItems:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DefaultInputCellDelegate

- (void)cell:(DefaultInputCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    _currentTextField = textField;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (rowMo.editAble && !self.forbidEdit) {
            [_currentTextField becomeFirstResponder];
        } else {
            [_currentTextField resignFirstResponder];
        }
    });
//    if ([rowMo.key isEqualToString:@"reimbursementCity"]||
//        [rowMo.key isEqualToString:@"city"]||
//        [rowMo.key isEqualToString:@"area"]) {
//        [self continueTodo:rowMo.key selName:@"DefaultInputCellBegin" indexPath:indexPath];
//    }
    [self continueTodo:rowMo.key selName:@"DefaultInputCellBegin" indexPath:indexPath];
}

- (void)cell:(DefaultInputCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.strValue = [Utils saveToValues:(textField.text)];
    rowMo.value = [Utils saveToValues:(textField.text)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self continueTodo:rowMo.key selName:@"DefaultInputCellEnd" indexPath:indexPath];
    _currentTextField = nil;
}

#pragma mark - MyTextViewCellDelegate

- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.strValue = [Utils saveToValues:(textView.text)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    _currentTextView = nil;
}

- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    _currentTextView = textView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (rowMo.editAble && !self.forbidEdit) {
            [_currentTextView becomeFirstResponder];
        } else {
            [_currentTextView resignFirstResponder];
        }
    });
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    DicMo *dicMo = [self.selectArr objectAtIndex:index];
    rowMo.singleValue = dicMo;
    rowMo.strValue = selectMo.moText;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self continueTodo:rowMo.key selName:@"ListSelectViewCtrl" indexPath:indexPath];
}

// 多选方法，会覆盖单选方法
- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath {
    NSString *valueStr = @"";
    NSMutableArray *multipleValue = [NSMutableArray new];
    for (int i = 0; i < selectIndexPaths.count; i++) {
        NSIndexPath *tmpIndexPath = selectIndexPaths[i];
        ListSelectMo *tmpMo = [self.selectShowArr objectAtIndex:tmpIndexPath.row];
        [multipleValue addObject:self.selectArr[tmpIndexPath.row]];
        valueStr = [valueStr stringByAppendingString:STRING(tmpMo.moText)];
        if (i < selectIndexPaths.count - 1) {
            valueStr = [valueStr stringByAppendingString:@","];
        }
    }
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.mutipleValue = multipleValue;
    rowMo.strValue = valueStr;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.member = model;
        rowMo.strValue = model.orgName;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self continueTodo:@"member" selName:@"MemberSelectViewCtrl" indexPath:indexPath];
    }
}

#pragma mark - MaterialPageSelectViewCtrlDelegate

- (void)materialPageSelectViewCtrl:(MaterialPageSelectViewCtrl *)materialPageSelectViewCtrl didSelectData:(NSArray *)data indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    // 多选
    if (rowMo.mutiAble) {
        NSString *valueStr = @"";
        for (int i = 0; i < data.count; i++) {
            MaterialMo *tmpMo = data[i];
            valueStr = [valueStr stringByAppendingString:STRING(tmpMo.name)];
            if (i < data.count - 1) {
                valueStr = [valueStr stringByAppendingString:@","];
            }
        }
        if (data.count > 0) {
            rowMo.m_objs = [[NSMutableArray alloc] initWithArray:data];
            rowMo.strValue = valueStr;
        }
    }
    // 单选
    else {
        MaterialMo *tmpMo = [data firstObject];
        rowMo.m_obj = tmpMo;
        rowMo.strValue = STRING(tmpMo.name);
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)materialPageSelectViewCtrlDismiss:(MaterialPageSelectViewCtrl *)materialPageSelectViewCtrl {
    materialPageSelectViewCtrl = nil;
}

#pragma mark - DepartmentSelectViewCtrlDelegate

- (void)departmentSelectViewCtrl:(DepartmentSelectViewCtrl *)departmentSelectViewCtrl didSelect:(DepartmentMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.m_obj = model;
        rowMo.strValue = model.name;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)departmentSelectViewCtrlDismiss:(DepartmentSelectViewCtrl *)departmentSelectViewCtrl {
    departmentSelectViewCtrl = nil;
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    [self clickRightButton:self.rightBtn];
}

#pragma mark - MySwitchCellDelegate

- (void)cell:(MySwitchCell *)cell btnClick:(UISwitch *)sender isOn:(BOOL)isOn indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    if (rowMo.editAble && !self.forbidEdit) {
        rowMo.defaultValue = isOn;
        rowMo.strValue = rowMo.defaultValue?@"YES":@"NO";
        [self continueTodo:rowMo.key selName:@"MySwitchCellBtnSender" indexPath:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - JYUserMoSelectViewCtrlDelegate

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(JYUserMo *)selectMo {
    if (selectMo) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.m_obj = selectMo;
        rowMo.strValue = selectMo.name;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self continueTodo:rowMo.key selName:@"jyUserMoSelectViewCtrlSelectIndex" indexPath:indexPath];
    }
}

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectedData:(NSArray *)selectedData indexPath:(NSIndexPath *)indexPath {
//    NSString *str = [[NSString alloc] init];
//    if (indexPath.row == 4) {
//        [self.arrPerson1 removeAllObjects];
//        for (int i = 0; i < selectedData.count; i++) {
//            JYUserMo *tmpMo = selectedData[i];
//            [self.arrPerson1 addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
//            str = [str stringByAppendingString:STRING(tmpMo.name)];
//            if (i < selectedData.count - 1) {
//                str = [str stringByAppendingString:@","];
//            }
//        }
//    } else if (indexPath.row == 5) {
//        [self.arrPerson2 removeAllObjects];
//        for (int i = 0; i < selectedData.count; i++) {
//            JYUserMo *tmpMo = selectedData[i];
//            [self.arrPerson2 addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
//            str = [str stringByAppendingString:STRING(tmpMo.name)];
//            if (i < selectedData.count - 1) {
//                str = [str stringByAppendingString:@","];
//            }
//        }
//    }
//    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:str]];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)jyUserMoSelectViewCtrlDismiss:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl {
    jyUserMoSelectViewCtrl = nil;
}

#pragma mark - StoreBandsSelectViewCtrlDelegate

- (void)storeBandsSelectViewCtrl:(StoreBandsSelectViewCtrl *)storeBandsSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(StoreBandsMo *)selectMo {
    if (selectMo) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.m_obj = selectMo;
        rowMo.strValue = selectMo.brandName;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)storeBandsSelectViewCtrl:(StoreBandsSelectViewCtrl *)storeBandsSelectViewCtrl selectedData:(NSArray *)selectedData indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    NSString *str = [[NSString alloc] init];
    NSMutableArray *arrBands = [NSMutableArray new];
    for (int i = 0; i < selectedData.count; i++) {
        StoreBandsMo *tmpMo = selectedData[i];
        [arrBands addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
        str = [str stringByAppendingString:STRING(tmpMo.brandName)];
        if (i < selectedData.count - 1) {
            str = [str stringByAppendingString:@" "];
        }
    }
    rowMo.strValue = str;
    rowMo.m_objs = [[NSMutableArray alloc] initWithArray:selectedData];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)continueTodo:(NSString *)toDo selName:(NSString *)selName indexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    [self hidenKeyboard];
    AttachmentCell *cell = nil;
    NSInteger attachIndex = -1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    // 先判断是否可以后续操作，所以两个循环
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *rowMo = self.arrData[i];
        if ([rowMo.rowType isEqualToString:K_INPUT_LINK]) {
            continue;
        }
        // 确定是否有附件
        if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            attachIndex = i;
            cell = self.attCell;
            
            // 如果必填
            if (!rowMo.nullAble && rowMo.editAble) {
                
                // 如果cell=nil，则还没滑动到附件位置，判断原始的数据 _attachments
                // 如果cell不为空，则判断根据cell判断
                // cell为空，_attachments不为空的情况下，更新操作不会吧附件传上去，所以不会有问题
                if (!cell) {
                    if (self.attachments.count == 0) {
                        [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@", rowMo.leftContent]];
                        return;
                    }
                } else if (cell.collectionView.attachments.count == 0) {
                    [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@", rowMo.leftContent]];
                    return;
                }
            }
        } else if (!rowMo.nullAble && rowMo.editAble) {
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
        // swith
        if ([rowMo.rowType isEqualToString:K_INPUT_TOGGLEBUTTON]) {
            [param setObject:@(rowMo.defaultValue) forKey:rowMo.key];
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
        // 部门
        else if ([rowMo.rowType isEqualToString:K_INPUT_DEPARTMENT]) {
            DepartmentMo *depart = (DepartmentMo *)rowMo.m_obj;
            if (depart) [param setObject:@{@"id":@(depart.id)} forKey:rowMo.key];
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
        // 品牌
        else if ([rowMo.rowType isEqualToString:K_INPUT_BRAND_SELECT]) {
//            JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
//            if (userMo) [param setObject:@{@"id":@(userMo.id)} forKey:rowMo.key];
        }
        else if ([rowMo.rowType isEqualToString:K_INPUT_LINK]) {
        }
        if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            attachIndex = i;
        }
    }
    
    if (cell) {
        if (cell.collectionView.attachments.count > 0) {
            // 上传图片
            [Utils showHUDWithStatus:nil];
            QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
            [helper uploadFileMulti:cell.collectionView.attachments success:^(id responseObject) {
                [Utils showHUDWithStatus:@"附件上传成功"];
                [self dealWithParams:param attachementList:responseObject];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
                [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            }];
        } else {
            [self dealWithParams:param attachementList:[NSMutableArray new]];
        }
    } else {
        // 有附件，但是单元格还没显示出来
        if (attachIndex >= 0 && attachIndex < self.arrData.count) {
            CommonRowMo *attRowMo = self.arrData[attachIndex];
            [self dealWithParams:param attachementList:attRowMo.attachments];
        } else {
            [self dealWithParams:param attachementList:[NSMutableArray new]];
        }
    }
}

- (void)dealWithParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    if (self.isUpdate) {
        [self updateParams:params attachementList:attachementList];
    } else {
        [self createParams:params attachementList:attachementList];
    }
}


- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    
}

- (void)updateParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    
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

- (NSMutableDictionary *)customRules {
    if (!_customRules) _customRules = [NSMutableDictionary new];
    return _customRules;
}

@end
