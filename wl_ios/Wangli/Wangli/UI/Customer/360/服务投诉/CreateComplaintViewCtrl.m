//
//  CreateComplaintViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateComplaintViewCtrl.h"
#import "MyCommonCell.h"
#import "EditTextViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "CommonRowMo.h"
#import "AttachmentCell.h"
#import "MemberSelectViewCtrl.h"
#import "WSDatePickerView.h"
#import "UIButton+ShortCut.h"
#import "NewComplaintCell.h"
#import "CreateProblemDescViewCtrl.h"

@interface CreateComplaintViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate, MyTextFieldCellDelegate, MyTextViewCellDelegate, DefaultInputCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;

@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSMutableArray *attachUrls;
@property (nonatomic, strong) NSMutableArray *arrProblem;
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) UITextField *currentTextField;

@end

@implementation CreateComplaintViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self config];
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

//- (void)config {
//    if (_mo) {
//        for (QiniuFileMo *tmpMo in _mo.attachments) {
//            [self.attachments addObject:STRING(tmpMo.thumbnail)];
//            [self.attachUrls addObject:STRING(tmpMo.url)];
//        }
//
//        [self.arrTypeValue replaceObjectAtIndex:0 withObject:STRING([_mo.factory[@"id"] stringValue])];
//        [self.arrTypeValue replaceObjectAtIndex:2 withObject:STRING([_mo.equipment[@"id"] stringValue])];
//        [self.arrTypeValue replaceObjectAtIndex:3 withObject:STRING([_mo.type[@"id"] stringValue])];
//
//        [self.arrValues replaceObjectAtIndex:0 withObject:STRING(_mo.factory[@"name"])];
//        [self.arrValues replaceObjectAtIndex:1 withObject:STRING(_mo.recordDate)];
//        [self.arrValues replaceObjectAtIndex:2 withObject:STRING(_mo.equipment[@"name"])];
//        [self.arrValues replaceObjectAtIndex:3 withObject:STRING(_mo.type[@"value"])];
//        [self.arrValues replaceObjectAtIndex:4 withObject:STRING(_mo.size)];
//
//        [self.arrValues replaceObjectAtIndex:5 withObject:STRING(_mo.name)];
//        if (_mo.equipment) {
//            [self.arrValues replaceObjectAtIndex:6 withObject:[Utils saveToValues:[NSString stringWithFormat:@"%@",_mo.equipment[@"quantity"]]]];
//            if (_mo.equipment[@"type"]) {
//                [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:_mo.equipment[@"type"][@"value"]]];
//                [self.arrTypeValue replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@",_mo.equipment[@"type"][@"id"]]];
//            }
//        }
//        [self.arrValues replaceObjectAtIndex:7 withObject:STRING(_mo.bootedQuantity)];
//        [self.arrValues replaceObjectAtIndex:9 withObject:STRING(_mo.spandexNumber)];
//
//        [self.arrValues replaceObjectAtIndex:10 withObject:STRING(_mo.productionDate)];
//        [self.arrValues replaceObjectAtIndex:11 withObject:STRING(_mo.spandexBackoffSpeed)];
//        [self.arrValues replaceObjectAtIndex:12 withObject:STRING(_mo.spandexBackoffTension)];
//        [self.arrValues replaceObjectAtIndex:13 withObject:STRING(_mo.drawRation)];
//        [self.arrValues replaceObjectAtIndex:14 withObject:STRING(_mo.productUsingCondition)];
//
//        [self.arrValues replaceObjectAtIndex:15 withObject:STRING(_mo.usedQuantityExpected)];
//        [self.arrValues replaceObjectAtIndex:16 withObject:STRING(_mo.airPressure)];
//        [self.arrValues replaceObjectAtIndex:17 withObject:STRING(_mo.stockQuantity)];
//        [self.arrValues replaceObjectAtIndex:18 withObject:STRING(_mo.stockDays)];
//        [self.arrValues replaceObjectAtIndex:19 withObject:STRING(_mo.remark)];
//
//        [self refreshOpenAndALl];
//    } else {
//        NSString *recordDate = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
//        [self.arrValues replaceObjectAtIndex:1 withObject:recordDate];
//
//        [[JYUserApi sharedInstance] getDefaultFactorySuccess:^(id responseObject) {
//            NSError *error;
//            self.selectArr = [FactoryMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
//            if (self.selectArr.count > 0) {
//                FactoryMo *tmpMo = self.selectArr[0];
//                [self.arrTypeValue replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",(long)tmpMo.id]];
//                [self.arrValues replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",tmpMo.name]];
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        } failure:^(NSError *error) {
//        }];
//    }
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.arrProblem.count;
    }
    NSArray *sectionArr = self.arrData[section];
    return sectionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 65.0;
    }
    NSArray *sectionArr = self.arrData[indexPath.section];
    CommonRowMo *rowMo = sectionArr[indexPath.row];
    return rowMo.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 43.0;
    } else if (section == self.arrData.count-1) {
        return 100.0;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 47.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerId = @"headerId";
    MyCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[MyCommonHeaderView alloc] initWithReuseIdentifier:headerId isHidenLine:NO];
    }
    if (section == 0) {
        header.labLeft.text = @"基本信息";
    } else if (section == 1) {
        header.labLeft.text = @"客户反馈";
    } else if (section == 2) {
        header.labLeft.text = @"客诉详细";
    } else if (section == 3) {
        header.labLeft.text = @"客户要求";
    } else if (section == 4) {
        header.labLeft.text = @"问题附件";
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        MyCommonHeaderView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerbtn"];
        if (!footer) {
            footer = [[MyCommonHeaderView alloc] initWithReuseIdentifier:@"footerbtn" isHidenLine:YES];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
            [btn setTitle:@"添加" forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_C1 forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"order_add_product"] forState:UIControlStateNormal];
            [btn imageLeftWithTitleFix:10];
            [btn addTarget:self action:@selector(problemAddAction:) forControlEvents:UIControlEventTouchUpInside];
            [footer.contentView addSubview:btn];
            footer.isHidenLine = YES;
            footer.contentView.backgroundColor = COLOR_B4;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(footer.contentView);
            }];
        }
        return footer;
    } else {
        MyCommonHeaderView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
        if (!footer) {
            footer = [[MyCommonHeaderView alloc] initWithReuseIdentifier:@"footer" isHidenLine:YES];
        }
        return footer;
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        static NSString *identifier = @"NewComplaintCell";
        NewComplaintCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NewComplaintCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell loadDataWith:self.arrProblem[indexPath.row]];
        return cell;
    }
    
    
    NSArray *sectionArr = self.arrData[indexPath.section];
    CommonRowMo *rowMo = sectionArr[indexPath.row];
    if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
        if ([rowMo.inputType isEqualToString:K_SHORT_TEXT]) {
            static NSString *identifier = @"DefaultInputCell";
            DefaultInputCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[DefaultInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.cellDelegate = self;
            }
            cell.indexPath = indexPath;
            [cell setLeftText:rowMo.leftContent];
            cell.txtRight.placeholder = rowMo.rightContent;
            cell.txtRight.keyboardType = rowMo.iosKeyBoardType;
            cell.txtRight.enabled = rowMo.editAble;
            ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:rowMo.strValue];
            cell.txtRight.text = showTextMo.text;
            return cell;
        }
        
        if ([rowMo.inputType isEqualToString:K_SHORT_TEXT] || [rowMo.inputType isEqualToString:K_EMAIL_TEXT]) {
            // 默认输入框 || 邮箱输入框
            static NSString *identifier = @"MyTextFieldCell";
            MyTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[MyTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.cellDelegate = self;
            }
            cell.imgArrow.hidden = YES;
            cell.btnRight.hidden = YES;
            cell.indexPath = indexPath;
            [cell setLeftText:rowMo.leftContent];
            cell.txtRight.placeholder = rowMo.rightContent;
            cell.txtRight.keyboardType = rowMo.iosKeyBoardType;
            cell.txtRight.enabled = rowMo.editAble;
            ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:rowMo.strValue];
            cell.txtRight.text = showTextMo.text;
            return cell;
        } else if ([rowMo.inputType isEqualToString:K_LONG_TEXT]) {
            // 备注输入框
            static NSString *cellId = @"contentCell";
            MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [cell setLeftText:rowMo.leftContent];
                cell.placeholder = rowMo.rightContent;
                cell.cellDelegate = self;
            }
            [cell setLeftText:rowMo.leftContent];
            cell.txtView.keyboardType = rowMo.iosKeyBoardType;
            cell.txtView.editable = rowMo.editAble;
            cell.indexPath = indexPath;
            cell.txtView.text = [Utils showTextRightStr:@"" valueStr:rowMo.strValue].text;
            return cell;
        } else if ([rowMo.inputType isEqualToString:K_NUMBER_A_TEXT]) {
            // 价格输入框
            return [[UITableViewCell alloc] init];
        } else {
            return [[UITableViewCell alloc] init];
        }
    }
    else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT] || [rowMo.rowType isEqualToString:K_DATE_SELECT]) {
        // 选择列表 || 时间选择
        static NSString *cellId = @"commonCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell setLeftText:rowMo.leftContent];
        ShowTextMo *showTextMo = [Utils showTextRightStr:rowMo.rightContent valueStr:rowMo.strValue];
        cell.labRight.textColor = rowMo.editAble ? showTextMo.color : COLOR_B2;
        cell.labRight.text = showTextMo.text;
        cell.labLeft.textColor = COLOR_B1;
        return cell;
    }
    else if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
        static NSString *cellId = @"attachmentCell";
        AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.count = 9;
