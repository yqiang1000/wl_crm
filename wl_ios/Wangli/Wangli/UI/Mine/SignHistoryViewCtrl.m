//
//  SignHistoryViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/3/20.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "SignHistoryViewCtrl.h"
#import "WSDatePickerView.h"
#import "SignHistoryCell.h"
#import "AttendanceViewCtrl.h"

@interface SignHistoryViewCtrl () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *btnStart;
@property (nonatomic, strong) UIButton *btnEnd;
@property (nonatomic, strong) UIButton *btnQuery;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, copy) NSString *startStr;
@property (nonatomic, copy) NSString *endStr;
@property (nonatomic, copy) NSString *serviceDate;

@end

@implementation SignHistoryViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到记录";
    
    self.endStr = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    self.startStr = [[Utils getDateDayOffset:-7 mydate:[NSDate date]]  stringWithFormat:@"yyyy-MM-dd"];
    _page = 0;
    [self setUI];
    [self getList:_page];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);;
        make.height.equalTo(@49.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 150.0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"signHistoryCell";
    SignHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SignHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    SignInMo *signMo = self.arrData[indexPath.row];
    if (signMo.address.length == 0) {
        long long serviceLong = [Utils formateDateChangeToLong:self.serviceDate];
        long long createLong = [Utils formateDateChangeToLong:signMo.createdDate];
        long long dateCount = serviceLong-createLong-30*60;
        return dateCount > 0 ? NO : YES;
    } else {
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"修改地址";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SignInMo *signMo = self.arrData[indexPath.row];
        AttendanceViewCtrl *vc = [[AttendanceViewCtrl alloc] init];
        vc.signInMo = signMo;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - event

- (void)btnStartClick:(UIButton *)sender {
    NSInteger tag = sender.tag - 100;
    
    if (tag == 2) {
        
    } else {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *scrollToDate = [minDateFormater dateFromString:sender.titleLabel.text];
        __weak typeof(self) weakSelf = self;
        
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            __strong typeof(self) strongSelf = weakSelf;
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",date);
            [sender setTitle:date forState:UIControlStateNormal];
            if (tag == 0) {
                strongSelf.startStr = date;
            } else {
                strongSelf.endStr = date;
            }
            if (![date isEqualToString:sender.titleLabel.text]) {
                // 刷新数据
                [strongSelf.tableView.mj_header beginRefreshing];
            }
        }];
        datepicker.btnCancelTitle = @"重置";
        datepicker.wsCancelBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (tag == 0) {
                strongSelf.startStr = [[Utils getDateDayOffset:-7 mydate:[NSDate date]]  stringWithFormat:@"yyyy-MM-dd"];
            } else {
                strongSelf.endStr = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
            }
            [sender setTitle:tag == 0 ? strongSelf.startStr : strongSelf.endStr  forState:UIControlStateNormal];
        };
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        
        if (tag == 0) {
            datepicker.maxLimitDate = [minDateFormater dateFromString:self.endStr];
        } else {
            datepicker.minLimitDate = [minDateFormater dateFromString:self.startStr];
        }
        
        [datepicker show];
    }
}

- (void)btnQueryClick:(UIButton *)sender {
    _page = 0;
    [self getList:_page];
    
}

- (BOOL)compareBegin:(NSDate *)timeBegin end:(NSDate *)timeEnd {
    
    NSLog(@"\n时间1:%@\n时间2:%@", timeBegin, timeEnd);
    //开始时间和当前时间比较
    NSComparisonResult result = [timeBegin compare:timeEnd];
    if (result == NSOrderedAscending) {  //升序
        // 返回正常
        return NO;
    } else {
        // 结束时间不能早于开始时间
        return YES;
    }
}

