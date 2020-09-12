//
//  BusinessVisitViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BusinessVisitViewCtrl.h"
#import "FSCalendar.h"
#import "Business360TableViewCell.h"
#import "BusinessVisitActiveViewCtrl.h"
#import "EmptyView.h"
#import "LunarFormatter.h"
#import "JYCalendarCell.h"
#import <EventKit/EventKit.h>

@interface BusinessVisitViewCtrl () <UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate>
{
    void * _KVOContext;
    EmptyView *_emptyView;
}
@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) NSMutableArray *arrData;                  // 某一天的数据

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) LunarFormatter *lunarFormatter;
@property (nonatomic, strong) UIPanGestureRecognizer *scopeGesture;
@property (strong, nonatomic) NSArray *fillDefaultColors;            // 圆点颜色
@property (strong, nonatomic) NSMutableDictionary *pageCalendarData;         // 日历数据

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSDate *currentDate;                      // 选中的日期
@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) NSArray<EKEvent *> *events;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *labTitleDate;
@property (nonatomic, strong) UILabel *labTitleYear;
@property (nonatomic, strong) UILabel *labNongDate;
@property (nonatomic, strong) UIButton *btnToday;

@end

static NSString *jyCell = @"jyCalendarCell";

@implementation BusinessVisitViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden = YES;
    _page = 0;
    _currentDate = [NSDate date];
    [self.calendar registerClass:[JYCalendarCell class] forCellReuseIdentifier:jyCell];
    [self setUI];
    [self addGester];
    [self refreshView];
    [self loadCalendarEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.cache removeAllObjects];
}

- (void)refreshView {
    [self getNewPageCalendarData];
    [self tableViewHeaderRefreshAction];
}

- (void)getNewPageCalendarData {
    
    if (self.fromMy) {
        // 获取总的
        [[JYUserApi sharedInstance] getCurrentUserVisitCalendarDateStr:[self.dateFormatter stringFromDate:self.calendar.currentPage] param:nil success:^(id responseObject) {
            [_pageCalendarData removeAllObjects];
            _pageCalendarData = nil;
            [self dealNewPageCalendarData:responseObject[@"current"]];
            [self dealNewPageCalendarData:responseObject[@"pre"]];
            [self dealNewPageCalendarData:responseObject[@"next"]];
            [self.calendar reloadData];
        } failure:^(NSError *error) {
        }];
    } else {
        // 获取360里面
        [[JYUserApi sharedInstance] getBusinessVisitActivityCalendarMemberId:TheCustomer.customerMo.id dateStr:[self.dateFormatter stringFromDate:self.calendar.currentPage] param:nil success:^(id responseObject) {
            [_pageCalendarData removeAllObjects];
            _pageCalendarData = nil;
            [self dealNewPageCalendarData:responseObject[@"current"]];
            [self dealNewPageCalendarData:responseObject[@"pre"]];
            [self dealNewPageCalendarData:responseObject[@"next"]];
            [self.calendar reloadData];
        } failure:^(NSError *error) {
        }];
    }
}

- (void)dealNewPageCalendarData:(NSArray *)data {
    for (int i = 0; i < data.count; i++) {
        NSDictionary *dic = data[i];
        NSString *date = dic[@"fieldValue"];
        NSString *count = dic[@"field"];
        if (date.length > 0) {
            [self.pageCalendarData setObject:STRING(count) forKey:STRING(date)];
        }
    }
}

- (void)setUI {
    self.view.backgroundColor = COLOR_B0;
    [self.view addSubview:self.calendar];
    [self.view addSubview:self.tableView];
    
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@400.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendar.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)addGester {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    // While the scope gesture begin, the pan gesture of tableView should cancel.
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
}


- (void)dealloc {
    [self.calendar removeObserver:self forKeyPath:@"scope" context:_KVOContext];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

// Whether scope gesture should begin
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                return velocity.y > 0;
        }
    }
    return shouldBegin;
}

#pragma mark - <FSCalendarDelegate>

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    //    NSString *dateString = [self.dateFormatter stringFromDate:date];
    //    NSString *count = [self.pageCalendarData objectForKey:dateString];
    //    ((JYCalendarCell *)cell).labTost.hidden = count == 0 ? YES :NO;
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    //    NSLog(@"%@",(calendar.scope==FSCalendarScopeWeek?@"week":@"month"));
    CGFloat height = CGRectGetHeight(bounds);
    [_calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    
    self.currentDate = date;
    
    if ([[self.dateFormatter stringFromDate:date] isEqualToString:[self.dateFormatter stringFromDate:[NSDate date]]]) {
        self.labDate.text = @"今天";
    } else {
        self.labDate.text = [self.dateFormatter stringFromDate:date];
    }
    [self tableViewHeaderRefreshAction];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"%s %@", __FUNCTION__, [self.dateFormatter stringFromDate:calendar.currentPage]);
    [self getNewPageCalendarData];
}


- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date {
    //    if ([[self.dateFormatter stringFromDate:date] isEqualToString:[self.dateFormatter stringFromDate:[NSDate date]]]) {
    //        return @"今";
    //    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    JYCalendarCell *cell = (JYCalendarCell *)[calendar dequeueReusableCellWithIdentifier:jyCell forDate:date atMonthPosition:monthPosition];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSString *count = [self.pageCalendarData objectForKey:dateString];
    cell.labTost.hidden = count == 0 ? YES : NO;
    cell.labTost.text = @"拜访";
    return cell;
}

#pragma mark - <FSCalendarDataSource>

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSString *count = [self.pageCalendarData objectForKey:dateString];
    return [count integerValue];
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    EKEvent *event = [self eventsForDate:date].firstObject;
    if (event) {
        return event.title;
    }
    return [self.lunarFormatter stringFromDate:date];
}

#pragma mark - <FSCalendarDelegateAppearance>

- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSString *countStr = [self.pageCalendarData objectForKey:dateString];
    NSInteger count = [countStr integerValue];
    if (count == 0) {
        return nil;
    } else {
        count = count > 3 ? 3 : count;
        return [self.fillDefaultColors subarrayWithRange:NSMakeRange(0, count)];
    }
}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter stringFromDate:date];
//    if ([_fillSelectionColors containsObject:key]) {
//        return _fillSelectionColors[key];
//    }
//    return appearance.selectionColor;
//}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    //    NSString *dateString = [self.dateFormatter stringFromDate:date];
    //    NSInteger count = [[self.pageCalendarData objectForKey:dateString] integerValue];
    //    if (count > 0) {
    //        return COLOR_C1;
    //    }
    return nil;
}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_borderDefaultColors.allKeys containsObject:key]) {
//        return _borderDefaultColors[key];
//    }
//    return appearance.borderDefaultColor;
//}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_borderSelectionColors.allKeys containsObject:key]) {
//        return _borderSelectionColors[key];
//    }
//    return appearance.borderSelectionColor;
//}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top).offset(44);
            make.left.equalTo(self.tableView);
            make.width.height.equalTo(self.tableView);
        }];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = @"headerView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        header.contentView.backgroundColor = COLOR_B4;
        [header.contentView addSubview:self.labDate];
        [self.labDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header.contentView);
            make.left.equalTo(header.contentView).offset(15);
        }];
        UIView *lineView = [Utils getLineView];
        [header.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(header.contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Business360TableViewCell";
    Business360TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[Business360TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessVisitActiveViewCtrl *vc = [[BusinessVisitActiveViewCtrl alloc] init];
    vc.model = self.arrData[indexPath.row];
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        [weakself refreshView];
    };
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    self.page = 0;
    [self getDataByPage:self.page];
}

- (void)tableViewFooterRefreshAction {
    [self getDataByPage:self.page+1];
}

- (void)getDataByPage:(NSInteger)page {
    
    if (self.fromMy) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"number"];
        [param setObject:@(10) forKey:@"size"];
        [param setObject:@"DESC" forKey:@"direction"];
        [param setObject:@"createdDate" forKey:@"property"];
        
        NSMutableArray *rules = [NSMutableArray new];
        [rules addObject:@{@"field":@"dateStr",
                           @"option":@"EQ",
                           @"values":@[[self.dateFormatter stringFromDate:self.currentDate]]}];
        //    [rules addObject:@{@"field":@"visitor.id",
        //                       @"option":@"EQ",
        //                       @"values":@[@(TheUser.userMo.id)]}];
        
        [param setObject:rules forKey:@"rules"];
        
        [[JYUserApi sharedInstance] getCurrentVisitPageParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSError *error = nil;
            NSMutableArray *tmpArr = [BusinessVisitActivityMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            if (page == 0) {
                [_arrData removeAllObjects];
                _arrData = nil;
                self.arrData = tmpArr;
            } else {
                if (tmpArr.count > 0) {
                    self.page = page;
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
    } else {
        [[JYUserApi sharedInstance] getBusinessVisitActivityListByCalendarMemberId:TheCustomer.customerMo.id dateStr:[self.dateFormatter stringFromDate:self.currentDate] param:nil success:^(id responseObject) {
            [Utils dismissHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSError *error = nil;
            NSMutableArray *tmpArr = [BusinessVisitActivityMo arrayOfModelsFromDictionaries:responseObject error:&error];
            if (page == 0) {
                [_arrData removeAllObjects];
                _arrData = nil;
                self.arrData = tmpArr;
            } else {
                if (tmpArr.count > 0) {
                    self.page = page;
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
    }
}

- (void)loadCalendarEvents
{
    __weak typeof(self) weakSelf = self;
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if(granted) {
            NSDate *startDate = [self getDateYearOffset:-2];
            NSDate *endDate = [self getDateYearOffset:2];
            NSPredicate *fetchCalendarEvents = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
            NSArray<EKEvent *> *eventList = [store eventsMatchingPredicate:fetchCalendarEvents];
            NSArray<EKEvent *> *events = [eventList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable event, NSDictionary<NSString *,id> * _Nullable bindings) {
                return event.calendar.subscribed;
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!weakSelf) return;
                weakSelf.events = events;
                [weakSelf.calendar reloadData];
            });
            
        } else {
            
            // Alert
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的\"设置-隐私-日历\"选项中，允许访问你的手机日历" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
}

- (NSArray<EKEvent *> *)eventsForDate:(NSDate *)date
{
    NSArray<EKEvent *> *events = [self.cache objectForKey:date];
    if ([events isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSArray<EKEvent *> *filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.occurrenceDate isEqualToDate:date];
    }]];
    if (filteredEvents.count) {
        [self.cache setObject:filteredEvents forKey:date];
    } else {
        [self.cache setObject:[NSNull null] forKey:date];
    }
    return filteredEvents;
}

- (NSDate *)getDateYearOffset:(NSInteger)offset {
    NSDate *mydate = [NSDate date];
    // date转化为string
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    // 正值加日期、负值减日期
    [comps setYear:offset];
    NSDate *newdate = [calendar dateByAddingComponents:comps toDate:mydate options:0];
    return newdate;
}

- (void)refreshTitleView:(NSDate *)date {
    //    NSString *dateStr = [self.dateFormatter stringFromDate:date];
    //    NSString *date = [dateStr substringWithRange:NSMakeRange(0, NSUInteger len)]
    
}

#pragma mark - lazy

- (FSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        [_calendar selectDate:[NSDate date] scrollToDate:YES];
        _calendar.backgroundColor = COLOR_B4;
        [_calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        _calendar.scope = FSCalendarScopeWeek;
        _calendar.delegate = self;
        _calendar.dataSource = self;
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        _calendar.appearance.weekdayTextColor = COLOR_B2;
        _calendar.appearance.headerTitleColor = COLOR_B1;
        _calendar.appearance.headerTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:19];
        _calendar.appearance.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _calendar.appearance.subtitleFont = FONT_F10;
        _calendar.appearance.todayColor = COLOR_CLEAR;
        _calendar.appearance.titleTodayColor = COLOR_B1;
        _calendar.appearance.subtitleTodayColor = COLOR_B1;
        _calendar.appearance.selectionColor = COLOR_C1;
        _calendar.appearance.subtitleDefaultColor = COLOR_B2;
        _calendar.appearance.titleWeekendColor = COLOR_C1;
        _calendar.appearance.subtitleWeekendColor = COLOR_C1;
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
    }
    return _calendar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        if (self.fromMy) _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        _tableView.backgroundColor = COLOR_B0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UILabel *)labDate {
    if (!_labDate) {
        _labDate = [[UILabel alloc] init];
        _labDate.font = FONT_F14;
        _labDate.textColor = COLOR_B1;
        _labDate.text = @"今天";
    }
    return _labDate;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

- (NSArray *)fillDefaultColors {
    if (!_fillDefaultColors) _fillDefaultColors = @[UIColor.redColor ,UIColor.redColor,UIColor.redColor];
    return _fillDefaultColors;
}

- (NSMutableDictionary *)pageCalendarData {
    if (!_pageCalendarData) _pageCalendarData = [NSMutableDictionary new];
    return _pageCalendarData;
}

- (LunarFormatter *)lunarFormatter {
    if (!_lunarFormatter) _lunarFormatter = [[LunarFormatter alloc] init];
    return _lunarFormatter;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        [_topView addSubview:self.labTitleDate];
        [_topView addSubview:self.labTitleYear];
        [_topView addSubview:self.labNongDate];
        [_topView addSubview:self.btnToday];
        
        [self.labTitleDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_topView);
            make.left.equalTo(_topView).offset(15);
        }];
        
        [self.labTitleYear mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labTitleDate);
            make.left.equalTo(_labTitleDate).offset(10);
        }];
        
        [self.labNongDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_labTitleDate);
            make.left.equalTo(_labTitleDate).offset(10);
        }];
        
        [self.btnToday mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView);
            make.right.equalTo(_topView).offset(-15);
            make.height.width.equalTo(@30.0);
        }];
    }
    return _topView;
}

- (UILabel *)labTitleDate {
    if (!_labTitleDate) {
        _labTitleDate = [UILabel new];
        _labTitleDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
        _labTitleDate.textColor = COLOR_B1;
    }
    return _labTitleDate;
}

- (UILabel *)labNongDate {
    if (!_labNongDate) {
        _labNongDate = [UILabel new];
        _labNongDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        _labNongDate.textColor = COLOR_B1;
    }
    return _labNongDate;
}

- (UILabel *)labTitleYear {
    if (!_labTitleYear) {
        _labTitleYear = [UILabel new];
        _labTitleYear.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        _labTitleYear.textColor = COLOR_B1;
    }
    return _labTitleYear;
}

- (UIButton *)btnToday {
    if (!_btnToday) {
        _btnToday = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_btnToday setTitle:@"29" forState:UIControlStateNormal];
        _btnToday.layer.borderColor = COLOR_B1.CGColor;
        _btnToday.layer.borderWidth = 1;
    }
    return _btnToday;
}

@end