//            cell.attachments = _mo.attachments;
            [cell refreshView];
        }
        return cell;
    }
    else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        CreateProblemDescViewCtrl *vc = [[CreateProblemDescViewCtrl alloc] init];
        vc.title = @"客诉详细";
        vc.model = self.arrProblem[indexPath.row];
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(ProblemDescMo *problemDescMo) {
            __strong typeof(self) strongself = weakself;
            [strongself.arrProblem replaceObjectAtIndex:indexPath.row withObject:problemDescMo];
            [strongself.tableView reloadData];
        };
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        
        return;
    }
    NSArray *sectionArr = self.arrData[indexPath.section];
    CommonRowMo *rowMo = sectionArr[indexPath.row];
    if (!rowMo.editAble) {
        return;
    }

    if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
        //        if (rowMo.iosInputType == JYInputDefault || rowMo.iosInputType == JYInputEmailText) {
        //            // 默认输入框 || 邮箱输入框
        //        } else if (rowMo.iosInputType == JYInputLongText) {
        //            // 备注输入框
        //        } else if (rowMo.iosInputType == JYInputSmallText) {
        //            // 价格输入框
        //        } else if (rowMo.iosInputType == JYInputPhoneText) {
        //            // 手机号
        //        }
    } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
        // 字典项选择
        [self hidenKeyboard];
