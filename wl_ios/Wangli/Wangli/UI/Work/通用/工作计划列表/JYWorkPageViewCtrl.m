//
//  JYWorkPageViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/8/28.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "JYWorkPageViewCtrl.h"
#import "JYWorkMo.h"
#import "JYWorkPageCell.h"
#import "SearchTopView.h"
#import "WSDatePickerView.h"
#import "JYWorkPlanViewCtrl.h"

@interface JYWorkPageViewCtrl () <UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>

@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnCalendar;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *workTypeStr;

@end

@implementation JYWorkPageViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = (self.workType == JYWorkTypeJinMuMen)?@"金木门销售计划":((self.workType == JYWorkTypeLvMuMen)?@"铝木门销售计划":((self.workType == JYWorkTypeZhiNengSuo) ? @"智能锁销售计划" : ((self.workType == JYWorkTypeTongMuMen)? @"铜艺销售计划" : ((self.workType == JYWorkTypeMuMen)? @"木门销售计划" : @"暂无"))));
    self.dateStr = @"";
    self.keyWord = @"";
    [self.rightBtn setImage:[UIImage imageNamed:@"dynamic_order_add"] forState:UIControlStateNormal];
    [self setUI];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setUI {
    UIView *topView = [UIView new];
    topView.backgroundColor = COLOR_B4;
    [self.view addSubview:topView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.btnCalendar];
    [self.view addSubview:self.tableView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49.0);
    }];
    
    [self.searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(self.naviView).offset(15);
        make.height.equalTo(@28.0);
        make.right.equalTo(self.btnCalendar.mas_left).offset(-15);
    }];
    
    [self.btnCalendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.height.width.equalTo(@17.0);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(7.5);
        make.bottom.left.right.equalTo(self.view);
    }];
}

- (void)getList:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(10) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    NSMutableArray *rules = [NSMutableArray new];
    if (self.keyWord.length != 0) {
        [rules addObject:@{@"field":@"operator.name",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[STRING(self.keyWord)]}];
    }
    
    if (self.dateStr.length != 0) {
        [rules addObject:@{@"field":@"date",
                           @"option":@"BTD",
                           @"values":@[[NSString stringWithFormat:@"%@ 00:00:00", self.dateStr],
                                       [NSString stringWithFormat:@"%@ 23:59:59", self.dateStr]]}];
    }
    if (self.workTypeStr.length > 0) {
        [rules addObject:@{@"field":@"workPlanType",
                           @"option": @"EQ",
                           @"values": @[self.workTypeStr]}];
    }
    
    if (rules.count > 0) [param setObject:rules forKey:@"rules"];
    [[JYUserApi sharedInstance] getPageDynmicFormDynamicId:@"workPlan" param:param success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [JYWorkMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        self.page = page;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"JYWorkPageCell";
    JYWorkPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[JYWorkPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    JYWorkMo *model = self.arrData[indexPath.row];
    NSString *name = model.operator[@"name"];
    cell.labName.text = name.length == 0 ? @"暂无业务员" : name;
    cell.labTime.text = STRING(model.workPlanDate);
    cell.labKTL.text = @"当月销售目标";
    cell.labKTR.text = @"当日预计发货量";
    cell.labKBL.text = @"当月累计发货量";
    cell.labKBR.text = @"当日实际发货量";
    cell.labTL.text = [Utils getPriceFrom:model.salesTarget];
    cell.labTR.text = [Utils getPriceFrom:model.projectedShipment];
    cell.labBL.text = [Utils getPriceFrom:model.cumulativeShipments];
    cell.labBR.text = [Utils getPriceFrom:model.actualShipment];
    [cell rateProgress:model.ompletionRate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JYWorkMo *model = self.arrData[indexPath.row];
    JYWorkPlanViewCtrl *vc = [[JYWorkPlanViewCtrl alloc] init];
    vc.model = model;
    vc.workType = self.workType;
    vc.title = self.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchView.searchTxtField resignFirstResponder];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该记录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JYWorkMo *model = self.arrData[indexPath.row];
        if (model.id != 0) {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] detailWorkPlanType:@"workPlan" ids:@[@(model.id)] success:^(id responseObject) {
                [Utils dismissHUD];
                [self.arrData removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
                [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            }];
        }
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    self.keyWord = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self tableViewHeaderRefreshAction];
    [self.searchView.searchTxtField resignFirstResponder];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    self.page = 0;
    [self getList:self.page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:self.page+1];
}

- (void)calendarClick:(UIButton *)sender {
    [self.searchView.searchTxtField resignFirstResponder];
    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    [minDateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *scrollToDate = [minDateFormater dateFromString:self.dateStr];
    
    __weak typeof(self) weakSelf = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
        __strong typeof(self) strongSelf = weakSelf;
        NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"选择的日期：%@",date);
        if (![strongSelf.dateStr isEqualToString:date]) {
            strongSelf.dateStr = date;
            [strongSelf tableViewHeaderRefreshAction];
        }
    }];
    datepicker.btnCancelTitle = @"重置";
    datepicker.wsCancelBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.dateStr = @"";
        [strongSelf tableViewHeaderRefreshAction];
    };
    datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
    datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
    datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
    datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
    [datepicker show];
}

- (void)clickRightButton:(UIButton *)sender {
    JYWorkPlanViewCtrl *vc = [[JYWorkPlanViewCtrl alloc] init];
    vc.yesterdayData = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.workType = self.workType;
    vc.title = self.title;
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return _tableView;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = @"请输入业务员姓名";
        _searchView.btnSearch.layer.borderColor = COLOR_E6E6EA.CGColor;
        _searchView.btnSearch.layer.borderWidth = 0.5;
    }
    return _searchView;
}

- (UIButton *)btnCalendar {
    if (!_btnCalendar) {
        _btnCalendar = [[UIButton alloc] init];
        [_btnCalendar setImage:[UIImage imageNamed:@"work_plan_date"] forState:UIControlStateNormal];
        [_btnCalendar addTarget:self action:@selector(calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCalendar;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

- (void)setWorkType:(JYWorkType)workType {
    _workType = workType;
    switch (_workType) {
        case JYWorkTypeJinMuMen: self.workTypeStr = @"GOLDWOOD";
            break;
        case JYWorkTypeLvMuMen: self.workTypeStr = @"ALD";
            break;
        case JYWorkTypeZhiNengSuo: self.workTypeStr = @"HYZNG";
            break;
        case JYWorkTypeTongMuMen: self.workTypeStr = @"CERART";
            break;
        case JYWorkTypeMuMen: self.workTypeStr = @"TIMBER";
            break;
    }
}

@end
