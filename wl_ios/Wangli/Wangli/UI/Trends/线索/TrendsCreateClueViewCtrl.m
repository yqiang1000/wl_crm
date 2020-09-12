//
//  TrendsCreateClueViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/14.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsCreateClueViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "AttachmentCell.h"
#import "MemberSelectViewCtrl.h"
#import "WSDatePickerView.h"
#import "UIButton+ShortCut.h"
#import "NewComplaintCell.h"
#import "QiNiuUploadHelper.h"
#import "MarketActivitySelectViewCtrl.h"
#import "MarketIntelligenceSelectViewCtrl.h"
#import "MaterialPageSelectViewCtrl.h"
#import "ClueMo.h"

@interface TrendsCreateClueViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, MyTextViewCellDelegate, DefaultInputCellDelegate, MemberSelectViewCtrlDelegate, MyButtonCellDelegate, MarketActivitySelectViewCtrlDelegate, MarketIntelligenceSelectViewCtrlDelegate, MaterialPageSelectViewCtrlDelegate>

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UITextView *currentTextView;

@property (nonatomic, strong) CommonRowMo *rowMoOld;
@property (nonatomic, strong) CommonRowMo *rowMoAct;
@property (nonatomic, strong) CommonRowMo *rowMoInt;

@property (nonatomic, strong) AttachmentCell *attCell;

@property (nonatomic, strong) ClueMo *clueMo;

@end

