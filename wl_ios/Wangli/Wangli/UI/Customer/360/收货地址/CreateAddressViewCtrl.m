//
//  CreateAddressViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/16.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "CreateAddressViewCtrl.h"
#import "MyCommonCell.h"
#import "AddressPickerView.h"

@interface CreateAddressViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyTextFieldCellDelegate, MyTextViewCellDelegate, MyButtonCellDelegate, MyDefaultCellDelegate>

{
    BOOL _isEdit;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) UITextField *currentTxtField;
@property (nonatomic, strong) UITextView *currentTxtView;

@property (nonatomic, strong) NSMutableArray *arrValues;
// 地址
@property (nonatomic, strong) NSArray *arrAddIds;
@property (nonatomic, strong) NSArray *arrAddNames;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;


@end

@implementation CreateAddressViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isEdit = _mo ? YES : NO;
    
    self.title = _isEdit ? @"修改收货地址" : @"新增收货地址";
    
    self.arrLeft = @[@"收件人    ",
                     @"联系电话",
                     @"选择地址",
                     @"详细地址",
                     @"设为默认地址",
                     @"保存地址"];
    self.arrRight = @[@"请输入收货人姓名",
                      @"请输入联系电话",
                      @"请选择地区",
                      @"请输入详细的街道、门牌号",
                      @"设为默认地址",
                      @"保存地址"];
    [self setUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldChange:(NSNotification *)noti {
    if (_currentIndexPath.row == 1) {
        UITextField *txtField = (UITextField *)noti.object;
        NSString *str = [txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (str.length > 11) {
            txtField.text = [str substringToIndex:11];
        }
    }
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.bottom.right.left.equalTo(self.view);
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
    if (indexPath.row == 3) {
        return 110.0;
    } else if (indexPath.row == 5) {
        return 94.0;
    } else {
        return 45.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        static NSString *identifier = @"textFieldCell";
        MyTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setLeftText:self.arrLeft[indexPath.row]];
        cell.txtRight.placeholder = self.arrRight[indexPath.row];
        cell.txtRight.text = [Utils showTextRightStr:nil valueStr:self.arrValues[indexPath.row]].text;
        cell.cellDelegate = self;
        cell.indexPath = indexPath;
        cell.imgArrow.hidden = indexPath.row == 2 ? NO : YES;
        return cell;
    }
    else if (indexPath.row == 3) {
        static NSString *identifier = @"textViewCell";
        MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setLeftText:self.arrLeft[indexPath.row]];
        cell.placeholder = self.arrRight[indexPath.row];
        cell.txtView.text = [Utils showTextRightStr:nil valueStr:self.arrValues[indexPath.row]].text;
        cell.cellDelegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
    else if (indexPath.row == 4) {
        static NSString *identifier = @"defaultCell";
        MyDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.cellDelegate = self;
        [cell setLeftText:self.arrLeft[indexPath.row]];
        [cell.btnSwitch setOn:[self.arrValues[indexPath.row] boolValue] animated:YES];
        cell.lineView.hidden = YES;
        return cell;
    }
    else if (indexPath.row == 5) {
        static NSString *identifier = @"btnCell";
        MyButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.btnSave setTitle:self.arrLeft[indexPath.row] forState:UIControlStateNormal];
        cell.cellDelegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerId = @"headerId";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerId];
        header.backgroundColor = COLOR_B0;
    }
    return header;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.currentTxtView resignFirstResponder];
    [self.currentTxtField resignFirstResponder];
}

#pragma mark - MyTextFieldCellDelegate

