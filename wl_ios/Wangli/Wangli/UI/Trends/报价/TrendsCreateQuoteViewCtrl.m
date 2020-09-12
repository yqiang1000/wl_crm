
//
//  TrendsCreateQuoteViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsCreateQuoteViewCtrl.h"
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
#import "CreateQuoteDetailViewCtrl.h"
#import "BusinessChangeSelectViewCtrl.h"
#import "TrendsQuoteMo.h"
#import "TrendsQuoteDetailCell.h"

@interface TrendsCreateQuoteViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, MyTextViewCellDelegate, DefaultInputCellDelegate, MemberSelectViewCtrlDelegate, MyButtonCellDelegate, MaterialPageSelectViewCtrlDelegate, DepartmentSelectViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, BusinessChangeSelectViewCtrlDelegate>

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UITextView *currentTextView;

// 重用之后，如果滑动隐藏了附件之后，拿不到原先的单元格，所以单独创建保留
@property (nonatomic, strong) AttachmentCell *attCell;
@property (nonatomic, strong) NSMutableArray *arrDetails;

@property (nonatomic, strong) TrendsQuoteMo *quoteMo;

@end

@implementation TrendsCreateQuoteViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
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
    rowMo1.leftContent = @"客户名称";
    rowMo1.key = @"member";
    rowMo1.rightContent = @"必填";
    rowMo1.editAble = YES;
    rowMo1.nullAble = NO;
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_TEXT;
    rowMo2.leftContent = @"客户联系人";
    rowMo2.inputType = K_SHORT_TEXT;
    rowMo2.key = @"memberContractor";
    rowMo2.rightContent = @"必填";
    rowMo2.editAble = YES;
    rowMo2.nullAble = NO;
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_OPERATOR;
    rowMo3.leftContent = @"负责人";
    rowMo3.key = @"operator";
    rowMo3.rightContent = @"必填";
    rowMo3.editAble = YES;
    rowMo3.nullAble = NO;
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_SELECT_OTHER;
    rowMo4.leftContent = @"关联商机";
    rowMo4.rightContent = @"请选择";
    rowMo4.key = @"businessChance";
    rowMo4.editAble = YES;
    rowMo4.nullAble = YES;
    [self.arrData addObject:rowMo4];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_DATE_SELECT;
    rowMo5.leftContent = @"报价开始有效期";
    rowMo5.pattern = @"yyyy-MM-dd";
    rowMo5.rightContent = @"必填";
    rowMo5.key = @"beginDate";
    rowMo5.editAble = YES;
    rowMo5.nullAble = NO;
    rowMo5.strValue = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_DATE_SELECT;
    rowMo6.leftContent = @"报价结束有效期";
    rowMo6.pattern = @"yyyy-MM-dd";
    rowMo6.rightContent = @"必填";
    rowMo6.key = @"endDate";
    rowMo6.editAble = YES;
    rowMo6.nullAble = NO;
    [self.arrData addObject:rowMo6];
    
    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_SELECT;
    rowMo7.leftContent = @"付款方式";
    rowMo7.inputType = K_SHORT_TEXT;
    rowMo7.dictName = @"pay_method";
    rowMo7.key = @"payWayKey";
    rowMo7.rightContent = @"必填";
    rowMo7.editAble = YES;
    [self.arrData addObject:rowMo7];
    
    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_INPUT_SELECT;
    rowMo8.leftContent = @"报价币种";
    rowMo8.rightContent = @"必填";
    rowMo8.key = @"currencyKey";
    rowMo8.dictName = @"gathering_currency";
    rowMo8.editAble = YES;
    rowMo8.nullAble = NO;
    [self.arrData addObject:rowMo8];
    
    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_SELECT;
    rowMo9.leftContent = @"付款条件";
    rowMo9.rightContent = @"必填";
    rowMo9.key = @"conditionKey";
    rowMo9.dictName = @"pay_condition";
    rowMo9.editAble = YES;
    rowMo9.nullAble = NO;
    [self.arrData addObject:rowMo9];
    // 付款条件
    NSInteger x = self.arrData.count;
    [[JYUserApi sharedInstance] getConfigDicByName:rowMo9.dictName success:^(id responseObject) {
        NSError *error = nil;
        NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        for (int j = 0; j < arr.count; j++) {
            DicMo *dicMo = arr[j];
            if ([dicMo.key isEqualToString:@"Z005"]) {
                rowMo9.strValue = dicMo.value;
                rowMo9.singleValue = dicMo;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:x-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    } failure:^(NSError *error) {
    }];
    
    CommonRowMo *rowMo10 = [[CommonRowMo alloc] init];
    rowMo10.rowType = K_INPUT_TEXT;
    rowMo10.inputType = K_SHORT_TEXT;
    rowMo10.leftContent = @"整单折扣";
    rowMo10.rightContent = @"必填";
    rowMo10.key = @"discount";
    rowMo10.keyBoardType = K_DOUBLE;
    rowMo10.editAble = YES;
    rowMo10.nullAble = NO;
    rowMo10.strValue = @"1";
    [self.arrData addObject:rowMo10];
    
    CommonRowMo *rowMo101 = [[CommonRowMo alloc] init];
    rowMo101.rowType = K_INPUT_TEXT;
    rowMo101.inputType = K_SHORT_TEXT;
    rowMo101.leftContent = @"总体报价";
    rowMo101.rightContent = @"必填";
    rowMo101.keyBoardType = K_DOUBLE;
    rowMo101.key = @"amount";
    rowMo101.editAble = NO;
    rowMo101.nullAble = NO;
    [self.arrData addObject:rowMo101];
    
    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.rowType = K_INPUT_TEXT;
    rowMo11.leftContent = @"报价备注";
    rowMo11.inputType = K_LONG_TEXT;
    rowMo11.rightContent = @"请输入";
    rowMo11.editAble = YES;
    rowMo11.nullAble = YES;
    rowMo11.key = @"remark";
    [self.arrData addObject:rowMo11];
    
    CommonRowMo *rowMo12 = [[CommonRowMo alloc] init];
    rowMo12.rowType = K_FILE_INPUT;
    rowMo12.leftContent = @"附件";
    rowMo12.inputType = K_SHORT_TEXT;
    rowMo12.key = @"attachments";
    rowMo12.editAble = YES;
    rowMo12.nullAble = YES;
    [self.arrData addObject:rowMo12];
    
    [self.tableView reloadData];
}

- (void)configRowMosWithModel {
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_MEMBER;
    rowMo1.leftContent = @"客户名称";
    rowMo1.key = @"member";
    rowMo1.rightContent = @"必填";
    rowMo1.editAble = YES;
    rowMo1.nullAble = NO;
    NSError *error = nil;
    CustomerMo *member = [[CustomerMo alloc] initWithDictionary:self.quoteMo.member error:&error];
    rowMo1.m_obj = member;
    rowMo1.strValue = member.orgName;
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_TEXT;
    rowMo2.leftContent = @"客户联系人";
    rowMo2.inputType = K_SHORT_TEXT;
    rowMo2.key = @"memberContractor";
    rowMo2.rightContent = @"必填";
    rowMo2.editAble = YES;
    rowMo2.nullAble = NO;
    rowMo2.strValue = self.quoteMo.memberContractor;
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_OPERATOR;
    rowMo3.leftContent = @"负责人";
    rowMo3.key = @"operator";
    rowMo3.rightContent = @"必填";
    rowMo3.editAble = YES;
    rowMo3.nullAble = NO;
    error = nil;
    JYUserMo *userMo = [[JYUserMo alloc] initWithDictionary:self.quoteMo.operator error:&error];
    rowMo3.m_obj = userMo;
    rowMo3.strValue = userMo.name;
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_SELECT_OTHER;
    rowMo4.leftContent = @"关联商机";
    rowMo4.rightContent = @"请选择";
    rowMo4.key = @"businessChance";
    rowMo4.editAble = YES;
    rowMo4.nullAble = YES;
    error = nil;
    TrendsBusinessMo *busMo = [[TrendsBusinessMo alloc] initWithDictionary:self.quoteMo.businessChance error:&error];
    rowMo4.m_obj = busMo;
    rowMo4.strValue = busMo.title;
    [self.arrData addObject:rowMo4];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_DATE_SELECT;
    rowMo5.leftContent = @"报价开始有效期";
    rowMo5.pattern = @"yyyy-MM-dd";
    rowMo5.rightContent = @"必填";
    rowMo5.key = @"beginDate";
    rowMo5.editAble = YES;
    rowMo5.nullAble = NO;
    rowMo5.strValue = self.quoteMo.beginDate;
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_DATE_SELECT;
    rowMo6.leftContent = @"报价结束有效期";
    rowMo6.pattern = @"yyyy-MM-dd";
    rowMo6.rightContent = @"必填";
    rowMo6.key = @"endDate";
    rowMo6.editAble = YES;
    rowMo6.nullAble = NO;
    rowMo6.strValue = self.quoteMo.endDate;
    [self.arrData addObject:rowMo6];
    
    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_SELECT;
    rowMo7.leftContent = @"付款方式";
    rowMo7.inputType = K_SHORT_TEXT;
    rowMo7.dictName = @"pay_method";
    rowMo7.key = @"payWayKey";
    rowMo7.rightContent = @"必填";
    rowMo7.editAble = YES;
    DicMo *payMo = [[DicMo alloc] init];
    payMo.key = self.quoteMo.payWayKey;
    payMo.value = self.quoteMo.payWayValue;
    rowMo7.singleValue = payMo;
    rowMo7.strValue = payMo.value;
    [self.arrData addObject:rowMo7];
    
    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_INPUT_SELECT;
    rowMo8.leftContent = @"报价币种";
    rowMo8.rightContent = @"必填";
    rowMo8.key = @"currencyKey";
    rowMo8.dictName = @"gathering_currency";
    rowMo8.editAble = YES;
    rowMo8.nullAble = NO;
    DicMo *currencyMo = [[DicMo alloc] init];
    currencyMo.key = self.quoteMo.currencyKey;
    currencyMo.value = self.quoteMo.currencyValue;
    rowMo8.singleValue = currencyMo;
    rowMo8.strValue = currencyMo.value;
    [self.arrData addObject:rowMo8];
    
    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_SELECT;
    rowMo9.leftContent = @"付款条件";
    rowMo9.rightContent = @"必填";
    rowMo9.key = @"conditionKey";
    rowMo9.dictName = @"pay_condition";
    rowMo9.editAble = YES;
    rowMo9.nullAble = NO;
    DicMo *conditionMo = [[DicMo alloc] init];
    conditionMo.key = self.quoteMo.conditionKey;
    conditionMo.value = self.quoteMo.conditionValue;
    rowMo9.singleValue = conditionMo;
    rowMo9.strValue = conditionMo.value;
    [self.arrData addObject:rowMo9];
    
    CommonRowMo *rowMo10 = [[CommonRowMo alloc] init];
    rowMo10.rowType = K_INPUT_TEXT;
    rowMo10.inputType = K_SHORT_TEXT;
    rowMo10.leftContent = @"整单折扣";
    rowMo10.rightContent = @"必填";
    rowMo10.key = @"discount";
    rowMo10.keyBoardType = K_DOUBLE;
    rowMo10.editAble = YES;
    rowMo10.nullAble = NO;
    rowMo10.strValue = self.quoteMo.discount;
    rowMo10.value = self.quoteMo.discount;
    [self.arrData addObject:rowMo10];
    
    CommonRowMo *rowMo101 = [[CommonRowMo alloc] init];
    rowMo101.rowType = K_INPUT_TEXT;
    rowMo101.inputType = K_SHORT_TEXT;
    rowMo101.leftContent = @"总体报价";
    rowMo101.rightContent = @"必填";
    rowMo101.keyBoardType = K_DOUBLE;
    rowMo101.key = @"amount";
    rowMo101.editAble = NO;
    rowMo101.nullAble = NO;
    rowMo101.value = self.quoteMo.amount;
    rowMo101.strValue = self.quoteMo.amount;
    [self.arrData addObject:rowMo101];
    
    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.rowType = K_INPUT_TEXT;
    rowMo11.leftContent = @"报价备注";
    rowMo11.inputType = K_LONG_TEXT;
    rowMo11.rightContent = @"请输入";
    rowMo11.editAble = YES;
    rowMo11.key = @"remark";
    rowMo11.value = self.quoteMo.remark;
    rowMo11.strValue = self.quoteMo.remark;
    [self.arrData addObject:rowMo11];
    
    CommonRowMo *rowMo12 = [[CommonRowMo alloc] init];
    rowMo12.rowType = K_FILE_INPUT;
    rowMo12.leftContent = @"附件";
    rowMo12.inputType = K_SHORT_TEXT;
    rowMo12.key = @"attachments";
    rowMo12.editAble = YES;
    rowMo12.nullAble = YES;
    NSMutableArray *att = [NSMutableArray new];
    for (NSDictionary *dic in self.quoteMo.attachments) {
        error = nil;
        QiniuFileMo *qiniuMo = [[QiniuFileMo alloc] initWithDictionary:dic error:&error];
        if ([qiniuMo.fileName containsString:@".jpg"] || [qiniuMo.fileName containsString:@".png"]) {
            [att addObject:qiniuMo];
        }
    }
    rowMo12.attachments = att;
    [self.arrData addObject:rowMo12];
    
    error = nil;
    self.arrDetails = [TrendsQuoteDetailMo arrayOfModelsFromDictionaries:self.quoteMo.quotedPriceItem error:&error];
    [self.tableView reloadData];
}


- (void)config {
    if (self.isUpdate) {
        [[JYUserApi sharedInstance] getQuotedPriceDetailId:self.detailId param:nil success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            self.quoteMo = [[TrendsQuoteMo alloc] initWithDictionary:responseObject error:&error];
            [self configRowMosWithModel];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [self configRowMos];
    }
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.arrData.count-1;
    } else if (section == 1) {
        return self.arrDetails.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        return rowMo.rowHeight;
    } else if (indexPath.section == 2) {
        CommonRowMo *rowMo = [self.arrData lastObject];
        return rowMo.rowHeight;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    } else if (section == 1) {
        return 44;
    } else if (section == 2) {
        return 100;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerId = @"headerId";
    MyCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[MyCommonHeaderView alloc] initWithReuseIdentifier:headerId isHidenLine:NO];
    }
    if (section == 0) {
        header.labLeft.text = @"基本信息";
    } else if (section == 1) {
        header.labLeft.text = @"报价明细";
    } else if (section == 2) {
        header.labLeft.text = @"相关附件";
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        MyCommonHeaderView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
        if (!footer) {
            footer = [[MyCommonHeaderView alloc] initWithReuseIdentifier:@"footer" isHidenLine:NO];
            UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            [btnAdd setTitle:@"增加" forState:UIControlStateNormal];
            [btnAdd setImage:[UIImage imageNamed:@"add_business"] forState:UIControlStateNormal];
            btnAdd.titleLabel.font = FONT_F15;
            [btnAdd setTitleColor:COLOR_336699 forState:UIControlStateNormal];
            [btnAdd setBackgroundColor:COLOR_B4];
            [btnAdd addTarget:self action:@selector(createCompetitor:) forControlEvents:UIControlEventTouchUpInside];
            [footer.contentView addSubview:btnAdd];
            
            [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(footer.contentView);
            }];
        }
        return footer;
    }
    return [UIView new];
}
#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
        else if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            if (!self.attCell) {
                self.attCell = [[AttachmentCell alloc] init];
                self.attCell.count = 9;
                self.attCell.attachments = rowMo.attachments;
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
    else if (indexPath.section == 1) {
        static NSString *identifier = @"TrendsQuoteDetailCell";
        TrendsQuoteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TrendsQuoteDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell loadDataWith:self.arrDetails[indexPath.row]];
        return cell;
    }
    else if (indexPath.section == 2) {
        CommonRowMo *rowMo = [self.arrData lastObject];
        if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            if (!self.attCell) {
                self.attCell = [[AttachmentCell alloc] init];
                self.attCell.count = 9;
                self.attCell.attachments = rowMo.attachments;
                [self.attCell refreshView];
            }
            return self.attCell;
        }
        else {
            return [[UITableViewCell alloc] init];
        }
    }
    else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
            vc.needRules = YES;
            vc.isWangli = YES;
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
            JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
            if (userMo) vc.defaultValues = [NSMutableArray arrayWithObject:@(userMo.id)];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER]) {
            [self hidenKeyboard];
            // 新商机
            if ([rowMo.key isEqualToString:@"businessChance"]) {
                BusinessChangeSelectViewCtrl *vc = [[BusinessChangeSelectViewCtrl alloc] init];
                vc.vcDelegate = self;
                vc.indexPath = indexPath;
                TrendsBusinessMo *tmpMo = (TrendsBusinessMo *)rowMo.value;
                if (tmpMo) vc.defaultId = tmpMo.id;
                BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
                [[Utils topViewController] presentViewController:navi animated:YES completion:^{
                }];
            }
        }
    }
    else if (indexPath.section == 1) {
        TrendsQuoteDetailMo *detailMo = self.arrDetails[indexPath.row];
        CreateQuoteDetailViewCtrl *vc = [[CreateQuoteDetailViewCtrl alloc] init];
        vc.detailMo = detailMo;
        vc.isUpdate = YES;
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(TrendsQuoteDetailMo *obj) {
            __strong typeof(self) strongself = weakself;
            [strongself.arrDetails replaceObjectAtIndex:indexPath.row withObject:obj];
            [strongself dealWithTotalPrice];
            [strongself.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 1) ? YES : NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该记录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.arrDetails removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
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
    if ([rowMo.key isEqualToString:@"discount"]) {
        [self dealWithTotalPrice];
    }
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
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpRow = self.arrData[i];
            if ([tmpRow.key isEqualToString:@"operator"]) {
                if (model.arId != 0) {
                    JYUserMo *jyMo = [[JYUserMo alloc] init];
                    jyMo.id = model.arId;
                    jyMo.name = model.arName;
                    tmpRow.strValue = jyMo.name;
                    tmpRow.m_obj = jyMo;
                } else {
                    tmpRow.strValue = @"";
                    tmpRow.m_obj = nil;
                }
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
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

#pragma mark - BusinessChangeSelectViewCtrlDelegate

- (void)businessChangeSelectViewCtrl:(BusinessChangeSelectViewCtrl *)businessChangeSelectViewCtrl didSelect:(TrendsBusinessMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.value = model;
        rowMo.strValue = model.title;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)businessChangeSelectViewCtrlDismiss:(BusinessChangeSelectViewCtrl *)businessChangeSelectViewCtrl {
    businessChangeSelectViewCtrl = nil;
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    [self clickRightButton:self.rightBtn];
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

#pragma mark - event

- (void)dealWithTotalPrice {
    CGFloat total = 0;
    for (int i = 0; i < self.arrDetails.count; i++) {
        TrendsQuoteDetailMo *detailMo = self.arrDetails[i];
        total = total + [detailMo.totalPrice floatValue];
    }
    
    CommonRowMo *rowDiscount = nil;
    CommonRowMo *rowAmount = nil;
    
    for (int i = 7; i < self.arrData.count; i++) {
        CommonRowMo *rowMo = self.arrData[i];
        if ([rowMo.key isEqualToString:@"discount"]) {
            rowDiscount = rowMo;
        } else if ([rowMo.key isEqualToString:@"amount"]) {
            rowAmount = rowMo;
        }
    }
    
    CGFloat dicCount = [rowDiscount.strValue floatValue];
    CGFloat amount = dicCount * total;
    
    rowDiscount.strValue = [Utils getPriceFrom:dicCount];
    rowAmount.strValue = [Utils getPriceFrom:amount];
    [self.tableView reloadData];
}

- (void)createCompetitor:(UIButton *)sender {
    CreateQuoteDetailViewCtrl *vc = [[CreateQuoteDetailViewCtrl alloc] init];
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(TrendsQuoteDetailMo *obj) {
        __strong typeof(self) strongself = weakself;
        [strongself.arrDetails addObject:obj];
        [strongself dealWithTotalPrice];
        [strongself.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

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
        
        if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            attachIndex = i;
        }
    }
    
    if (self.arrDetails.count == 0) {
        [Utils showToastMessage:@"至少添加一条明细"];
        return;
    }
    
    
    AttachmentCell *cell = nil;
    if (attachIndex >= 0) {
        cell = self.attCell;// [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:attachIndex inSection:0]];
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
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachementList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    [params setObject:arr forKey:@"attachments"];
    
    for (CommonRowMo *rowMo in self.arrData) {
        if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
            // 多选
            //            if (rowMo.mutiAble) {
            //                NSMutableArray *arrValue = [NSMutableArray new];
            //                // 多选
            //                for (DicMo *tmpMo in rowMo.mutipleValue) {
            //                    [arrValue addObject:@{@"productBigCategoryKey":STRING(tmpMo.key),
            //                                          @"productBigCategoryValue":STRING(tmpMo.value)}];
            //                }
            //                [params setObject:arrValue forKey:rowMo.key];
            //            }
            // 单选
            if (!rowMo.mutiAble) {
                if (rowMo.singleValue) {
                    NSString *tmpStr = [rowMo.key substringToIndex:rowMo.key.length-3];
                    tmpStr = [tmpStr stringByAppendingString:@"Value"];
                    [params setObject:rowMo.singleValue.key forKey:rowMo.key];
                    [params setObject:rowMo.singleValue.value forKey:tmpStr];
                }
            }
        }
        else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER]) {
            // 关联商机
            if ([rowMo.key isEqualToString:@"businessChance"]) {
                TrendsBusinessMo *busMo = (TrendsBusinessMo *)rowMo.value;
                if (busMo) {
                    [params setObject:@{@"id":@(busMo.id)} forKey:rowMo.key];
                }
            }
        }
    }
    
    NSMutableArray *details = [NSMutableArray new];
    for (TrendsQuoteDetailMo *detailMo in self.arrDetails) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:STRING(detailMo.gears) forKey:@"gears"];
        [dic setObject:@{@"id":STRING(detailMo.materialType[@"id"]),
                         @"name":STRING(detailMo.materialType[@"name"])} forKey:@"materialType"];
        [dic setObject:STRING(detailMo.quantity) forKey:@"quantity"];
        [dic setObject:STRING(detailMo.unitKey) forKey:@"unitKey"];
        [dic setObject:STRING(detailMo.unitValue) forKey:@"unitValue"];
        [dic setObject:STRING(detailMo.price) forKey:@"price"];
        [dic setObject:STRING(detailMo.totalPrice) forKey:@"totalPrice"];
        [dic setObject:STRING(detailMo.remark) forKey:@"remark"];
        [details addObject:dic];
    }
    
    [params setObject:details forKey:@"quotedPriceItem"];
    
    if (self.isUpdate) {
        [self updateParams:params attachementList:attachementList];
    } else {
        [self createParams:params attachementList:attachementList];
    }
}


- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    
    [[JYUserApi sharedInstance] createQuotedPriceParam:params success:^(id responseObject) {
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

- (void)updateParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [params setObject:@(self.quoteMo.id) forKey:@"id"];
    [[JYUserApi sharedInstance] updateQuotedPriceParam:params success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
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

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableArray *)arrDetails {
    if (!_arrDetails) _arrDetails = [NSMutableArray new];
    return _arrDetails;
}

@end

