//
//  CreateFactoryEquipmentViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateFactoryEquipmentViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "AttachmentCell.h"
#import "MyCommonCell.h"
#import "QiNiuUploadHelper.h"
#import "FactoryMo.h"
#import "WSDatePickerView.h"

@interface CreateFactoryEquipmentViewCtrl ()
<UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;

@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;

@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) NSArray *arrTypeName;
@property (nonatomic, strong) NSMutableArray *arrTypeValue;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSMutableArray *attachUrls;

@end

@implementation CreateFactoryEquipmentViewCtrl

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
        [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:STRING(_mo.factory[@"name"])]];
        [self.arrValues replaceObjectAtIndex:1 withObject:[Utils saveToValues:STRING(_mo.recordDate)]];
        [self.arrValues replaceObjectAtIndex:2 withObject:[Utils saveToValues:STRING(_mo.fieldValue)]];
        [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:STRING(_mo.typeValue)]];
        [self.arrValues replaceObjectAtIndex:4 withObject:[Utils saveToValues:STRING(_mo.brands)]];
        [self.arrValues replaceObjectAtIndex:5 withObject:[Utils saveToValues:STRING(_mo.name)]];
        [self.arrValues replaceObjectAtIndex:6 withObject:[Utils saveToValues:STRING(_mo.size)]];
        [self.arrValues replaceObjectAtIndex:7 withObject:[Utils saveToValues:STRING(_mo.purchaseYears)]];
        [self.arrValues replaceObjectAtIndex:8 withObject:[Utils saveToValues:STRING(_mo.quantity)]];
        [self.arrValues replaceObjectAtIndex:9 withObject:[Utils saveToValues:STRING(_mo.guideMethod)]];
        [self.arrValues replaceObjectAtIndex:10 withObject:[Utils saveToValues:STRING(_mo.remark)]];
        
        [self.arrTypeValue replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",_mo.factory[@"id"]]];
        [self.arrTypeValue replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",_mo.field[@"id"]]];
        [self.arrTypeValue replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@",_mo.type[@"id"]]];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 工厂
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
    // 领域
    else if (indexPath.row == 2) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getConfigDicByName:self.arrTypeName[indexPath.row] success:^(id responseObject) {
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
    // 设备类型
    else if (indexPath.row == 3) {
        if ([self.arrValues[2] isEqualToString:@"demo"]) {
            [Utils showToastMessage:@"请先选择领域，再选择设备类型"];
        } else {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] getEquipmentTypeWithField:self.arrValues[2] success:^(id responseObject) {
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
    }
    else if (indexPath.row == 1) {
//        NSDate *scrollToDate = [NSDate date:self.arrValues[indexPath.row] WithFormat:@"yyyy-MM-dd"] ;
//        __weak typeof(self) weakself = self;
//        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
//            __strong typeof(self) strongself = weakself;
//            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
//            NSLog(@"选择的日期：%@",date);
//            [strongself.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:date]];
//            [strongself.tableView reloadData];
//        }];
//        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
//        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
//        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
//        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
//        [datepicker show];
    }
    else if (indexPath.row == self.arrLeft.count - 1) {
        // 附件
    } else {
        // 手动输入
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 100;
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        if (indexPath.row == 7) {
            vc.keyType = UIKeyboardTypeDecimalPad;
            vc.numberOnly = YES;
        } else if (indexPath.row == 8) {
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
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        DicMo *tmpMo = self.selectArr[index];
        [self.arrTypeValue replaceObjectAtIndex:indexPath.row withObject:STRING(tmpMo.id)];
        if (indexPath.row == 2) {
            [self.arrTypeValue replaceObjectAtIndex:3 withObject:@"demo"];
            [self.arrValues replaceObjectAtIndex:3 withObject:@"demo"];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    NSString *str = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:str])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    for (int i = 0; i < self.arrValues.count-1; i++) {
        NSString *valueStr = self.arrValues[i];
        if (i == 0 || i == 1 || i == 2 || i == 3 || i == 5 || i == 8) {
            if ([valueStr isEqualToString:@"demo"]) {
                [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@",self.arrLeft[i]]];
                return;
            }
        }
    }
    
    AttachmentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrValues.count-1 inSection:0]];
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self createFactoryEquipment:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self createFactoryEquipment:@[]];
    }
}

- (void)createFactoryEquipment:(NSArray *)attachments {
    [Utils showHUDWithStatus:nil];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    // 客户
    [params setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    // 工厂
    [params setObject:@{@"id":STRING(self.arrTypeValue[0]),
                        @"name":STRING(self.arrValues[0])} forKey:@"factory"];
    // 记录时间
    [params setObject:STRING(self.arrValues[1]) forKey:@"recordDate"];
    // 领域
    [params setObject:@{@"id":STRING(self.arrTypeValue[2])} forKey:@"field"];
    [params setObject:STRING(self.arrValues[2]) forKey:@"fieldValue"];
    // 设备类型
    [params setObject:@{@"id":STRING(self.arrTypeValue[3])} forKey:@"type"];
    [params setObject:STRING(self.arrValues[3]) forKey:@"typeValue"];
    // 品牌
    if ([Utils uploadToValues:self.arrValues[4]])
        [params setObject:STRING(self.arrValues[4]) forKey:@"brands"];
    // 名称
    if ([Utils uploadToValues:self.arrValues[5]])
        [params setObject:STRING(self.arrValues[5]) forKey:@"name"];
    // 尺寸
    if ([Utils uploadToValues:self.arrValues[6]])
        [params setObject:STRING(self.arrValues[6]) forKey:@"size"];
    // 年限
    if ([Utils uploadToValues:self.arrValues[7]])
        [params setObject:STRING(self.arrValues[7]) forKey:@"purchaseYears"];
    // 数量
    if ([Utils uploadToValues:self.arrValues[8]])
        [params setObject:STRING(self.arrValues[8]) forKey:@"quantity"];
    // 导丝方式
    if ([Utils uploadToValues:self.arrValues[9]])
        [params setObject:STRING(self.arrValues[9]) forKey:@"guideMethod"];
    // 备注
    if ([Utils uploadToValues:self.arrValues[10]])
        [params setObject:STRING(self.arrValues[10]) forKey:@"remark"];
    
    if (_mo) {
        [[JYUserApi sharedInstance] updateEquipmentId:_mo.id param:params attachments:[Utils filterUrls:attachments arrFile:_mo.attachments] success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
            EquipmentMo *tmpMo = [[EquipmentMo alloc] initWithDictionary:responseObject error:nil];
            if (self.updateSuccess) {
                self.updateSuccess(tmpMo);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createEquipmentParam:params attachments:attachments success:^(id responseObject) {
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
//compositionContent; //成分含量
//gauze; //纱支
//gramWeight; // 克重
//dyeing; //染整工艺
//productType;//产品类型
//产品类型字典下拉项name product_type
- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"工厂",
                     @"记录时间",
                     @"领域",
                     @"设备类型",
                     @"设备品牌",
                     
                     @"设备名称",
                     @"尺寸",
                     @"购买年限(年)",
                     @"设备数量(台)",
                     @"导丝方式",
                     
                     @"备注",
                     @"附件"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择(必填)",
                      @"自动带出",
                      @"请选择(必填)",
                      @"请选择(必填)",
                      @"请输入",
                      
                      @"请输入(必填)",
                      @"请输入",
                      @"请输入",
                      @"请输入(必填)",
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

- (NSArray *)arrTypeName {
    if (!_arrTypeName) {
//        产品类型：name:product_type
//         成份含量：name:product_ingredient
//         纱支：product_yarn
//         克重：product_weight
//         染整工艺：product_dyeing_technology
//         品质标准：product_quality_standard
//         流行元素：product_popular_element
//         适用季节：product_applicable_session
//         印花风格: product_print_style
//         颜色:product_color
//         市场预期：product_market_expectation
//         设备类型：equipment_type
//         原料类型:raw_material_type
//         竞企类型:competing_companies_type
//         行业地位：industry_status
//         竞品品牌：competing_goods_brand
//         品牌定位：brand_position
//         招工类型:hire_type
//         生产信息类型：message_type
        
        _arrTypeName = @[@"demo",
                         @"demo",
                         @"member_field",
                         @"equipment_type",
                         @"demo",
                         
                         @"demo",
                         @"demo",
                         @"demo",
                         @"demo",
                         @"demo",
                         
                         @"demo",
                         @"demo"];
    }
    return _arrTypeName;
}

- (NSMutableArray *)arrTypeValue {
    if (!_arrTypeValue) {
        _arrTypeValue = [NSMutableArray new];
        for (int i = 0; i < self.arrLeft.count; i++) {
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
