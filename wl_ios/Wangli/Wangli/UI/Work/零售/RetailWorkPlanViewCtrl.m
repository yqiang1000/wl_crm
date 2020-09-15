//
//  RetailWorkPlanViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/4/17.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "RetailWorkPlanViewCtrl.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "AttachmentCell.h"
#import "MemberSelectViewCtrl.h"
#import "WSDatePickerView.h"
#import "UIButton+ShortCut.h"
#import "QiNiuUploadHelper.h"
#import "CommonRowMo.h"
#import "JYUserMoSelectViewCtrl.h"
#import "RetailItemViewCtrl.h"
#import "RetailItemCell.h"
#import "AddressPickerView.h"
#import "QiniuFileMo.h"

@interface RetailWorkPlanViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, MyTextViewCellDelegate, DefaultInputCellDelegate, MemberSelectViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, MySwitchCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;      // 表单模型数组
@property (nonatomic, strong) NSMutableArray *attachments;  // 缩略图
@property (nonatomic, strong) NSMutableArray *attachUrls;   // 图片
@property (nonatomic, strong) NSMutableArray *arrMembers;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UITextView *currentTextView;
@property (nonatomic, strong) AttachmentCell *attCell;
@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, strong) NSArray *arrAddIds;
@property (nonatomic, strong) NSArray *arrAddNames;
@property (nonatomic, strong) CommonRowMo *attRowMo;
@property (nonatomic, strong) NSMutableArray *arrProvince;
@property (nonatomic, assign) BOOL isOperator;
@property (nonatomic, assign) BOOL isToday;

/** 新建时候 YES：是，NO：不是 */
@property (nonatomic, assign) BOOL createDate;
/** 在计划工作时间之前 YES：是，NO：不是 */
@property (nonatomic, assign) BOOL beforeDate;
/** 上班两小时后到次日上班前 YES：是，NO：不是 */
@property (nonatomic, assign) BOOL handleDate;
/** 次日上班后 YES：是，NO：不是 */
@property (nonatomic, assign) BOOL afterDate;

//零售
//1.新建的时候，未处理事项不可编辑，第二天上班后可以修改
//2.计划时间在当日上班后不能删除修改
//3.走访必填，自动带出地址上的客户
//战略
//1.新建时，达成结果不可输入，编辑时，达成结果必填，第二天上班允许修改达成结果
//2.达成结果计划工作日期次日才能填写
//直营
//1.新建时，达成结果不可输入，编辑时，达成结果比天，第二天上班允许修改达成结果
//2.达成结果计划工作日期次日才能填写
//华爵，能诚，与以上一致
//未处理事项都一致
//所有工作计划
//计划提交时间：计划工作日期的前一天下班后至当日上班前；
//计划更改时间：在计划工作日期的当日上班两小时后至次日上班前可以更改，次日上班后可不更改
//工作计划已填写内容在计划日期上班后不允许更改

// 新增获取昨日数据
// 1.判断是否是修改页面
// 2.如果是修改：获取model
//      2.1 获取服务器时间，比较是否能编辑
//      2.2 更新行项目数据
// 3.如果不是修改
//      3.1 判断是否能编辑
//      3.2 更新行项目
// （3）逻辑修改：先获取昨日数据，赋值

@end

