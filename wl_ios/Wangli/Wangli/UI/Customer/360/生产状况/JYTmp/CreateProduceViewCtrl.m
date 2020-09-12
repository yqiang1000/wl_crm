//
//  CreateProduceViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateProduceViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "AttachmentCell.h"
#import "DicMo.h"
#import "QiNiuUploadHelper.h"
#import "FactoryMo.h"

@interface CreateProduceViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;           // 显示的列表
@property (nonatomic, strong) NSMutableArray *selectArr;        // 点击选择的原始数据
@property (nonatomic, strong) NSMutableArray *selectShowArr;    // 点击选择的现实数据
@property (nonatomic, strong) NSArray *arrLeft;                 // 左侧标题
@property (nonatomic, strong) NSArray *arrRight;                // 右侧标题
@property (nonatomic, strong) NSMutableArray *arrValues;        // 所有的值，默认使用demo字段
@property (nonatomic, strong) NSArray *arrTypeName;             // 选择字典项
@property (nonatomic, strong) NSMutableArray *arrTypeValue;     // 选择id
@property (nonatomic, strong) NSMutableArray *attachments;      // 附件缩略数组
@property (nonatomic, strong) NSMutableArray *attachUrls;       // 附件原图数组

@end

@implementation CreateProduceViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self setUI];
    [self config];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)config {
    if (!_mo) {
        // _mo 为空，新建操作
        // 1. 获取默认工厂信息
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
        return;
    }
    // _mo 不为空，修改操作
    // 获取工厂 id 存入 arrTypeValue
    [self.arrTypeValue replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",_mo.factory[@"id"]]];
    // 需要显示的值
    [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:_mo.factory[@"name"]]];
    [self.arrValues replaceObjectAtIndex:1 withObject:[Utils saveToValues:_mo.categoryValue]];
    [self.arrValues replaceObjectAtIndex:2 withObject:[Utils saveToValues:STRING(_mo.ingredientValue)]];
    [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:STRING(_mo.weightValue)]];
    [self.arrValues replaceObjectAtIndex:4 withObject:[Utils saveToValues:STRING(_mo.finishedDoor)]];
    [self.arrValues replaceObjectAtIndex:5 withObject:[Utils saveToValues:STRING(_mo.dyeingTechnologyValue)]];
    [self.arrValues replaceObjectAtIndex:6 withObject:[Utils saveToValues:STRING(_mo.qualityStandardValue)]];
    [self.arrValues replaceObjectAtIndex:7 withObject:[Utils saveToValues:STRING(_mo.applicableSessionValue)]];
    [self.arrValues replaceObjectAtIndex:8 withObject:[Utils saveToValues:STRING(_mo.marketReferencePrice)]];
    
    for (QiniuFileMo *tmpMo in _mo.attachments) {
        [self.attachments addObject:STRING(tmpMo.thumbnail)];
        [self.attachUrls addObject:STRING(tmpMo.url)];
    }
    [self.tableView reloadData];
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
        }
        cell.attachments = _mo.attachments;
        [cell refreshView];
        return cell;
    }
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 获取工厂里列表
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getDefaultFactorySuccess:^(id responseObject) {
            NSError *error;
            // 原始工厂列表信息
            self.selectArr = [FactoryMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            [_selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (FactoryMo *tmpMo in self.selectArr) {
                // 处理过后只需携带工厂的ID和Name
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = [NSString stringWithFormat:@"%ld", (long)tmpMo.id];
                mo.moText = tmpMo.name;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
        }];
    }
    else if (indexPath.row == self.arrLeft.count-1) {
        return;
    }
    // 类型
//    else if (indexPath.row == 1) {
//        NSString *name = self.arrTypeName[indexPath.row];
//        [Utils showHUDWithStatus:nil];
//        [[JYUserApi sharedInstance] getConfigDicByName:name success:^(id responseObject) {
//            [Utils dismissHUD];
//            // 原始字典项列表信息
//            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
//            [_selectShowArr removeAllObjects];
//            _selectShowArr = nil;
//            for (DicMo *tmpMo in self.selectArr) {
//                // 处理过后只需携带字典项的ID和Name
//                ListSelectMo *mo = [[ListSelectMo alloc] init];
//                mo.moId = tmpMo.id;
//                mo.moText = tmpMo.value;
//                [self.selectShowArr addObject:mo];
//            }
//            [self pushToSelectVC:indexPath];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//        }];
//    }
    else {
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 100;    // 输入字符长度
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];//占位文字
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil :    self.arrValues[indexPath.row];  // 默认文字
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        if (indexPath.row == 8) {       // 是否是数字键盘限制
            vc.keyType = UIKeyboardTypeDecimalPad;
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
    // 标题
    vc.title = self.arrLeft[indexPath.row];
    // 上一次选中的ID
    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:_arrValues[indexPath.row], nil];
    // 是否根据Id，或者文字来标记上一次打勾情况
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    // 1. 更新显示数据
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:selectMo.moText])];
    // 2. 更新UI
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    // 2. 更新字典项 && 特殊情况分析
    if (indexPath.row == 0) {
        FactoryMo *tmpMo = self.selectArr[index];
        [self.arrTypeValue replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
    } else {
        DicMo *dicMo = self.selectArr[index];
        [self.arrTypeValue replaceObjectAtIndex:indexPath.row withObject:STRING(dicMo.id)];
    }
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 8) content = [NSString stringWithFormat:@"%.2f",[content floatValue]];
    // 1. 更新显示数据
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
    // 2. 更新UI
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    // 对必填项进行判断提示
    for (int i = 0 ; i < 3; i++) {
        NSString *obj = self.arrValues[i];
        if ([obj isEqualToString:@"demo"]) {
            [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@", self.arrLeft[i]]];
            return;
        }
    }
    // 附件图片处理，已上传过的和新添加的图片处理
    AttachmentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrValues.count-1 inSection:0]];
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self createAction:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self createAction:@[]];
    }
}

