//
//  CreateQuoteDetailViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CreateQuoteDetailViewCtrl.h"

@interface CreateQuoteDetailViewCtrl ()

@property (nonatomic, assign) CGFloat quanity;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat total;


@end

@implementation CreateQuoteDetailViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加报价明细";
}

- (void)configRowMosDefault {
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_TITLE;
    rowMo0.leftContent = @"添加报价产品";
    [self.arrData addObject:rowMo0];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_PRODUCT_TYPE;
    rowMo1.leftContent = @"产品分类";
    rowMo1.rightContent = @"必填";
    rowMo1.key = @"materialType";
    rowMo1.mutiAble = NO;
    rowMo1.editAble = YES;
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo102 = [[CommonRowMo alloc] init];
    rowMo102.rowType = K_INPUT_TEXT;
    rowMo102.inputType = K_SHORT_TEXT;
    rowMo102.leftContent = @"档位";
    rowMo102.rightContent = @"必填";
    rowMo102.key = @"gears";
    rowMo102.editAble = YES;
    [self.arrData addObject:rowMo102];
    
    //    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    //    rowMo2.rowType = K_INPUT_TEXT;
    //    rowMo2.inputType = K_SHORT_TEXT;
    //    rowMo2.leftContent = @"转化率";
    //    rowMo2.rightContent = @"请输入";
    //    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_SELECT;
    rowMo3.dictName = @"";
    rowMo3.leftContent = @"报价单位";
    rowMo3.rightContent = @"必填";
    rowMo3.dictName = @"unit";
    rowMo3.key = @"unitKey";
    rowMo3.editAble = YES;
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_INPUT_TEXT;
    rowMo5.inputType = K_SHORT_TEXT;
    rowMo5.keyBoardType = K_DOUBLE;
    rowMo5.leftContent = @"报价数量";
    rowMo5.rightContent = @"必填";
    rowMo5.key = @"quantity";
    rowMo5.editAble = YES;
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_INPUT_TEXT;
    rowMo6.inputType = K_SHORT_TEXT;
    rowMo6.keyBoardType = K_DOUBLE;
    rowMo6.leftContent = @"单价";
    rowMo6.rightContent = @"必填";
    rowMo6.key = @"price";
    rowMo6.editAble = YES;
    [self.arrData addObject:rowMo6];
    
    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_TEXT;
    rowMo7.inputType = K_SHORT_TEXT;
    rowMo7.leftContent = @"小计";
    rowMo7.rightContent = @"必填";
    rowMo7.key = @"totalPrice";
    rowMo7.editAble = NO;
    rowMo7.strValue = @"0";
    [self.arrData addObject:rowMo7];
    
    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_INPUT_TEXT;
    rowMo8.leftContent = @"备注";
    rowMo8.rightContent = @"请输入备注";
    rowMo8.inputType = K_LONG_TEXT;
    rowMo8.key = @"content";
    rowMo8.editAble = YES;
    rowMo8.nullAble = YES;
    [self.arrData addObject:rowMo8];
    
    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_BUTTON;
    rowMo9.leftContent = @"完成";
    [self.arrData addObject:rowMo9];
    
    self.price = 0;
    self.total = 0;
    self.quanity = 0;
    
    [self.tableView reloadData];
}

