//
//  Custom360ControlViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360ControlViewCtrl.h"
#import "MyCommonCell.h"
#import "CusInfoMo.h"
#import "EditTextViewCtrl.h"
#import "EmptyView.h"
#import "ListSelectViewCtrl.h"
#import "WSDatePickerView.h"

@interface Custom360ControlViewCtrl () <EditTextViewCtrlDelegate, ListSelectViewCtrlDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) CusInfoDetailMo *changeMo;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;

@end

@implementation Custom360ControlViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    [self getCustomerInfo];
    self.headerRefresh = YES;
}

#pragma mark - network

- (void)getCustomerInfo {
    [[JYUserApi sharedInstance] getCustomerInfoByCustomId:TheCustomer.customerMo.id success:^(id responseObject) {
        [self tableViewEndRefresh];
        self.arrData = [CusInfoMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
        BOOL stop = NO;
        for (int i = 0; i < self.arrData.count; i++) {
            if (stop) {
                break;
            }
            CusInfoMo *infoMo = self.arrData[i];
            for (int j = 0; j < infoMo.data.count; j++) {
                CusInfoDetailMo *detailMo = infoMo.data[j];
                if ([detailMo.field isEqualToString:@"id"]) {
                    _personId = detailMo.rightContent;
                    [infoMo.data removeObject:detailMo];
                    stop = YES;
                    break;
                }
            }
        }
        [self dealWithData];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self tableViewEndRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)dealWithData {
    for (int i = 0; i < self.arrData.count; i++) {
        CusInfoMo *infoMo = self.arrData[i];
        for (int j = 0; j < infoMo.data.count; j++) {
            CusInfoDetailMo *detailMo = infoMo.data[j];
            if ([detailMo.field isEqualToString:@"sex"]||
                [detailMo.field isEqualToString:@"nation"]||
                [detailMo.field isEqualToString:@"birthday"]||
                [detailMo.field isEqualToString:@"politicalStatus"]||
                [detailMo.field isEqualToString:@"education"]||
                [detailMo.field isEqualToString:@"employerNature"]||
                [detailMo.field isEqualToString:@"marriage"]) {
                detailMo.placeHolder = @"请选择";
            } else {
                detailMo.placeHolder = @"请填写";
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.tableView);
            make.width.height.equalTo(self.tableView);
        }];
    }
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CusInfoMo *model = self.arrData[section];
    return model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellId = @"customCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.imgArrow.hidden = NO;
        }
        CusInfoMo *model = self.arrData[indexPath.section];
        CusInfoDetailMo *mo = model.data[indexPath.row];
        [cell setLeftText:mo.leftContent];
        ShowTextMo *showTextMo = [Utils showTextRightStr:mo.placeHolder valueStr:mo.rightContent];
        cell.labRight.text = showTextMo.text;
        cell.labRight.textColor = mo.change ? COLOR_B1 : COLOR_B2;
        [cell.imgArrow setImage:[UIImage imageNamed:mo.change ? @"Path" : @"client_arrow"]];
        cell.lineView.hidden = (indexPath.row == model.data.count - 1) ? YES : NO;
        return cell;
    } else {
        static NSString *cellId = @"longCell";
        LongCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LongCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        CusInfoMo *model = self.arrData[indexPath.section];
        CusInfoDetailMo *mo = model.data[indexPath.row];
        cell.labLeft.text = mo.leftContent;
        ShowTextMo *showTextMo = [Utils showTextRightStr:mo.placeHolder valueStr:mo.rightContent];
        [cell setLongRightText:showTextMo.text];
        cell.labRight.textColor = mo.change ? COLOR_B1 : COLOR_B2;
        cell.lineView.hidden = (indexPath.row == model.data.count - 1) ? YES : NO;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerId = @"headerId";
    MyCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[MyCommonHeaderView alloc] initWithReuseIdentifier:headerId isHidenLine:NO];
    }
    
    CusInfoMo *model = self.arrData[section];
    header.labLeft.text = model.title;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CusInfoMo *model = self.arrData[indexPath.section];
    self.changeMo = model.data[indexPath.row];
    if (_changeMo.change) {
        // 可以修改
        if ([_changeMo.field isEqualToString:@"birthday"]||
            [_changeMo.field isEqualToString:@"operatingPeriodFrom"]||
            [_changeMo.field isEqualToString:@"operatingPeriodTo"]) {
            
            NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
            [minDateFormater setDateFormat:@"yyyy-MM-dd"];
            NSDate *scrollToDate = [minDateFormater dateFromString:self.changeMo.rightContent];
            __weak typeof(self) weakself = self;
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
                __strong typeof(self) strongself = weakself;
                NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
                NSLog(@"选择的日期：%@",date);
                [strongself updatePersonField:STRING(strongself.changeMo.field) value:date];
            }];
            datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
            datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
            datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            [datepicker show];
            return;
        }
        // 性别
        else if ([_changeMo.field isEqualToString:@"sex"]) {
            NSArray *arr = @[@"男", @"女"];
            BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:arr defaultItem:-1 itemClick:^(NSInteger index) {
                [self updatePersonField:_changeMo.field value:arr[index]];
            } cancelClick:^(BottomView *obj) {
                [obj removeFromSuperview];
                obj = nil;
            }];
            [bottomView show];
        }
        else if (_changeMo.dictField.length != 0) {
            // 字典项
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] getConfigDicByName:_changeMo.dictField success:^(id responseObject) {
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
        else {
            // 可以修改
            EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
            vc.title = _changeMo.leftContent;
            vc.max_length = 50;
            //手机号
            if ([_changeMo.field isEqualToString:@"phoneOne"]||
                [_changeMo.field isEqualToString:@"phoneTwo"]||
                [_changeMo.field isEqualToString:@"phoneThree"]||
                [_changeMo.field isEqualToString:@"phoneFour"]||
                [_changeMo.field isEqualToString:@"contactPhone"]) {
                vc.numberOnly = YES;
                vc.max_length = 6;
                vc.hidenCount = YES;
                vc.keyType = UIKeyboardTypeNumberPad;
                vc.numberOnly = YES;
            }
            // 收入
            else if ([_changeMo.field isEqualToString:@"monthlyIncome"]) {
                vc.numberOnly = YES;
                vc.keyType = UIKeyboardTypeAlphabet;
            }
            // 长文本
            else if ([_changeMo.field isEqualToString:@"resume"]||
                [_changeMo.field isEqualToString:@"remark"]) {
                vc.max_length = 200;
            }
            vc.placeholder = [NSString stringWithFormat:@"请输入%@", _changeMo.leftContent];
            vc.currentText = _changeMo.rightContent;
            vc.indexPath = indexPath;
            vc.editVCDelegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = self.changeMo.leftContent;
    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:STRING(self.changeMo.rightContent), nil];
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    //手机号
    if ([_changeMo.field isEqualToString:@"phoneOne"]||
        [_changeMo.field isEqualToString:@"phoneTwo"]||
        [_changeMo.field isEqualToString:@"phoneThree"]||
        [_changeMo.field isEqualToString:@"phoneFour"]||
        [_changeMo.field isEqualToString:@"contactPhone"]) {
        if (content.length >= 11) {
            content = [content substringToIndex:11];
        }
    }
    [self updatePersonField:STRING(self.changeMo.field) value:STRING(content)];
}

- (void)updatePersonField:(NSString *)field value:(NSString *)value {
    NSDictionary *param = @{@"id":STRING(_personId),
                            @"value":STRING(value),
                            @"field":STRING(field)};
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] actualUpdateParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
        [self getCustomerInfo];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    
    DicMo *tmpDic = self.selectArr[index];
    [self updatePersonField:STRING(self.changeMo.field) value:STRING(tmpDic.value)];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    [self getCustomerInfo];
}

#pragma mark - setter getter

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
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