@implementation RetailWorkPlanViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    if (self.model) {
        [self.rightBtn setTitle:@"更新" forState:UIControlStateNormal];
        self.isUpdate = YES;
        [self getDetailModel];
    } else {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self ccanEdit];
    }
    
    if (self.yesterdayData) {
        [self getYesterDayDataWorkType];
    }
    
    // 监听键盘高度变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hidenKeyboard];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)getYesterDayDataWorkType {
    [Utils showHUDWithStatus:nil];
    NSString *yesterdayStr = [[Utils getDateDayOffset:-1 mydate:[NSDate date]]  stringWithFormat:@"yyyy-MM-dd"];
    [[JYUserApi sharedInstance] getYesterdayWorkDataWorkType:WORKTYPE_RETAIL_CHANNEL param:@{@"loginOperator":@(TheUser.userMo.id), @"yesterday":yesterdayStr} success:^(id responseObject) {
        [Utils dismissHUD];
        NSError *error = nil;
        self.model = [[RetailChannelMo alloc] initWithDictionary:responseObject error:&error];
        self.createDate = YES;
        self.beforeDate = self.handleDate = self.afterDate = NO;
        self.rightBtn.hidden = NO;
        [self configRowMos];
        self.model = nil;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self configRowMos];
        [self.tableView reloadData];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

// 修改页面获取详情
- (void)getDetailModel {
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getRetailChannelDetail:self.model.id param:nil success:^(id responseObject) {
        [Utils dismissHUD];
        NSError *error = nil;
        self.model = [[RetailChannelMo alloc] initWithDictionary:responseObject error:&error];
        self.isOperator = (TheUser.userMo.id == [self.model.operator[@"id"] integerValue]) ? YES : NO;
        [self getDate];
        [self configRowMos];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self configRowMos];
        [self.tableView reloadData];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

// 获取服务器时间
- (void)getDate {
    [[JYUserApi sharedInstance] getDateTodayParam:nil success:^(id responseObject) {
        [Utils dismissHUD];
        NSString *serviceDate = responseObject[@"today"];
        self.isToday = [serviceDate isEqualToString:self.model.date] ? YES : NO;
        [self ccanEdit];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

// 判断是否可编辑
- (void)ccanEdit {
    if (self.model) {
        _createDate = NO;
        _beforeDate = [self.model.handleStatus isEqualToString:K_BEFORE_WORKPLAN_DATE]?YES:NO;
        _handleDate = [self.model.handleStatus isEqualToString:K_HANDLE_WORKPLAN_DATE]?YES:NO;
        _afterDate = [self.model.handleStatus isEqualToString:K_BEYOND_SETTIME]?YES:NO;
        // 新建，上班前，上班中，上班后都可以修改，当前用户可以修改
        self.rightBtn.hidden = self.afterDate?YES:!self.isOperator;
    } else {
        _createDate = YES;
        _beforeDate = _handleDate = _afterDate = NO;
        self.rightBtn.hidden = NO;
    }
    [self configRowMos];
}

- (void)configRowMos {
    [self.arrData removeAllObjects];
    self.arrData = nil;
    
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_OPERATOR;
    rowMo0.leftContent = @"业务员";
    rowMo0.inputType = K_SHORT_TEXT;
    rowMo0.rightContent = @"请选择";
    rowMo0.key = @"operator";
    NSError *error = nil;
    if (self.model) {
        JYUserMo *userMo = [[JYUserMo alloc] initWithDictionary:self.model.operator error:&error];
        rowMo0.m_obj = userMo;
        rowMo0.strValue = self.model.operator[@"name"];
    } else {
        rowMo0.m_obj = TheUser.userMo;
        rowMo0.strValue = TheUser.userMo.name;
    }
    rowMo0.editAble = NO;
    [self.arrData addObject:rowMo0];
    
    CommonRowMo *rowMoPro = [[CommonRowMo alloc] init];
    rowMoPro.rowType = K_INPUT_TEXT;
    rowMoPro.leftContent = @"省份";
    rowMoPro.inputType = K_SHORT_TEXT;
    rowMoPro.rightContent = @"请选择";
    rowMoPro.editAble = self.createDate;
    rowMoPro.mutiAble = YES;
    rowMoPro.key = @"province";
    if (self.model) rowMoPro.strValue = STRING(self.model.province);
    [self.arrData addObject:rowMoPro];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_TEXT;
    rowMo1.leftContent = @"当月销售目标";
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.rightContent = @"自动带出";
    rowMo1.editAble = NO;
    rowMo1.key = @"salesTarget";
    if (self.model) {
        rowMo1.strValue = [Utils getPriceFrom:self.model.salesTarget];
        rowMo1.m_obj = [Utils getPriceFrom:self.model.salesTarget];
        rowMo1.value = [Utils getPriceFrom:self.model.salesTarget];
    }
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_TEXT;
    rowMo2.leftContent = @"当月累计发货量";
    rowMo2.inputType = K_SHORT_TEXT;
    rowMo2.rightContent = @"自动带出";
    rowMo2.editAble = NO;
    rowMo2.key = @"cumulativeShipments";
    if (self.model) {
        rowMo2.strValue = [Utils getPriceFrom:self.model.cumulativeShipments];
        rowMo2.m_obj = [Utils getPriceFrom:self.model.cumulativeShipments];
        rowMo2.value = [Utils getPriceFrom:self.model.cumulativeShipments];
    }
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_TEXT;
    rowMo3.leftContent = @"当日预计发货量";
    rowMo3.inputType = K_SHORT_TEXT;
    rowMo3.rightContent = @"请输入";
    rowMo3.editAble = self.beforeDate || self.createDate;
    rowMo3.keyBoardType = K_DOUBLE;
    rowMo3.key = @"projectedShipment";
    if (self.model.projectedShipment > 0) {
        rowMo3.strValue = [Utils getPriceFrom:self.model.projectedShipment];
        rowMo3.m_obj = [Utils getPriceFrom:self.model.projectedShipment];
        rowMo3.value = [Utils getPriceFrom:self.model.projectedShipment];
    }
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_TEXT;
    rowMo4.leftContent = @"当日实际发货量";
    rowMo4.inputType = K_SHORT_TEXT;
    rowMo4.rightContent = @"自动带出";
    rowMo4.editAble = NO;//self.beforeDate || self.createDate;
    rowMo4.keyBoardType = K_DOUBLE;
    rowMo4.key = @"actualShipment";
    if (self.model.actualShipment) {
        rowMo4.strValue = [Utils getPriceFrom:self.model.actualShipment];
        rowMo4.m_obj = [Utils getPriceFrom:self.model.actualShipment];
        rowMo4.value = [Utils getPriceFrom:self.model.actualShipment];
    }
    [self.arrData addObject:rowMo4];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_INPUT_TEXT;
    rowMo5.leftContent = @"月目标完成率(%)";
    rowMo5.inputType = K_SHORT_TEXT;
    rowMo5.rightContent = @"自动计算";
    rowMo5.editAble = NO;
    rowMo5.key = @"ompletionRate";
    if (self.model.ompletionRate > 0) {
        rowMo5.strValue = [Utils getPriceFrom:self.model.ompletionRate];
        rowMo5.m_obj = [Utils getPriceFrom:self.model.ompletionRate];
        rowMo5.value = [Utils getPriceFrom:self.model.ompletionRate];
    }
    [self.arrData addObject:rowMo5];
    
    CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
    rowMo6.rowType = K_INPUT_TEXT;
    rowMo6.leftContent = @"走访市场";
    rowMo6.inputType = K_SHORT_TEXT;
    rowMo6.rightContent = @"请选择";
    rowMo6.editAble = self.beforeDate || self.createDate;
    rowMo6.key = @"address";
    if (self.model) {
        _arrAddIds = nil;
        _arrAddNames = nil;
        NSString *address = @"";
        if (self.model.provinceName.length > 0) address = [address stringByAppendingString:self.model.provinceName];
        if (self.model.cityName.length > 0) address = [address stringByAppendingString:self.model.cityName];
        if (self.model.areaName.length > 0) address = [address stringByAppendingString:self.model.areaName];
        rowMo6.strValue = STRING(address);
        self.arrAddIds = @[STRING(_model.provinceNumber), STRING(_model.cityNumber), STRING(_model.areaNumber)];
        self.arrAddNames = @[STRING(_model.provinceName), STRING(_model.cityName), STRING(_model.areaName)];
    }
    [self.arrData addObject:rowMo6];
    
    CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
    rowMo7.rowType = K_INPUT_TEXT;
    rowMo7.leftContent = @"预计走访客户";
    rowMo7.inputType = K_SHORT_TEXT;
    rowMo7.rightContent = @"自动带出";
    rowMo7.editAble = NO;
    rowMo7.key = @"expectVisit";
    if (self.model) {
        rowMo7.strValue = [NSString stringWithFormat:@"%ld", (long)self.model.expectVisit];
    }
    [self.arrData addObject:rowMo7];
    
    CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
    rowMo8.rowType = K_INPUT_TEXT;
    rowMo8.leftContent = @"实际走访客户";
    rowMo8.inputType = K_SHORT_TEXT;
    rowMo8.rightContent = @"自动带出";
    rowMo8.editAble = NO;
    rowMo8.key = @"actualVisit";
    if (self.model) {
        rowMo8.strValue = [NSString stringWithFormat:@"%ld", (long)self.model.actualVisit];
    }
    [self.arrData addObject:rowMo8];
    
    CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
    rowMo9.rowType = K_INPUT_TEXT;
    rowMo9.leftContent = @"售后未处理事项";
    rowMo9.inputType = K_LONG_TEXT;
    rowMo9.rightContent = @"请输入";
    rowMo9.editAble = self.handleDate;
    // 如果新建为空，之后可为空可不为空
    rowMo9.nullAble = YES;
    rowMo9.key = @"afterSaleUnprocessed";
    rowMo9.strValue = self.model.afterSaleUnprocessed;
    [self.arrData addObject:rowMo9];
    
    CommonRowMo *rowMo10 = [[CommonRowMo alloc] init];
    rowMo10.rowType = K_INPUT_TEXT;
    rowMo10.leftContent = @"活动";
    rowMo10.inputType = K_SHORT_TEXT;
    rowMo10.rightContent = @"请输入";
    rowMo10.editAble = !self.afterDate;
    rowMo10.nullAble = YES;
    rowMo10.key = @"activity";
    rowMo10.strValue = self.model.activity;
    [self.arrData addObject:rowMo10];
    
    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.rowType = K_INPUT_TOGGLEBUTTON;
    rowMo11.leftContent = @"活动是否完成";
    rowMo11.inputType = K_SHORT_TEXT;
    rowMo11.rightContent = @"请输入";
    rowMo11.editAble = self.handleDate;
    rowMo11.key = @"finish";
    rowMo11.defaultValue = self.model.finish;
    rowMo11.strValue = self.model.finish ? @"YES" : @"NO";
    [self.arrData addObject:rowMo11];
    
//    NSDate *today = [NSDate date];
//    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:today];//后一天
    CommonRowMo *rowMoPlanDate = [[CommonRowMo alloc] init];
    rowMoPlanDate.rowType = K_DATE_SELECT;
    rowMoPlanDate.leftContent = @"计划工作日期";
    rowMoPlanDate.inputType = K_SHORT_TEXT;
    rowMoPlanDate.rightContent = @"请输入";
    rowMoPlanDate.pattern = @"yyyy-MM-dd";
    rowMoPlanDate.editAble = self.yesterdayData?YES:(self.model?NO:YES);
    rowMoPlanDate.key = @"workPlanDate";
    rowMoPlanDate.strValue = self.model?self.model.workPlanDate:@"";//[nextDay stringWithFormat:rowMoPlanDate.pattern];
    [self.arrData addObject:rowMoPlanDate];
    
    CommonRowMo *rowMo12 = [[CommonRowMo alloc] init];
    rowMo12.rowType = K_DATE_SELECT;
    rowMo12.leftContent = @"填写日期";
    rowMo12.inputType = K_SHORT_TEXT;
    rowMo12.rightContent = @"请输入";
    rowMo12.pattern = @"yyyy-MM-dd";
    rowMo12.editAble = self.yesterdayData?YES:(self.model?NO:YES);
    rowMo12.key = @"date";
    rowMo12.strValue = self.model?self.model.date:@"";//[today stringWithFormat:rowMo12.pattern];
    [self.arrData addObject:rowMo12];
    
    CommonRowMo *rowMo13 = [[CommonRowMo alloc] init];
    rowMo13.rowType = K_INPUT_TEXT;
    rowMo13.leftContent = @"其他";
    rowMo13.inputType = K_LONG_TEXT;
    rowMo13.rightContent = @"请输入";
    rowMo13.editAble = !self.afterDate;
    rowMo13.nullAble = YES;
    rowMo13.key = @"remark";
    rowMo13.strValue = self.model.remark;
    [self.arrData addObject:rowMo13];
    
    self.attRowMo.attachments = (NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)self.model.attachments;
    if (self.model.finish) [self.arrData addObject:self.attRowMo];
    
    [_arrMembers removeAllObjects];
    _arrMembers = nil;
    error = nil;
    for (int i = 0; i < self.model.retailChannelItems.count; i++) {
        NSDictionary *dic = self.model.retailChannelItems[i];
        RetailChannelItemsMo *tmpMo = [[RetailChannelItemsMo alloc] initWithDictionary:dic error:&error];
        [self.arrMembers addObject:tmpMo];
        [self loadAttachement:tmpMo];
    }
    [self getProvinceList];
}

#pragma mark - network

- (void)getProvinceList {
    CommonRowMo *rowMo = self.arrData[0];
    JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
    if (!userMo) {
        return;
    }
    [[JYUserApi sharedInstance] getWorkPlanTargetAreaByOperatorType:@"0"param:@{@"id":@(userMo.id),@"oaCode":STRING(userMo.oaCode)} success:^(id responseObject) {
        NSArray *responseData = (NSArray *)responseObject;
        [_arrProvince removeAllObjects];
        _arrProvince = nil;
        for (int i = 0; i < responseData.count; i++) {
            NSDictionary *dic = responseData[i];
            DicMo *dicMo = [[DicMo alloc] init];
            dicMo.key = [NSString stringWithFormat:@"%@-%@", dic[@"province"], dic[@"brand"][@"brandName"]];
            dicMo.extendValue1 = STRING(dic[@"province"]);
            dicMo.extendValue2 = STRING(dic[@"brand"][@"brandName"]);
            CGFloat valueF = [dic[@"salesTarget"] floatValue];
            dicMo.value = [Utils getPriceFrom:valueF];
            [self.arrProvince addObject:dicMo];
        }
    } failure:^(NSError *error) {
        [_arrProvince removeAllObjects];
        _arrProvince = nil;
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

// 获取当月累计
- (void)getMonthTotalSum {
    CommonRowMo *rowMo = self.arrData[0];
    JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
    if (!userMo) {
        return;
    }
    CommonRowMo *provinceRowMo = nil;
    CommonRowMo *sumRowMo = nil;
    int count = 0;
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpRowMo = self.arrData[i];
        if ([tmpRowMo.key isEqualToString:@"province"]) {
            provinceRowMo = tmpRowMo;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"cumulativeShipments"]) {
            sumRowMo = tmpRowMo;
            count++;
        }
        if (count == 2) {
            break;
        }
    }
    
    [[JYUserApi sharedInstance] getWorkSumAcutalShipmentType:@"retail-channel" province:STRING(provinceRowMo.strValue) param:@{@"id":@(userMo.id)} success:^(id responseObject) {
        CGFloat sumActualShipment = [STRING(responseObject[@"sumActualShipment"]) floatValue];
        sumRowMo.strValue = [Utils getPriceFrom:sumActualShipment];
        sumRowMo.value = [NSString stringWithFormat:@"%f", sumActualShipment];
        [self dealWithSum];
    } failure:^(NSError *error) {
        CGFloat sumActualShipment = 0;
        sumRowMo.strValue = [Utils getPriceFrom:sumActualShipment];
        sumRowMo.value = [NSString stringWithFormat:@"%f", sumActualShipment];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        [self dealWithSum];
    }];
}

// 计算完成率
- (void)dealWithSum {
    CommonRowMo *targetMo = nil;
    CommonRowMo *sumMo = nil;
    CommonRowMo *planMo = nil;
    CommonRowMo *rateMo = nil;
    NSInteger count = 0;
    NSInteger targetIndex = 0;
    NSInteger sumIndex = 0;
    NSInteger planIndex = 0;
    NSInteger rateIndex = 0;
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpRowMo = self.arrData[i];
        if ([tmpRowMo.key isEqualToString:@"salesTarget"]) {
            targetMo = tmpRowMo;
            targetIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"cumulativeShipments"]) {
            sumMo = tmpRowMo;
            sumIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"actualShipment"]) {
            planMo = tmpRowMo;
            planIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"ompletionRate"]) {
            rateMo = tmpRowMo;
            rateIndex = i;
            count++;
        }
        if (count==4) {
            break;
        }
    }
    
    CGFloat target = [((NSString *)targetMo.value) floatValue];
    if (target < 0.001) {
        rateMo.strValue = [Utils getPriceFrom:0];
        rateMo.value = @"0";
    } else {
        CGFloat sum = [((NSString *)sumMo.value) floatValue];
        CGFloat plan = [((NSString *)planMo.value) floatValue];
        CGFloat rate = (sum + plan) / target;
        rateMo.strValue = [Utils getPriceFrom:rate*100];
        rateMo.value = [NSString stringWithFormat:@"%f", rate*100];
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:targetIndex inSection:0],
                                             [NSIndexPath indexPathForRow:sumIndex inSection:0],
                                             [NSIndexPath indexPathForRow:planIndex inSection:0],
                                             [NSIndexPath indexPathForRow:rateIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reSelectedUser:(BOOL)reSelectedUser reSelectedProvince:(BOOL)reSelectedProvince {
    CommonRowMo *userRowMo = nil;
    CommonRowMo *provinceRowMo = nil;
    CommonRowMo *targetRowMo = nil;
    CommonRowMo *sumRowMo = nil;
    NSInteger count = 0;
    NSInteger userIndex = 0;
    NSInteger provinceIndex = 0;
    NSInteger targetIndex = 0;
    NSInteger sumIndex = 0;
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpRowMo = self.arrData[i];
        if ([tmpRowMo.key isEqualToString:@"operator"]) {
            userRowMo = tmpRowMo;
            userIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"province"]) {
            provinceRowMo = tmpRowMo;
            provinceIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"salesTarget"]) {
            targetRowMo = tmpRowMo;
            targetIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"cumulativeShipments"]) {
            sumRowMo = tmpRowMo;
            sumIndex = i;
            count++;
        }
        if (count==4) {
            break;
        }
    }
    // 清空省份、销售目标、当月累计发货
    if (reSelectedUser) {
        provinceRowMo.strValue = @"";
        targetRowMo.strValue = @"";
        targetRowMo.m_obj = @"";
        targetRowMo.value = @"";
        sumRowMo.strValue = @"";
        sumRowMo.m_obj = @"";
        sumRowMo.value = @"";
    } else if (reSelectedProvince) {
        targetRowMo.strValue = @"";
        targetRowMo.m_obj = @"";
        targetRowMo.value = @"";
        sumRowMo.strValue = @"";
        sumRowMo.m_obj = @"";
        sumRowMo.value = @"";
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:userIndex inSection:0],
                                             [NSIndexPath indexPathForRow:provinceIndex inSection:0],
                                             [NSIndexPath indexPathForRow:targetIndex inSection:0],
                                             [NSIndexPath indexPathForRow:sumIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)loadAttachement:(RetailChannelItemsMo *)item {
//    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getRetailChannelItemDetail:item.id param:nil success:^(id responseObject) {
//        [Utils dismissHUD];
        NSError *error = nil;
        item.attachments = [QiniuFileMo arrayOfModelsFromDictionaries:responseObject error:&error];
        item.id = 0;
    } failure:^(NSError *error) {
//        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - 键盘相关

- (void)onKeyboardWillHide:(NSNotification *)note
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

- (void)onKeyboardWillShow:(NSNotification *)note
{
    CGRect keyboardFrame;
    [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    float verticalOffset = CGRectGetHeight(keyboardFrame);
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-verticalOffset);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.arrData.count : self.arrMembers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        return rowMo.rowHeight;
    } else {
        return 45.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1 && !self.afterDate) {
        return 40;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerId = @"headerId";
    MyCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[MyCommonHeaderView alloc] initWithReuseIdentifier:headerId isHidenLine:NO];
    }
    if (section == 0) {
        header.labLeft.text = @"零售计划";
    } else if (section == 1) {
        header.labLeft.text = @"走访客户";
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1 && !self.afterDate) {
        return [self setupFooterViewWithIdentifier:@"section1" selector:@selector(createCompetitor:)];
    }
    return [UIView new];
}

