//
//  CreateProductViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateProductViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "MyCommonCell.h"

@interface CreateProductViewCtrl ()
<UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;

@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UIView *numberView;

@property (nonatomic, strong) UILabel *labPrice;
@property (nonatomic, strong) UILabel *labTotalMoney;

@end

@implementation CreateProductViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 8) {
        static NSString *cellId = @"customCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell setLeftText:self.arrLeft[indexPath.row]];
            cell.labLeft.textColor = COLOR_B1;
            cell.imgArrow.hidden = YES;
            cell.labRight.hidden = YES;
        }
        if (indexPath.row == 3) {
            [cell.contentView addSubview:self.labPrice];
            [self.labPrice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
            }];
        } else if (indexPath.row == 4) {
            [cell.contentView addSubview:self.priceView];
            [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
                make.width.equalTo(@100);
                make.height.equalTo(@32);
            }];
        } else if (indexPath.row == 5) {
            [cell.contentView addSubview:self.numberView];
            [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
                make.width.equalTo(@100);
                make.height.equalTo(@32);
            }];
        } else if (indexPath.row == 8) {
            [cell.contentView addSubview:self.labTotalMoney];
            [self.labTotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
            }];
        }
//        [cell.contentView addSubview:rightView];
//        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(cell.contentView);
//            make.right.equalTo(cell.contentView).offset(-15);
//        }];
        return cell;
    }
    else {
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
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    static NSString *identifier = @"footer";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        footerView.backgroundColor = COLOR_CLEAR;
        footerView.contentView.backgroundColor = COLOR_CLEAR;
        UILabel *lab = [UILabel new];
        [footerView.contentView addSubview:lab];
        lab.font = FONT_F13;
        lab.textColor = COLOR_B3;
        lab.text = @"* 自动带出上一笔成交价为申请单价";
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footerView.contentView);
            make.left.equalTo(footerView.contentView).offset(15);
        }];
    }
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 输入
    if ([self.arrRight[indexPath.row] isEqualToString:@"请输入"]) {
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 20;
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 8) {
        // 单独处理
    }
    else {
        if (indexPath.row == 0) {
            self.selectArr = [[NSMutableArray alloc] initWithArray:@[@"25-3101S3", @"25-3301S3", @"25-3134S3", @"22-3101S3"]];
        } else if (indexPath.row == 1) {
            self.selectArr = [[NSMutableArray alloc] initWithArray:@[@"40D", @"45M", @"34P"]];
        } else if (indexPath.row == 2) {
            self.selectArr = [[NSMutableArray alloc] initWithArray:@[@"100287", @"123287", @"100227"]];
        }  else if (indexPath.row == 6) {
            self.selectArr = [[NSMutableArray alloc] initWithArray:@[@"一等品", @"二等品", @"三等品"]];
        } else if (indexPath.row == 7) {
            self.selectArr = [[NSMutableArray alloc] initWithArray:@[@"整经机",
                                                                     @"经编机",
                                                                     @"花边机",
                                                                     @"大圆机",
                                                                     @"小圆机",
                                                                     @"C/C",
                                                                     @"A/C",
                                                                     @"Combi",
                                                                     @"2F1",
                                                                     @"牛仔",
                                                                     @"棉袜",
                                                                     @"CSY(锭)",
                                                                     @"N/F、D/P"]];
        }
        self.selectShowArr = self.selectArr;
        ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
        vc.indexPath = indexPath;
        vc.listVCdelegate = self;
        vc.arrData = self.selectShowArr;
        vc.title = self.arrLeft[indexPath.row];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.priceTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
}

#pragma mark - ListSelectViewCtrlDelegate


- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:self.selectShowArr[index]])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    if (self.success) {
        // 成功之后
        ProductMo *model = [[ProductMo alloc] init];
        model.itemId = @"1";
        model.specifications = self.arrValues[1];
        model.batch = self.arrValues[0];
        model.number = self.numberTextField.text ;
        model.price = self.labPrice.text;
        
        model.sapNum = self.arrValues[2];
        model.priceApply = self.priceTextField.text;
        model.level = self.arrValues[6];
        model.useWay = self.arrValues[7];
        model.totalMoney = self.labTotalMoney.text;
        self.success(model);
        [self.navigationController popViewControllerAnimated:YES];
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
        _arrLeft = @[@"产品批号",
                     @"产品规格",
                     @"SAP料号",
                     @"指导单价",
                     @"申请单价",
                     
                     @"申请数量",
                     @"等级",
                     @"用途",
                     @"金额小计"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请输入",
                      @"请选择",
                      @"请选择",
                      @"demo",
                      @"demo",
                      
                      @"demo",
                      @"请选择",
                      @"请选择",
                      @"demo"];
    }
    return _arrRight;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        if (_mo) {
            [_arrValues addObject:STRING(_mo.batch)];
            [_arrValues addObject:STRING(_mo.specifications)];
            [_arrValues addObject:STRING(_mo.sapNum)];
            [_arrValues addObject:STRING(_mo.price)];
            [_arrValues addObject:STRING(@"demo")];
            [_arrValues addObject:STRING(@"demo")];
            [_arrValues addObject:STRING(@"demo")];
            [_arrValues addObject:STRING(_mo.level)];
            [_arrValues addObject:STRING(_mo.useWay)];
            [_arrValues addObject:STRING(@"demo")];
            self.labTotalMoney.text = _mo.totalMoney;
            self.labPrice.text = _mo.price;
            self.numberTextField.text = _mo.number;
            self.priceTextField.text = _mo.priceApply;
        } else {
            for (int i = 0; i < self.arrLeft.count; i++) {
                [_arrValues addObject:@"demo"];
            }
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

- (UIView *)priceView {
    if (!_priceView) {
        _priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 32)];
        _priceView.layer.cornerRadius = 4;
        _priceView.layer.borderColor = COLOR_LINE.CGColor;
        _priceView.layer.borderWidth = 0.5;
        
        UILabel *labYuan = [UILabel new];
        labYuan.text = @"¥";
        labYuan.textColor = COLOR_B3;
        labYuan.font = FONT_F16;
        
        [_priceView addSubview:self.priceTextField];
        [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_priceView);
            make.right.equalTo(_priceView).offset(-10);
        }];
        
        [_priceView addSubview:labYuan];
        [labYuan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_priceView);
            make.left.equalTo(_priceView).offset(10);
            make.right.equalTo(_priceTextField.mas_left).offset(-5);
            make.width.equalTo(@10);
        }];
    }
    return _priceView;
}

- (UIView *)numberView {
    if (!_numberView) {
        _numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 32)];
        _numberView.layer.cornerRadius = 4;
        _numberView.layer.borderColor = COLOR_LINE.CGColor;
        _numberView.layer.borderWidth = 0.5;
        
        UILabel *labKg = [UILabel new];
        labKg.text = @"KG";
        labKg.textColor = COLOR_B3;
        labKg.font = FONT_F16;
        
        [_numberView addSubview:self.numberTextField];
        [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_numberView);
            make.left.equalTo(_numberView).offset(10);
        }];
        
        [_numberView addSubview:labKg];
        [labKg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_numberView);
            make.right.equalTo(_numberView).offset(-10);
            make.left.equalTo(_numberTextField.mas_right).offset(5);
            make.width.equalTo(@25);
        }];
    }
    return _numberView;
}

- (UITextField *)priceTextField {
    if (!_priceTextField) {
        _priceTextField = [[UITextField alloc] init];
        _priceTextField.font = FONT_F16;
        _priceTextField.textColor = COLOR_B2;
        _priceTextField.textAlignment = NSTextAlignmentCenter;
        _priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _priceTextField;
}

- (UITextField *)numberTextField {
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.font = FONT_F16;
        _numberTextField.textColor = COLOR_B2;
        _numberTextField.textAlignment = NSTextAlignmentCenter;
        _numberTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _numberTextField;
}

- (UILabel *)labPrice {
    if (!_labPrice) {
        _labPrice = [UILabel new];
        _labPrice.text = @"¥34/KG";
        _labPrice.textColor = COLOR_B2;
        _labPrice.font = FONT_F16;
    }
    return _labPrice;
}

- (UILabel *)labTotalMoney {
    if (!_labTotalMoney) {
        _labTotalMoney = [UILabel new];
        _labTotalMoney.text = @"¥ -";
        _labTotalMoney.textColor = COLOR_B2;
        _labTotalMoney.font = FONT_F16;
    }
    return _labTotalMoney;
}

@end
