
//
//  CreateCustomerViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateCustomerViewCtrl.h"
#import "MyCommonCell.h"
#import "CusInfoMo.h"
#import "EditTextViewCtrl.h"
#import "WSDatePickerView.h"
#import "ListSelectViewCtrl.h"
#import "CountrySelectViewCtrl.h"
#import "BrandSelectViewCtrl.h"
#import "BrandMo.h"
#import "JYUserMoSelectViewCtrl.h"
#import "MemberSelectViewCtrl.h"
#import "AddressPickerView.h"

@interface CreateCustomerViewCtrl () <EditTextViewCtrlDelegate, ListSelectViewCtrlDelegate, UITableViewDelegate, UITableViewDataSource, CountrySelectViewCtrlDelegate, BrandSelectViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, MemberSelectViewCtrlDelegate>
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) CusInfoDetailMo *changeMo;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;

@property (nonatomic, strong) NSArray *arrAddIds;
@property (nonatomic, strong) NSArray *arrAddNames;

@end

@implementation CreateCustomerViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self getCustomerInfo];
    self.title = @"新建客户";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
}

#pragma mark - network

- (void)getCustomerInfo {
    [[JYUserApi sharedInstance] getCustomerOrgInfoByCustomId:-1 success:^(id responseObject) {
        NSMutableArray *arr = [self dealWithResponse:responseObject];
        self.arrData = [CusInfoMo arrayOfModelsFromDictionaries:arr error:nil];
        [self dealWithDefault];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (NSMutableArray *)dealWithResponse:(id)responseObject {
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
            if ([dataDic[@"change"] boolValue]) {
                if (i == 0) {
                    if ([dataDic[@"field"] isEqualToString:@"orgName"]||
                        [dataDic[@"field"] isEqualToString:@"abbreviation"]||
                        [dataDic[@"field"] isEqualToString:@"customerDemand"]||
                        [dataDic[@"field"] isEqualToString:@"registeredCapital"]) {
                        [dataDic setObject:@"请填写(必填项)" forKey:@"placeHolder"];
                    }
                    else {
                        [dataDic setObject:@"请选择(必填项)" forKey:@"placeHolder"];
                    }
                } else {
                    if ([dataDic[@"field"] isEqualToString:@"businessStatusValue"]||
                        [dataDic[@"field"] isEqualToString:@"registrationDate"]||
                        [dataDic[@"field"] isEqualToString:@"operatingPeriodFrom"]||
                        [dataDic[@"field"] isEqualToString:@"operatingPeriodTo"]) {
                        [dataDic setObject:@"请选择" forKey:@"placeHolder"];
                    } else {
                        [dataDic setObject:@"请填写" forKey:@"placeHolder"];
                    }
                }
                [dataDic setObject:@"demo" forKey:@"rightValue"];
                [dataArr addObject:dataDic];
            }
        }
        
        [dic setObject:STRING(dataArr) forKey:@"data"];
        [totalArr addObject:dic];
    }
    return totalArr;
}

- (void)dealWithDefault {
    CusInfoMo *model = self.arrData[0];
    for (int i = 0; i < model.data.count; i++) {
        CusInfoDetailMo *tmpMo = model.data[i];
        // 客户等级
        if ([tmpMo.field isEqualToString:@"memberLevelValue"]) {
            [[JYUserApi sharedInstance] getConfigDicByName:tmpMo.dictField success:^(id responseObject) {
                NSError *error = nil;
                NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
                for (int j = 0; j < arr.count; j++) {
                    DicMo *dicMo = arr[j];
                    if ([dicMo.key isEqualToString:@"ordinary"]) {
                        tmpMo.rightValue = dicMo.value;
                        tmpMo.m_obj = dicMo;
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        break;
                    }
                }
            } failure:^(NSError *error) {
            }];
        }
        // 信用等级
        if ([tmpMo.field isEqualToString:@"creditLevelValue"]) {
            [[JYUserApi sharedInstance] getConfigDicByName:tmpMo.dictField success:^(id responseObject) {
                NSError *error = nil;
                NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
                for (int j = 0; j < arr.count; j++) {
                    DicMo *dicMo = arr[j];
                    if ([dicMo.key isEqualToString:@"A"]) {
                        tmpMo.rightValue = dicMo.value;
                        tmpMo.m_obj = dicMo;
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        break;
                    }
                }
            } failure:^(NSError *error) {
            }];
        }
        // 合作类型
        if ([tmpMo.field isEqualToString:@"cooperationTypeValue"]) {
            [[JYUserApi sharedInstance] getConfigDicByName:tmpMo.dictField success:^(id responseObject) {
                NSError *error = nil;
                NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
                for (int j = 0; j < arr.count; j++) {
                    DicMo *dicMo = arr[j];
                    if ([dicMo.key isEqualToString:@"two_level_distributor"]) {
                        tmpMo.rightValue = dicMo.value;
                        tmpMo.m_obj = dicMo;
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        break;
                    }
                }
            } failure:^(NSError *error) {
            }];
        }
        // 国家
        if ([tmpMo.field isEqualToString:@"landx"]) {
            CountryMo *country = [[CountryMo alloc] init];
            country.id = 47;
            country.land1 = @"CN";
            country.landx = @"中国";
            country.landx50 = @"中国";
            tmpMo.rightValue = country.landx;
            tmpMo.m_obj = country;
            break;
        }
    }
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
    cell.labLeft.textColor = COLOR_B1;
    [cell setLeftText:mo.leftContent];
    ShowTextMo *showTextMo = [Utils showTextRightStr:mo.placeHolder valueStr:mo.rightValue];
    cell.labRight.textColor = showTextMo.color;
    cell.labRight.text = showTextMo.text;
    if ([mo.field isEqualToString:@"memberLevelValue"]||
        [mo.field isEqualToString:@"creditLevelValue"]||
        [mo.field isEqualToString:@"cooperationTypeValue"]) cell.labRight.textColor = COLOR_B2;
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
    
    // 客户等级 && 信用等级
    if ([_changeMo.field isEqualToString:@"memberLevelValue"]||
        [_changeMo.field isEqualToString:@"creditLevelValue"]||
        [_changeMo.field isEqualToString:@"cooperationTypeValue"]) {
        return;
    }
    
    if (_changeMo.change) {
        // 可以修改
        if ([_changeMo.field isEqualToString:@"registrationDate"]||
            [_changeMo.field isEqualToString:@"operatingPeriodFrom"]||
            [_changeMo.field isEqualToString:@"operatingPeriodTo"]) {
            
            NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
            [minDateFormater setDateFormat:@"yyyy-MM-dd"];
            NSDate *scrollToDate = [minDateFormater dateFromString:self.changeMo.rightValue];
            __weak typeof(self) weakself = self;
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
                __strong typeof(self) strongself = weakself;
                NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
                NSLog(@"选择的日期：%@",date);
                
                CusInfoMo *model = strongself.arrData[indexPath.section];
                CusInfoDetailMo *mo = model.data[indexPath.row];
                mo.rightValue = [Utils saveToValues:date];
                [strongself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
            datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
            datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            [datepicker show];
        }
        else if (_changeMo.dictField.length != 0) {
            // 字典项
            [[JYUserApi sharedInstance] getConfigDicByName:_changeMo.dictField success:^(id responseObject) {
                self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
                [_selectShowArr removeAllObjects];
                _selectShowArr = nil;
                for (DicMo *tmpMo in self.selectArr) {
                    ListSelectMo *selectMo = [[ListSelectMo alloc] init];
                    selectMo.moId = tmpMo.id;
                    selectMo.moKey = tmpMo.key;
                    selectMo.moText = tmpMo.value;
                    [self.selectShowArr addObject:selectMo];
                }
                [self pushToSelectVC:indexPath];
            } failure:^(NSError *error) {
            }];
        }
        // 国家
        else if ([_changeMo.field isEqualToString:@"landx"]) {
            CountrySelectViewCtrl *vc = [[CountrySelectViewCtrl alloc] init];
            vc.indexPath = indexPath;
            vc.vcDelegate = self;
            CountryMo *mo = (CountryMo *)_changeMo.m_obj;
            if (mo) vc.defaultId = mo.id;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:navi animated:YES completion:nil];
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
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } cancelClick:^(AddressPickerView *obj) {
                [obj removeFromSuperview];
                obj = nil;
            }];
            [self.view addSubview:picker];
            [picker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self.view);
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
            if ([_changeMo.field isEqualToString:@"branchesOrg"]||
                [_changeMo.field isEqualToString:@"shareholderInformation"]) {
                vc.max_length = 200;
            }
            vc.placeholder = [NSString stringWithFormat:@"请输入%@", _changeMo.leftContent];
            vc.currentText = [_changeMo.rightValue isEqualToString:@"demo"] ? @"" : _changeMo.rightValue;
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
    vc.byText = YES;
    NSMutableArray *arrValue = [NSMutableArray new];
    if ([self.changeMo.field isEqualToString:@"businessScope"]) {
        vc.isMultiple = YES;
        for (DicMo *tmpMo in self.changeMo.m_objs) {
            [arrValue addObject:STRING(tmpMo.key)];
        }
    } else {
        DicMo *dic = (DicMo *)self.changeMo.m_obj;
        if (dic) [arrValue addObject:STRING(dic.key)];
    }
    if (arrValue.count > 0) vc.defaultValues = [[NSMutableArray alloc] initWithArray:arrValue copyItems:YES];
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
    self.changeMo.rightValue = str;
    self.changeMo.m_objs = arrSelect;
    [self.tableView reloadData];
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    CusInfoMo *model = self.arrData[indexPath.section];
    CusInfoDetailMo *mo = model.data[indexPath.row];
    mo.rightValue = [Utils saveToValues:content];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    DicMo *tmpDic = self.selectArr[index];
    CusInfoMo *model = self.arrData[indexPath.section];
    CusInfoDetailMo *mo = model.data[indexPath.row];
    mo.rightValue = [Utils saveToValues:STRING(tmpDic.value)];
    mo.m_obj = tmpDic;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath {
    NSString *value = [[NSString alloc] init];
    NSMutableArray *objs = [NSMutableArray new];
    for (int i = 0; i < selectIndexPaths.count; i++) {
        NSIndexPath *tmpIndex = selectIndexPaths[i];
        DicMo *tmpDic = self.selectArr[tmpIndex.row];
        value = [value stringByAppendingString:tmpDic.value];
        if (i != selectIndexPaths.count - 1) {
            value = [value stringByAppendingString:@","];
        }
        [objs addObject:tmpDic];
    }
    CusInfoMo *model = self.arrData[indexPath.section];
    CusInfoDetailMo *mo = model.data[indexPath.row];
    mo.m_objs = objs;
    mo.rightValue = [Utils saveToValues:value];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - CountrySelectViewCtrlDelegate

- (void)countrySelectViewCtrl:(CountrySelectViewCtrl *)countrySelectViewCtrl didSelect:(CountryMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        self.changeMo.m_obj = model;
        self.changeMo.rightValue = model.landx;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)countrySelectViewCtrlDismiss:(CountrySelectViewCtrl *)countrySelectViewCtrl {
    countrySelectViewCtrl = nil;
}

#pragma mark - JYUserMoSelectViewCtrlDelegate

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(JYUserMo *)selectMo {
    if (selectMo) {
        self.changeMo.m_obj = selectMo;
        self.changeMo.rightValue = selectMo.name;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)jyUserMoSelectViewCtrlDismiss:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl {
    jyUserMoSelectViewCtrl = nil;
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    self.changeMo.m_obj = model;
    self.changeMo.rightValue = model.orgName;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)memberSelectViewCtrlDismiss:(MemberSelectViewCtrl *)memberSelectViewCtrl {
    memberSelectViewCtrl = nil;
}


#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    CusInfoMo *infoMo = self.arrData[0];
    for (int i = 0; i < infoMo.data.count; i++) {
        CusInfoDetailMo *detailMo = infoMo.data[i];
        if ([detailMo.rightValue isEqualToString:@"demo"] || detailMo.rightValue.length == 0) {
            [Utils showToastMessage:@"请完善账户信息"];
            return;
        }
    }
    
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] createCustomerByOperatorIdId:TheUser.userMo.id data:self.arrData success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"创建成功"];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.backgroundColor = COLOR_B0;
    }
    return _tableView;
}

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