- (MyCommonHeaderView *)setupFooterViewWithIdentifier:(NSString *)identifier selector:(SEL)selector {
    MyCommonHeaderView *footer = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footer) {
        footer = [[MyCommonHeaderView alloc] initWithReuseIdentifier:identifier isHidenLine:NO];
        UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [btnAdd setTitle:@"新增" forState:UIControlStateNormal];
        [btnAdd setImage:[UIImage imageNamed:@"add_business"] forState:UIControlStateNormal];
        btnAdd.titleLabel.font = FONT_F15;
        [btnAdd setTitleColor:COLOR_336699 forState:UIControlStateNormal];
        [btnAdd setBackgroundColor:COLOR_B4];
        [btnAdd addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [footer.contentView addSubview:btnAdd];
        
        [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(footer.contentView);
        }];
    }
    return footer;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
            if ([rowMo.inputType isEqualToString:K_SHORT_TEXT]) {
                // 默认输入框
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
                cell.txtRight.textColor = rowMo.editAble ? showTextMo.color : COLOR_B2;
                return cell;
            } else if ([rowMo.inputType isEqualToString:K_LONG_TEXT]) {
                // 备注输入框
                static NSString *cellId = @"contentCell";
                MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    cell.cellDelegate = self;
                }
                [cell setLeftText:rowMo.leftContent];
                cell.placeholder = rowMo.rightContent;
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
        else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT] || [rowMo.rowType isEqualToString:K_DATE_SELECT] || [rowMo.rowType isEqualToString:K_INPUT_MEMBER] || [rowMo.rowType isEqualToString:K_INPUT_SELECT_OTHER] || [rowMo.rowType isEqualToString:K_INPUT_OPERATOR]) {
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
        else if ([rowMo.rowType isEqualToString:K_INPUT_TOGGLEBUTTON]) {
            // 单选按钮
            static NSString *cellId = @"MySwitchCell";
            MySwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[MySwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.cellDelegate = self;
            }
            [cell setLeftText:rowMo.leftContent];
            cell.labLeft.textColor = COLOR_B1;
            [cell.btnRight setOn:rowMo.defaultValue];
            cell.indexPath = indexPath;
            return cell;
        }
        else if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            if (!self.attCell) {
                self.attCell = [[AttachmentCell alloc] init];
                self.attCell.count = 9;
                self.attCell.attachments = rowMo.attachments;
                [self.attCell refreshView];
            }
            return self.attCell;
        }
        // 标题
        else if ([rowMo.rowType isEqualToString:K_INPUT_TITLE]) {
            static NSString *cellId = @"DefaultHeaderCell";
            DefaultHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[DefaultHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.labLeft.text = rowMo.leftContent;
            return cell;
        } else {
            return [[UITableViewCell alloc] init];
        }
    } else if (indexPath.section == 1) {
        static NSString *identifier = @"RetailItemCell";
        RetailItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[RetailItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        RetailChannelItemsMo *tmpMo = self.arrMembers[indexPath.row];
        cell.labTitle.text = tmpMo.member[@"orgName"];
        return cell;
    } else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        if (!rowMo.editAble) {
            if (_currentTextView) [_currentTextView resignFirstResponder];
            if (_currentTextField) [_currentTextField resignFirstResponder];
            return;
        }
        // 标题
        if ([rowMo.rowType isEqualToString:K_INPUT_TITLE]) {
            
        } else if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
            
        } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
            // 字典项选择
            [self hidenKeyboard];
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
                [self pushToSelectVC:indexPath];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
            }];
        } else if ([rowMo.rowType isEqualToString:K_DATE_SELECT]) {
            // 时间选择
            [self hidenKeyboard];
            NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
            [minDateFormater setDateFormat:rowMo.pattern];
            NSDate *scrollToDate = [minDateFormater dateFromString:rowMo.strValue];
            
            WSDateStyle style = DateStyleShowYearMonthDay;
            // 日期格式  "yyyy-MM", "yyyy-MM-dd", "yyyy-MM-dd hh", "yyyy-MM-dd HH:mm:ss"等
            if ([rowMo.pattern isEqualToString:@"yyyy-MM"]) {
                style = DateStyleShowYearMonth;
            } else if ([rowMo.pattern isEqualToString:@"yyyy-MM-dd"]) {
                style = DateStyleShowYearMonthDay;
            } else if ([rowMo.pattern isEqualToString:@"yyyy-MM-dd HH:mm:ss"] || [rowMo.pattern isEqualToString:@"yyyy-MM-dd HH:mm"]) {
                style = DateStyleShowYearMonthDayHourMinute;
            }
            
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:style scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
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
        } else if ([rowMo.rowType isEqualToString:K_INPUT_MEMBER]) {
            // 客户选择
            [self hidenKeyboard];
            MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
            vc.needRules = YES;
            vc.isWangli = YES;
            vc.VcDelegate = self;
            vc.defaultId = rowMo.member.id;
            vc.indexPath = indexPath;
            BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
            [[Utils topViewController] presentViewController:navi animated:YES completion:^{
            }];
            //    } else if (rowMo.iosRowType == RowOperator) {
            //        [self hidenKeyboard];
            //    } else if (rowMo.iosRowType == RowOther) {
            [self hidenKeyboard];
        } else if ([rowMo.rowType isEqualToString:K_INPUT_OPERATOR]) {
            JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
            vc.indexPath = indexPath;
            vc.VcDelegate = self;
            vc.isMultiple = NO;
            JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
            if (userMo) vc.defaultValues = [NSMutableArray arrayWithObject:@(userMo.id)];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 1) {
        RetailChannelItemsMo *itemMo = self.arrMembers[indexPath.row];
        
        if (itemMo.id != 0) {
            [self getNewItem:itemMo indexPath:indexPath];
        } else {
            RetailItemViewCtrl *vc = [[RetailItemViewCtrl alloc] init];
            [vc.customRules removeAllObjects];
            if (![self.arrAddIds[0] isEqualToString:@"0"]) {
                [vc.customRules setObject:@[@{@"field":@"provinceNumber",
                                              @"option":@"EQ",
                                              @"values":@[self.arrAddIds[0]]}] forKey:@"member"];
            }
            vc.itemMo = itemMo;
            vc.createDate = self.createDate;
            vc.beforeDate = self.beforeDate;
            vc.handleDate = self.handleDate;
            vc.afterDate = self.afterDate;
            vc.isUpdate = YES;
            __weak typeof(self) weakself = self;
            vc.updateSuccess = ^(id obj) {
                __strong typeof(self) strongself = weakself;
                [strongself updateMemberCount];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)getNewItem:(RetailChannelItemsMo *)item indexPath:(NSIndexPath *)indexPath {
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getRetailChannelItemDetail:item.id param:nil success:^(id responseObject) {
        [Utils dismissHUD];
        RetailItemViewCtrl *vc = [[RetailItemViewCtrl alloc] init];
        [vc.customRules removeAllObjects];
        if (![self.arrAddIds[0] isEqualToString:@"0"]) {
            [vc.customRules setObject:@[@{@"field":@"provinceNumber",
                                          @"option":@"EQ",
                                          @"values":@[self.arrAddIds[0]]}] forKey:@"member"];
        }
        vc.itemMo = item;
        vc.isUpdate = YES;
        vc.createDate = self.createDate;
        vc.beforeDate = self.beforeDate;
        vc.handleDate = self.handleDate;
        vc.afterDate = self.afterDate;
        NSError *error = nil;
        item.attachments = [QiniuFileMo arrayOfModelsFromDictionaries:responseObject error:&error];
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(id obj) {
            __strong typeof(self) strongself = weakself;
            [strongself updateMemberCount];
        };
        [self.navigationController pushViewController:vc animated:YES];
        item.id = 0;
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该记录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.arrMembers removeObjectAtIndex:indexPath.row];
        [self updateMemberCount];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)hidenKeyboard {
    if (_currentTextField) [_currentTextField resignFirstResponder];
    if (_currentTextView) [_currentTextView resignFirstResponder];
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = rowMo.leftContent;
    vc.byText = YES;
    NSMutableArray *arrValue = [NSMutableArray new];
    if (rowMo.mutiAble) {
        // 多选
        vc.isMultiple = YES;
        for (DicMo *tmpMo in rowMo.mutipleValue) {
            [arrValue addObject:STRING(tmpMo.key)];
        }
    } else {
        // 单选
        [arrValue addObject:STRING(rowMo.singleValue.key)];
    }
    vc.defaultValues = [[NSMutableArray alloc] initWithArray:arrValue copyItems:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DefaultInputCellDelegate

- (void)cell:(DefaultInputCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    __block CommonRowMo *rowMo = self.arrData[indexPath.row];
    _currentTextField = textField;
    if ([rowMo.key isEqualToString:@"address"] || [rowMo.key isEqualToString:@"province"]) {
        [_currentTextField resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __weak typeof(self) weakSelf = self;
            
            if ([rowMo.key isEqualToString:@"address"]) {
                AddressPickerView *picker = [[AddressPickerView alloc] initWithDefaultItem:self.arrAddIds itemClick:^(NSArray *arrResult) {
                    __strong typeof(self) strongSelf = weakSelf;
                    strongSelf.arrAddIds = arrResult[0];
                    strongSelf.arrAddNames = arrResult[1];
                    textField.text = [arrResult lastObject];
                    [textField resignFirstResponder];
                    rowMo.strValue = STRING([Utils saveToValues:textField.text]);
                    [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [strongSelf getCustomersByAddress];
                } cancelClick:^(AddressPickerView *obj) {
                    [obj removeFromSuperview];
                    obj = nil;
                    [textField resignFirstResponder];
                }];
                [self.view addSubview:picker];
                [picker mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.bottom.equalTo(self.view);
                }];
            } else if ([rowMo.key isEqualToString:@"province"]) {
                _selectArr = nil;
                _selectShowArr = nil;
                self.selectArr = self.arrProvince;
                for (DicMo *tmpDic in self.arrProvince) {
                    ListSelectMo *mo = [[ListSelectMo alloc] init];
                    mo.moText = [NSString stringWithFormat:@"%@: %@", tmpDic.key, tmpDic.value];
                    mo.moKey = tmpDic.key;
                    [self.selectShowArr addObject:mo];
                }
                [self pushToSelectVC:indexPath];
            }
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (rowMo.editAble) {
                [_currentTextField becomeFirstResponder];
            } else {
                [_currentTextField resignFirstResponder];
            }
        });
    }
}

- (void)cell:(DefaultInputCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.value = textField.text;
    rowMo.strValue = [Utils saveToValues:(textField.text)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([rowMo.key isEqualToString:@"actualShipment"]) {
        [self dealWithSum];
    }
}

#pragma mark - MyTextViewCellDelegate

- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    if ([rowMo.key isEqualToString:@"address"]) {
        
    }
    rowMo.strValue = [Utils saveToValues:(textView.text)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    _currentTextView = textView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (rowMo.editAble) {
            [_currentTextView becomeFirstResponder];
        } else {
            [_currentTextView resignFirstResponder];
        }
    });
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
//    if ([rowMo.key isEqualToString:@"province"]) {
//        // 省份
//        DicMo *dicMo = [self.selectArr objectAtIndex:index];
//        rowMo.strValue = dicMo.key;
//
//        // 目标
//        CommonRowMo *targetRowMo = nil;
//        NSInteger targetIndex = 0;
//        for (int i = 0; i < self.arrData.count; i++) {
//            CommonRowMo *tmpRowMo = self.arrData[i];
//            if ([tmpRowMo.key isEqualToString:@"salesTarget"]) {
//                targetRowMo = tmpRowMo;
//                targetIndex = i;
//                break;
//            }
//        }
//        targetRowMo.strValue = dicMo.value;
//        targetRowMo.value = dicMo.value;
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:targetIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//
//        // 用户
//        CommonRowMo *userRowMo = nil;
//        for (int i = 0; i < self.arrData.count; i++) {
//            CommonRowMo *tmpRowMo = self.arrData[i];
//            if ([tmpRowMo.key isEqualToString:@"operator"]) {
//                userRowMo = tmpRowMo;
//                break;
//            }
//        }
//        JYUserMo *userMo = (JYUserMo *)userRowMo.m_obj;
//        JYUserMo *modelUserMo = [[JYUserMo alloc] initWithDictionary:self.model.operator error:nil];
//
//        // 如果修改，选择省份之后，累计发货量用 detail 里的值
//        if (self.model && ([dicMo.key isEqualToString:self.model.province] && userMo.id == modelUserMo.id)) {
//            CommonRowMo *sumRowMo = nil;
//            NSInteger sumIndex = 0;
//            for (int i = 0; i < self.arrData.count; i++) {
//                CommonRowMo *tmpRowMo = self.arrData[i];
//                if ([tmpRowMo.key isEqualToString:@"cumulativeShipments"]) {
//                    sumRowMo = tmpRowMo;
//                    sumIndex = i;
//                    break;
//                }
//            }
//            sumRowMo.strValue = [Utils getPriceFrom:self.model.cumulativeShipments];
//            sumRowMo.m_obj = [Utils getPriceFrom:self.model.cumulativeShipments];
//            sumRowMo.value = [Utils getPriceFrom:self.model.cumulativeShipments];
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sumIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//            [self dealWithSum];
//        } else {
//            [self getMonthTotalSum];
//        }
//
//        // 逻辑更改：自动带出当日实际发货量
//        [self getDailyDeveliveryDataProvinceName:rowMo.strValue];
//    } else {
        DicMo *dicMo = [self.selectArr objectAtIndex:index];
        rowMo.m_obj = dicMo;
        rowMo.strValue = selectMo.moText;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
}

// 自动带出当日实际发货量 && 当月累计发货量
- (void)getSapData:(NSMutableArray *)provinceData {
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSMutableArray *arrProvince = [NSMutableArray new];
    NSMutableArray *arrBrand = [NSMutableArray new];
    for (DicMo *selectMo in provinceData) {
        [arrProvince addObject:@{@"provinceName":STRING(selectMo.extendValue1)}];
        [arrBrand addObject:@{@"brandName":STRING(selectMo.extendValue2)}];
    }
    [param setObject:arrProvince forKey:@"provinceSet"];
    [param setObject:arrBrand forKey:@"brandSet"];
    
    [[JYUserApi sharedInstance] GET_SAP_SALES_BY_BRAND_AND_YEAR_Type:@"_LS/LFIMG_" param:param success:^(id responseObject) {
        [self dealWithSapData:responseObject];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)dealWithSapData:(NSArray *)responseObject {
    CommonRowMo *dailyMo = nil;
    CommonRowMo *monthMo = nil;
    NSInteger count = 0;
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpRowMo = self.arrData[i];
        if ([tmpRowMo.key isEqualToString:@"actualShipment"]) {
            dailyMo = tmpRowMo;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"cumulativeShipments"]) {
            monthMo = tmpRowMo;
            count++;
        }
        if (count==2) {
            break;
        }
    }
    
    CGFloat cumulativeSalesForTheMonthValue = 0;
    CGFloat actualSalesValue = 0;
    for (NSDictionary *dic in responseObject) {
        cumulativeSalesForTheMonthValue += [dic[@"cumulativeSalesForTheMonth"] floatValue];
        actualSalesValue += [dic[@"actualSales"] floatValue];
    }
    dailyMo.strValue = [Utils getPriceFrom:actualSalesValue];
    dailyMo.m_obj = dailyMo.strValue;
    dailyMo.value = dailyMo.strValue;
    
    monthMo.strValue = [Utils getPriceFrom:cumulativeSalesForTheMonthValue];
    monthMo.m_obj = monthMo.strValue;
    monthMo.value = monthMo.strValue;
    
    [self dealWithSum];
}

//// 自动带出当日实际发货量
//- (void)getDailyDeveliveryDataProvinceName:(NSString *)provinceName {
//    CommonRowMo *dailyMo = nil;
//    for (int i = 0; i < self.arrData.count; i++) {
//        CommonRowMo *tmpRowMo = self.arrData[i];
//        if ([tmpRowMo.key isEqualToString:@"actualShipment"]) {
//            dailyMo = tmpRowMo;
//            break;
//        }
//    }
//    [[JYUserApi sharedInstance] getDailyDeveliveryByWorkType:@"retail-channel" provinceName:provinceName param:nil success:^(id responseObject) {
//        CGFloat todayDeliveryTotal = [responseObject[@"todayDeliveryTotal"] floatValue];
//        dailyMo.strValue = [Utils getPriceFrom:todayDeliveryTotal];
//        dailyMo.m_obj = dailyMo.strValue;
//        dailyMo.value = dailyMo.strValue;
//        [self dealWithSum];
//    } failure:^(NSError *error) {
//        [Utils dismissHUD];
//        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//    }];
//}

// 多选方法，会覆盖单选方法
- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndexPaths:(NSArray *)selectIndexPaths indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    // 省份多选
    if ([rowMo.key isEqualToString:@"province"]) {
        // 省份
        NSString *valueStr = @"";
        NSMutableArray *multipleValue = [NSMutableArray new];
        for (int i = 0; i < selectIndexPaths.count; i++) {
            NSIndexPath *tmpIndexPath = selectIndexPaths[i];
            ListSelectMo *tmpMo = [self.selectShowArr objectAtIndex:tmpIndexPath.row];
            [multipleValue addObject:self.selectArr[tmpIndexPath.row]];
            valueStr = [valueStr stringByAppendingString:STRING(tmpMo.moKey)];
            if (i < selectIndexPaths.count - 1) {
                valueStr = [valueStr stringByAppendingString:@","];
            }
        }
        rowMo.m_objs = multipleValue;
        rowMo.strValue = valueStr;
        
        // 目标
        CommonRowMo *targetRowMo = nil;
        NSInteger targetIndex = 0;
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpRowMo = self.arrData[i];
            if ([tmpRowMo.key isEqualToString:@"salesTarget"]) {
                targetRowMo = tmpRowMo;
                targetIndex = i;
                break;
            }
        }
        
        CGFloat targetValue = 0;
        for (DicMo *tmpDicMo in multipleValue) {
            targetValue += tmpDicMo.value.integerValue;
        }
        
        targetRowMo.strValue = [Utils getPriceFrom:targetValue];
        targetRowMo.value = targetRowMo.strValue;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:targetIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        // 用户
        CommonRowMo *userRowMo = nil;
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpRowMo = self.arrData[i];
            if ([tmpRowMo.key isEqualToString:@"operator"]) {
                userRowMo = tmpRowMo;
                break;
            }
        }
        JYUserMo *userMo = (JYUserMo *)userRowMo.m_obj;
        JYUserMo *modelUserMo = [[JYUserMo alloc] initWithDictionary:self.model.operator error:nil];
        
        // 如果修改，选择省份之后，累计发货量用 detail 里的值
        if (self.model && ([rowMo.key isEqualToString:self.model.province] && userMo.id == modelUserMo.id)) {
            CommonRowMo *sumRowMo = nil;
            NSInteger sumIndex = 0;
            for (int i = 0; i < self.arrData.count; i++) {
                CommonRowMo *tmpRowMo = self.arrData[i];
                if ([tmpRowMo.key isEqualToString:@"cumulativeShipments"]) {
                    sumRowMo = tmpRowMo;
                    sumIndex = i;
                    break;
                }
            }
            sumRowMo.strValue = [Utils getPriceFrom:self.model.cumulativeShipments];
            sumRowMo.m_obj = [Utils getPriceFrom:self.model.cumulativeShipments];
            sumRowMo.value = [Utils getPriceFrom:self.model.cumulativeShipments];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sumIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self dealWithSum];
        } else {
//            [self getMonthTotalSum];
        }
        
        // 逻辑更改：从sap获取品牌的两个值
        [self getSapData:rowMo.m_objs];
    } else {
        NSString *valueStr = @"";
        NSMutableArray *multipleValue = [NSMutableArray new];
        for (int i = 0; i < selectIndexPaths.count; i++) {
            NSIndexPath *tmpIndexPath = selectIndexPaths[i];
            ListSelectMo *tmpMo = [self.selectShowArr objectAtIndex:tmpIndexPath.row];
            [multipleValue addObject:self.selectArr[tmpIndexPath.row]];
            valueStr = [valueStr stringByAppendingString:STRING(tmpMo.moText)];
            if (i < selectIndexPaths.count - 1) {
                valueStr = [valueStr stringByAppendingString:@","];
            }
        }
        rowMo.m_objs = multipleValue;
        rowMo.strValue = valueStr;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.member = model;
        rowMo.strValue = model.orgName;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - JYUserMoSelectViewCtrlDelegate

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(JYUserMo *)selectMo {
    if (selectMo) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        if (((JYUserMo *)rowMo.m_obj).id != selectMo.id && ((JYUserMo *)rowMo.m_obj).id != 0) {
            [self reSelectedUser:YES reSelectedProvince:NO];
            [self dealWithSum];
        }
        rowMo.m_obj = selectMo;
        rowMo.strValue = selectMo.name;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - MySwitchCellDelegate

- (void)cell:(MySwitchCell *)cell btnClick:(UISwitch *)sender isOn:(BOOL)isOn indexPath:(NSIndexPath *)indexPath {
    [self hidenKeyboard];
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    if (rowMo.editAble) {
        rowMo.defaultValue = isOn;
        rowMo.strValue = rowMo.defaultValue?@"YES":@"NO";
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([rowMo.key isEqualToString:@"finish"]) {
        if (rowMo.defaultValue) {
            if (![self.arrData containsObject:self.attRowMo]) {
                [self.arrData addObject:self.attRowMo];
            }
        } else {
            if ([self.arrData containsObject:self.attRowMo]) {
                [self.arrData removeObject:self.attRowMo];
            }
        }
        [self.tableView reloadData];
    }
}

#pragma mark - event

// 选择走访地址之后，根据地址获取走访客户
- (void)getCustomersByAddress {
    [_arrMembers removeAllObjects];
    _arrMembers = nil;
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.arrAddIds[0] isEqualToString:@"0"]?@"":STRING(self.arrAddIds[0])  forKey:@"provinceNumber"];
    [param setObject:[self.arrAddIds[1] isEqualToString:@"0"]?@"":STRING(self.arrAddIds[1]) forKey:@"cityNumber"];
    [param setObject:[self.arrAddIds[2] isEqualToString:@"0"]?@"":STRING(self.arrAddIds[2]) forKey:@"areaNumber"];
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] findCarefulAreaParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        NSArray *tmpArr = (NSArray *)responseObject;
        for (NSDictionary *tmpDic in tmpArr) {
            RetailChannelItemsMo *tmpMo = [[RetailChannelItemsMo alloc] init];
            NSMutableDictionary *memberDic = [NSMutableDictionary new];
            [memberDic setObject:STRING(tmpDic[@"orgName"]) forKey:@"orgName"];
            [memberDic setObject:STRING(tmpDic[@"id"]) forKey:@"id"];
            tmpMo.member = memberDic;
            [self.arrMembers addObject:tmpMo];
        }
        [self.tableView reloadData];
        [self updateMemberCount];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        [self.tableView reloadData];
        [self updateMemberCount];
    }];
}

