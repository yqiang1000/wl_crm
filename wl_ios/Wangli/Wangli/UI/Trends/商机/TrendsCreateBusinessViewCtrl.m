//
//  TrendsCreateBusinessViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsCreateBusinessViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "AttachmentCell.h"
#import "MemberSelectViewCtrl.h"
#import "WSDatePickerView.h"
#import "UIButton+ShortCut.h"
#import "NewComplaintCell.h"
#import "QiNiuUploadHelper.h"
#import "CreateBusinessCompetitorViewCtrl.h"
#import "MarketActivitySelectViewCtrl.h"
#import "CreateBusinessCompetiorCell.h"
#import "MaterialPageSelectViewCtrl.h"
#import "ClueSelectViewCtrl.h"
#import "TrendsBusinessMo.h"

@interface TrendsCreateBusinessViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, MyTextViewCellDelegate, DefaultInputCellDelegate, MemberSelectViewCtrlDelegate, MarketActivitySelectViewCtrlDelegate, ClueSelectViewCtrlDelegate, MaterialPageSelectViewCtrlDelegate>

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UITextView *currentTextView;

@property (nonatomic, strong) NSMutableArray *arrCompetitor;
@property (nonatomic, strong) CommonRowMo *rowMoOld;
@property (nonatomic, strong) AttachmentCell *attCell;

@property (nonatomic, strong) TrendsBusinessMo *businessMo;

@end

@implementation TrendsCreateBusinessViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增商机";
    // 初始化选项
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