- (void)cell:(MyTextFieldCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        NSString *str = [_currentTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (str.length > 11) {
            str = [str substringToIndex:11];
        }
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:str])];
    } else {
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:textField.text])];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)cell:(MyTextFieldCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    [_currentTxtField resignFirstResponder];
    [_currentTxtView resignFirstResponder];
    _currentTxtField = textField;
    _currentIndexPath = indexPath;
    if (indexPath.row == 2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_currentTxtField resignFirstResponder];
            __weak typeof(self) weakSelf = self;
            AddressPickerView *picker = [[AddressPickerView alloc] initWithDefaultItem:self.arrAddIds itemClick:^(NSArray *arrResult) {
                
                __strong typeof(self) strongSelf = weakSelf;
                strongSelf.arrAddIds = arrResult[0];
                strongSelf.arrAddNames = arrResult[1];
                textField.text = [arrResult lastObject];
                [textField resignFirstResponder];
                [strongSelf.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:textField.text])];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } cancelClick:^(AddressPickerView *obj) {
                [obj removeFromSuperview];
                obj = nil;
                [textField resignFirstResponder];
            }];
            [self.view addSubview:picker];
            [picker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self.view);
            }];
        });
    } else {
        if (indexPath.row == 1) {
            _currentTxtField.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            _currentTxtField.keyboardType = UIKeyboardTypeDefault;
        }
    }
}

#pragma mark - MyTextViewCellDelegate

- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:textView.text])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    _currentTxtView = textView;
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    if (_currentTxtView) {
        [_currentTxtView resignFirstResponder];
    }
    if (_currentTxtField) {
        [_currentTxtField resignFirstResponder];
    }
    for (int i = 0; i < self.arrValues.count-2; i++) {
        if ([self.arrValues[i] isEqualToString:@"demo"]) {
            [Utils showToastMessage:@"请完善信息"];
            return;
        }
    }
    [Utils showHUDWithStatus:nil];
    // 保存
    if (_isEdit) {
        [[JYUserApi sharedInstance] updateAddressByCustomId:TheCustomer.customerMo.id addressId:_mo.id phoneOne:self.arrValues[1] areaIds:self.arrAddIds areaNames:self.arrAddNames receiver:self.arrValues[0] address:self.arrValues[3] defaults:[self.arrValues[4] boolValue] success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
            if (self.addSuccessBlock) {
                self.addSuccessBlock(nil);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createAddressByCustomId:TheCustomer.customerMo.id phoneOne:self.arrValues[1] areaIds:self.arrAddIds areaNames:self.arrAddNames receiver:self.arrValues[0] address:self.arrValues[3] defaults:[self.arrValues[4] boolValue] success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"创建成功"];
            if (self.addSuccessBlock) {
                self.addSuccessBlock(nil);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

#pragma mark - MyDefaultCellDelegate

- (void)defaultCell:(MyDefaultCell *)cell isDefault:(BOOL)isDefault {
    [self.arrValues replaceObjectAtIndex:4 withObject:@(isDefault)];
}

#pragma mark - event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.currentTxtView resignFirstResponder];
    [self.currentTxtField resignFirstResponder];
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        
        for (int i = 0; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@"demo"];
        }
        
        if (_isEdit) {
            [self.arrValues replaceObjectAtIndex:0 withObject:STRING(_mo.receiver)];
            [self.arrValues replaceObjectAtIndex:1 withObject:STRING(_mo.phoneOne)];
            
            NSString *str = @"";
            if (_mo.provinceName) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", _mo.provinceName]];
            }
            if (_mo.cityName) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", _mo.cityName]];
            }
            if (_mo.areaName) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", _mo.areaName]];
            }
            [self.arrValues replaceObjectAtIndex:2 withObject:STRING(str)];
            [self.arrValues replaceObjectAtIndex:3 withObject:STRING(_mo.address)];
            [self.arrValues replaceObjectAtIndex:4 withObject:@(_mo.defaults)];
        } else {
            [self.arrValues replaceObjectAtIndex:4 withObject:@(NO)];
        }
        [self.arrValues replaceObjectAtIndex:5 withObject:self.arrLeft[5]];
    }
    return _arrValues;
}

- (NSArray *)arrAddIds {
    if (!_arrAddIds) {
        if (_isEdit) {
            _arrAddIds = @[STRING(_mo.provinceNumber), STRING(_mo.cityNumber), STRING(_mo.areaNumber)];
        } else {
            _arrAddIds = @[@"0", @"0", @"0"];
        }
    }
    return _arrAddIds;
}

- (NSArray *)arrAddNames {
    if (!_arrAddNames) {
        if (_isEdit) {
            _arrAddNames = @[STRING(_mo.provinceName), STRING(_mo.cityName), STRING(_mo.areaName)];
        } else {
            _arrAddNames = [NSArray new];
        }
    }
    return _arrAddNames;
}

@end
