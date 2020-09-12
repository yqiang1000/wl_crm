//
//  CreateProductionDynamicsViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateProductionDynamicsViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "AttachmentCell.h"
#import "MyCommonCell.h"
#import "WSDatePickerView.h"
#import "FactoryMo.h"
#import "QiNiuUploadHelper.h"
#import "EquipmentMo.h"

@interface CreateProductionDynamicsViewCtrl ()
<UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) NSMutableArray *arrTypeValue;
@property (nonatomic, strong) NSMutableArray *attachments;

@property (nonatomic, strong) NSMutableArray *attachUrls;

//@property (nonatomic, strong) NSMutableArray *arrRows;

@end

@implementation CreateProductionDynamicsViewCtrl

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
    if (_mo) {
        for (QiniuFileMo *tmpMo in _mo.attachments) {
            [self.attachments addObject:STRING(tmpMo.thumbnail)];
            [self.attachUrls addObject:STRING(tmpMo.url)];
        }
        
        [self.arrTypeValue replaceObjectAtIndex:0 withObject:STRING([_mo.factory[@"id"] stringValue])];
        [self.arrTypeValue replaceObjectAtIndex:2 withObject:STRING([_mo.equipment[@"id"] stringValue])];
        [self.arrTypeValue replaceObjectAtIndex:3 withObject:STRING([_mo.type[@"id"] stringValue])];
        
        [self.arrValues replaceObjectAtIndex:0 withObject:STRING(_mo.factory[@"name"])];
        [self.arrValues replaceObjectAtIndex:1 withObject:STRING(_mo.recordDate)];
        [self.arrValues replaceObjectAtIndex:2 withObject:STRING(_mo.equipment[@"name"])];
        [self.arrValues replaceObjectAtIndex:3 withObject:STRING(_mo.type[@"value"])];
        [self.arrValues replaceObjectAtIndex:4 withObject:STRING(_mo.size)];
        
        [self.arrValues replaceObjectAtIndex:5 withObject:STRING(_mo.name)];
        if (_mo.equipment) {
            [self.arrValues replaceObjectAtIndex:6 withObject:[Utils saveToValues:[NSString stringWithFormat:@"%@",_mo.equipment[@"quantity"]]]];
            if (_mo.equipment[@"type"]) {
                [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:_mo.equipment[@"type"][@"value"]]];
                [self.arrTypeValue replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@",_mo.equipment[@"type"][@"id"]]];
            }
        }
        [self.arrValues replaceObjectAtIndex:7 withObject:STRING(_mo.bootedQuantity)];
        [self.arrValues replaceObjectAtIndex:9 withObject:STRING(_mo.spandexNumber)];
        
        [self.arrValues replaceObjectAtIndex:10 withObject:STRING(_mo.productionDate)];
        [self.arrValues replaceObjectAtIndex:11 withObject:STRING(_mo.spandexBackoffSpeed)];
        [self.arrValues replaceObjectAtIndex:12 withObject:STRING(_mo.spandexBackoffTension)];
        [self.arrValues replaceObjectAtIndex:13 withObject:STRING(_mo.drawRation)];
        [self.arrValues replaceObjectAtIndex:14 withObject:STRING(_mo.productUsingCondition)];
        
        [self.arrValues replaceObjectAtIndex:15 withObject:STRING(_mo.usedQuantityExpected)];
        [self.arrValues replaceObjectAtIndex:16 withObject:STRING(_mo.airPressure)];
        [self.arrValues replaceObjectAtIndex:17 withObject:STRING(_mo.stockQuantity)];
        [self.arrValues replaceObjectAtIndex:18 withObject:STRING(_mo.stockDays)];
        [self.arrValues replaceObjectAtIndex:19 withObject:STRING(_mo.remark)];
        
        [self refreshOpenAndALl];
    } else {
        NSString *recordDate = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
        [self.arrValues replaceObjectAtIndex:1 withObject:recordDate];
        
        [[JYUserApi sharedInstance] getDefaultFactorySuccess:^(id responseObject) {
            NSError *error;
            self.selectArr = [FactoryMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            if (self.selectArr.count > 0) {
                FactoryMo *tmpMo = self.selectArr[0];
                [self.arrTypeValue replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",(long)tmpMo.id]];
                [self.arrValues replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",tmpMo.name]];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        } failure:^(NSError *error) {
        }];
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
            cell.attachments = _mo.attachments;
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
    if (indexPath.row == 8) {
        NSString *str = self.arrValues[indexPath.row];
        cell.labRight.text = [NSString stringWithFormat:@"%.0f%%", [str floatValue]*100];
        cell.labRight.textColor = COLOR_B1;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getDefaultFactorySuccess:^(id responseObject) {
            NSError *error;
            self.selectArr = [FactoryMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            [_selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (FactoryMo *tmpMo in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = [NSString stringWithFormat:@"%ld", (long)tmpMo.id];
                mo.moText = tmpMo.name;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
        }];
    }
    // 记录时间 || 设备数 || 开机率 || 附件
    else if (indexPath.row == 1 ||
             indexPath.row == 6 ||
             indexPath.row == 8 ||
             indexPath.row == self.arrLeft.count - 1
             ) {
    }
    // 设备类型
    else if (indexPath.row == 3) {
//        [Utils showHUDWithStatus:nil];
//        [[JYUserApi sharedInstance] getConfigDicByName:@"equipment_type" success:^(id responseObject) {
//            [Utils dismissHUD];
//            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
//            [_selectShowArr removeAllObjects];
//            _selectShowArr = nil;
//            for (DicMo *tmpMo in self.selectArr) {
//                ListSelectMo *mo = [[ListSelectMo alloc] init];
//                mo.moId = tmpMo.id;
//                mo.moText = tmpMo.value;
//                [self.selectShowArr addObject:mo];
//            }
//            [self pushToSelectVC:indexPath];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//        }];
    }
    // 设备名称
    else if (indexPath.row == 2) {
        [Utils showHUDWithStatus:nil];
        NSArray *rules = @[@{@"field": @"member.id",
                             @"values": @[@(TheCustomer.customerMo.id)],
                             @"option": @"EQ"}];
        [[JYUserApi sharedInstance] getEquipmentPage:0 size:5000 rules:rules success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            self.selectArr = [EquipmentMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            [_selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (EquipmentMo *tmpMo in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = [NSString stringWithFormat:@"%ld", tmpMo.id];
                mo.moText = tmpMo.name;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
        }];
    }
    else if (indexPath.row == 10) {
        // 时间
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
    else {
        // 手动输入
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 100;
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        if (indexPath.row == 7) {
            vc.keyType = UIKeyboardTypeNumberPad;
            vc.numberOnly = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = self.arrLeft[indexPath.row];
    NSString *str = self.arrTypeValue[indexPath.row];
    if (![str isEqualToString:@"demo"]) {
        vc.defaultValues = [[NSMutableArray alloc] initWithObjects:str, nil];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:selectMo.moText])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (indexPath.row == 0) {
        FactoryMo *tmpMo = self.selectArr[index];
        [self.arrTypeValue replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
        
    } else if (indexPath.row == 2) {
        EquipmentMo *tmpMo = self.selectArr[index];
        
        [self.arrTypeValue replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%ld",(long)tmpMo.id]];
        // 设备类型
        if (tmpMo.type) {
            [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:tmpMo.type[@"value"]]];
            [self.arrTypeValue replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@",tmpMo.type[@"id"]]];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        // 设备数量
        [self.arrValues replaceObjectAtIndex:6 withObject:STRING(tmpMo.quantity)];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

        [self refreshOpenAndALl];
    }
}

- (void)refreshOpenAndALl {
    CGFloat x = 0;
    if (![_arrValues[6] isEqualToString:@"demo"]) {
        NSInteger open = [_arrValues[7] integerValue];
        NSInteger all = [_arrValues[6] integerValue];
        x = open * 1.0 / all;
    }
    [self.arrValues replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%.2f", x]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (indexPath.row == 7) {
        [self refreshOpenAndALl];
    }
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    for (int i = 9; i < 14; i++) {
        if (i == 9 || i == 10 || i == 13) {
            if ([self.arrValues[i] isEqualToString:@"demo"]) {
                [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@", self.arrLeft[i]]];
                return;
            }
        }
    }
    AttachmentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrValues.count-1 inSection:0]];
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self createProductionPerformance:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self createProductionPerformance:@[]];
    }
}

- (void)createProductionPerformance:(NSArray *)attachments {
    [Utils showHUDWithStatus:nil];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    // 客户
    [params setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    // 工厂
    if ([Utils uploadToValues:self.arrValues[0]])
        [params setObject:@{@"id":STRING(self.arrTypeValue[0])} forKey:@"factory"];
    // 记录时间
    if ([Utils uploadToValues:self.arrValues[1]])
        [params setObject:STRING(self.arrValues[1]) forKey:@"recordDate"];
    // 设备名称
    if ([Utils uploadToValues:self.arrValues[2]])
        [params setObject:@{@"id":STRING(self.arrTypeValue[2])} forKey:@"equipment"];
    // 设备类型
    if ([Utils uploadToValues:self.arrValues[3]]) {
        [params setObject:@{@"id":STRING(self.arrTypeValue[3])} forKey:@"type"];
        [params setObject:STRING(self.arrValues[3]) forKey:@"typeValue"];
    }
    // 设备尺寸
    if ([Utils uploadToValues:self.arrValues[4]])
        [params setObject:STRING(self.arrValues[4]) forKey:@"size"];
    
    // 产品名称
    if ([Utils uploadToValues:self.arrValues[5]])
    [params setObject:STRING(self.arrValues[5]) forKey:@"name"];
    // 设备数
    // 开机数
    if ([Utils uploadToValues:self.arrValues[7]])
    [params setObject:STRING(self.arrValues[7]) forKey:@"bootedQuantity"];
    // 开机率
    NSString *str = self.arrValues[8];
    [params setObject:[NSString stringWithFormat:@"%.0f", [str floatValue]*100] forKey:@"bootedRatio"];
    // 先用氨纶批号
    if ([Utils uploadToValues:self.arrValues[9]])
    [params setObject:STRING(self.arrValues[9]) forKey:@"spandexNumber"];
    
    // 氨纶生产日期
    if ([Utils uploadToValues:self.arrValues[10]])
    [params setObject:STRING(self.arrValues[10]) forKey:@"productionDate"];
    // 绕线速度
    if ([Utils uploadToValues:self.arrValues[11]])
    [params setObject:STRING(self.arrValues[11]) forKey:@"spandexBackoffSpeed"];
    // 张力
    if ([Utils uploadToValues:self.arrValues[12]])
    [params setObject:STRING(self.arrValues[12]) forKey:@"spandexBackoffTension"];
    // 牵伸比
    if ([Utils uploadToValues:self.arrValues[13]])
    [params setObject:STRING(self.arrValues[13]) forKey:@"drawRation"];
    // 产品使用情况
    if ([Utils uploadToValues:self.arrValues[14]])
    [params setObject:STRING(self.arrValues[14]) forKey:@"productUsingCondition"];
    
    // 用量预估
    if ([Utils uploadToValues:self.arrValues[15]])
    [params setObject:STRING(self.arrValues[15]) forKey:@"usedQuantityExpected"];
    // 气压
    if ([Utils uploadToValues:self.arrValues[16]])
    [params setObject:STRING(self.arrValues[16]) forKey:@"airPressure"];
    // 客户氨纶库存
    if ([Utils uploadToValues:self.arrValues[17]])
    [params setObject:STRING(self.arrValues[17]) forKey:@"stockQuantity"];
    // 客户成品库存
    if ([Utils uploadToValues:self.arrValues[18]])
    [params setObject:STRING(self.arrValues[18]) forKey:@"stockDays"];
    // 备注
    if ([Utils uploadToValues:self.arrValues[19]])
    [params setObject:STRING(self.arrValues[19]) forKey:@"remark"];
    
    if (_mo && !_enableSave) {
        [[JYUserApi sharedInstance] updatePerformanceId:_mo.id param:params attachments:[Utils filterUrls:attachments arrFile:_mo.attachments] success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
            NSError *error = nil;
            PerformanceMo *tmpMo = [[PerformanceMo alloc] initWithDictionary:responseObject error:&error];
            if (self.updateSuccess) {
                self.updateSuccess(tmpMo);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createPerformanceParam:params attachments:attachments success:^(id responseObject) {
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
        _arrLeft = @[@"工厂",
                     @"记录时间",
                     @"设备名称",
                     @"设备类型",
                     @"设备规格或尺寸",
                     
                     @"产品名称",
                     @"设备数(台)",
                     @"开机数(台)",
                     @"开机率",
                     @"现用氨纶批号",
                     
                     @"氨纶生产日期",
                     @"氨纶退绕速度",
                     @"氨纶退绕张力",
                     @"牵伸比",
                     @"产品使用情况",
                     
                     @"氨纶使用量预估(吨/月)",
                     @"气压(空包类)",
                     @"客户处氨纶丝库存情况",
                     @"客户成品库存",
                     @"备注",
                     
                     @"附件"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择",
                      @"自动带出",
                      @"请选择",
                      @"自动带出",
                      @"请输入",
                      
                      @"请输入",
                      @"自动带出",
                      @"请输入",
                      @"自动计算",
                      @"请输入(必填)",
                      
                      @"请输入(必填)",
                      @"请输入",
                      @"请输入",
                      @"请输入(必填)",
                      @"请输入",
                      
                      @"请输入",
                      @"请输入",
                      @"请输入",
                      @"请输入",
                      @"请输入",
                      
                      @"附件"];
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

- (NSMutableArray *)arrTypeValue {
    if (!_arrTypeValue) {
        _arrTypeValue = [NSMutableArray new];
        for (int i = 0; i < 5; i++) {
            [_arrTypeValue addObject:@"demo"];
        }
    }
    return _arrTypeValue;
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