@implementation TrendsCreateClueViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建线索";
    // 初始化选项
    [self configRowMos];
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
    if (self.isUpdate) {
        [[JYUserApi sharedInstance] getClueDetailId:self.detailId param:nil success:^(id responseObject) {
            NSError *error = nil;
            [Utils dismissHUD];
            self.clueMo = [[ClueMo alloc] initWithDictionary:responseObject error:&error];
            [self configWithModel];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [self config];
    }
}

- (void)config {
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_TITLE;
    rowMo0.leftContent = @"情报内容";
    [self.arrData addObject:rowMo0];

    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_TEXT;
    rowMo1.leftContent = @"线索标题";
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.rightContent = @"请输入";
    rowMo1.editAble = YES;
    rowMo1.key = @"title";
    if (self.isUpdate && _clueMo) rowMo1.value = self.clueMo.title;
    [self.arrData addObject:rowMo1];

    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_SELECT;
    rowMo2.leftContent = @"线索来源";
    rowMo2.dictName = @"clue_resource";
    rowMo2.rightContent = @"请选择";
    rowMo2.key = @"resourceKey";
    rowMo2.editAble = YES;
    [self.arrData addObject:rowMo2];

    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_MEMBER;
    rowMo4.leftContent = @"客户名称";
    rowMo4.key = @"member";
    rowMo4.rightContent = @"请选择";
    rowMo4.editAble = YES;
    //    rowMo4.nullAble = YES;
    [self.arrData addObject:rowMo4];

    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_INPUT_TEXT;
    rowMo5.leftContent = @"客户联系人";
    rowMo5.inputType = K_SHORT_TEXT;
    rowMo5.key = @"memberContactor";
    rowMo5.rightContent = @"请输入";
    rowMo5.editAble = YES;
    //    rowMo5.nullAble = NO;
    [self.arrData addObject:rowMo5];

    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_INPUT_TEXT;
    rowMo6.leftContent = @"联系人电话";
    rowMo6.inputType = K_SHORT_TEXT;
    rowMo6.keyBoardType = K_INTEGER;
    rowMo6.key = @"memberContactorPhone";
    rowMo6.rightContent = @"请输入";
    rowMo6.editAble = YES;
    [self.arrData addObject:rowMo6];

    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_SELECT_OTHER;
    rowMo7.leftContent = @"提交人";
    rowMo7.key = @"submitter";
    rowMo7.rightContent = @"请选择";
    rowMo7.editAble = NO;
    rowMo7.strValue = STRING(TheUser.userMo.name);
    rowMo7.value = TheUser.userMo;
    [self.arrData addObject:rowMo7];

    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_DATE_SELECT;
    rowMo8.leftContent = @"提交日期";
    rowMo8.pattern = @"yyyy-MM-dd";
    rowMo8.rightContent = @"请选择";
    rowMo8.key = @"submitDate";
    rowMo8.editAble = YES;
    rowMo8.strValue = [[NSDate date] stringWithFormat:rowMo8.pattern];
    [self.arrData addObject:rowMo8];

    CommonRowMo *rowMo81 = [[CommonRowMo alloc] init];
    rowMo81.rowType = K_INPUT_SELECT_OTHER;
    rowMo81.leftContent = @"产品大类";
    rowMo81.rightContent = @"请选择";
    rowMo81.key = @"materialTypes";
    rowMo81.editAble = YES;
    [self.arrData addObject:rowMo81];

    CommonRowMo *rowMo82 = [[CommonRowMo alloc] init];
    rowMo82.rowType = K_INPUT_SELECT;
    rowMo82.leftContent = @"重要程度";
    rowMo82.dictName = @"importance";
    rowMo82.rightContent = @"请选择";
    rowMo82.key = @"importantKey";
    rowMo82.editAble = YES;
    [self.arrData addObject:rowMo82];
    // 重要性
    NSInteger x = self.arrData.count;
    [[JYUserApi sharedInstance] getConfigDicByName:rowMo82.dictName success:^(id responseObject) {
        NSError *error = nil;
        NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        for (int j = 0; j < arr.count; j++) {
            DicMo *dicMo = arr[j];
            if ([dicMo.key isEqualToString:@"general"]) {
                rowMo82.strValue = dicMo.value;
                rowMo82.singleValue = dicMo;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:x-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    } failure:^(NSError *error) {
    }];

    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_TEXT;
    rowMo9.leftContent = @"线索内容";
    rowMo9.rightContent = @"请输入线索内容";
    rowMo9.inputType = K_LONG_TEXT;
    rowMo9.key = @"content";
    rowMo9.editAble = YES;
    //    rowMo9.nullAble = NO;
    [self.arrData addObject:rowMo9];

    CommonRowMo *rowMo10 = [[CommonRowMo alloc] init];
    rowMo10.rowType = K_INPUT_TITLE;
    rowMo10.leftContent = @"相关附件";
    [self.arrData addObject:rowMo10];

    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.rowType = K_FILE_INPUT;
    rowMo11.leftContent = @"附件";
    rowMo11.inputType = K_SHORT_TEXT;
    rowMo11.key = @"attachments";
    [self.arrData addObject:rowMo11];

    [self.tableView reloadData];
}

- (void)configWithModel {
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_TITLE;
    rowMo0.leftContent = @"情报内容";
    [self.arrData addObject:rowMo0];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_TEXT;
    rowMo1.leftContent = @"线索标题";
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.rightContent = @"请输入";
    rowMo1.editAble = YES;
    rowMo1.key = @"title";
    rowMo1.strValue = self.clueMo.title;
    rowMo1.value = self.clueMo.title;
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_SELECT;
    rowMo2.leftContent = @"线索来源";
    rowMo2.dictName = @"clue_resource";
    rowMo2.rightContent = @"请选择";
    rowMo2.key = @"resourceKey";
    rowMo2.editAble = YES;
    DicMo *resourceDic = [[DicMo alloc] init];
    resourceDic.key = self.clueMo.resourceKey;
    resourceDic.value = self.clueMo.resourceValue;
    rowMo2.singleValue = resourceDic;
    rowMo2.strValue = resourceDic.value;
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_MEMBER;
    rowMo4.leftContent = @"客户名称";
    rowMo4.key = @"member";
    rowMo4.rightContent = @"请选择";
    rowMo4.editAble = YES;
    //    rowMo4.nullAble = YES;
    NSError *error = nil;
    CustomerMo *member = [[CustomerMo alloc] initWithDictionary:self.clueMo.member error:&error];
    rowMo4.member = member;
    rowMo4.strValue = member.orgName;
    [self.arrData addObject:rowMo4];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_INPUT_TEXT;
    rowMo5.leftContent = @"客户联系人";
    rowMo5.inputType = K_SHORT_TEXT;
    rowMo5.key = @"memberContactor";
    rowMo5.rightContent = @"请输入";
    rowMo5.editAble = YES;
    //    rowMo5.nullAble = NO;
    rowMo5.strValue = self.clueMo.memberContactor;
    rowMo5.value = self.clueMo.memberContactor;
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_INPUT_TEXT;
    rowMo6.leftContent = @"联系人电话";
    rowMo6.inputType = K_SHORT_TEXT;
    rowMo6.keyBoardType = K_INTEGER;
    rowMo6.key = @"memberContactorPhone";
    rowMo6.rightContent = @"请输入";
    rowMo6.editAble = YES;
    rowMo6.strValue = self.clueMo.memberContactorPhone;
    rowMo6.value = self.clueMo.memberContactorPhone;
    [self.arrData addObject:rowMo6];
    
    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_SELECT_OTHER;
    rowMo7.leftContent = @"提交人";
    rowMo7.key = @"submitter";
    rowMo7.rightContent = @"请选择";
    rowMo7.editAble = NO;
    error = nil;
    JYUserMo *suber = [[JYUserMo alloc] initWithDictionary:self.clueMo.submitter error:&error];
    rowMo7.strValue = suber.name;
    rowMo7.value = suber;
    [self.arrData addObject:rowMo7];
    
    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_DATE_SELECT;
    rowMo8.leftContent = @"提交日期";
    rowMo8.pattern = @"yyyy-MM-dd";
    rowMo8.rightContent = @"请选择";
    rowMo8.key = @"submitDate";
    rowMo8.editAble = YES;
    //    rowMo8.nullAble = NO;
    rowMo8.strValue = self.clueMo.submitDate;
    rowMo8.value = self.clueMo.submitDate;
    [self.arrData addObject:rowMo8];
    
    CommonRowMo *rowMo81 = [[CommonRowMo alloc] init];
    rowMo81.rowType = K_INPUT_SELECT_OTHER;
    rowMo81.leftContent = @"产品大类";
    rowMo81.rightContent = @"请选择";
    rowMo81.key = @"materialTypes";
    rowMo81.editAble = YES;
    NSString *valueStr = @"";
    NSMutableArray *multipleValue = [NSMutableArray new];
    for (int i = 0; i < self.clueMo.materialTypes.count; i++) {
        NSDictionary *tmpMo = self.clueMo.materialTypes[i];
        [multipleValue addObject:@{@"id":@([tmpMo[@"id"] longLongValue])}];
        valueStr = [valueStr stringByAppendingString:STRING(tmpMo[@"name"])];
        if (i < self.clueMo.materialTypes.count - 1) {
            valueStr = [valueStr stringByAppendingString:@","];
        }
    }
    rowMo81.value = multipleValue;
    rowMo81.strValue = valueStr;
    [self.arrData addObject:rowMo81];
    
    CommonRowMo *rowMo82 = [[CommonRowMo alloc] init];
    rowMo82.rowType = K_INPUT_SELECT;
    rowMo82.leftContent = @"重要程度";
    rowMo82.dictName = @"importance";
    rowMo82.rightContent = @"请选择";
    rowMo82.key = @"importantKey";
    rowMo82.editAble = YES;
    DicMo *inportDic = [[DicMo alloc] init];
    inportDic.key = self.clueMo.importantKey;
    inportDic.value = self.clueMo.importantValue;
    rowMo82.singleValue = inportDic;
    rowMo82.strValue = inportDic.value;
    [self.arrData addObject:rowMo82];
    
    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_TEXT;
    rowMo9.leftContent = @"线索内容";
    rowMo9.rightContent = @"请输入线索内容";
    rowMo9.inputType = K_LONG_TEXT;
    rowMo9.key = @"content";
    rowMo9.editAble = YES;
    //    rowMo9.nullAble = NO;
    rowMo9.strValue = self.clueMo.content;
    rowMo9.value = self.clueMo.content;
    [self.arrData addObject:rowMo9];
    
    CommonRowMo *rowMo10 = [[CommonRowMo alloc] init];
    rowMo10.rowType = K_INPUT_TITLE;
    rowMo10.leftContent = @"相关附件";
    [self.arrData addObject:rowMo10];
    
    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.rowType = K_FILE_INPUT;
    rowMo11.leftContent = @"附件";
    rowMo11.inputType = K_SHORT_TEXT;
    rowMo11.key = @"attachments";
    
    NSMutableArray *att = [NSMutableArray new];
    for (NSDictionary *dic in self.clueMo.attachments) {
        error = nil;
        QiniuFileMo *qiniuMo = [[QiniuFileMo alloc] initWithDictionary:dic error:&error];
        if ([qiniuMo.fileName containsString:@".jpg"] || [qiniuMo.fileName containsString:@".png"]) {
            [att addObject:qiniuMo];
        }
    }
    rowMo11.attachments = att;
    [self.arrData addObject:rowMo11];
    
    [self.tableView reloadData];
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
        vc.VcDelegate = self;
        vc.needRules = YES;
        vc.isWangli = YES;
        vc.defaultId = rowMo.member.id;
        vc.indexPath = indexPath;
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
        //    } else if (rowMo.iosRowType == RowOperator) {
        //        [self hidenKeyboard];
        //    } else if (rowMo.iosRowType == RowOther) {
        [self hidenKeyboard];
    } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER]) {
        // 关联活动
        if ([rowMo.key isEqualToString:@"marketActivity"]) {
            MarketActivitySelectViewCtrl *vc = [[MarketActivitySelectViewCtrl alloc] init];
            vc.vcDelegate = self;
            vc.indexPath = indexPath;
            MarketActivityMo *tmpMo = (MarketActivityMo *)rowMo.value;
            if (tmpMo) vc.defaultId = tmpMo.id;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
            [self hidenKeyboard];
            return;
        }
        // 关联情报
        else if ([rowMo.key isEqualToString:@"intelligenceItem"]) {
            MarketIntelligenceSelectViewCtrl *vc = [[MarketIntelligenceSelectViewCtrl alloc] init];
            vc.vcDelegate = self;
            vc.indexPath = indexPath;
            MarketIntelligenceMo *tmpMo = (MarketIntelligenceMo *)rowMo.value;
            if (tmpMo) vc.defaultId = tmpMo.id;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
            [self hidenKeyboard];
            return;
        }
        // 大类
        else if ([rowMo.key isEqualToString:@"materialTypes"]) {
            MaterialPageSelectViewCtrl *vc = [[MaterialPageSelectViewCtrl alloc] init];
            vc.vcDelegate = self;
            vc.indexPath = indexPath;
            vc.isSignal = NO;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
            [self hidenKeyboard];
            return;
        }
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

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    DicMo *dicMo = [self.selectArr objectAtIndex:index];
    rowMo.singleValue = dicMo;
    rowMo.strValue = selectMo.moText;
    if ([dicMo.name isEqualToString:@"clue_resource"]) {
        // 市场活动
        if ([dicMo.key isEqualToString:@"market_activity"]) {
            if ([self.arrData containsObject:self.rowMoOld]) [self.arrData removeObject:self.rowMoOld];
            if ([self.arrData containsObject:self.rowMoInt]) [self.arrData removeObject:self.rowMoInt];
            if (![self.arrData containsObject:self.rowMoAct]) [self.arrData insertObject:self.rowMoAct atIndex:3];
            _rowMoOld = nil;
            _rowMoInt = nil;
        }
        // 市场情报
        else if ([dicMo.key isEqualToString:@"market_intelligence"]) {
            if ([self.arrData containsObject:self.rowMoOld]) [self.arrData removeObject:self.rowMoOld];
            if ([self.arrData containsObject:self.rowMoAct]) [self.arrData removeObject:self.rowMoAct];
            if (![self.arrData containsObject:self.rowMoInt]) [self.arrData insertObject:self.rowMoInt atIndex:3];
            _rowMoOld = nil;
            _rowMoAct = nil;
        }
        // 老客户介绍
        else if ([dicMo.key isEqualToString:@"customer_introduce"]) {
            if ([self.arrData containsObject:self.rowMoInt]) [self.arrData removeObject:self.rowMoInt];
            if ([self.arrData containsObject:self.rowMoAct]) [self.arrData removeObject:self.rowMoAct];
            if (![self.arrData containsObject:self.rowMoOld]) [self.arrData insertObject:self.rowMoOld atIndex:3];
            _rowMoInt = nil;
            _rowMoAct = nil;
        }
        else {
            if ([self.arrData containsObject:self.rowMoInt]) [self.arrData removeObject:self.rowMoInt];
            if ([self.arrData containsObject:self.rowMoAct]) [self.arrData removeObject:self.rowMoAct];
            if ([self.arrData containsObject:self.rowMoOld]) [self.arrData removeObject:self.rowMoOld];
            _rowMoOld = nil;
            _rowMoInt = nil;
            _rowMoAct = nil;
        }
        [self.tableView reloadData];
        return;
    }
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

- (void)memberSelectViewCtrlDismiss:(MemberSelectViewCtrl *)memberSelectViewCtrl {
    memberSelectViewCtrl = nil;
}

#pragma mark - MarketActivitySelectViewCtrlDelegate

- (void)marketActivitySelectViewCtrl:(MarketActivitySelectViewCtrl *)marketActivitySelectViewCtrl didSelect:(MarketActivityMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.value = model;
        rowMo.strValue = model.title;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)marketActivitySelectViewCtrlDismiss:(MarketActivitySelectViewCtrl *)marketActivitySelectViewCtrl {
    marketActivitySelectViewCtrl = nil;
}


#pragma mark - MarketIntelligenceSelectViewCtrlDelegate

- (void)marketIntelligenceSelectViewCtrl:(MarketIntelligenceSelectViewCtrl *)marketIntelligenceSelectViewCtrl didSelect:(MarketIntelligenceMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.value = model;
        rowMo.strValue = model.content;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)marketIntelligenceSelectViewCtrlDismiss:(MarketIntelligenceSelectViewCtrl *)marketIntelligenceSelectViewCtrl {
    marketIntelligenceSelectViewCtrl = nil;
}

#pragma mark - MaterialPageSelectViewCtrlDelegate

- (void)materialPageSelectViewCtrl:(MaterialPageSelectViewCtrl *)materialPageSelectViewCtrl didSelectData:(NSArray *)data indexPath:(NSIndexPath *)indexPath {
    NSString *valueStr = @"";
    NSMutableArray *multipleValue = [NSMutableArray new];
    for (int i = 0; i < data.count; i++) {
        MaterialMo *tmpMo = data[i];
        [multipleValue addObject:@{@"id":@(tmpMo.id)}];
        valueStr = [valueStr stringByAppendingString:STRING(tmpMo.name)];
        if (i < data.count - 1) {
            valueStr = [valueStr stringByAppendingString:@","];
        }
    }
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.value = multipleValue;
    rowMo.strValue = valueStr;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)materialPageSelectViewCtrlDismiss:(MaterialPageSelectViewCtrl *)materialPageSelectViewCtrl {
    materialPageSelectViewCtrl = nil;
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
        cell = self.attCell; //[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:attachIndex inSection:0]];
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
    }
    
    for (CommonRowMo *tmpMo in self.arrData) {
        if ([tmpMo.rowType isEqualToString:K_INPUT_SELECT_OTHER]) {
            if ([tmpMo.key isEqualToString:@"marketActivity"]) {
                MarketActivityMo *mo = (MarketActivityMo *)tmpMo.value;
                if (mo) [params setObject:[mo toDictionary] forKey:tmpMo.key];
                continue;
            }
            if ([tmpMo.key isEqualToString:@"intelligenceItem"]) {
                MarketIntelligenceMo *mo = (MarketIntelligenceMo *)tmpMo.value;
                if (mo) [params setObject:[mo toDictionary] forKey:tmpMo.key];
                continue;
            }
            if ([tmpMo.key isEqualToString:@"submitter"]) {
                JYUserMo *mo = (JYUserMo *)tmpMo.value;
                if (mo) [params setObject:@{@"id":@(mo.id)} forKey:tmpMo.key];
                continue;
            }
            if ([tmpMo.key isEqualToString:@"materialTypes"]) {
                NSArray *arr = (NSArray *)tmpMo.value;
                if (arr.count > 0) [params setObject:arr forKey:tmpMo.key];
                continue;
            }
        }
    }
    if (self.isUpdate) {
        [self updateParams:params attachementList:attachementList];
    } else {
        [self createParams:params attachementList:attachementList];
    }
}


- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [[JYUserApi sharedInstance] createClueParam:params success:^(id responseObject) {
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
    [params setObject:@(self.clueMo.id) forKey:@"id"];
    [[JYUserApi sharedInstance] updateClueParam:params success:^(id responseObject) {
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


- (CommonRowMo *)rowMoOld {
    if (!_rowMoOld) {
        _rowMoOld = [[CommonRowMo alloc] init];
        _rowMoOld.rowType = K_INPUT_MEMBER;
        _rowMoOld.leftContent = @"老客户";
        _rowMoOld.rightContent = @"请选择";
        _rowMoOld.key = @"oldMember";
        _rowMoOld.editAble = YES;
        _rowMoOld.nullAble = YES;
    }
    return _rowMoOld;
}

- (CommonRowMo *)rowMoAct {
    if (!_rowMoAct) {
        _rowMoAct = [[CommonRowMo alloc] init];
        _rowMoAct.rowType = K_INPUT_SELECT_OTHER;
        _rowMoAct.leftContent = @"关联活动";
        _rowMoAct.rightContent = @"请选择";
        _rowMoAct.key = @"marketActivity";
        _rowMoAct.editAble = YES;
        _rowMoAct.nullAble = YES;
    }
    return _rowMoAct;
}

- (CommonRowMo *)rowMoInt {
    if (!_rowMoInt) {
        _rowMoInt = [[CommonRowMo alloc] init];
        _rowMoInt.rowType = K_INPUT_SELECT_OTHER;
        _rowMoInt.leftContent = @"关联情报";
        _rowMoInt.rightContent = @"请选择";
        _rowMoInt.key = @"intelligenceItem";
        _rowMoInt.editAble = YES;
        _rowMoInt.nullAble = YES;
    }
    return _rowMoInt;
}

- (ClueMo *)clueMo {
    if (!_clueMo) {
        _clueMo = [[ClueMo alloc] init];
    }
    return _clueMo;
}

@end