- (void)createCompetitor:(UIButton *)sender {
    [self hidenKeyboard];
    
    RetailItemViewCtrl *vc = [[RetailItemViewCtrl alloc] init];
    [vc.customRules removeAllObjects];
    if (![self.arrAddIds[0] isEqualToString:@"0"]) {
        [vc.customRules setObject:@[@{@"field":@"provinceNumber",
                                      @"option":@"EQ",
                                      @"values":@[self.arrAddIds[0]]}] forKey:@"member"];
    }
    vc.createDate = self.createDate;
    vc.beforeDate = self.beforeDate;
    vc.handleDate = self.handleDate;
    vc.afterDate = self.afterDate;
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(RetailChannelItemsMo *tmpMo) {
        __strong typeof(self) strongself = weakself;
        [strongself.arrMembers addObject:tmpMo];
        [strongself.tableView reloadData];
        [strongself updateMemberCount];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateMemberCount {
    for (CommonRowMo *rowMo in self.arrData) {
        if ([rowMo.key isEqualToString:@"expectVisit"]) {
            rowMo.strValue = [NSString stringWithFormat:@"%lu", (long)self.arrMembers.count];
            rowMo.value = [NSString stringWithFormat:@"%lu", (long)self.arrMembers.count];
        }
        else if ([rowMo.key isEqualToString:@"actualVisit"]) {
            NSInteger count = 0;
            for (int i = 0; i < self.arrMembers.count; i++) {
                RetailChannelItemsMo *tmpMo = self.arrMembers[i];
                if (tmpMo.visit) count++;
            }
            rowMo.strValue = [NSString stringWithFormat:@"%ld", (long)count];
            rowMo.value = [NSString stringWithFormat:@"%ld", (long)count];
        }
    }
    [self.tableView reloadData];
}

- (void)clickRightButton:(UIButton *)sender {
    [self hidenKeyboard];
    NSInteger attachIndex = -1;
    NSMutableDictionary *param = [NSMutableDictionary new];
    
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
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *rowMo = self.arrData[i];
        // 客户
        if ([rowMo.rowType isEqualToString:K_INPUT_MEMBER]) {
            [param setObject:@{@"id":@(rowMo.member.id),
                               @"abbreviation":STRING(rowMo.member.abbreviation)} forKey:rowMo.key];
        }
        // 操作员
        if ([rowMo.rowType isEqualToString:K_INPUT_OPERATOR]) {
            JYUserMo *userMo = (JYUserMo *)rowMo.m_obj;
            [param setObject:@{@"id":@(userMo.id)} forKey:rowMo.key];
        }
        // 输入
        else if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
            if ([Utils uploadToValues:rowMo.strValue]) {
                // 有Key才传值
                if (rowMo.key.length != 0) {
                    [param setObject:rowMo.strValue forKey:rowMo.key];
                }
            }
        }
        // 时间
        if ([rowMo.rowType isEqualToString:K_DATE_SELECT]) {
            if ([Utils uploadToValues:rowMo.strValue]) [param setObject:rowMo.strValue forKey:rowMo.key];
        }
        // swith
        if ([rowMo.rowType isEqualToString:K_INPUT_TOGGLEBUTTON]) {
            [param setObject:@(rowMo.defaultValue) forKey:rowMo.key];
        }
        // 选择
        else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
            
            if (rowMo.mutiAble) {
                // 多选
                NSMutableArray *arrValue = [NSMutableArray new];
                for (DicMo *tmpMo in rowMo.mutipleValue) {
                    [arrValue addObject:STRING(tmpMo.key)];
                }
                if (arrValue.count > 0) [param setObject:arrValue forKey:rowMo.key];
            } else {
                // 单选
                if (rowMo.singleValue) [param setObject:rowMo.singleValue.key forKey:rowMo.key];
            }
        }
        
        if ([rowMo.rowType isEqualToString:K_FILE_INPUT]) {
            attachIndex = i;
        }
    }
    
    if (self.arrMembers.count == 0) {
        [Utils showToastMessage:@"客户明细数量不能为0"];
        return;
    }
    
    AttachmentCell *cell = nil;
    if (attachIndex >= 0) {
        cell = self.attCell;
    }
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        [Utils showHUDWithStatus:nil];
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadFileMulti:cell.collectionView.attachments success:^(id responseObject) {
            [Utils showHUDWithStatus:@"附件上传成功"];
            [self dealWithParams:param attachementList:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [self dealWithParams:param attachementList:[NSMutableArray new]];
    }
}

