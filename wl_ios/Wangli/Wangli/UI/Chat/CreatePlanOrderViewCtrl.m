//
//  CreatePlanOrderViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/8/16.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreatePlanOrderViewCtrl.h"
#import "CreateSpePriceViewCtrl.h"
#import "MyCommonCell.h"
#import "OrderProductCell.h"
#import "ListSelectViewCtrl.h"
#import "CreateSpeProductViewCtrl.h"
#import "MemberSelectViewCtrl.h"
#import "WSDatePickerView.h"

@interface CreatePlanOrderViewCtrl () <UITableViewDataSource, UITableViewDelegate, ListSelectViewCtrlDelegate, MyButtonCellDelegate, MemberSelectViewCtrlDelegate, MyTextViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) CustomerMo *cusMo;
@property (nonatomic, strong) UITextView *currentTxtView;

@end

@implementation CreatePlanOrderViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建计划外要货";
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.arrLeft.count + 1;
    } else {
        return self.arrData.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == self.arrData.count) {
            return 94.0;
        } else {
            return 68;
        }
    } else {
        if (indexPath.row == 2) {
            return 110.0;
        }
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 0 ? 0.001 : 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 8 : 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            static NSString *identifier = @"MyTextViewCell";
            MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.lineView.hidden = YES;
            }
            [cell setLeftText:self.arrLeft[indexPath.row]];
            cell.placeholder = self.arrRight[indexPath.row];
            cell.txtView.text = [Utils showTextRightStr:nil valueStr:self.arrValues[indexPath.row]].text;
            cell.cellDelegate = self;
            cell.indexPath = indexPath;
            return cell;
        }
        if (indexPath.row == 3) {
            static NSString *cellId = @"sectionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = COLOR_CLEAR;
                UIButton *btn = [[UIButton alloc] init];
                [btn setTitle:@"+ 添加产品" forState:UIControlStateNormal];
                [btn setTitleColor:COLOR_C1 forState:UIControlStateNormal];
                [btn setBackgroundColor:COLOR_F8F8F8];
                btn.titleLabel.font = FONT_F13;
                btn.layer.cornerRadius = 4;
                btn.clipsToBounds = YES;
                [btn addTarget:self action:@selector(addProductClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(15);
                    make.bottom.equalTo(cell.contentView).offset(-5);
                    make.width.equalTo(@80);
                    make.height.equalTo(@25);
                }];
            }
            return cell;
        }
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
        return cell;
    } else {
        if (indexPath.row == self.arrData.count) {
            static NSString *cellId = @"MyButtonCell";
            MyButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[MyButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [cell.btnSave setTitle:@"提交" forState:UIControlStateNormal];
                cell.cellDelegate = self;
            }
            return cell;
        } else {
            
            static NSString *cellId = @"OrderProductCell";
            OrderProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            ProductMo *mo = self.arrData[indexPath.row];
            [cell loadDataWith:mo order:YES];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        // 客户
        if (indexPath.row == 0) {
            MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
            vc.needRules = YES;
            vc.knkli = YES;
            vc.VcDelegate = self;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
        }
        // 时间
        else if (indexPath.row == 1) {
            NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
            [minDateFormater setDateFormat:@"yyyy-MM"];
            NSDate *scrollToDate = [minDateFormater dateFromString:self.arrValues[indexPath.row]];
            __weak typeof(self) weakself = self;
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
                
                NSString *date = [selectDate stringWithFormat:@"yyyy-MM"];
                [weakself.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:date])];
                [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
            datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
            datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            [datepicker show];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row < self.arrData.count) {
            ProductMo *mo = self.arrData[indexPath.row];
            ProductMo *tmpMo = [[ProductMo alloc] init];
            tmpMo.level = mo.level;
            tmpMo.batch = mo.batch;
            tmpMo.priceApply = mo.priceApply;
            tmpMo.levelValue = mo.levelValue;
            CreateSpeProductViewCtrl *vc = [[CreateSpeProductViewCtrl alloc] init];
            vc.isOrder = YES;
            vc.productMo = tmpMo;
            __weak typeof(self) weakself = self;
            vc.updateSuccess = ^(ProductMo *productMo) {
                [weakself addMoToData:productMo edit:YES index:indexPath.row];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_currentTxtView resignFirstResponder];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else {
        if (indexPath.row < self.arrData.count) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该产品？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.arrData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        self.cusMo = model;
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:model.orgName]];
        //        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
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

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    DicMo *tmpDic = self.selectArr[index];
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:STRING(tmpDic.value)]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    //    {
    //        "memberId":46930,
    //        "date":"2018-10-11",
    //        "remark":"老客户",
    //        "demandRecordItems":[
    //                              {
    //                                  "batchNumber":"C4290S",
    //                                  "grade":"01",
    //                                  "quantity":"1"
    //                              }]
    //    }
    [_currentTxtView resignFirstResponder];
    if (!self.cusMo) {
        [Utils showToastMessage:@"请完善信息"];
        return;
    }
    
    if (self.arrData.count == 0) {
        [Utils showToastMessage:@"请添加产品"];
        return;
    }
    
    for (int i = 0; i < 2; i++) {
        if ([self.arrValues[i] isEqualToString:@"demo"]) {
            [Utils showToastMessage:@"请完善信息"];
            return;
        }
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(self.cusMo.id) forKey:@"memberId"];
    [param setObject:[NSString stringWithFormat:@"%@-01", self.arrValues[1]] forKey:@"date"];
    [param setObject:[self.arrValues[2] isEqualToString:@"demo"] ? @"" : STRING(self.arrValues[2]) forKey:@"remark"];
    
    NSMutableArray *demandRecordItems = [NSMutableArray new];
    for (ProductMo *tmpMo in self.arrData) {
        NSDictionary *dic = @{@"batchNumber":STRING(tmpMo.batch),
                              @"grade":STRING(tmpMo.levelValue),
                              @"quantity":STRING(tmpMo.priceApply)};
        [demandRecordItems addObject:dic];
    }
    [param setObject:demandRecordItems forKey:@"demandRecordItems"];
    
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] createDemandRecordParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"创建成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}


#pragma mark - event

- (void)addProductClick:(UIButton *)sender {
    CreateSpeProductViewCtrl *vc = [[CreateSpeProductViewCtrl alloc] init];
    vc.isOrder = YES;
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(ProductMo *productMo) {
        [weakself addMoToData:productMo edit:NO index:-1];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addMoToData:(ProductMo *)proMo edit:(BOOL)edit index:(NSInteger)index {
    for (int i = 0; i < self.arrData.count; i++) {
        if (i == index) {
            continue;
        }
        ProductMo *tmpMo = self.arrData[i];
        if ([tmpMo.batch isEqualToString:proMo.batch]) {
            if ([tmpMo.level isEqualToString:proMo.level]) {
                [Utils showToastMessage:@"同一个批号等级的产品不允许申请多个订单"];
                return;
            }
        }
    }
    if (!edit) {
        [self.arrData addObject:proMo];
    } else {
        [self.arrData replaceObjectAtIndex:index withObject:proMo];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
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
        _arrLeft = @[@"客户名称",
                     @"时间",
                     @"备注"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择",
                      @"请选择",
                      @"请输入"];
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

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end

