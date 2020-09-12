//
//  CreateContractViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateContractViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "AttachmentCell.h"
#import "MyCommonCell.h"
#import "WSDatePickerView.h"
#import "QiNiuUploadHelper.h"
#import "MemberSelectViewCtrl.h"

@interface CreateContractViewCtrl ()
<UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, MyTextViewCellDelegate, MemberSelectViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSMutableArray *attachUrls;
@property (nonatomic, strong) DicMo *dicMo;
@property (nonatomic, strong) CustomerMo *customerMo;

@end

@implementation CreateContractViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self setUI];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)config {
    [self.arrValues replaceObjectAtIndex:3 withObject:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"]];
    if (_mo) {
        for (QiniuFileMo *tmpMo in _mo.attachments) {
            [self.attachments addObject:STRING(tmpMo.thumbnail)];
            [self.attachUrls addObject:STRING(tmpMo.url)];
        }
        self.dicMo = [[DicMo alloc] initWithDictionary:_mo.type error:nil];
        [self.arrValues replaceObjectAtIndex:0 withObject:STRING(self.dicMo.value)];
        [self.arrValues replaceObjectAtIndex:1 withObject:STRING(_mo.member[@"orgName"])];
        [self.arrValues replaceObjectAtIndex:2 withObject:STRING(_mo.number)];
        [self.arrValues replaceObjectAtIndex:3 withObject:STRING(_mo.infoDate)];
        self.rightBtn.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == self.arrLeft.count - 1 ? 120 : 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count - 1) {
        static NSString *cellId = @"attachmentCell";
        AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.count = 9;
            cell.labTitle.text = self.arrLeft[indexPath.row];
            cell.attachments = _mo.attachments;
            cell.forbidDelete = _mo ? YES : NO;
            [cell refreshView];
        }
        return cell;
    }
    static NSString *cellId = @"commonCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setLeftText:self.arrLeft[indexPath.row]];
    
    ShowTextMo *showTextMo = [Utils showTextRightStr:self.arrRight[indexPath.row] valueStr: self.arrValues[indexPath.row]];
    cell.labRight.textColor = showTextMo.color;
    cell.labRight.text = showTextMo.text;
    cell.labLeft.textColor = COLOR_B1;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_mo) {
        return;
    }
    if (indexPath.row == 0) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getConfigDicByName:@"salescontract_type" success:^(id responseObject) {
            [Utils dismissHUD];
            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
            [_selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (DicMo *tmpMo in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = tmpMo.id;
                mo.moText = tmpMo.value;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
        }];
    }
    // 客户
    else if (indexPath.row == 1) {
        MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
        vc.needRules = NO;
        vc.VcDelegate = self;
        vc.defaultId = self.customerMo.id;
        vc.indexPath = indexPath;
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
    }
    else if (indexPath.row == 3) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *scrollToDate = [minDateFormater dateFromString:self.arrValues[indexPath.row]];
        __weak typeof(self) weakself = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",date);
            [weakself.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:date])];
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = self.arrLeft[indexPath.row];
    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:self.arrValues[indexPath.row], nil];
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:selectMo.moText])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (indexPath.row == 0) {
        self.dicMo = self.selectArr[index];
    } else if (indexPath.row == 1) {
        self.customerMo = self.selectArr[index];
    }
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        self.customerMo = model;
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:model.orgName])];
        if (indexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    for (int i = 0; i < self.arrValues.count - 1; i++) {
        if (i != 2) {
            if ([self.arrValues[i] isEqualToString:@"demo"]) {
                [Utils showToastMessage:@"请完善信息"];
                return;
            }
        }
    }
    AttachmentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrValues.count-1 inSection:0]];
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self createContract:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self createContract:@[]];
    }
}

- (void)createContract:(NSArray *)attachments {
    [Utils showHUDWithStatus:nil];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@{@"id":@(self.customerMo.id)} forKey:@"member"];
    
    [params setObject:@{@"id":STRING(_dicMo.id),
                        @"value":STRING(_dicMo.value),
                        @"key":STRING(_dicMo.key)} forKey:@"type"];
    [params setObject:STRING(self.arrValues[3]) forKey:@"infoDate"];
    
    [[JYUserApi sharedInstance] createContractParam:params attachments:attachments success:^(id responseObject) {
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

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"合同类型",
                     @"客户",
                     @"合同编号",
                     @"合同日期",
                     @"合同拍照"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请输入",
                      @"请输入",
                      @"无",
                      @"请选择",
                      @"合同拍照"];
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

@end
