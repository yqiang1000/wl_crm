//
//  CreateTaskViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateTaskViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "AttachmentCell.h"
#import "WSDatePickerView.h"
#import "TaskSuggestionViewCtrl.h"
#import "DicMo.h"
#import "QiNiuUploadHelper.h"
#import "JYUserMoSelectViewCtrl.h"

@interface CreateTaskViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) NSMutableArray *arrTypeValues;
@property (nonatomic, strong) NSDictionary *dicMo;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSMutableArray *arrPerson1;
@property (nonatomic, strong) NSMutableArray *arrPerson2;
@property (nonatomic, assign) BOOL hidenPerson;

@property (nonatomic, strong) DicMo *typeDic;
@property (nonatomic, strong) DicMo *stateDic;
@property (nonatomic, strong) DicMo *remindTimeDic;

@property (nonatomic, strong) AttachmentCell *attCell;

@end

@implementation CreateTaskViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    if (_mo) {
        [self.rightBtn setTitle:@"新反馈" forState:UIControlStateNormal];
        self.title = @"任务协作详情";
    } else {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.title = @"新建任务";
    }
    [self setUI];
    [self defaultStates];
}

- (void)defaultStates {
    // 默认类型
    [self getMemberList:@"task_type" success:^(id responseObject) {
        NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
        for (DicMo *tmpMo in arr) {
            if ([tmpMo.key isEqualToString:@"assingn"]) {
                self.typeDic = tmpMo;
                [self.arrValues replaceObjectAtIndex:1 withObject:STRING([Utils saveToValues:STRING(tmpMo.value)])];
                [self.arrTypeValues replaceObjectAtIndex:1 withObject:STRING(tmpMo.id)];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    } failure:^(NSError *error) {
    }];
    // 默认状态
    [self getMemberList:@"task_status" success:^(id responseObject) {
        NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
        for (DicMo *tmpMo in arr) {
            if ([tmpMo.key isEqualToString:@"distributed"]) {
                self.stateDic = tmpMo;
                [self.arrValues replaceObjectAtIndex:2 withObject:STRING([Utils saveToValues:STRING(tmpMo.value)])];
                [self.arrTypeValues replaceObjectAtIndex:2 withObject:STRING(tmpMo.id)];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    } failure:^(NSError *error) {
    }];
    // 默认提醒时间
    [self getMemberList:@"task_remind_time" success:^(id responseObject) {
        NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
        for (DicMo *tmpMo in arr) {
            if ([tmpMo.key isEqualToString:@"half_day"]) {
                self.remindTimeDic = tmpMo;
                [self.arrValues replaceObjectAtIndex:3 withObject:STRING([Utils saveToValues:STRING(tmpMo.desp)])];
                [self.arrTypeValues replaceObjectAtIndex:3 withObject:STRING(tmpMo.id)];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    } failure:^(NSError *error) {
    }];
    
    NSString *dateStr = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm"];
    [self.arrValues replaceObjectAtIndex:6 withObject:STRING([Utils saveToValues:dateStr])];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
//        [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:STRING(_mo.title)]];
//        [self.arrValues replaceObjectAtIndex:1 withObject:[Utils saveToValues:STRING(_mo.type[@"value"])]];
//        [self.arrValues replaceObjectAtIndex:2 withObject:STRING(_mo.status[@"value"])];
//        [self.arrValues replaceObjectAtIndex:3 withObject:STRING(_mo.receiver[@"name"])];
//        [self.arrValues replaceObjectAtIndex:4 withObject:[Utils saveToValues: STRING(_mo.collaborator[@"name"])]];
//        [self.arrValues replaceObjectAtIndex:5 withObject:STRING(_mo.startTime)];
//        [self.arrValues replaceObjectAtIndex:6 withObject:STRING(_mo.endTime)];
//        [self.arrValues replaceObjectAtIndex:7 withObject:STRING(_mo.founder[@"name"])];
//        [self.arrValues replaceObjectAtIndex:8 withObject:STRING(_mo.remark)];
//
//        [self.arrTypeValues replaceObjectAtIndex:1 withObject:@([_mo.type[@"id"] integerValue])];
//        [self.arrTypeValues replaceObjectAtIndex:2 withObject: @([_mo.status[@"id"] integerValue])];
//        [self.arrTypeValues replaceObjectAtIndex:3 withObject:@([_mo.receiver[@"id"] integerValue])];
//        if (_mo.collaborator) {
//            [self.arrValues replaceObjectAtIndex:4 withObject:@([_mo.collaborator[@"id"] integerValue])];
//        }
//        [self.arrTypeValues replaceObjectAtIndex:7 withObject:@([_mo.founder[@"id"] integerValue])];
//
//        for (QiniuFileMo *tmpMo in _mo.attachments) {
//            [self.attachments addObject:STRING(tmpMo.url)];
//        }
        
    } else {
        _hidenPerson = NO;
        [self.arrValues replaceObjectAtIndex:8 withObject:STRING(TheUser.userMo.name)];
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
    if (_hidenPerson) {
        if (indexPath.row == 4 || indexPath.row == 5) {
            return 0;
        }
    }
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
        if (!_attCell) {
            _attCell = [[AttachmentCell alloc] init];
            _attCell.count = 9;
            _attCell.attachments = _mo.attachmentList;
            _attCell.forbidDelete = _mo ? YES : NO;
            [_attCell refreshView];
        }
        return _attCell;
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
    if (indexPath.row == 4 || indexPath.row == 5) {
        cell.hidenContent = _hidenPerson;
    } else {
        cell.hidenContent = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_mo) {
        return;
    }
    if (indexPath.row == 1) {
        NSString *name = @"task_type";
        [self getMemberList:name success:^(id responseObject) {
            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
            [self.selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (DicMo *tmpMo in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = tmpMo.id;
                mo.moText = tmpMo.value;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
        }];
    }
    // 提醒时间
    else if (indexPath.row == 3) {
        NSString *name = @"task_remind_time";
        [self getMemberList:name success:^(id responseObject) {
            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
            [self.selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (DicMo *tmpMo in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = tmpMo.id;
                mo.moText = tmpMo.desp;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
        }];
    }
    // 负责人
    else if (indexPath.row == 4) {
//        [Utils showHUDWithStatus:nil];
//        [[JYUserApi sharedInstance] getTaskReceiverRules:nil success:^(id responseObject) {
//            [Utils dismissHUD];
//            self.selectArr = [JYUserMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
//            [_selectShowArr removeAllObjects];
//            _selectShowArr = nil;
//            for (JYUserMo *tmpMo in self.selectArr) {
//                ListSelectMo *mo = [[ListSelectMo alloc] init];
//                mo.moId = [NSString stringWithFormat:@"%ld", (long)tmpMo.id];
//                mo.moText = tmpMo.name;
//                [self.selectShowArr addObject:mo];
//            }
//            [self pushToSelectVC:indexPath];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//        }];
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.indexPath = indexPath;
        vc.VcDelegate = self;
        vc.isMultiple = YES;
        vc.defaultValues = self.arrPerson1;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 协办人
    else if (indexPath.row == 5) {
//        [Utils showHUDWithStatus:nil];
//        [[JYUserApi sharedInstance] getTaskCollaboratorRules:nil success:^(id responseObject) {
//            [Utils dismissHUD];
//            self.selectArr = [JYUserMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
//            [_selectShowArr removeAllObjects];
//            _selectShowArr = nil;
//            for (JYUserMo *tmpMo in self.selectArr) {
//                ListSelectMo *mo = [[ListSelectMo alloc] init];
//                mo.moId = [NSString stringWithFormat:@"%ld", tmpMo.id];
//                mo.moText = tmpMo.name;
//                [self.selectShowArr addObject:mo];
//            }
//            [self pushToSelectVC:indexPath];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//        }];
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.indexPath = indexPath;
        vc.VcDelegate = self;
        vc.isMultiple = YES;
        vc.defaultValues = self.arrPerson2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 开始时间结束时间
    else if (indexPath.row == 6 || indexPath.row == 7) {
        NSDate *scrollToDate = [NSDate date:self.arrValues[indexPath.row] WithFormat:@"yyyy-MM-dd HH:mm"];
        __weak typeof(self) weakself = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            NSLog(@"选择的日期：%@",date);
            [weakself.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:date])];
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    }
    // 创建人
    else if (indexPath.row == 8) {
        // 默认自己
    } else if (indexPath.row == 0 || indexPath.row == 9) {
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 20;
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.arrLeft.count - 1) {
        // 附件
    }
}

- (PickerUtilType)compareBegin:(NSDate *)timeBegin end:(NSDate *)timeEnd {
    
    NSLog(@"\n时间1:%@\n时间2:%@", timeBegin, timeEnd);
    //开始时间和当前时间比较
//    NSComparisonResult res1 = [[NSDate date] compare:timeBegin];
//
//    if (res1 == NSOrderedAscending) {
        //选择开始时间
        if (timeEnd == nil) {
            // 返回正常
            return PickerUtilTypeDefault;
        } else {
            NSComparisonResult result = [timeBegin compare:timeEnd];
            if (result == NSOrderedAscending) {  //升序
                // 返回正常
                return PickerUtilTypeDefault;
            } else {
                // 结束时间不能早于开始时间
                return PickerUtilTypeBegin;
            }
        }
//    } else {
//        //返回“开始时间不能早于当前时间”
//        return PickerUtilTypeNow;
//    }
}

//- (void)getContactListSuccess:(void (^)(id responseObject))success
//                      failure:(void (^)(NSError *error))fail {
//    NSMutableArray *rules = [NSMutableArray new];
//    [rules addObject:@{@"field":@"department.id",
//                       @"option":@"EQ",
//                       @"values":@[STRING(TheUser.userMo.department[@"id"])]}];
//    [[JYUserApi sharedInstance] getDepartmentPersonRules:rules success:^(id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        if (fail) {
//            fail(error);
//        }
//    }];
//}

- (void)getMemberList:(NSString *)name
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))fail {
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getConfigDicByName:name success:^(id responseObject) {
        [Utils dismissHUD];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        if (fail) {
            fail(error);
        }
    }];
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = self.arrLeft[indexPath.row];
    if (indexPath.row == 1 || indexPath.row == 3) {
        vc.byText = YES;
        vc.isMultiple = NO;
        vc.defaultValues = [[NSMutableArray alloc] initWithObjects:self.arrValues[indexPath.row], nil];
    } else {
        vc.isMultiple = YES;
        if (indexPath.row == 4) {
            vc.defaultValues = self.arrPerson1;
        } else {
            vc.defaultValues = self.arrPerson2;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:selectMo.moText])];
    // 字典
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        DicMo *tmpMo = self.selectArr[index];
        [self.arrTypeValues replaceObjectAtIndex:indexPath.row withObject:STRING(tmpMo.id)];
        if (indexPath.row == 1) {
            _hidenPerson = [tmpMo.key isEqualToString:@"assingn"] ? NO : YES;
            self.typeDic = tmpMo;
        } else if (indexPath.row == 2) {
            self.stateDic = tmpMo;
        } else if (indexPath.row == 3) {
            self.remindTimeDic = tmpMo;
        }
    }
    [self.tableView reloadData];
}

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath {
    NSString *str = [[NSString alloc] init];
    if (indexPath.row == 4) {
        [self.arrPerson1 removeAllObjects];
        for (int i = 0; i < selectIndexPaths.count; i++) {
            NSIndexPath *tmpIndex = selectIndexPaths[i];
            JYUserMo *tmpMo = self.selectArr[tmpIndex.row];
            [self.arrPerson1 addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
            str = [str stringByAppendingString:STRING(tmpMo.name)];
            if (i < selectIndexPaths.count - 1) {
                str = [str stringByAppendingString:@","];
            }
        }
    } else if (indexPath.row == 5) {
        [self.arrPerson2 removeAllObjects];
        for (int i = 0; i < selectIndexPaths.count; i++) {
            NSIndexPath *tmpIndex = selectIndexPaths[i];
            JYUserMo *tmpMo = self.selectArr[tmpIndex.row];
            [self.arrPerson2 addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
            str = [str stringByAppendingString:STRING(tmpMo.name)];
            if (i < selectIndexPaths.count - 1) {
                str = [str stringByAppendingString:@","];
            }
        }
    }
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:str]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - JYUserMoSelectViewCtrlDelegate

- (void)JYUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)JYUserMoSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(JYUserMo *)selectMo {
    
}

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectedData:(NSArray *)selectedData indexPath:(NSIndexPath *)indexPath {
    NSString *str = [[NSString alloc] init];
    if (indexPath.row == 4) {
        [self.arrPerson1 removeAllObjects];
        for (int i = 0; i < selectedData.count; i++) {
            JYUserMo *tmpMo = selectedData[i];
            [self.arrPerson1 addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
            str = [str stringByAppendingString:STRING(tmpMo.name)];
            if (i < selectedData.count - 1) {
                str = [str stringByAppendingString:@","];
            }
        }
    } else if (indexPath.row == 5) {
        [self.arrPerson2 removeAllObjects];
        for (int i = 0; i < selectedData.count; i++) {
            JYUserMo *tmpMo = selectedData[i];
            [self.arrPerson2 addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
            str = [str stringByAppendingString:STRING(tmpMo.name)];
            if (i < selectedData.count - 1) {
                str = [str stringByAppendingString:@","];
            }
        }
    }
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:str]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)jyUserMoSelectViewCtrlDismiss:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl {
    jyUserMoSelectViewCtrl = nil;
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.row == 2) {
    //        self.createRiskMo.title = content;
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //    }
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    if (_mo) {
        // 反馈
        TaskSuggestionViewCtrl *vc = [[TaskSuggestionViewCtrl alloc] init];
        vc.mo = self.mo;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 新建
        [self createTask];
    }
}

- (void)createTask {
   
    for (int i = 0; i < self.arrValues.count - 1; i++) {
        if (i != 4 && i != 5 && i != 9) {
            if ([self.arrValues[i] isEqualToString:@"demo"]) {
                [Utils showToastMessage:@"请完善信息"];
                return;
            }
        }
    }
    
    if (self.arrPerson1.count == 0 && !_hidenPerson) {
        [Utils showToastMessage:@"请选择责任人"];
        return;
    }
    
//        PickerUtilTypeDefault   = 0,    // 正常
//        PickerUtilTypeNow,              // 开始时间不能早于当前时间
//        PickerUtilTypeBegin,            // 结束时间不能早于开始时间
    
    NSDate *dateBegin = [NSDate date:self.arrValues[6] WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateEnd = [NSDate date:self.arrValues[7] WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    PickerUtilType type = [self compareBegin:dateBegin end:dateEnd];
    if (type == PickerUtilTypeNow) {
        [Utils showToastMessage:@"开始日期不能早于当前日期"];
        return;
    } else
    if (type == PickerUtilTypeBegin) {
        [Utils showToastMessage:@"结束日期不能早于开始日期"];
        return;
    }

    if (_attCell.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadFileMulti:_attCell.attachments success:^(id responseObject) {
            [self newTask:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self newTask:@[]];
    }
}

- (void)newTask:(NSArray *)attachments {
    [Utils showHUDWithStatus:nil];
    NSMutableDictionary *params = [NSMutableDictionary new];
//    remindTimeKey remindTimeValue
//    typeKey typeValue
//    statusKey statusValue
    [params setObject:STRING(self.arrValues[0]) forKey:@"title"];
    
    [params setObject:STRING(self.typeDic.key) forKey:@"typeKey"];
    [params setObject:STRING(self.typeDic.value) forKey:@"typeValue"];
    [params setObject:STRING(self.stateDic.key) forKey:@"statusKey"];
    [params setObject:STRING(self.stateDic.value) forKey:@"statusValue"];
    [params setObject:STRING(self.remindTimeDic.key) forKey:@"remindTimeKey"];
    [params setObject:STRING(self.remindTimeDic.value) forKey:@"remindTimeValue"];
    // 指派人
    [params setObject:@{@"id":@(TheUser.userMo.id)} forKey:@"founder"];
    
    //    receiverSet 责任人
    //    collaboratorSet 协助人
    //    founder 创建人
    
    if (!_hidenPerson) {
        // 协助人接受人多选
        NSMutableArray *receiverSet = [NSMutableArray new];
        for (NSString *userId in self.arrPerson1) {
            [receiverSet addObject:@{@"id":STRING(userId)}];
        }
        [params setObject:receiverSet forKey:@"receiverSet"];
        
        NSMutableArray *collaboratorSet = [NSMutableArray new];
        for (NSString *userId in self.arrPerson2) {
            [collaboratorSet addObject:@{@"id":STRING(userId)}];
        }
        [params setObject:collaboratorSet forKey:@"collaboratorSet"];
    }
    
    NSString *startTime = [self.arrValues[6] stringByAppendingString:@":00"];
    NSString *endTime = [self.arrValues[7] stringByAppendingString:@":00"];
    [params setObject:startTime forKey:@"startTime"];
    [params setObject:endTime forKey:@"endTime"];
    [params setObject:[self.arrValues[9] isEqualToString:@"demo"] ? @"" : STRING(self.arrValues[9]) forKey:@"remark"];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachments) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    if (arr.count > 0) [params setObject:arr forKey:@"attachmentList"];
    
    [[JYUserApi sharedInstance] createTaskParam:params attachments:nil success:^(id responseObject) {
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
        _arrLeft = @[@"任务名称",
                     @"类型",
                     @"状态",
                     @"提醒时间",
                     @"责任人",
                     
                     @"协办人",
                     @"开始日期",
                     @"结束日期",
                     @"创建人",
                     @"备注",
                     
                     @"附件"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请输入",
                      @"请选择",
                      @"请选择",
                      @"请选择",
                      @"请选择",
                      
                      @"请选择",
                      @"请选择",
                      @"请选择",
                      @"请选择",
                      @"请输入",
                      
                      @"附件"];;
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

- (NSMutableArray *)arrTypeValues {
    if (!_arrTypeValues) {
        _arrTypeValues = [NSMutableArray new];
        for (int i = 0; i < self.arrLeft.count; i++) {
            [_arrTypeValues addObject:@"demo"];
        }
    }
    return _arrTypeValues;
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

- (NSMutableArray *)arrPerson1 {
    if (!_arrPerson1) {
        _arrPerson1 = [NSMutableArray new];
    }
    return _arrPerson1;
}

- (NSMutableArray *)arrPerson2 {
    if (!_arrPerson2) {
        _arrPerson2 = [NSMutableArray new];
    }
    return _arrPerson2;
}

@end