- (void)dealWithParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachementList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    if (arr.count > 0) [params setObject:arr forKey:@"attachments"];
    
    NSString *address = [params objectForKey:@"address"];
    if (address.length != 0 && self.arrAddIds.count == 3) {
        [params setObject:STRING(self.arrAddNames[0]) forKey:@"provinceName"];
        [params setObject:STRING(self.arrAddIds[0]) forKey:@"provinceNumber"];
        [params setObject:STRING(self.arrAddNames[1]) forKey:@"cityName"];
        [params setObject:STRING(self.arrAddIds[1]) forKey:@"cityNumber"];
        [params setObject:STRING(self.arrAddNames[2]) forKey:@"areaName"];
        [params setObject:STRING(self.arrAddIds[2]) forKey:@"areaNumber"];
        [params removeObjectForKey:@"address"];
    }
    // 走访客户
    NSMutableArray *memberArr = [NSMutableArray new];
    for (RetailChannelItemsMo *tmpMo in self.arrMembers) {
        NSMutableArray *itemAttachments = [NSMutableArray new];
        for (QiniuFileMo *qiniuTmpMo in tmpMo.attachments) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[qiniuTmpMo toDictionary]];
            [dic setObject:@"" forKey:@"url"];
            [dic setObject:@"" forKey:@"thumbnail"];
            [itemAttachments addObject:dic];
        }
        [memberArr addObject:@{@"member": @{@"id":@([tmpMo.member[@"id"] longValue]),
                                            @"abbreviation":STRING(tmpMo.member[@"orgName"])},
                               @"visit":@(tmpMo.visit),
                               @"monopoly":@(tmpMo.monopoly),
                               @"complete":@(tmpMo.complete),
                               @"comparativeSales":@(tmpMo.comparativeSales),
                               @"policyProcessAdvocacy":@(tmpMo.policyProcessAdvocacy),
                               @"train":@(tmpMo.train),
                               @"content":STRING(tmpMo.content),
                               @"attachments":itemAttachments}];
    }
    [params setObject:memberArr forKey:@"retailChannelItems"];
    
    if (self.isUpdate) {
        [self updateParams:params attachementList:attachementList];
    } else {
        [self createParams:params attachementList:attachementList];
    }
}


- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [[JYUserApi sharedInstance] createRetailChannelParam:params success:^(id responseObject) {
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

- (void)updateParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [params setObject:@(self.model.id) forKey:@"id"];
    [[JYUserApi sharedInstance] updateRetailChannelParam:params success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

#pragma mark - lazy

- (NSMutableArray *)arrMembers {
    if (!_arrMembers) _arrMembers = [NSMutableArray new];
    return _arrMembers;
}

- (NSMutableArray *)arrProvince {
    if (!_arrProvince) _arrProvince = [NSMutableArray new];
    return _arrProvince;
}

- (NSArray *)arrAddIds {
    if (!_arrAddIds) {
        if (_isUpdate) {
            _arrAddIds = @[STRING(_model.provinceNumber), STRING(_model.cityNumber), STRING(_model.areaNumber)];
        } else {
            _arrAddIds = @[@"0", @"0", @"0"];
        }
    }
    return _arrAddIds;
}

- (NSArray *)arrAddNames {
    if (!_arrAddNames) {
        if (_isUpdate) {
            _arrAddNames = @[STRING(_model.provinceName), STRING(_model.cityName), STRING(_model.areaName)];
        } else {
            _arrAddNames = [NSArray new];
        }
    }
    return _arrAddNames;
}

- (CommonRowMo *)attRowMo {
    if (!_attRowMo) {
        _attRowMo = [[CommonRowMo alloc] init];
        _attRowMo.rowType = K_FILE_INPUT;
        _attRowMo.leftContent = @"相关附件";
        _attRowMo.inputType = K_SHORT_TEXT;
        _attRowMo.key = @"attachments";
        _attRowMo.editAble = !self.afterDate;;
        _attRowMo.nullAble = YES;
    }
    return _attRowMo;
}

@end
