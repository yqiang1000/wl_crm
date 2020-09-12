//
//  AddPlanNumViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/9/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "AddPlanNumViewCtrl.h"
#import "MyCommonCell.h"
//#import "ListSelectViewCtrl.h"
#import "WeightListViewCtrl.h"

@interface AddPlanNumViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyButtonCellDelegate, WeightListViewCtrlDelegate>

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DicMo *dicMo;

@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UITextField *priceTextField;

@end

@implementation AddPlanNumViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加计划批号";
    [self config];
    [self setUI];
    if (_materialMo) {
        self.priceTextField.text = _materialMo.quantity;
    }
}

- (void)config {
    if (_materialMo) {
        [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:_materialMo.batchNumber]];
        [self.arrValues replaceObjectAtIndex:1 withObject:[Utils saveToValues:_materialMo.productLevelName]];
        [self.arrValues replaceObjectAtIndex:2 withObject:[Utils saveToValues:_materialMo.spec]];
        [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:_materialMo.weight]];
        [self.arrValues replaceObjectAtIndex:4 withObject:[Utils saveToValues:_materialMo.factoryName]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count - 1) {
        return 94.0;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count-1) {
        static NSString *cellId = @"MyButtonCell";
        MyButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell.btnSave setTitle:@"确定" forState:UIControlStateNormal];
            cell.cellDelegate = self;
        }
        return cell;
    } else {
        static NSString *cellId = @"MyCommonCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell setLeftText:self.arrLeft[indexPath.row]];
        ShowTextMo *showTextMo = [Utils showTextRightStr:self.arrRight[indexPath.row] valueStr: self.arrValues[indexPath.row]];
        cell.labRight.textColor = showTextMo.color;
        cell.labRight.text = showTextMo.text;
        cell.labLeft.textColor = COLOR_B1;
        if (indexPath.row == 5) {
            cell.labRight.hidden = YES;
            cell.imgArrow.hidden = YES;
            [cell.contentView addSubview:self.priceView];
            [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
                make.width.equalTo(@100);
                make.height.equalTo(@32);
            }];
        } else {
            cell.labRight.hidden = NO;
            cell.imgArrow.hidden = NO;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WeightListViewCtrl *vc = [[WeightListViewCtrl alloc] init];
        vc.VcDelegate = self;
        vc.defaultId = self.materialMo.id;
        BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:naviVC animated:YES completion:^{
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.priceTextField resignFirstResponder];
}

//- (void)pushToSelectVC:(NSIndexPath *)indexPath {
//    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
//    vc.indexPath = indexPath;
//    vc.listVCdelegate = self;
//    vc.arrData = self.selectShowArr;
//    vc.title = self.arrLeft[indexPath.row];
//    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:_arrValues[indexPath.row], nil];
//    vc.byText = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//#pragma mark - ListSelectViewCtrlDelegate
//
//- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
//    self.dicMo = self.selectArr[index];
//    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:STRING(self.dicMo.remark)]];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}

#pragma mark - WeightListViewCtrlDelegate

- (void)weightListViewCtrl:(WeightListViewCtrl *)weightListViewCtrl selectedModel:(MaterialMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        self.materialMo = model;
        [self config];
        [self.tableView reloadData];
    }
}

- (void)weightListViewCtrlDismiss:(WeightListViewCtrl *)weightListViewCtrl {
    weightListViewCtrl = nil;
    [self.tableView reloadData];
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    if (!_materialMo) {
        [Utils showToastMessage:@"请选择批号"];
        return;
    }
    if (_priceTextField.text.length == 0) {
        [Utils showToastMessage:@"请输入数量"];
        return;
    }
    CGFloat floatValue = [self.priceTextField.text floatValue];
    _materialMo.quantity = [Utils getPriceFrom:floatValue];
    if (self.updateSuccess) {
        self.updateSuccess(_materialMo);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event


#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.backgroundColor = COLOR_B0;
    }
    return _tableView;
}

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"批号",
                     @"等级",
                     @"规格",
                     @"件重",
                     @"工厂",
                     
                     @"数量(KG)",
                     @"确定"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择",
                      @"自动带出",
                      @"自动带出",
                      @"自动带出",
                      @"自动带出",
                      
                      @"请输入",
                      @"确定"];
    }
    return _arrRight;
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

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@"demo"];
        }
    }
    return _arrValues;
}

//- (ProductMo *)productMo {
//    if (!_productMo) {
//        _productMo = [[ProductMo alloc] init];
//    }
//    return _productMo;
//}


- (UIView *)priceView {
    if (!_priceView) {
        _priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 32)];
        _priceView.layer.cornerRadius = 4;
        _priceView.layer.borderColor = COLOR_LINE.CGColor;
        _priceView.layer.borderWidth = 0.5;
        
        [_priceView addSubview:self.priceTextField];
        
//        if (_isOrder) {
            [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_priceView);
                make.right.equalTo(_priceView).offset(-10);
                make.left.equalTo(_priceView).offset(10);
            }];
//        } else {
//            [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(_priceView);
//                make.right.equalTo(_priceView).offset(-10);
//            }];
//            UILabel *labYuan = [UILabel new];
//            labYuan.text = @"¥";
//            labYuan.textColor = COLOR_B3;
//            labYuan.font = FONT_F16;
//            [_priceView addSubview:labYuan];
//            [labYuan mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(_priceView);
//                make.left.equalTo(_priceView).offset(10);
//                make.right.equalTo(_priceTextField.mas_left).offset(-5);
//                make.width.equalTo(@10);
//            }];
//        }
        
    }
    return _priceView;
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

- (DicMo *)dicMo {
    if (!_dicMo) {
        _dicMo = [[DicMo alloc] init];
    }
    return _dicMo;
}

@end