- (void)createAction:(NSArray *)attachementList {
    [Utils showHUDWithStatus:nil];
    NSMutableDictionary *params = [NSMutableDictionary new];
    // 客户
    [params setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    // 工厂
    [params setObject:@{@"id":STRING(self.arrTypeValue[0]),
                        @"name":STRING(self.arrValues[0])} forKey:@"factory"];
    // 类型
    [params setObject:STRING(self.arrValues[1]) forKey:@"categoryValue"];
    // 成分
    if ([Utils uploadToValues:self.arrValues[2]])
        [params setObject:STRING(self.arrValues[2]) forKey:@"ingredientValue"];
    // 克重
    if ([Utils uploadToValues:self.arrValues[3]])
        [params setObject:STRING(self.arrValues[3]) forKey:@"weightValue"];
    // 门幅
    if ([Utils uploadToValues:self.arrValues[4]])
        [params setObject:STRING(self.arrValues[4]) forKey:@"finishedDoor"];
    // 染整工艺
    if ([Utils uploadToValues:self.arrValues[5]])
        [params setObject:STRING(self.arrValues[5]) forKey:@"dyeingTechnologyValue"];
    // 品质标准
    if ([Utils uploadToValues:self.arrValues[6]])
        [params setObject:STRING(self.arrValues[6]) forKey:@"qualityStandardValue"];
    // 季节
    if ([Utils uploadToValues:self.arrValues[7]])
        [params setObject:STRING(self.arrValues[7]) forKey:@"applicableSessionValue"];
    // 价格
    if ([Utils uploadToValues:self.arrValues[8]])
        [params setObject:STRING(self.arrValues[8]) forKey:@"marketReferencePrice"];
    
    if (_mo) {
        [[JYUserApi sharedInstance] updateProductId:_mo.id memberId:TheCustomer.customerMo.id param:params attachments:[Utils filterUrls:attachementList arrFile:_mo.attachments] success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
            ProductInfoMo *tmpMo = [[ProductInfoMo alloc] initWithDictionary:responseObject error:nil];
            if (self.updateSuccess) {
                self.updateSuccess(tmpMo);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [Utils showHUDWithStatus:nil];
        [JYUserApi sharedInstance];
        [[JYUserApi sharedInstance] createProductMemberId:TheCustomer.customerMo.id  param:params attachments:attachementList success:^(id responseObject) {
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
                     @"产品类型",
                     @"成分含量",
                     @"成品克重(g)",
                     @"成品门幅",
                     
                     @"染整工艺",
                     @"品质标准",
                     @"适用季节",
                     @"市场参考价(元)",
                     @"附件"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择(必填)",
                      @"请输入(必填)",
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
        for (int i = 0; i < self.arrTypeName.count; i++) {
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