- (void)config {
    if (self.isUpdate) {
        [[JYUserApi sharedInstance] getBusinessChangeDetailId:self.detailId param:nil success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            self.businessMo = [[TrendsBusinessMo alloc] initWithDictionary:responseObject error:&error];
            [self configRowMos];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [self configRowMosNoModel];
    }
}

- (void)configRowMos {
    
    [_arrData removeAllObjects];
    _arrData = nil;
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_TEXT;
    rowMo1.leftContent = @"商机标题";
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.rightContent = @"请输入";
    rowMo1.editAble = YES;
    rowMo1.key = @"title";
    rowMo1.value = self.businessMo.title;
    rowMo1.strValue = self.businessMo.title;
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_SELECT;
    rowMo2.leftContent = @"商机来源";
    rowMo2.dictName = @"business_chance_resource";
    rowMo2.rightContent = @"请选择";
    rowMo2.key = @"resourceKey";
    rowMo2.editAble = YES;
    DicMo *dicMo2 = [[DicMo alloc] init];
    dicMo2.value = self.businessMo.resourceValue;
    dicMo2.key = self.businessMo.resourceKey;
    rowMo2.singleValue = dicMo2;
    rowMo2.strValue = self.businessMo.resourceValue;
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo21 = [[CommonRowMo alloc] init];
    rowMo21.rowType = K_INPUT_SELECT;
    rowMo21.leftContent = @"商机类型";
    rowMo21.dictName = @"business_chance_type";
    rowMo21.rightContent = @"请选择";
    rowMo21.key = @"typeKey";
    rowMo21.editAble = YES;
    DicMo *dicMo21 = [[DicMo alloc] init];
    dicMo21.value = self.businessMo.resourceValue;
    dicMo21.key = self.businessMo.resourceKey;
    rowMo21.singleValue = dicMo21;
    rowMo21.strValue = self.businessMo.resourceValue;
    [self.arrData addObject:rowMo21];
    
    CommonRowMo *rowMo31 = [[CommonRowMo alloc] init];
    rowMo31.rowType = K_INPUT_SELECT_OTHER;
    rowMo31.leftContent = @"关联活动";
    rowMo31.rightContent = @"请选择";
    rowMo31.key = @"activity";
    rowMo31.editAble = YES;
    rowMo31.nullAble = YES;
    NSError *error = nil;
    MarketActivityMo *tmpMo = [[MarketActivityMo alloc] initWithDictionary:self.businessMo.activity error:&error];
    rowMo31.value = tmpMo;
    rowMo31.strValue = tmpMo.title;
    [self.arrData addObject:rowMo31];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_SELECT_OTHER;
    rowMo3.leftContent = @"关联线索";
    rowMo3.rightContent = @"请选择";
    rowMo3.key = @"clue";
    rowMo3.editAble = YES;
    rowMo3.nullAble = YES;
    error = nil;
    ClueMo *clueMo = [[ClueMo alloc] initWithDictionary:self.businessMo.clue error:&error];
    rowMo3.value = clueMo;
    rowMo3.strValue = clueMo.title;
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_SELECT_OTHER;
    rowMo7.leftContent = @"提交人";
    rowMo7.inputType = K_SHORT_TEXT;
    rowMo7.key = @"operator";
    rowMo7.rightContent = @"请选择";
    rowMo7.editAble = NO;
    error = nil;
    JYUserMo *userMo = [[JYUserMo alloc] initWithDictionary:self.businessMo.operator error:&error];
    rowMo7.strValue = userMo.name;
    rowMo7.value = userMo.oaCode;
    [self.arrData addObject:rowMo7];
    
    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_DATE_SELECT;
    rowMo8.leftContent = @"提交日期";
    rowMo8.pattern = @"yyyy-MM-dd HH:mm";
    rowMo8.rightContent = @"请选择";
    rowMo8.key = @"submitDate";
    rowMo8.editAble = YES;
    rowMo8.value = self.businessMo.submitDate;
    rowMo8.strValue = self.businessMo.submitDate;
    [self.arrData addObject:rowMo8];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_MEMBER;
    rowMo4.leftContent = @"客户名称";
    rowMo4.key = @"member";
    rowMo4.rightContent = @"请选择";
    rowMo4.editAble = YES;
    error = nil;
    CustomerMo *member = [[CustomerMo alloc] initWithDictionary:self.businessMo.member error:&error];
    rowMo4.strValue = member.orgName;
    rowMo4.member = member;
    [self.arrData addObject:rowMo4];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_INPUT_TEXT;
    rowMo5.leftContent = @"客户联系人";
    rowMo5.inputType = K_SHORT_TEXT;
    rowMo5.key = @"customerContact";
    rowMo5.rightContent = @"请输入";
    rowMo5.editAble = YES;
    rowMo5.value = self.businessMo.customerContact;
    rowMo5.strValue = self.businessMo.customerContact;
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo51 = [[CommonRowMo alloc] init];
    rowMo51.rowType = K_INPUT_TEXT;
    rowMo51.keyBoardType = K_INTEGER;
    rowMo51.leftContent = @"联系人电话";
    rowMo51.inputType = K_SHORT_TEXT;
    rowMo51.key = @"customerTel";
    rowMo51.rightContent = @"请输入";
    rowMo51.editAble = YES;
    rowMo51.value = self.businessMo.customerTel;
    rowMo51.strValue = self.businessMo.customerTel;
    [self.arrData addObject:rowMo51];
    
    CommonRowMo *rowMo81 = [[CommonRowMo alloc] init];
    rowMo81.rowType = K_INPUT_SELECT_OTHER;
    rowMo81.leftContent = @"产品大类";
    rowMo81.rightContent = @"请选择";
    rowMo81.key = @"materialTypes";
    rowMo81.editAble = YES;
    rowMo81.mutiAble = YES;
    NSString *valueStr = @"";
    NSMutableArray *multipleValue = [NSMutableArray new];
    for (int i = 0; i < self.businessMo.materialTypes.count; i++) {
        NSDictionary *dic = self.businessMo.materialTypes[i];
        [multipleValue addObject:@{@"id":@([dic[@"id"] longLongValue])}];
        valueStr = [valueStr stringByAppendingString:STRING(dic[@"name"])];
        if (i < self.businessMo.materialTypes.count - 1) {
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
    DicMo *dicMo82 = [[DicMo alloc] init];
    dicMo82.value = self.businessMo.importantValue;
    dicMo82.key = self.businessMo.importantKey;
    rowMo82.singleValue = dicMo82;
    rowMo82.strValue = self.businessMo.importantValue;
    [self.arrData addObject:rowMo82];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_DATE_SELECT;
    rowMo6.leftContent = @"预计成交日期";
    rowMo6.pattern = @"yyyy-MM-dd";
    rowMo6.rightContent = @"请选择";
    rowMo6.key = @"transactionDate";
    rowMo6.editAble = YES;
    rowMo6.value = self.businessMo.transactionDate;
    rowMo6.strValue = self.businessMo.transactionDate;
    [self.arrData addObject:rowMo6];
    
    CommonRowMo *rowMo61 = [[CommonRowMo alloc] init];
    rowMo61.rowType = K_INPUT_TEXT;
    rowMo61.leftContent = @"商机金额";
    rowMo61.inputType = K_SHORT_TEXT;
    rowMo61.keyBoardType = K_DOUBLE;
    rowMo61.key = @"amount";
    rowMo61.rightContent = @"请输入";
    rowMo61.editAble = YES;
    rowMo61.value = self.businessMo.amount;
    rowMo61.strValue = self.businessMo.amount;
    [self.arrData addObject:rowMo61];
    
    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_TEXT;
    rowMo9.leftContent = @"商机内容";
    rowMo9.rightContent = @"请输入商机内容";
    rowMo9.inputType = K_LONG_TEXT;
    rowMo9.key = @"content";
    rowMo9.editAble = YES;
    rowMo9.value = self.businessMo.content;
    rowMo9.strValue = self.businessMo.content;
    [self.arrData addObject:rowMo9];
    
    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.rowType = K_FILE_INPUT;
    rowMo11.leftContent = @"附件";
    rowMo11.inputType = K_SHORT_TEXT;
    rowMo11.key = @"attachments";
    rowMo11.nullAble = YES;
    NSMutableArray *att = [NSMutableArray new];
    for (NSDictionary *dic in self.businessMo.attachments) {
        error = nil;
        QiniuFileMo *qiniuMo = [[QiniuFileMo alloc] initWithDictionary:dic error:&error];
        if ([qiniuMo.fileName containsString:@".jpg"] || [qiniuMo.fileName containsString:@".png"]) {
            [att addObject:qiniuMo];
        }
    }
    rowMo11.attachments = att;
    [self.arrData addObject:rowMo11];
    
//    error = nil;
//    self.arrCompetitor = [TrendsCompetitorMo arrayOfModelsFromDictionaries:self.businessMo.competitorBehaviorset error:&error];
    
    for (int i = 0; i < self.businessMo.competitorBehaviorset.count; i++) {
        NSDictionary *dic = self.businessMo.competitorBehaviorset[i];
        TrendsCompetitorMo *tmpMo = [[TrendsCompetitorMo alloc] init];
        error = nil;
        CustomerMo *member = [[CustomerMo alloc] initWithDictionary:dic[@"member"] error:&error];
        tmpMo.member = member;
        tmpMo.abbreviation = member.abbreviation;
        tmpMo.content = dic[@"content"];
        tmpMo.principalTel = dic[@"principalTel"];
        tmpMo.principalName = dic[@"principalName"];
        tmpMo.principalJob = dic[@"principalJob"];
        tmpMo.principalDepartment = dic[@"principalDepartment"];
        tmpMo.id = [dic[@"id"] longLongValue];
        [self.arrCompetitor addObject:tmpMo];
    }
    
    [self.tableView reloadData];
}

- (void)configRowMosNoModel {
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_TEXT;
    rowMo1.leftContent = @"商机标题";
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.rightContent = @"请输入";
    rowMo1.editAble = YES;
    rowMo1.key = @"title";
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_SELECT;
    rowMo2.leftContent = @"商机来源";
    rowMo2.dictName = @"business_chance_resource";
    rowMo2.rightContent = @"请选择";
    rowMo2.key = @"resourceKey";
    rowMo2.editAble = YES;
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo21 = [[CommonRowMo alloc] init];
    rowMo21.rowType = K_INPUT_SELECT;
    rowMo21.leftContent = @"商机类型";
    rowMo21.dictName = @"business_chance_type";
    rowMo21.rightContent = @"请选择";
    rowMo21.key = @"typeKey";
    rowMo21.editAble = YES;
    [self.arrData addObject:rowMo21];
    // 商机类型
    NSInteger x = self.arrData.count;
    [[JYUserApi sharedInstance] getConfigDicByName:rowMo21.dictName success:^(id responseObject) {
        NSError *error = nil;
        NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        for (int j = 0; j < arr.count; j++) {
            DicMo *dicMo = arr[j];
            if ([dicMo.key isEqualToString:@"new_business_chance"]) {
                rowMo21.strValue = dicMo.value;
                rowMo21.singleValue = dicMo;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:x-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    } failure:^(NSError *error) {
    }];
    
    
    CommonRowMo *rowMo31 = [[CommonRowMo alloc] init];
    rowMo31.rowType = K_INPUT_SELECT_OTHER;
    rowMo31.leftContent = @"关联活动";
    rowMo31.rightContent = @"请选择";
    rowMo31.key = @"activity";
    rowMo31.editAble = YES;
    rowMo31.nullAble = YES;
    [self.arrData addObject:rowMo31];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_SELECT_OTHER;
    rowMo3.leftContent = @"关联线索";
    rowMo3.rightContent = @"请选择";
    rowMo3.key = @"clue";
    rowMo3.editAble = YES;
    rowMo3.nullAble = YES;
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_SELECT_OTHER;
    rowMo7.leftContent = @"提交人";
    rowMo7.inputType = K_SHORT_TEXT;
    rowMo7.key = @"operator";
    rowMo7.rightContent = @"请选择";
    rowMo7.editAble = NO;
    rowMo7.strValue = STRING(TheUser.userMo.name);
    rowMo7.value = STRING(TheUser.userMo.oaCode);
    [self.arrData addObject:rowMo7];
    
    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_DATE_SELECT;
    rowMo8.leftContent = @"提交日期";
    rowMo8.pattern = @"yyyy-MM-dd HH:mm";
    rowMo8.rightContent = @"请选择";
    rowMo8.key = @"submitDate";
    rowMo8.strValue = [[NSDate date] stringWithFormat:rowMo8.pattern];
    rowMo8.editAble = YES;
    [self.arrData addObject:rowMo8];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_MEMBER;
    rowMo4.leftContent = @"客户名称";
    rowMo4.key = @"member";
    rowMo4.rightContent = @"请选择";
    rowMo4.editAble = YES;
    [self.arrData addObject:rowMo4];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_INPUT_TEXT;
    rowMo5.leftContent = @"客户联系人";
    rowMo5.inputType = K_SHORT_TEXT;
    rowMo5.key = @"customerContact";
    rowMo5.rightContent = @"请输入";
    rowMo5.editAble = YES;
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo51 = [[CommonRowMo alloc] init];
    rowMo51.rowType = K_INPUT_TEXT;
    rowMo51.keyBoardType = K_INTEGER;
    rowMo51.leftContent = @"联系人电话";
    rowMo51.inputType = K_SHORT_TEXT;
    rowMo51.key = @"customerTel";
    rowMo51.rightContent = @"请输入";
    rowMo51.editAble = YES;
    [self.arrData addObject:rowMo51];
    
    CommonRowMo *rowMo81 = [[CommonRowMo alloc] init];
    rowMo81.rowType = K_INPUT_SELECT_OTHER;
    rowMo81.leftContent = @"产品大类";
    rowMo81.rightContent = @"请选择";
    rowMo81.key = @"materialTypes";
    rowMo81.editAble = YES;
    rowMo81.mutiAble = YES;
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
    NSInteger y = self.arrData.count;
    [[JYUserApi sharedInstance] getConfigDicByName:rowMo82.dictName success:^(id responseObject) {
        NSError *error = nil;
        NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        for (int j = 0; j < arr.count; j++) {
            DicMo *dicMo = arr[j];
            if ([dicMo.key isEqualToString:@"general"]) {
                rowMo82.strValue = dicMo.value;
                rowMo82.singleValue = dicMo;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:y-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    } failure:^(NSError *error) {
    }];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_DATE_SELECT;
    rowMo6.leftContent = @"预计成交日期";
    rowMo6.pattern = @"yyyy-MM-dd";
    rowMo6.rightContent = @"请选择";
    rowMo6.key = @"transactionDate";
    rowMo6.editAble = YES;
    [self.arrData addObject:rowMo6];
    
    CommonRowMo *rowMo61 = [[CommonRowMo alloc] init];
    rowMo61.rowType = K_INPUT_TEXT;
    rowMo61.leftContent = @"商机金额";
    rowMo61.inputType = K_SHORT_TEXT;
    rowMo61.keyBoardType = K_DOUBLE;
    rowMo61.key = @"amount";
    rowMo61.rightContent = @"请输入";
    rowMo61.editAble = YES;
    [self.arrData addObject:rowMo61];
    
    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_TEXT;
    rowMo9.leftContent = @"商机内容";
    rowMo9.rightContent = @"请输入商机内容";
    rowMo9.inputType = K_LONG_TEXT;
    rowMo9.key = @"content";
    rowMo9.editAble = YES;
    [self.arrData addObject:rowMo9];
    
    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.rowType = K_FILE_INPUT;
    rowMo11.leftContent = @"附件";
    rowMo11.inputType = K_SHORT_TEXT;
    rowMo11.key = @"attachments";
    rowMo11.nullAble = YES;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.arrData.count-1;
    } else if (section == 1) {
        return self.arrCompetitor.count;
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
    if (section == 1) {
        return 40;
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
        header.labLeft.text = @"友商";
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
                AttachmentCell *cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.count = 9;
                cell.attachments = rowMo.attachments;
                [cell refreshView];
            }
            self.attCell = cell;
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
        } else {
            return [[UITableViewCell alloc] init];
        }
    }
    else if (indexPath.section == 1) {
        static NSString *cellId = @"CreateBusinessCompetiorCell";
        CreateBusinessCompetiorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[CreateBusinessCompetiorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell loadDataWith:self.arrCompetitor[indexPath.row]];
        return cell;
    }
    else if (indexPath.section == 2) {
        CommonRowMo *rowMo = [self.arrData lastObject];
        if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
//            static NSString *cellId = @"attachmentCell";
//            AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
        } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER]) {
            // 关联活动
            if ([rowMo.key isEqualToString:@"activity"]) {
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
            // 关联线索
            else if ([rowMo.key isEqualToString:@"clue"]) {
                ClueSelectViewCtrl *vc = [[ClueSelectViewCtrl alloc] init];
                vc.vcDelegate = self;
                vc.indexPath = indexPath;
                ClueMo *tmpMo = (ClueMo *)rowMo.value;
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
            
            [self hidenKeyboard];
        }
    }
    else if (indexPath.section == 1) {
        TrendsCompetitorMo *model = self.arrCompetitor[indexPath.row];
        CreateBusinessCompetitorViewCtrl *vc = [[CreateBusinessCompetitorViewCtrl alloc] init];
        vc.model = model;
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(TrendsCompetitorMo *tmpMo) {
            __strong typeof(self) strongself = weakself;
            [strongself.arrCompetitor replaceObjectAtIndex:indexPath.row withObject:tmpMo];
            [strongself.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2) {
        
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    } else {
        return NO;
    }
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
        [self.arrCompetitor removeObjectAtIndex:indexPath.row];
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
    
    if ([dicMo.name isEqualToString:@"business_chance_resource"]) {
        // 老客户
        if ([dicMo.key isEqualToString:@"customer_introduce"]) {
            if (![self.arrData containsObject:self.rowMoOld]) [self.arrData insertObject:self.rowMoOld atIndex:2];
        } else{
            if ([self.arrData containsObject:self.rowMoOld]) [self.arrData removeObject:self.rowMoOld];
            _rowMoOld = nil;
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

#pragma mark - ClueSelectViewCtrlDelegate

- (void)clueSelectViewCtrl:(ClueSelectViewCtrl *)clueSelectViewCtrl didSelect:(ClueMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.value = model;
        rowMo.strValue = model.title;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)clueSelectViewCtrlDismiss:(ClueSelectViewCtrl *)clueSelectViewCtrl {
    clueSelectViewCtrl = nil;
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

#pragma mark - event

- (void)createCompetitor:(UIButton *)sender {
    [self hidenKeyboard];
    CreateBusinessCompetitorViewCtrl *vc = [[CreateBusinessCompetitorViewCtrl alloc] init];
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(TrendsCompetitorMo *tmpMo) {
        __strong typeof(self) strongself = weakself;
        [strongself.arrCompetitor addObject:tmpMo];
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
            [param setObject:@{@"id":@(rowMo.member.id),
                               @"abbreviation":STRING(rowMo.member.abbreviation)} forKey:rowMo.key];
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
        cell = self.attCell;
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
    if (arr.count > 0) [params setObject:arr forKey:@"attachmentList"];
    
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
    
    [params removeObjectForKey:@"operator"];
    
    for (CommonRowMo *tmpMo in self.arrData) {
        if ([tmpMo.rowType isEqualToString:K_INPUT_SELECT_OTHER]) {
            if ([tmpMo.key isEqualToString:@"activity"]) {
                MarketActivityMo *mo = (MarketActivityMo *)tmpMo.value;
                if (mo) [params setObject:@{@"id":@(mo.id),
                                            @"title":STRING(mo.title)} forKey:tmpMo.key];
                continue;
            }
            if ([tmpMo.key isEqualToString:@"clue"]) {
                ClueMo *mo = (ClueMo *)tmpMo.value;
                if (mo) [params setObject:@{@"id":@(mo.id),
                                            @"title":STRING(mo.title)} forKey:tmpMo.key];
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
    
    // 竞争对手
    NSMutableArray *comArr = [NSMutableArray new];
    for (TrendsCompetitorMo *tmpMo in self.arrCompetitor) {
        [comArr addObject:@{@"member": @{@"id":@(tmpMo.member.id),
                                         @"abbreviation":STRING(tmpMo.member.abbreviation)},
                            @"principalName":tmpMo.principalName,
                            @"principalTel":tmpMo.principalTel,
                            @"principalJob":tmpMo.principalJob,
                            @"principalDepartment":tmpMo.principalDepartment,
                            @"abbreviation":STRING(tmpMo.member.abbreviation),
                            @"content":tmpMo.content}];
    }
    
    [params setObject:comArr forKey:@"competitorBehaviorset"];
    
    if (self.isUpdate) {
        [self updateParams:params attachementList:attachementList];
    } else {
        [self createParams:params attachementList:attachementList];
    }
}


- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [[JYUserApi sharedInstance] createDynmicFormDynamicId:@"business-chance" param:params success:^(id responseObject) {
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
    [params setObject:@(self.detailId) forKey:@"id"];
    [[JYUserApi sharedInstance] updateBusinessChangeParam:params success:^(id responseObject) {
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

- (NSMutableArray *)arrCompetitor {
    if (!_arrCompetitor) _arrCompetitor = [NSMutableArray new];
    return _arrCompetitor;
}

- (CommonRowMo *)rowMoOld {
    if (!_rowMoOld) {
        _rowMoOld = [[CommonRowMo alloc] init];
        _rowMoOld.rowType = K_INPUT_MEMBER;
        _rowMoOld.leftContent = @"老客户";
        _rowMoOld.rightContent = @"请选择";
        _rowMoOld.key = @"regularCustomer";
        _rowMoOld.editAble = YES;
    }
    return _rowMoOld;
}

@end
