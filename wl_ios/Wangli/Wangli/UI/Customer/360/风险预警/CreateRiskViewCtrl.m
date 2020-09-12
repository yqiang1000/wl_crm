//
//  CreateRiskViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/4.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "CreateRiskViewCtrl.h"
#import "MyCommonCell.h"
#import "AttachmentCell.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "WSDatePickerView.h"
#import "RiskListMo.h"
#import "QiNiuUploadHelper.h"
#import "DicMo.h"
#import "MemberSelectViewCtrl.h"

@interface CreateRiskViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyTextViewCellDelegate, ListSelectViewCtrlDelegate, MemberSelectViewCtrlDelegate, EditTextViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrLeft;                 //标题固定
@property (nonatomic, strong) NSArray *arrRight;                //占位文字
@property (nonatomic, strong) NSMutableArray *arrValues;        //实际修改以后的文字,默认为demo
@property (nonatomic, strong) UITextView *currentTextView;

@property (nonatomic, strong) NSMutableArray *selectArr;        //选择选项
@property (nonatomic, strong) NSMutableArray *selectShowArr;    //选择页面显示选项

@property (nonatomic, strong) NSMutableArray *arrAttach;
@property (nonatomic, strong) DicMo *dicMo;

@end

@implementation CreateRiskViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_mo) {
        self.title = @"修改风险预警";
        self.dicMo = [[DicMo alloc] initWithDictionary:_mo.type error:nil];
        for (QiniuFileMo *tmpMo in _mo.attachmentList) {
            [self.arrAttach addObject:STRING(tmpMo.url)];
        }
    } else {
        self.title = @"新建风险预警";
    }
    [self config];
    [self setUI];
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
}

- (void)config {
    if (_mo) {
        // 修改
        [self.arrValues replaceObjectAtIndex:0 withObject:STRING(_dicMo.value)];
        [_arrValues replaceObjectAtIndex:1 withObject:STRING(TheCustomer.customerMo.orgName)];
        [_arrValues replaceObjectAtIndex:2 withObject:STRING(_mo.title)];
        if (_mo.riskManageHandleDate.length > 0) {
            [_arrValues replaceObjectAtIndex:3 withObject:STRING([_mo.riskManageHandleDate substringToIndex:10])];
        } else {
            NSString *date = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
            [_arrValues replaceObjectAtIndex:3 withObject:date];
        }
        [_arrValues replaceObjectAtIndex:4 withObject:STRING(_mo.content)];
    } else {
        // 新建
        if (!_fromChat) {
            [self.arrValues replaceObjectAtIndex:1 withObject:STRING(TheCustomer.customerMo.orgName)];
        }
        NSString *date = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
        [self.arrValues replaceObjectAtIndex:3 withObject:STRING(date)];
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
    if (indexPath.row == 4) {
        return 76;
    } else if (indexPath.row == 5) {
        return 120;
    }
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        // 内容
        static NSString *cellId = @"contentCell";
        MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell setLeftText:self.arrLeft[indexPath.row]];
            cell.placeholder = self.arrRight[indexPath.row];
            cell.cellDelegate = self;
        }
        cell.indexPath = indexPath;
        cell.txtView.text = [Utils showTextRightStr:@"" valueStr:self.arrValues[indexPath.row]].text;
        return cell;
    }
    else if (indexPath.row == 5) {
        // 附件
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
    else {
        static NSString *cellId = @" ";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.labLeft.textColor = COLOR_B1;
            cell.labRight.textColor = COLOR_B2;
        }
        [cell setLeftText:self.arrLeft[indexPath.row]];
        ShowTextMo *showTextMo = [Utils showTextRightStr:self.arrRight[indexPath.row] valueStr:self.arrValues[indexPath.row]];
        cell.labRight.textColor = showTextMo.color;
        cell.labRight.text = showTextMo.text;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getConfigDicByName:@"risk_type" success:^(id responseObject) {
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
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
        }];
    }
    if (indexPath.row == 1) {
        // 默认客户
        if (_fromChat) {
            MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
            vc.needRules = NO;
            vc.VcDelegate = self;
            vc.defaultId = TheCustomer.customerMo.id;
            vc.indexPath = indexPath;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
        }
    }
    if (indexPath.row == 2) {
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 15;
        vc.placeholder = @"请输入标题";
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *scrollToDate = [minDateFormater dateFromString:self.arrValues[indexPath.row]];

        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",date);
            [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:date])];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    }
    else if (indexPath.row == 1) {
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.currentTextView resignFirstResponder];
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:self.arrValues[indexPath.row], nil];
    vc.title = self.arrLeft[indexPath.row];
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MyTextViewCellDelegate

- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    self.currentTextView = textView;
}

- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:textView.text])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:selectMo.moText])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (indexPath.row == 0) {
        _dicMo = self.selectArr[index];
    }
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        TheCustomer.customerMo = model;
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:model.orgName]];
        
        [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:model.orgName])];
        if (indexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    if (_currentTextView) {
        [self.arrValues replaceObjectAtIndex:4 withObject:STRING([Utils saveToValues:_currentTextView.text])];
    }
    for (int i = 0 ; i < self.arrValues.count-1; i++) {
        NSString *obj = self.arrValues[i];
        if ([obj isEqualToString:@"demo"]) {
            [Utils showToastMessage:@"请完善信息"];
            return;
        }
    }
    
    AttachmentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self createRisk:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建预警
        [self createRisk:@[]];
    }
}

- (void)createRisk:(NSArray *)attachementList {
    [Utils showHUDWithStatus:nil];
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@{@"id":STRING(_dicMo.id),
                       @"value":STRING(_dicMo.value),
                       @"key":STRING(_dicMo.key)} forKey:@"type"];
    [param setObject:STRING(self.arrValues[2]) forKey:@"title"];
    [param setObject:STRING(self.arrValues[3]) forKey:@"riskManageHandleDate"];
    [param setObject:STRING(_arrValues[4]) forKey:@"content"];
    [param setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    [param setObject:@{@"id":@(TheUser.userMo.id)} forKey:@"operator"];
    
    
    if (_mo) {
        [[JYUserApi sharedInstance] updateRiskWarnByRiskId:_mo.id param:param attachmentList:[Utils filterUrls:attachementList arrFile:_mo.attachmentList] success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
            RiskFollowMo *tmpMo = [[RiskFollowMo alloc] initWithDictionary:responseObject error:nil];
            if (self.createUpdateSuccess) {
                self.createUpdateSuccess(tmpMo);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createRiskWarnParam:param attachmentList:attachementList success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"创建成功"];
            if (self.createUpdateSuccess) {
                self.createUpdateSuccess(nil);
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
        _arrLeft = @[@"预警类型",
                     @"客户",
                     @"标题",
                     @"日期",
                     @"内容",
                     @"附件"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择风险类型",
                      @"请选择客户",
                      @"请输入",
                      @"请选择",
                      @"请输入详细内容",
                      @"附件"];
    }
    return _arrRight;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0; i < self.arrRight.count; i++) {
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

- (NSMutableArray *)arrAttach {
    if (!_arrAttach) {
        _arrAttach = [NSMutableArray new];
    }
    return _arrAttach;
}

@end