//        if ([rowMo.selectType isEqualToString:K_JYSelectDict]) {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] getConfigDicByName:rowMo.dictName success:^(id responseObject) {
                [Utils dismissHUD];
                [_selectArr removeAllObjects];
                _selectArr = nil;
                [_selectShowArr removeAllObjects];
                _selectShowArr = nil;
                self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
                for (int i = 0; i < self.selectArr.count; i++) {
                    DicMo *tmpDic = self.selectArr[i];
                    if ([tmpDic.key isEqualToString:@"all"]) {
                        [_selectArr removeObject:tmpDic];
                        break;
                    }
                }
                for (DicMo *tmpDic in self.selectArr) {
                    ListSelectMo *mo = [[ListSelectMo alloc] init];
                    mo.moId = tmpDic.id;
                    mo.moText = tmpDic.value;
                    mo.moKey = tmpDic.key;
                    [self.selectShowArr addObject:mo];
                }
//                [self pushToSelectVC:indexPath rowMo:rowMo];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
            }];
//        } else {
//
//        }
    } else if ([rowMo.rowType isEqualToString:K_DATE_SELECT]) {
        // 时间选择
        [self hidenKeyboard];
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:rowMo.pattern];
        NSDate *scrollToDate = [minDateFormater dateFromString:rowMo.strValue];

        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:rowMo.pattern];
            NSLog(@"选择的日期：%@",date);
            rowMo.strValue = [Utils saveToValues:date];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    } else if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
        [self hidenKeyboard];
    }
