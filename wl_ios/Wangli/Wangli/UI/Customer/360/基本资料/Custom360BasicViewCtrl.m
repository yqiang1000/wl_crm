//
//  Custom360BasicViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360BasicViewCtrl.h"
#import "MyCommonCell.h"
#import "CusInfoMo.h"
#import "EditTextViewCtrl.h"
#import "EmptyView.h"
#import "WSDatePickerView.h"
#import "ListSelectViewCtrl.h"
#import "BrandSelectViewCtrl.h"
#import "BrandMo.h"
#import "JYUserMoSelectViewCtrl.h"
#import "MemberSelectViewCtrl.h"
#import "AddressPickerView.h"

@interface Custom360BasicViewCtrl () <EditTextViewCtrlDelegate, ListSelectViewCtrlDelegate, BrandSelectViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, MemberSelectViewCtrlDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) CusInfoDetailMo *changeMo;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrAddIds;
@property (nonatomic, strong) NSArray *arrAddNames;

@end

@implementation Custom360BasicViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    [self getCustomerInfo];
    self.headerRefresh = YES;
}

#pragma mark - network

- (void)getCustomerInfo {
    [[JYUserApi sharedInstance] getCustomerOrgInfoByCustomId:TheCustomer.customerMo.id success:^(id responseObject) {
        [self tableViewEndRefresh];
        
        NSError *error = nil;
        
        NSMutableArray *arr = [self dealWithResponse:responseObject];
        self.arrData = [CusInfoMo arrayOfModelsFromDictionaries:arr error:&error];
//        self.arrData = [CusInfoMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self tableViewEndRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}


- (NSMutableArray *)dealWithResponse:(id)responseObject {
    
    
//    {
//        "leftContent": "客户名称",
//        "rightContent": "苏州贝叶纺织有限公司",
//        "field": "orgName",
//        "change": false,
//        "url": null,
//        "dictField": null
//    },
    NSArray *arr = responseObject[@"content"];
    NSMutableArray *totalArr = [NSMutableArray new];
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *tmpDic = arr[i];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:STRING(tmpDic[@"title"]) forKey:@"title"];
        
        NSArray *arr = tmpDic[@"data"];
        NSMutableArray *dataArr = [NSMutableArray new];
        
        for (int j = 0; j < arr.count; j++) {
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:arr[j]];
//            if ([dataDic[@"change"] boolValue]) {
                if (i == 0) {
                    if ([dataDic[@"field"] isEqualToString:@"orgName"]||
                        [dataDic[@"field"] isEqualToString:@"abbreviation"]) {
                        [dataDic setObject:@"请填写" forKey:@"placeHolder"];
                    } else {
                        [dataDic setObject:@"请选择" forKey:@"placeHolder"];
                    }
                } else {
                    if ([dataDic[@"field"] isEqualToString:@"registrationDate"]||
                        [dataDic[@"field"] isEqualToString:@"businessStatus"]||
                        [dataDic[@"field"] isEqualToString:@"companyType"]||
                        [dataDic[@"field"] isEqualToString:@"operatingPeriodFrom"]||
                        [dataDic[@"field"] isEqualToString:@"operatingPeriodTo"]||
                        [dataDic[@"field"] isEqualToString:@"riskLevel"]||
                        [dataDic[@"field"] isEqualToString:@"companyType"]||
                        [dataDic[@"field"] isEqualToString:@"businessStatus"]) {
                        [dataDic setObject:@"请选择" forKey:@"placeHolder"];
                    } else {
                        [dataDic setObject:@"请填写" forKey:@"placeHolder"];
                    }
                }
                [dataArr addObject:dataDic];
//            }
        }
        
        [dic setObject:STRING(dataArr) forKey:@"data"];
        [totalArr addObject:dic];
    }
    return totalArr;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    static NSString *cellId = @"customCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
        if ([_changeMo.field isEqualToString:@"registrationDate"]||
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
                [strongself update:strongself.changeMo value:date param:nil];
            }];
            datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
            datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
            datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            [datepicker show];
        }
        // 品牌
        else if ([_changeMo.field isEqualToString:@"brandNames"]) {
            BrandSelectViewCtrl *vc = [[BrandSelectViewCtrl alloc] init];
            vc.vcDelegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        // 业务员
        else if ([_changeMo.field isEqualToString:@"operatorName"]) {
            JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
            vc.VcDelegate = self;
            vc.isMultiple = NO;
            vc.indexPath = indexPath;
            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        }
        // 客户
        else if ([_changeMo.field isEqualToString:@"firstDistributor"]) {
            MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
            CustomerMo *member = (CustomerMo *)self.changeMo.m_obj;
            vc.needRules = NO;
            vc.VcDelegate = self;
            vc.defaultId = member.id;
            vc.indexPath = indexPath;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
        }
        // 地区
        else if ([_changeMo.field isEqualToString:@"region"]) {
            __weak typeof(self) weakSelf = self;
            AddressPickerView *picker = [[AddressPickerView alloc] initWithDefaultItem:self.arrAddIds itemClick:^(NSArray *arrResult) {
                
                __strong typeof(self) strongSelf = weakSelf;
                strongSelf.arrAddIds = arrResult[0];
                strongSelf.arrAddNames = arrResult[1];
                strongSelf.changeMo.rightValue = [arrResult lastObject];
                strongSelf.changeMo.m_objs = [[NSMutableArray alloc] initWithArray:arrResult];
                
                NSString *provinceName = @"";
                for (int i = 0; i < strongSelf.arrAddIds.count; i++) {
                    NSString *num = strongSelf.arrAddIds[i];
                    if (num.length > 0 && ![num containsString:@"-"]) {
                        if (provinceName.length > 0) provinceName = [provinceName stringByAppendingString:@"-"];
                        provinceName = [provinceName stringByAppendingString:[NSString stringWithFormat:@"%@-%@", num, strongSelf.arrAddNames[i]]];
                    }
                }
                [strongSelf update:strongSelf.changeMo value:provinceName param:nil];
            } cancelClick:^(AddressPickerView *obj) {
                [obj removeFromSuperview];
                obj = nil;
            }];
            [self.view addSubview:picker];
            [picker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self.view);
            }];
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
            EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
            vc.title = _changeMo.leftContent;
            vc.max_length = 50;
            if ([_changeMo.field isEqualToString:@"registeredCapital"]) {
                vc.numberOnly = YES;
                vc.keyType = UIKeyboardTypeDecimalPad;
            }
            if ([_changeMo.field isEqualToString:@"businessScope"]||
                [_changeMo.field isEqualToString:@"branchesOrg"]||
                [_changeMo.field isEqualToString:@"shareholderInformation"]) {
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

- (void)update:(CusInfoDetailMo *)cusInfoMo value:(NSString *)value param:(NSMutableDictionary *)param {
    [[JYUserApi sharedInstance] updateCustomerByCustomId:TheCustomer.customerMo.id field:cusInfoMo.field value:value param:param success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
        [self getCustomerInfo];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = self.changeMo.leftContent;
    
    if ([self.changeMo.field isEqualToString:@"landx"]) {
        vc.title = @"国家、地区、城市";
        vc.enableSearch = YES;
    }
    
    if ([self.changeMo.field isEqualToString:@"field"]||
        [self.changeMo.field isEqualToString:@"application"]||
        [self.changeMo.field isEqualToString:@"businessScope"]) {
        vc.isMultiple = YES;
        vc.defaultValues = [self arrayWithText:self.changeMo.rightContent];
    } else {
        vc.defaultValues = [[NSMutableArray alloc] initWithObjects:STRING(self.changeMo.rightContent), nil];
    }
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)arrayWithText:(NSString *)text {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[text componentsSeparatedByString:@","]];
    return arr;
}

#pragma mark - BrandSelectViewCtrlDelegate

- (void)brandSelectViewCtrl:(BrandSelectViewCtrl *)brandSelectViewCtrl didSelected:(NSMutableArray *)arrSelect {
    NSString *str = @"";
    for (int i = 0; i < arrSelect.count; i++) {
        BrandMo *mo = arrSelect[i];
        str = [str stringByAppendingString:mo.brandName];
        if (i < arrSelect.count-1) [str stringByAppendingString:@","];
    }
    [self update:self.changeMo value:str param:nil];
}

#pragma mark - JYUserMoSelectViewCtrlDelegate

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(JYUserMo *)selectMo {
    if (selectMo) {
        [self update:self.changeMo value:[NSString stringWithFormat:@"%ld",  selectMo.id] param:nil];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)jyUserMoSelectViewCtrlDismiss:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl {
    jyUserMoSelectViewCtrl = nil;
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (TheCustomer.customerMo.id == model.id) {
        [Utils showToastMessage:@"一级经销商不能为当前客户"];
        return;
    }
    [self update:self.changeMo value:[NSString stringWithFormat:@"%ld",  model.id] param:nil];
//    self.changeMo.m_obj = model;
//    self.changeMo.rightValue = model.orgName;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)memberSelectViewCtrlDismiss:(MemberSelectViewCtrl *)memberSelectViewCtrl {
    memberSelectViewCtrl = nil;
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath btnRightClick:(UIButton *)sender complete:(void (^)(BOOL, NSString *))complete {
    [editVC.navigationController popViewControllerAnimated:YES];
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] updateCustomerByCustomId:TheCustomer.customerMo.id field:_changeMo.field value:content param:nil success:^(id responseObject) {
        [Utils dismissHUD];
        complete(YES, @"修改成功");
        [self getCustomerInfo];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        complete(NO, STRING(error.userInfo[@"message"]));
    }];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    DicMo *tmpDic = self.selectArr[index];
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] updateCustomerByCustomId:TheCustomer.customerMo.id field:_changeMo.field value:tmpDic.value param:nil success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
        [self getCustomerInfo];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath {
    NSString *value = [[NSString alloc] init];
    for (int i = 0; i < selectIndexPaths.count; i++) {
        NSIndexPath *tmpIndex = selectIndexPaths[i];
        DicMo *tmpDic = self.selectArr[tmpIndex.row];
        value = [value stringByAppendingString:tmpDic.value];
        if (i != selectIndexPaths.count - 1) {
            value = [value stringByAppendingString:@","];
        }
    }
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] updateCustomerByCustomId:TheCustomer.customerMo.id field:_changeMo.field value:value param:nil success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
        [self getCustomerInfo];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
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

- (NSArray *)arrAddIds {
    if (!_arrAddIds) {
        _arrAddIds = @[@"0", @"0", @"0"];
    }
    return _arrAddIds;
}

- (NSArray *)arrAddNames {
    if (!_arrAddNames) {
        _arrAddNames = [NSArray new];
    }
    return _arrAddNames;
}

@end