- (void)getList:(NSInteger)page {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formater dateFromString:self.startStr];
    NSDate *endDate   = [formater dateFromString:self.endStr];
    
    if ([self compareBegin:startDate end:endDate]) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils showToastMessage:@"结束时间不能早于开始时间"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(20) forKey:@"size"];
    [param setObject:@
     "DESC" forKey:@"direction"];
    [param setObject:@"createdDate" forKey:@"property"];
    [param setObject:@[@{@"field":@"signInDate",
                         @"option":@"BTD",
                         @"values":@[[NSString stringWithFormat:@"%@ 00:00:00", self.startStr],
                                     [NSString stringWithFormat:@"%@ 23:59:59", self.endStr]]}] forKey:@"rules"];
    [param setObject:@(page) forKey:@"number"];
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getSignInPageParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [SignInMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
    [self getDate];
}

- (void)getDate {
    [[JYUserApi sharedInstance] getDateTodayParam:nil success:^(id responseObject) {
        [Utils dismissHUD];
        self.serviceDate = responseObject[@"todayNow"];
    } failure:^(NSError *error) {
    }];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:_page+1];
}

#pragma mark - lazy

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = COLOR_B4;
        
        [_topView addSubview:self.btnStart];
        [_topView addSubview:self.btnEnd];
        [_topView addSubview:self.btnQuery];
        
        UILabel *lab = [UILabel new];
        lab.text = @"~";
        lab.textColor = COLOR_B3;
        lab.font = FONT_F13;
        lab.textAlignment = NSTextAlignmentCenter;
        [_topView addSubview:lab];
        
        UIView *lineView = [Utils getLineView];
        [_topView addSubview:lineView];
        
        [_btnStart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_topView);
            make.left.equalTo(_topView).offset(15);
            make.height.equalTo(@28.0);
        }];
        
        [_btnEnd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btnStart);
            make.left.equalTo(_btnStart.mas_right).offset(20);
            make.height.width.equalTo(_btnStart);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btnStart);
            make.left.equalTo(_btnStart.mas_right);
            make.right.equalTo(_btnEnd.mas_left);
        }];
        
        [_btnQuery mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_topView);
            make.left.equalTo(_btnEnd.mas_right).offset(10);
            make.height.equalTo(@28.0);
            make.width.equalTo(@60.0);
            make.right.equalTo(_topView).offset(-15);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_topView);
            make.height.equalTo(@0.5);
        }];
    }
    return _topView;
}

- (UIButton *)btnStart {
    if (!_btnStart) {
        _btnStart = [[UIButton alloc] init];
        _btnStart.titleLabel.font = FONT_F13;
        [_btnStart setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        [_btnStart setTitle:_startStr forState:UIControlStateNormal];
        [_btnStart addTarget:self action:@selector(btnStartClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnStart.layer.cornerRadius = 5;
        _btnStart.layer.borderWidth = 0.5;
        _btnStart.layer.borderColor = COLOR_E6E6EA.CGColor;
        _btnStart.clipsToBounds = YES;
        _btnStart.tag = 100;
    }
    return _btnStart;
}

- (UIButton *)btnEnd {
    if (!_btnEnd) {
        _btnEnd = [[UIButton alloc] init];
        _btnEnd.titleLabel.font = FONT_F13;
        [_btnEnd setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        [_btnEnd setTitle:_endStr forState:UIControlStateNormal];
        [_btnEnd addTarget:self action:@selector(btnStartClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnEnd.layer.cornerRadius = 5;
        _btnEnd.layer.borderWidth = 0.5;
        _btnEnd.layer.borderColor = COLOR_E6E6EA.CGColor;
        _btnEnd.clipsToBounds = YES;
        _btnEnd.tag = 101;
    }
    return _btnEnd;
}

- (UIButton *)btnQuery {
    if (!_btnQuery) {
        _btnQuery = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 28)];
        [_btnQuery setBackgroundColor:COLOR_F2F3F5];
        _btnQuery.titleLabel.font = FONT_F13;
        [_btnQuery setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [_btnQuery setTitle:@"查询" forState:UIControlStateNormal];
        [_btnQuery addTarget:self action:@selector(btnQueryClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnQuery.layer.mask = [Utils drawContentFrame:_btnQuery.bounds corners:UIRectCornerAllCorners cornerRadius:3];
        _btnQuery.tag = 102;
    }
    return _btnQuery;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return _tableView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