//    else if (rowMo.iosRowType == RowMember) {
//        [self hidenKeyboard];
//        MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
//        vc.needRules = NO;
//        vc.VcDelegate = self;
//        vc.defaultId = TheCustomer.customerMo.id;
//        vc.indexPath = indexPath;
//        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
//        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
//        }];
//    } else if (rowMo.iosRowType == RowOperator) {
//        [self hidenKeyboard];
//    } else if (rowMo.iosRowType == RowOther) {
//        [self hidenKeyboard];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hidenKeyboard];
}

- (void)hidenKeyboard {
    if (_currentTextField) [_currentTextField resignFirstResponder];
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
//    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
//    vc.indexPath = indexPath;
//    vc.listVCdelegate = self;
//    vc.arrData = self.selectShowArr;
//    vc.title = self.arrLeft[indexPath.row];
//    NSString *str = self.arrTypeValue[indexPath.row];
//    if (![str isEqualToString:@"demo"]) {
//        vc.defaultValues = [[NSMutableArray alloc] initWithObjects:str, nil];
//    }
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MyTextFieldCellDelegate

#pragma mark - DefaultInputCellDelegate

- (void)cell:(DefaultInputCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    NSArray *sectionArr = self.arrData[indexPath.section];
    CommonRowMo *rowMo = sectionArr[indexPath.row];
    _currentTextField = textField;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (rowMo.editAble) {
            [_currentTextField becomeFirstResponder];
        } else {
            [_currentTextField resignFirstResponder];
        }
    });
}