- (void)configRowMosModel {
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_TITLE;
    rowMo0.leftContent = @"添加报价产品";
    [self.arrData addObject:rowMo0];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_PRODUCT_TYPE;
    rowMo1.leftContent = @"产品分类";
    rowMo1.rightContent = @"必填";
    rowMo1.key = @"materialType";
    rowMo1.mutiAble = NO;
    rowMo1.editAble = YES;
    NSError *error = nil;
    MaterialMo *materiMo = [[MaterialMo alloc] initWithDictionary:self.detailMo.materialType error:&error];
    rowMo1.strValue = materiMo.name;
    rowMo1.m_obj = materiMo;
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo102 = [[CommonRowMo alloc] init];
    rowMo102.rowType = K_INPUT_TEXT;
    rowMo102.inputType = K_SHORT_TEXT;
    rowMo102.leftContent = @"档位";
    rowMo102.rightContent = @"必填";
    rowMo102.key = @"gears";
    rowMo102.editAble = YES;
    rowMo102.strValue = self.detailMo.gears;
    [self.arrData addObject:rowMo102];
    
    //    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    //    rowMo2.rowType = K_INPUT_TEXT;
    //    rowMo2.inputType = K_SHORT_TEXT;
    //    rowMo2.leftContent = @"转化率";
    //    rowMo2.rightContent = @"请输入";
    //    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_SELECT;
    rowMo3.dictName = @"";
    rowMo3.leftContent = @"报价单位";
    rowMo3.rightContent = @"必填";
    rowMo3.dictName = @"unit";
    rowMo3.key = @"unitKey";
    rowMo3.editAble = YES;
    DicMo *unitMo = [[DicMo alloc] init];
    unitMo.key = self.detailMo.unitKey;
    unitMo.value = self.detailMo.unitValue;
    rowMo3.strValue = unitMo.value;
    rowMo3.singleValue = unitMo;
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_INPUT_TEXT;
    rowMo5.inputType = K_SHORT_TEXT;
    rowMo5.keyBoardType = K_DOUBLE;
    rowMo5.leftContent = @"报价数量";
    rowMo5.rightContent = @"必填";
    rowMo5.key = @"quantity";
    rowMo5.editAble = YES;
    rowMo5.strValue = self.detailMo.quantity;
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_INPUT_TEXT;
    rowMo6.inputType = K_SHORT_TEXT;
    rowMo6.keyBoardType = K_DOUBLE;
    rowMo6.leftContent = @"单价";
    rowMo6.rightContent = @"必填";
    rowMo6.key = @"price";
    rowMo6.editAble = YES;
    rowMo6.strValue = self.detailMo.price;
    [self.arrData addObject:rowMo6];
    
    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_TEXT;
    rowMo7.inputType = K_SHORT_TEXT;
    rowMo7.leftContent = @"小计";
    rowMo7.rightContent = @"必填";
    rowMo7.key = @"totalPrice";
    rowMo7.editAble = NO;
    rowMo7.strValue = self.detailMo.totalPrice;
    [self.arrData addObject:rowMo7];
    
    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_INPUT_TEXT;
    rowMo8.leftContent = @"备注";
    rowMo8.rightContent = @"请输入备注";
    rowMo8.inputType = K_LONG_TEXT;
    rowMo8.key = @"content";
    rowMo8.editAble = YES;
    rowMo8.nullAble = YES;
    rowMo8.strValue = self.detailMo.remark;
    [self.arrData addObject:rowMo8];
    
    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_BUTTON;
    rowMo9.leftContent = @"完成";
    [self.arrData addObject:rowMo9];
    
    self.price = [self.detailMo.price floatValue];
    self.total = [self.detailMo.totalPrice floatValue];
    self.quanity = [self.detailMo.quantity floatValue];
    
    [self.tableView reloadData];
}

- (void)config {
    if (self.isUpdate) {
        [self configRowMosModel];
    } else {
        [self configRowMosDefault];
    }
}

- (void)clickRightButton:(UIButton *)sender {
    [self hidenKeyboard];
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
    // 分类
    CommonRowMo *rowMo1 = self.arrData[1];
    self.detailMo.materialType = [((MaterialMo *)rowMo1.m_obj) toDictionary];
    // 档位
    CommonRowMo *rowMo2 = self.arrData[2];
    self.detailMo.gears = rowMo2.strValue;
    // 报价单位
    CommonRowMo *rowMo3 = self.arrData[3];
    self.detailMo.unitKey = rowMo3.singleValue.value;
    self.detailMo.unitValue = rowMo3.singleValue.value;
    // 报价数量
    CommonRowMo *rowMo4 = self.arrData[4];
    self.detailMo.quantity = rowMo4.strValue;
    // 单价
    CommonRowMo *rowMo5 = self.arrData[5];
    self.detailMo.price = rowMo5.strValue;
    // 小计
    CommonRowMo *rowMo6 = self.arrData[6];
    self.detailMo.totalPrice = rowMo6.strValue;
    // 备注
    CommonRowMo *rowMo7 = self.arrData[7];
    self.detailMo.remark = rowMo7.strValue;
    
    if (self.updateSuccess) {
        self.updateSuccess(self.detailMo);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)continueTodo:(NSString *)toDo selName:(nonnull NSString *)selName indexPath:(nonnull NSIndexPath *)indexPath {
    if ([selName isEqualToString:@"DefaultInputCell"]) {
        if ([toDo isEqualToString:@"quantity"] || [toDo isEqualToString:@"price"]) {
            // 报价数量
            CommonRowMo *rowMo4 = self.arrData[4];
            self.quanity = [rowMo4.strValue floatValue];
            rowMo4.strValue = [Utils getPriceFrom:self.quanity];
            // 单价
            CommonRowMo *rowMo5 = self.arrData[5];
            self.price = [rowMo5.strValue floatValue];
            rowMo5.strValue = [Utils getPriceFrom:self.price];
            
            self.total = self.quanity * self.price;
            // 小计
            CommonRowMo *rowMo6 = self.arrData[6];
            rowMo6.strValue = [Utils getPriceFrom:self.total];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (TrendsQuoteDetailMo *)detailMo {
    if (!_detailMo) _detailMo = [[TrendsQuoteDetailMo alloc] init];
    return _detailMo;
}

@end
