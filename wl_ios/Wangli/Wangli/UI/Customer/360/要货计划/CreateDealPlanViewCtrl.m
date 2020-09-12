//
//  CreateDealPlanViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "CreateDealPlanViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "WSDatePickerView.h"
#import "EditTextViewCtrl.h"
#import "MaterialMo.h"
#import "MaterialListViewCtrl.h"
#import "MemberSelectViewCtrl.h"

@interface CreateDealPlanViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate, MemberSelectViewCtrlDelegate, MaterialListViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) MaterialMo *materialMo;

@end

@implementation CreateDealPlanViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_mo) {
        self.title = @"要货计划详情";
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        // 已审批不可修改
        if ([_mo.status isEqualToString:@"APPROVALED"]) {
            self.rightBtn.hidden = YES;
        } else {
            self.rightBtn.hidden = NO;
        }
        [self getPlanDetail];
    } else {
        self.title = @"新建要货计划";
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    [self config];
    [self setUI];
}

- (void)getPlanDetail {
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getDemandPlanDetailByPlanId:_mo.id param:nil success:^(id responseObject) {
        [Utils dismissHUD];
        NSError *error = nil;
        _mo = [[DealPlanMo alloc] initWithDictionary:responseObject error:&error];
        [self config];
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        // 已审批不可修改
        if ([_mo.status isEqualToString:@"APPROVALED"]) {
            self.rightBtn.hidden = YES;
        } else {
            self.rightBtn.hidden = NO;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)config {
    
    if (!_fromChat) {
        [self.arrValues replaceObjectAtIndex:0 withObject:STRING(TheCustomer.customerMo.orgName)];
    }
    if (_mo) {
        self.materialMo.factoryName = _mo.factory;
        self.materialMo.factoryCode = _mo.factoryNumber;
        self.materialMo.weight = _mo.weight;
        self.materialMo.batchNumber = _mo.batchNumber;
        self.materialMo.productLevelName = _mo.productLevelName;
        self.materialMo.productLevel = _mo.productLevel;
        self.materialMo.spec = _mo.spec;
        if (_mo.member) {
            [self.arrValues replaceObjectAtIndex:0 withObject:_mo.member[@"orgName"]];
        }
        [self.arrValues replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@-%@", _mo.year, _mo.month]];
        [_arrValues replaceObjectAtIndex:7 withObject:[Utils getPriceFrom:_mo.showQuantity]];//数量
        [self reloadData];
    } else {
        NSString *date = [[Utils getNextMonthDate] stringWithFormat:@"yyyy-MM"];
        [self.arrValues replaceObjectAtIndex:1 withObject:STRING(date)];
    }
}

- (void)reloadData {
    // 修改
    [self.arrValues replaceObjectAtIndex:2 withObject:[Utils saveToValues:_materialMo.batchNumber]];//批号
    [_arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:_materialMo.spec]];//规格
    [_arrValues replaceObjectAtIndex:4 withObject:[Utils saveToValues:_materialMo.weight]];//件重
    [_arrValues replaceObjectAtIndex:5 withObject:[Utils saveToValues:_materialMo.productLevelName]];// 等级
    [_arrValues replaceObjectAtIndex:6 withObject:[Utils saveToValues:_materialMo.factoryName]];//工厂
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - network

//- (void)getDefaultLevel {
//    [[JYUserApi sharedInstance] getConfigDicByName:@"product_grade" success:^(id responseObject) {
//        self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
//        if (self.selectArr.count > 1) {
//            self.dicMo = self.selectArr[0];
//            [self.arrValues replaceObjectAtIndex:4 withObject:STRING(self.dicMo.remark)];
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//        }
//    } failure:^(NSError *error) {
//    }];
//}

//- (void)getWeightSuccess:(void (^)(id responseObject))success
//                 failure:(void (^)(NSError *error))fail{
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    NSMutableArray *rules = [NSMutableArray new];
//    [param setObject:@"0" forKey:@"number"];
//    [rules addObject:@{@"field":@"enable",
//                       @"values":@[@1],
//                       @"option":@"EQ"}];
//    [rules addObject:@{@"field":@"batchNumber",
//                       @"values":@[STRING(self.materialMo.batchNumber)],
//                       @"option":@"EQ"}];
//    [[JYUserApi sharedInstance] getBatchNumberWeightPageParam:param rules:rules success:^(id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        if (fail) {
//            fail(error);
//        }
//    }];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"dealPlanCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setLeftText:self.arrLeft[indexPath.row]];
    ShowTextMo *showTextMo = [Utils showTextRightStr:self.arrRight[indexPath.row] valueStr: self.arrValues[indexPath.row]];
    cell.labRight.textColor = showTextMo.color;
    cell.labRight.text = showTextMo.text;
    cell.labLeft.textColor = COLOR_B1;
    if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6) {
        cell.imgArrow.hidden = YES;
    } else {
        cell.imgArrow.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 客户
    if (indexPath.row == 0) {
        if (_fromChat) {
            MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
            vc.needRules = YES;
            vc.knkli = YES;
            vc.VcDelegate = self;
            vc.indexPath = indexPath;
            vc.defaultId = TheCustomer.customerMo.id;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
        }
    }
    // 时间
    else if (indexPath.row == 1) {
        if (_mo) {
            [Utils showToastMessage:@"不能修改要货时间"];
            return;
        }
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM"];
        NSDate *scrollToDate = [minDateFormater dateFromString:self.arrValues[indexPath.row]];
        __weak typeof(self) weakself = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM"];
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
    // 批号
    else if (indexPath.row == 2) {
        if (_mo) {
            [Utils showToastMessage:@"不能修改物料信息"];
            return;
        }
        
        if ([_mo.status isEqualToString:@"APPROVALED"]) {
            [Utils showToastMessage:@"不能修改已审批的物料信息"];
            return;
        }
        if ([self.arrValues[0] isEqualToString:@"demo"]) {
            [Utils showToastMessage:@"请先选择客户"];
            return;
        }
        MaterialListViewCtrl *vc = [[MaterialListViewCtrl alloc] init];
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        
        NSString *string = [[NSString alloc] init];
        if (_materialMo.batchNumber.length != 0) {
            string = [string stringByAppendingString:_materialMo.batchNumber];
        }
        if (_materialMo.weight.length != 0) {
            string = [string stringByAppendingString:@" - "];
            string = [string stringByAppendingString:_materialMo.weight];
        }
        if (_materialMo.productLevelName.length != 0) {
            string = [string stringByAppendingString:@" - "];
            string = [string stringByAppendingString:_materialMo.productLevelName];
        }
        vc.defaultNum = string;
        vc.indexPath = indexPath;
        vc.VcDelegate = self;
        vc.title = self.arrLeft[indexPath.row];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
    }
    // 件重
//    else if (indexPath.row == 3) {
//        if ([_mo.status isEqualToString:@"APPROVALED"]) {
//            [Utils showToastMessage:@"不能修改已审批的要货计划"];
//            return;
//        }
//
//        if ([self.arrValues[2] isEqualToString:@"demo"]) {
//            [Utils showToastMessage:@"请先选择批号"];
//            return;
//        }
//        [Utils showHUDWithStatus:nil];
//        [self getWeightSuccess:^(id responseObject) {
//            [Utils dismissHUD];
//            [self.selectShowArr removeAllObjects];
//            NSError *error = nil;
//            self.arrWeight = [WeightMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
//
//            if (self.arrWeight.count == 0) {
//                [Utils showToastMessage:@"该商品不需要选择克重信息"];
//            } else {
//                self.selectArr = [self.arrWeight mutableCopy];
//                for (WeightMo *tmpMo in self.selectArr) {
//                    ListSelectMo *mo = [[ListSelectMo alloc] init];
//                    mo.moId = [NSString stringWithFormat:@"%ld", (long)tmpMo.id];
//                    mo.moText = tmpMo.weight;
//                    [self.selectShowArr addObject:mo];
//                }
//                [self pushToSelectVC:indexPath];
//            }
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//        }];
//    }
//    // 等级
//    else if (indexPath.row == 4) {
//        if ([_mo.status isEqualToString:@"APPROVALED"]) {
//            [Utils showToastMessage:@"不能修改已审批的要货计划"];
//            return;
//        }
//
//        [Utils showHUDWithStatus:nil];
//        [[JYUserApi sharedInstance] getConfigDicByName:@"product_grade" success:^(id responseObject) {
//            [Utils dismissHUD];
//            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
//            [_selectShowArr removeAllObjects];
//            _selectShowArr = nil;
//            for (DicMo *tmpMo in self.selectArr) {
//                ListSelectMo *mo = [[ListSelectMo alloc] init];
//                mo.moId = tmpMo.id;
//                mo.moText = tmpMo.remark;
//                [self.selectShowArr addObject:mo];
//            }
//            [self pushToSelectVC:indexPath];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//        }];
//    }
    // 数量
    else if (indexPath.row == 7) {
        if ([_mo.status isEqualToString:@"APPROVALED"]) {
            [Utils showToastMessage:@"不能修改已审批的要货计划"];
            return;
        }
        
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 20;
        vc.txtView.keyboardType = UIKeyboardTypeDecimalPad;
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (void)pushToSelectVC:(NSIndexPath *)indexPath {
//    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
//    vc.indexPath = indexPath;
//    vc.listVCdelegate = self;
//    vc.arrData = self.selectShowArr;
//    vc.title = self.arrLeft[indexPath.row];
//    if (indexPath.row == 4) {
//        vc.defaultValues = [[NSMutableArray alloc] initWithObjects:STRING(self.dicMo.remark), nil];
//        vc.byText = YES;
//    } else if (indexPath.row == 3) {
//        vc.defaultValues = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%ld", self.weightMo.id], nil];
//    }
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - ListSelectViewCtrlDelegate

//- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
//    if (indexPath.row == 3) {
//        self.weightMo = self.selectArr[index];
//        [self.arrValues replaceObjectAtIndex:3 withObject:STRING(self.weightMo.weight)];
//        [self.tableView reloadData];
//    } else if (indexPath.row == 4) {
//        self.dicMo = self.selectArr[index];
//        [self.arrValues replaceObjectAtIndex:4 withObject:STRING(self.dicMo.remark)];
//        [self.tableView reloadData];
//    }
//}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        TheCustomer.customerMo = model;
//        self.materialMo.factoryName = _mo.factory;
//        self.materialMo.factoryCode = _mo.factoryNumber;
//        self.materialMo.weight = _mo.weight;
//        self.materialMo.batchNumber = _mo.batchNumber;
        
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:model.orgName])];
        self.materialMo = nil;
//        [self.arrValues replaceObjectAtIndex:2 withObject:@"demo"];
//        [self.arrValues replaceObjectAtIndex:3 withObject:@"demo"];
        [self reloadData];
        [self.tableView reloadData];
    }
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 2) {
//        self.createRiskMo.title = content;
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
}

#pragma mark - MaterialListViewCtrlDelegate

- (void)materialListViewCtrl:(MaterialListViewCtrl *)listSelectViewCtrl selectMaterialMo:(MaterialMo *)materialMo indexPath:(NSIndexPath *)indexPath {
    _materialMo = materialMo;
    [self reloadData];
    [self.tableView reloadData];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    
    if ([self.arrValues[0] isEqualToString:@"demo"] || [self.arrValues[1] isEqualToString:@"demo"] || [self.arrValues[2] isEqualToString:@"demo"] || [self.arrValues[7] isEqualToString:@"demo"]) {
        [Utils showToastMessage:@"请完善信息"];
        return;
    }

    //    self.materialMo.factoryName = _mo.factory;
    //    self.materialMo.factoryCode = _mo.factoryNumber;
    //    self.materialMo.weight = _mo.weight;
    //    self.materialMo.batchNumber = _mo.batchNumber;
    //    @property (nonatomic, copy) NSString <Optional> *productLevel;
    //    @property (nonatomic, copy) NSString <Optional> *productLevelName;
    
    [Utils showHUDWithStatus:nil];
    NSArray *arr = [Utils dateStr:self.arrValues[1]];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:STRING(arr[0]) forKey:@"year"];
    [param setObject:STRING(arr[1]) forKey:@"month"];
    [param setObject:STRING(self.arrValues[7]) forKey:@"quantity"];
    [param setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    [param setObject:STRING(self.materialMo.batchNumber) forKey:@"batchNumber"];
    [param setObject:STRING(self.materialMo.factoryName) forKey:@"factory"];
    [param setObject:STRING(self.materialMo.factoryCode) forKey:@"factoryNumber"];
    [param setObject:STRING(self.materialMo.weight) forKey:@"weight"];
    [param setObject:STRING(self.materialMo.productLevel) forKey:@"productLevel"];
    [param setObject:STRING(self.materialMo.productLevelName) forKey:@"productLevelName"];
    [param setObject:STRING(self.materialMo.spec) forKey:@"spec"];
    
    
    if (_mo) {
        // 修改计划
        [[JYUserApi sharedInstance] updateDemandPlanByPlanId:_mo.id param:param success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:GET_LANGUAGE_KEY(@"修改成功")];
            if (self.createSuccess) {
                self.createSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建要货计划
        [[JYUserApi sharedInstance] createDealPlanByCustomerId:TheCustomer.customerMo.id param:param success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:GET_LANGUAGE_KEY(@"创建成功")];
            if (self.createSuccess) {
                self.createSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
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
        _arrLeft = @[@"客户名称",
                     @"计划月份",
                     @"产品批号",
                     @"规格",
                     @"件重",
                     
                     @"等级",
                     @"工厂",
                     @"数量(KG)"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择",
                      @"请选择",
                      @"请选择",
                      @" ",
                      @"请选择",
                      
                      @"请选择",
                      @"请选择",
                      @"请输入"];
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

- (MaterialMo *)materialMo {
    if (!_materialMo) {
        _materialMo = [[MaterialMo alloc] init];
    }
    return _materialMo;
}

@end