- (void)cell:(DefaultInputCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArr = self.arrData[indexPath.section];
    CommonRowMo *rowMo = sectionArr[indexPath.row];
    rowMo.strValue = [Utils saveToValues:(textField.text)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - ListSelectViewCtrlDelegate

//- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
//
//    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:selectMo.moText])];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
//    if (indexPath.row == 0) {
//        FactoryMo *tmpMo = self.selectArr[index];
//        [self.arrTypeValue replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
//
//    } else if (indexPath.row == 2) {
//        EquipmentMo *tmpMo = self.selectArr[index];
//
//        [self.arrTypeValue replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%ld",(long)tmpMo.id]];
//        // 设备类型
//        if (tmpMo.type) {
//            [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:tmpMo.type[@"value"]]];
//            [self.arrTypeValue replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@",tmpMo.type[@"id"]]];
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        // 设备数量
//        [self.arrValues replaceObjectAtIndex:6 withObject:STRING(tmpMo.quantity)];
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//
//        [self refreshOpenAndALl];
//    }
//}

- (void)refreshOpenAndALl {
//    CGFloat x = 0;
//    if (![_arrValues[6] isEqualToString:@"demo"]) {
//        NSInteger open = [_arrValues[7] integerValue];
//        NSInteger all = [_arrValues[6] integerValue];
//        x = open * 1.0 / all;
//    }
//    [self.arrValues replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%.2f", x]];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
//    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    if (indexPath.row == 7) {
//        [self refreshOpenAndALl];
//    }
}

#pragma mark - event

- (void)problemAddAction:(UIButton *)sender {
    CreateProblemDescViewCtrl *vc = [[CreateProblemDescViewCtrl alloc] init];
    vc.title = @"新建客户详细";
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(ProblemDescMo *problemDescMo) {
        __strong typeof(self) strongself = weakself;
        [strongself.arrProblem addObject:problemDescMo];
        [strongself.tableView reloadData];
    };
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    
//    [self.arrProblem addObject:@"111"];
//    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
}

//- (void)createProductionPerformance:(NSArray *)attachments {
//    [Utils showHUDWithStatus:nil];
//
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    // 客户
//    [params setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
//    // 工厂
//    if ([Utils uploadToValues:self.arrValues[0]])
//        [params setObject:@{@"id":STRING(self.arrTypeValue[0])} forKey:@"factory"];
//    // 记录时间
//    if ([Utils uploadToValues:self.arrValues[1]])
//        [params setObject:STRING(self.arrValues[1]) forKey:@"recordDate"];
//    // 设备名称
//    if ([Utils uploadToValues:self.arrValues[2]])
//        [params setObject:@{@"id":STRING(self.arrTypeValue[2])} forKey:@"equipment"];
//    // 设备类型
//    if ([Utils uploadToValues:self.arrValues[3]]) {
//        [params setObject:@{@"id":STRING(self.arrTypeValue[3])} forKey:@"type"];
//        [params setObject:STRING(self.arrValues[3]) forKey:@"typeValue"];
//    }
//    // 设备尺寸
//    if ([Utils uploadToValues:self.arrValues[4]])
//        [params setObject:STRING(self.arrValues[4]) forKey:@"size"];
//
//    // 产品名称
//    if ([Utils uploadToValues:self.arrValues[5]])
//        [params setObject:STRING(self.arrValues[5]) forKey:@"name"];
//    // 设备数
//    // 开机数
//    if ([Utils uploadToValues:self.arrValues[7]])
//        [params setObject:STRING(self.arrValues[7]) forKey:@"bootedQuantity"];
//    // 开机率
//    NSString *str = self.arrValues[8];
//    [params setObject:[NSString stringWithFormat:@"%.0f", [str floatValue]*100] forKey:@"bootedRatio"];
//    // 先用氨纶批号
//    if ([Utils uploadToValues:self.arrValues[9]])
//        [params setObject:STRING(self.arrValues[9]) forKey:@"spandexNumber"];
//
//    // 氨纶生产日期
//    if ([Utils uploadToValues:self.arrValues[10]])
//        [params setObject:STRING(self.arrValues[10]) forKey:@"productionDate"];
//    // 绕线速度
//    if ([Utils uploadToValues:self.arrValues[11]])
//        [params setObject:STRING(self.arrValues[11]) forKey:@"spandexBackoffSpeed"];
//    // 张力
//    if ([Utils uploadToValues:self.arrValues[12]])
//        [params setObject:STRING(self.arrValues[12]) forKey:@"spandexBackoffTension"];
//    // 牵伸比
//    if ([Utils uploadToValues:self.arrValues[13]])
//        [params setObject:STRING(self.arrValues[13]) forKey:@"drawRation"];
//    // 产品使用情况
//    if ([Utils uploadToValues:self.arrValues[14]])
//        [params setObject:STRING(self.arrValues[14]) forKey:@"productUsingCondition"];
//
//    // 用量预估
//    if ([Utils uploadToValues:self.arrValues[15]])
//        [params setObject:STRING(self.arrValues[15]) forKey:@"usedQuantityExpected"];
//    // 气压
//    if ([Utils uploadToValues:self.arrValues[16]])
//        [params setObject:STRING(self.arrValues[16]) forKey:@"airPressure"];
//    // 客户氨纶库存
//    if ([Utils uploadToValues:self.arrValues[17]])
//        [params setObject:STRING(self.arrValues[17]) forKey:@"stockQuantity"];
//    // 客户成品库存
//    if ([Utils uploadToValues:self.arrValues[18]])
//        [params setObject:STRING(self.arrValues[18]) forKey:@"stockDays"];
//    // 备注
//    if ([Utils uploadToValues:self.arrValues[19]])
//        [params setObject:STRING(self.arrValues[19]) forKey:@"remark"];
//
//    if (_mo && !_enableSave) {
//        [[JYUserApi sharedInstance] updatePerformanceId:_mo.id param:params attachments:[Utils filterUrls:attachments arrFile:_mo.attachments] success:^(id responseObject) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:@"修改成功"];
//            NSError *error = nil;
//            PerformanceMo *tmpMo = [[PerformanceMo alloc] initWithDictionary:responseObject error:&error];
//            if (self.updateSuccess) {
//                self.updateSuccess(tmpMo);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//        }];
//    } else {
//        [[JYUserApi sharedInstance] createPerformanceParam:params attachments:attachments success:^(id responseObject) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:@"创建成功"];
//            if (self.updateSuccess) {
//                self.updateSuccess(nil);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//        }];
//    }
//}

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

- (NSMutableArray *)arrProblem {
    if (!_arrProblem) {
        _arrProblem = [NSMutableArray new];
    }
    return _arrProblem;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
        NSMutableArray *section0 = [NSMutableArray new];
        NSMutableArray *section1 = [NSMutableArray new];
        NSMutableArray *section3 = [NSMutableArray new];
        NSMutableArray *section4 = [NSMutableArray new];
        
        CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
        rowMo0.leftContent = @"客户名称";
        rowMo0.rightContent = @"请选择";
        rowMo0.rowType = K_INPUT_SELECT;
        rowMo0.editAble = YES;
        [section0 addObject:rowMo0];
        
        CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
        rowMo1.leftContent = @"申请人";
        rowMo1.rightContent = @"请选择";
        rowMo1.rowType = K_INPUT_SELECT;
        rowMo1.editAble = YES;
        [section0 addObject:rowMo1];
        
        CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
        rowMo2.leftContent = @"CS负责人";
        rowMo2.rightContent = @"请选择";
        rowMo2.rowType = K_INPUT_SELECT;
        rowMo2.editAble = YES;
        [section0 addObject:rowMo2];
        
        CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
        rowMo3.leftContent = @"投诉日期";
        rowMo3.rowType = K_DATE_SELECT;
        rowMo3.pattern = @"yyyy-MM-dd";
        rowMo3.rightContent = @"请填写";
        rowMo3.editAble = YES;
        [section0 addObject:rowMo3];
        
        CommonRowMo *rowMo31 = [[CommonRowMo alloc] init];
        rowMo31.leftContent = @"申请日期";
        rowMo31.rowType = K_DATE_SELECT;
        rowMo31.pattern = @"yyyy-MM-dd";
        rowMo31.rightContent = @"请填写";
        rowMo31.editAble = YES;
        [section0 addObject:rowMo31];
        
        CommonRowMo *rowMo32 = [[CommonRowMo alloc] init];
        rowMo32.leftContent = @"备注";
        rowMo32.rowType = K_INPUT_TEXT;
        rowMo32.inputType = K_LONG_TEXT;
        rowMo32.rightContent = @"请输入备注";
        rowMo32.editAble = YES;
        [section0 addObject:rowMo32];
        
        CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
        rowMo5.leftContent = @"小包/箱批次";
        rowMo5.rightContent = @"请填写";
        rowMo5.rowType = K_INPUT_TEXT;
        rowMo5.inputType = K_SHORT_TEXT;
        rowMo5.editAble = YES;
        [section1 addObject:rowMo5];
        
        CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
        rowMo4.leftContent = @"投诉产品";
        rowMo4.rightContent = @"请填写";
        rowMo4.rowType = K_INPUT_TEXT;
        rowMo4.inputType = K_SHORT_TEXT;
        rowMo4.editAble = YES;
        [section1 addObject:rowMo4];
        
        CommonRowMo *rowMo41 = [[CommonRowMo alloc] init];
        rowMo41.leftContent = @"发货日期";
        rowMo41.rowType = K_DATE_SELECT;
        rowMo41.pattern = @"yyyy-MM-dd";
        rowMo41.rightContent = @"请填写";
        rowMo41.editAble = YES;
        [section1 addObject:rowMo41];
        
        CommonRowMo *rowMo61 = [[CommonRowMo alloc] init];
        rowMo61.leftContent = @"发货单号";
        rowMo61.rightContent = @"请填写";
        rowMo61.rowType = K_INPUT_TEXT;
        rowMo61.inputType = K_SHORT_TEXT;
        rowMo61.keyBoardType = K_DEFAULT;
        rowMo61.editAble = YES;
        [section1 addObject:rowMo61];
        
        CommonRowMo *rowMo62 = [[CommonRowMo alloc] init];
        rowMo62.leftContent = @"发货数量";
        rowMo62.rightContent = @"请填写";
        rowMo62.rowType = K_INPUT_TEXT;
        rowMo62.inputType = K_SHORT_TEXT;
        rowMo62.keyBoardType = K_DEFAULT;
        rowMo62.editAble = YES;
        [section1 addObject:rowMo62];
        
        CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
        rowMo6.leftContent = @"销售订单号";
        rowMo6.rightContent = @"请填写";
        rowMo6.rowType = K_INPUT_TEXT;
        rowMo6.inputType = K_SHORT_TEXT;
        rowMo6.editAble = YES;
        [section1 addObject:rowMo6];
        
        CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
        rowMo7.leftContent = @"销售合同号";
        rowMo7.rightContent = @"请填写";
        rowMo7.rowType = K_INPUT_TEXT;
        rowMo7.inputType = K_SHORT_TEXT;
        rowMo7.editAble = YES;
        [section1 addObject:rowMo7];
        
        CommonRowMo *rowMo71 = [[CommonRowMo alloc] init];
        rowMo71.leftContent = @"责任发货工厂";
        rowMo71.rightContent = @"请选择";
        rowMo71.rowType = K_INPUT_SELECT;
        rowMo71.editAble = YES;
        [section1 addObject:rowMo71];
        
        CommonRowMo *rowMo13 = [[CommonRowMo alloc] init];
        rowMo13.leftContent = @"发生时间";
        rowMo13.rightContent = @"请选择";
        rowMo13.rowType = K_DATE_SELECT;
        rowMo13.pattern = @"yyyy-MM-dd";
        rowMo13.editAble = YES;
        [section1 addObject:rowMo13];
        
        CommonRowMo *rowMo14 = [[CommonRowMo alloc] init];
        rowMo14.leftContent = @"发生环节";
        rowMo14.rightContent = @"请选择";
        rowMo14.rowType = K_INPUT_SELECT;
        rowMo14.editAble = YES;
        [section1 addObject:rowMo14];
        
        CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
        rowMo8.leftContent = @"客户需要报告";
        rowMo8.rightContent = @"请选择";
        rowMo8.rowType = K_INPUT_SELECT;
//        rowMo8.selectType = K_JYSelectEnum;
        rowMo8.editAble = YES;
        [section3 addObject:rowMo8];
        
        CommonRowMo *rowMo81 = [[CommonRowMo alloc] init];
        rowMo81.leftContent = @"恢复截止期";
        rowMo81.rightContent = @"请选择";
        rowMo81.rowType = K_DATE_SELECT;
        rowMo81.pattern = @"yyyy-MM-dd";
        rowMo81.editAble = YES;
        [section3 addObject:rowMo81];
        
        CommonRowMo *rowMo12 = [[CommonRowMo alloc] init];
        rowMo12.leftContent = @"客户要求";
        rowMo12.rightContent = @"请填写";
        rowMo12.rowType = K_INPUT_TEXT;
        rowMo12.inputType = K_LONG_TEXT;
        rowMo12.keyBoardType = K_DEFAULT;
        rowMo12.editAble = YES;
        [section3 addObject:rowMo12];
        
        CommonRowMo *rowMo15 = [[CommonRowMo alloc] init];
        rowMo15.leftContent = @"附件";
        rowMo15.rightContent = @"请选择";
        rowMo15.rowType = K_FILE_INPUT;
        rowMo15.editAble = YES;
        [section4 addObject:rowMo15];
        
        [_arrData addObject:section0];
        [_arrData addObject:section1];
        [_arrData addObject:self.arrProblem];
        [_arrData addObject:section3];
        [_arrData addObject:section4];
    }
    return _arrData;
}

@end
