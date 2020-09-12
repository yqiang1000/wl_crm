//
//  CreateSpeProductViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/8/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateSpeProductViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "MaterialListViewCtrl.h"

@interface CreateSpeProductViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyButtonCellDelegate, ListSelectViewCtrlDelegate, MaterialListViewCtrlDelegate>

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MaterialMo *materialMo;
@property (nonatomic, strong) DicMo *dicMo;

@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UITextField *priceTextField;

@end

@implementation CreateSpeProductViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self setUI];
}

- (void)config {
    if (_isOrder) {
        self.title = @"添加计划外要货产品";
    } else {
        self.title = @"添加特价产品";
    }
    
    if (_productMo) {
        [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:_productMo.batch]];
        [self.arrValues replaceObjectAtIndex:1 withObject:[Utils saveToValues:_productMo.level]];
        self.priceTextField.text = _productMo.priceApply;
        self.dicMo.remark = self.productMo.level;
        self.dicMo.value = self.productMo.levelValue;
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
        if (indexPath.row == 2) {
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
    // 获取批号
    if (indexPath.row == 0) {
        MaterialListViewCtrl *vc = [[MaterialListViewCtrl alloc] init];
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        vc.defaultNum = _materialMo.batchNumber;
        vc.indexPath = indexPath;
        vc.VcDelegate = self;
        vc.fromSpe = YES;
        vc.title = self.arrLeft[indexPath.row];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
    }
    else if (indexPath.row == 1) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getConfigDicByName:@"product_grade" success:^(id responseObject) {
            [Utils dismissHUD];
            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
            [_selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (DicMo *tmpMo in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = tmpMo.id;
                mo.moText = tmpMo.remark;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.priceTextField resignFirstResponder];
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = self.arrLeft[indexPath.row];
    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:_arrValues[indexPath.row], nil];
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    self.dicMo = self.selectArr[index];
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:STRING(self.dicMo.remark)]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MaterialListViewCtrlDelegate

- (void)materialListViewCtrl:(MaterialListViewCtrl *)listSelectViewCtrl selectMaterialMo:(MaterialMo *)materialMo indexPath:(NSIndexPath *)indexPath {
    self.materialMo = materialMo;
    [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:_materialMo.batchNumber]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    [self.priceTextField resignFirstResponder];
    if (self.priceTextField.text.length == 0 ||
        [self.arrValues[0] isEqualToString:@"demo"] ||
        [self.arrValues[1] isEqualToString:@"demo"]) {
        [Utils showToastMessage:@"请完善信息"];
        return;
    }
    
    self.productMo.batch = self.arrValues[0];
    self.productMo.level = self.dicMo.remark;
    self.productMo.priceApply = self.priceTextField.text;
    self.productMo.levelValue = self.dicMo.value;
    if (self.updateSuccess) {
        self.updateSuccess(self.productMo);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

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
                     _isOrder ? @"数量(KG)": @"特价(元/KG)",
                     
                     @"确定"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择",
                      @"请选择",
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

- (ProductMo *)productMo {
    if (!_productMo) {
        _productMo = [[ProductMo alloc] init];
    }
    return _productMo;
}


- (UIView *)priceView {
    if (!_priceView) {
        _priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 32)];
        _priceView.layer.cornerRadius = 4;
        _priceView.layer.borderColor = COLOR_LINE.CGColor;
        _priceView.layer.borderWidth = 0.5;
        
        [_priceView addSubview:self.priceTextField];
        
        if (_isOrder) {
            [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_priceView);
                make.right.equalTo(_priceView).offset(-10);
                make.left.equalTo(_priceView).offset(10);
            }];
        } else {
            [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_priceView);
                make.right.equalTo(_priceView).offset(-10);
            }];
            UILabel *labYuan = [UILabel new];
            labYuan.text = @"¥";
            labYuan.textColor = COLOR_B3;
            labYuan.font = FONT_F16;
            [_priceView addSubview:labYuan];
            [labYuan mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_priceView);
                make.left.equalTo(_priceView).offset(10);
                make.right.equalTo(_priceTextField.mas_left).offset(-5);
                make.width.equalTo(@10);
            }];
        }
        
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
