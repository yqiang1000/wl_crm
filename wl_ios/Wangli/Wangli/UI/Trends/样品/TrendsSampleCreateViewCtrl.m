//
//  TrendsSampleCreateViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsSampleCreateViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "AttachmentCell.h"
#import "MemberSelectViewCtrl.h"
#import "WSDatePickerView.h"
#import "UIButton+ShortCut.h"
#import "NewComplaintCell.h"
#import "QiNiuUploadHelper.h"

@interface TrendsSampleCreateViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, MyTextViewCellDelegate, DefaultInputCellDelegate, MemberSelectViewCtrlDelegate, MyButtonCellDelegate>

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UITextView *currentTextView;

@end

@implementation TrendsSampleCreateViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建样品";
    // 初始化选项
    [self configRowMos];
    // 初始化数据
    [self config];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
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

- (void)configRowMos {
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_MEMBER;
    rowMo1.leftContent = @"客户";
    rowMo1.key = @"member";
    rowMo1.rightContent = @"请选择(必填项)";
    rowMo1.editAble = YES;
    rowMo1.nullAble = YES;
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_TEXT;
    rowMo2.leftContent = @"销售区域";
    rowMo2.inputType = K_SHORT_TEXT;
    rowMo2.key = @"memberContactor";
    rowMo2.rightContent = @"请输入";
    rowMo2.editAble = YES;
    rowMo2.nullAble = NO;
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_MEMBER;
    rowMo3.leftContent = @"送样类型";
    rowMo3.key = @"member";
    rowMo3.rightContent = @"请选择";
    rowMo3.editAble = YES;
    rowMo3.nullAble = YES;
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_SELECT_OTHER;
    rowMo4.leftContent = @"申请人";
    rowMo4.rightContent = @"请选择";
    rowMo4.key = @"marketActivity";
    rowMo4.editAble = YES;
    rowMo4.nullAble = YES;
    [self.arrData addObject:rowMo4];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_DATE_SELECT;
    rowMo5.leftContent = @"申请日期";
    rowMo5.pattern = @"yyyy-MM-dd";
    rowMo5.rightContent = @"请选择";
    rowMo5.key = @"submitDate";
    rowMo5.editAble = YES;
    rowMo5.nullAble = NO;
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_DATE_SELECT;
    rowMo6.leftContent = @"是否收费";
    rowMo6.pattern = @"yyyy-MM-dd";
    rowMo6.rightContent = @"请选择(必填项)";
    rowMo6.key = @"submitDate";
    rowMo6.editAble = YES;
    rowMo6.nullAble = NO;
    [self.arrData addObject:rowMo6];
    
    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_SELECT;
    rowMo7.leftContent = @"收费样品合同号";
    rowMo7.inputType = K_SHORT_TEXT;
    rowMo7.key = @"submitter";
    rowMo7.rightContent = @"请选择";
    rowMo7.editAble = NO;
    [self.arrData addObject:rowMo7];
    
    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_INPUT_SELECT;
    rowMo8.leftContent = @"关联商机";
    rowMo8.rightContent = @"请选择";
    rowMo8.key = @"submitDate";
    rowMo8.editAble = YES;
    rowMo8.nullAble = NO;
    [self.arrData addObject:rowMo8];
    
    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_SELECT;
    rowMo9.leftContent = @"客户收件人";
    rowMo9.rightContent = @"请选择";
    rowMo9.key = @"submitDate";
    rowMo9.editAble = YES;
    rowMo9.nullAble = NO;
    [self.arrData addObject:rowMo9];
    
    CommonRowMo *rowMo10 = [[CommonRowMo alloc] init];
    rowMo10.rowType = K_INPUT_TEXT;
    rowMo10.inputType = K_SHORT_TEXT;
    rowMo10.leftContent = @"收件人电话";
    rowMo10.rightContent = @"请输入";
    rowMo10.key = @"submitDate";
    rowMo10.editAble = YES;
    rowMo10.nullAble = NO;
    [self.arrData addObject:rowMo10];
    
    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.rowType = K_INPUT_TEXT;
    rowMo11.inputType = K_SHORT_TEXT;
    rowMo11.leftContent = @"收件地址";
    rowMo11.rightContent = @"自动计算";
    rowMo11.key = @"submitDate";
    rowMo11.editAble = YES;
    rowMo11.nullAble = NO;
    [self.arrData addObject:rowMo11];
    
    CommonRowMo *rowMo12 = [[CommonRowMo alloc] init];
    rowMo12.rowType = K_INPUT_TEXT;
    rowMo12.inputType = K_SHORT_TEXT;
    rowMo12.leftContent = @"制作方";
    rowMo12.rightContent = @"自动计算";
    rowMo12.key = @"submitDate";
    rowMo12.editAble = YES;
    rowMo12.nullAble = NO;
    [self.arrData addObject:rowMo12];
    
    CommonRowMo *rowMo13 = [[CommonRowMo alloc] init];
    rowMo13.rowType = K_INPUT_TEXT;
    rowMo13.inputType = K_SHORT_TEXT;
    rowMo13.leftContent = @"本月累计免费样片数量";
    rowMo13.rightContent = @"自动计算";
    rowMo13.key = @"submitDate";
    rowMo13.editAble = YES;
    rowMo13.nullAble = NO;
    [self.arrData addObject:rowMo13];
    
    CommonRowMo *rowMo14 = [[CommonRowMo alloc] init];
    rowMo14.rowType = K_INPUT_TEXT;
    rowMo14.inputType = K_SHORT_TEXT;
    rowMo14.leftContent = @"是否量产";
    rowMo14.rightContent = @"自动计算";
    rowMo14.key = @"submitDate";
    rowMo14.editAble = YES;
    rowMo14.nullAble = NO;
    [self.arrData addObject:rowMo14];
    
    CommonRowMo *rowMo15 = [[CommonRowMo alloc] init];
    rowMo15.rowType = K_INPUT_TEXT;
    rowMo15.inputType = K_SHORT_TEXT;
    rowMo15.leftContent = @"是否留样";
    rowMo15.rightContent = @"自动计算";
    rowMo15.key = @"submitDate";
    rowMo15.editAble = YES;
    rowMo15.nullAble = NO;
    [self.arrData addObject:rowMo15];
    
    CommonRowMo *rowMo16 = [[CommonRowMo alloc] init];
    rowMo16.rowType = K_INPUT_TEXT;
    rowMo16.inputType = K_SHORT_TEXT;
    rowMo16.leftContent = @"留样数量";
    rowMo16.rightContent = @"自动计算";
    rowMo16.key = @"submitDate";
    rowMo16.editAble = YES;
    rowMo16.nullAble = NO;
    [self.arrData addObject:rowMo16];
    
    CommonRowMo *rowMo17 = [[CommonRowMo alloc] init];
    rowMo17.rowType = K_INPUT_TEXT;
    rowMo17.inputType = K_SHORT_TEXT;
    rowMo17.leftContent = @"用途";
    rowMo17.rightContent = @"自动计算";
    rowMo17.key = @"submitDate";
    rowMo17.editAble = YES;
    rowMo17.nullAble = NO;
    [self.arrData addObject:rowMo17];
    
    CommonRowMo *rowMo18 = [[CommonRowMo alloc] init];
    rowMo18.rowType = K_INPUT_TEXT;
    rowMo18.inputType = K_SHORT_TEXT;
    rowMo18.leftContent = @"用途备注";
    rowMo18.rightContent = @"自动计算";
    rowMo18.key = @"submitDate";
    rowMo18.editAble = YES;
    rowMo18.nullAble = NO;
    [self.arrData addObject:rowMo18];
    
    CommonRowMo *rowMo19 = [[CommonRowMo alloc] init];
    rowMo19.rowType = K_INPUT_TEXT;
    rowMo19.inputType = K_SHORT_TEXT;
    rowMo19.leftContent = @"可靠性测试项目";
    rowMo19.rightContent = @"自动计算";
    rowMo19.key = @"submitDate";
    rowMo19.editAble = YES;
    rowMo19.nullAble = NO;
    [self.arrData addObject:rowMo19];
    
    CommonRowMo *rowMo20 = [[CommonRowMo alloc] init];
    rowMo20.rowType = K_INPUT_TEXT;
    rowMo20.inputType = K_SHORT_TEXT;
    rowMo20.leftContent = @"期待样品提供时间";
    rowMo20.rightContent = @"自动计算";
    rowMo20.key = @"submitDate";
    rowMo20.editAble = YES;
    rowMo20.nullAble = NO;
    [self.arrData addObject:rowMo20];
    
    CommonRowMo *rowMo21 = [[CommonRowMo alloc] init];
    rowMo21.rowType = K_INPUT_TEXT;
    rowMo21.inputType = K_LONG_TEXT;
    rowMo21.leftContent = @"申请样品原因";
    rowMo21.rightContent = @"自动计算";
    rowMo21.key = @"submitDate";
    rowMo21.editAble = YES;
    rowMo21.nullAble = NO;
    [self.arrData addObject:rowMo21];
    
    CommonRowMo *rowMo22 = [[CommonRowMo alloc] init];
    rowMo22.rowType = K_INPUT_TEXT;
    rowMo22.inputType = K_SHORT_TEXT;
    rowMo22.leftContent = @"非量产产品样品预计投产数量";
    rowMo22.rightContent = @"自动计算";
    rowMo22.key = @"submitDate";
    rowMo22.editAble = YES;
    rowMo22.nullAble = NO;
    [self.arrData addObject:rowMo22];
    
    CommonRowMo *rowMo23 = [[CommonRowMo alloc] init];
    rowMo23.rowType = K_INPUT_TEXT;
    rowMo23.inputType = K_SHORT_TEXT;
    rowMo23.leftContent = @"预计样品提供时间";
    rowMo23.rightContent = @"自动计算";
    rowMo23.key = @"submitDate";
    rowMo23.editAble = YES;
    rowMo23.nullAble = NO;
    [self.arrData addObject:rowMo23];
    
    CommonRowMo *rowMo24 = [[CommonRowMo alloc] init];
    rowMo24.rowType = K_INPUT_TEXT;
    rowMo24.inputType = K_SHORT_TEXT;
    rowMo24.leftContent = @"是否需要提前物流准备";
    rowMo24.rightContent = @"自动计算";
    rowMo24.key = @"submitDate";
    rowMo24.editAble = YES;
    rowMo24.nullAble = NO;
    [self.arrData addObject:rowMo24];
    
    CommonRowMo *rowMo25 = [[CommonRowMo alloc] init];
    rowMo25.rowType = K_FILE_INPUT;
    rowMo25.leftContent = @"相关附件";
    rowMo25.inputType = K_SHORT_TEXT;
    rowMo25.key = @"attachments";
    rowMo25.editAble = YES;
    rowMo25.nullAble = YES;
    [self.arrData addObject:rowMo25];
    
    [self.tableView reloadData];
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
    else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT] || [rowMo.rowType isEqualToString:K_DATE_SELECT] || [rowMo.rowType isEqualToString:K_INPUT_MEMBER] || [rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER]) {
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
    if (!rowMo.editAble) {
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
        //    } else if (rowMo.iosRowType == RowOperator) {
        //        [self hidenKeyboard];
        //    } else if (rowMo.iosRowType == RowOther) {
        [self hidenKeyboard];
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

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    DicMo *dicMo = [self.selectArr objectAtIndex:index];
    rowMo.singleValue = dicMo;
    rowMo.strValue = selectMo.moText;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    }
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    [self clickRightButton:self.rightBtn];
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
        [helper uploadFileMulti:cell.collectionView.attachments success:^(id responseObject) {
            [Utils showHUDWithStatus:@"附件上传成功"];
            [self dealWithParams:param attachementList:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [self dealWithParams:param attachementList:@[]];
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

@end
