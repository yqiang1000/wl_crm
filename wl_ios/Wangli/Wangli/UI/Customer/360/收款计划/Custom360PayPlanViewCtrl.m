//
//  Custom360PayPlanViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360PayPlanViewCtrl.h"
#import "Wangli-Bridging-Header.h"
#import "Wangli-Swift.h"
#import "Charts-Swift.h"
#import "UIButton+ShortCut.h"
#import "PayPlanMo.h"
#import "PayPlanCell.h"
#import "CreatePayPlanViewCtrl.h"
#import "WSDatePickerView.h"
#import "XValueFormatter.h"
#import "EmptyView.h"

@interface Custom360PayPlanViewCtrl () <ChartViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *labHeaderTitle;
@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UILabel *labTotal;
@property (nonatomic, strong) UILabel *labOverDue;
@property (nonatomic, strong) UIButton *btnFilter;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) WSDatePickerView *datepicker;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *rules;
@property (nonatomic, strong) NSDate *dateTag;
@property (nonatomic, strong) NSMutableArray *dataSets;

@end

@implementation Custom360PayPlanViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.filterView];
    
    [self addTableView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@192);
    }];
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@47);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self addBtnNew];
    self.footerRefresh = YES;
    self.headerRefresh = YES;
    [self getList:_page];
    [self getLineChart];
    [self loadData];
}

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:_page+1];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_datepicker) {
        [_datepicker removeFromSuperview];
        _datepicker = nil;
        _btnFilter.selected = NO;
    }
}

#pragma mark - network

- (void)getList:(NSInteger)page {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    
    [rules addObject:@{@"field":@"member.id",
                       @"option":@"EQ",
                       @"values":@[@(TheCustomer.customerMo.id)]}];
    if (_dateTag) {
        [rules addObject:@{@"field":@"year",
                           @"option":@"EQ",
                           @"values":@[[_dateTag stringWithFormat:@"yyyy"]]}];
        
        [rules addObject:@{@"field":@"month",
                           @"option":@"EQ",
                           @"values":@[[_dateTag stringWithFormat:@"M"]]}];
    }
    
//    [rules addObject:@{@"field":@"operator.id",
//                       @"option":@"IN",
//                       @"values":@[@(TheUser.userMo.id)]}];
    
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    
    [[JYUserApi sharedInstance] getGatheringPlanPageByParam:params page:page size:10 rules:rules specialConditions:nil success:^(id responseObject) {
        [self tableViewEndRefresh];
        [Utils dismissHUD];
        NSMutableArray *tmpArr = [PayPlanMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self tableViewEndRefresh];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getLineChart {
    [[JYUserApi sharedInstance] getGatheringLineChartByMemberId:TheCustomer.customerMo.id year:[self.dateTag stringWithFormat:@"yyyy"] success:^(id responseObject) {
        NSMutableArray *months = [NSMutableArray new];
        NSMutableArray *dataY = [NSMutableArray new];
        for (NSDictionary *dic in responseObject[@"list"]) {
            [months addObject:STRING(dic[@"field"])];
            [dataY addObject:STRING(dic[@"fieldValue"])];
        }
        [self setDataX:months dataY:dataY tag:0];
        
        NSMutableArray *months1 = [NSMutableArray new];
        NSMutableArray *dataY1 = [NSMutableArray new];
        for (NSDictionary *dic in responseObject[@"plan"]) {
            [months1 addObject:STRING(dic[@"field"])];
            [dataY1 addObject:STRING(dic[@"fieldValue"])];
        }
        [self setDataX:months1 dataY:dataY1 tag:1];
        self.labHeaderTitle.text = responseObject[@"content"];
    } failure:^(NSError *error) {
    }];
}

- (void)loadData {
    if (IS_IPHONE5) {
        self.labTotal.font = FONT_F12;
        self.labOverDue.font = FONT_F12;
    }
    self.labTotal.text = [NSString stringWithFormat:@"¥%@",[Utils getPrice:TheCustomer.customerMo.owedTotalAmount]];
    self.labOverDue.text = [NSString stringWithFormat:@"¥%@",[Utils getPrice:TheCustomer.customerMo.dueTotalAmount]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.tableView);
            make.width.height.equalTo(self.tableView);
        }];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 111;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"dealPlanCell";
    PayPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PayPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell loadDataWith:self.arrData[indexPath.row] orgName:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CreatePayPlanViewCtrl *vc = [[CreatePayPlanViewCtrl alloc] init];
    vc.mo = self.arrData[indexPath.row];
    __weak typeof(self) weakself = self;
    vc.createSuccess = ^{
        [weakself.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
    
    [_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
    //[_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    //[_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

#pragma mark - event

- (void)btnFilterClick:(UIButton *)sender {
    
    __block NSString *dateStr = [_dateTag stringWithFormat:@"yyyy-M"];
    
    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    [minDateFormater setDateFormat:@"yyyy-M"];
    NSDate *scrollToDate = [minDateFormater dateFromString:dateStr];
    
    __weak typeof(self) weakSelf = self;
    _datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
        __strong typeof(self) strongSelf = weakSelf;
        
        NSString *date = [selectDate stringWithFormat:@"yyyy-M"];

        NSLog(@"选择的日期：%@",date);
        if (![date isEqualToString:dateStr]) {
            strongSelf.dateTag = selectDate;
            [strongSelf selectDateAction];
        }
    }];
    
    _datepicker.wsCancelBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.dateTag = nil;
        [strongSelf selectDateAction];
    };
    _datepicker.btnCancelTitle = @"重置";
    _datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
    _datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
    _datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
    _datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
    [_datepicker show];
}

- (void)selectDateAction {
    [self getLineChart];
    if (_dateTag) {
        [self.btnFilter setTitle:[[self.dateTag stringWithFormat:@"M"] stringByAppendingString:@"月"] forState:UIControlStateNormal];
    } else {
        [self.btnFilter setTitle:@"月份" forState:UIControlStateNormal];
    }
    [self.btnFilter imageRightWithTitleFix:6];
    [self.tableView.mj_header beginRefreshing];
}

- (void)btnNewClick:(UIButton *)sender {
    if (TheCustomer.customerMo.sapNumber.length == 0) {
        [Utils showToastMessage:@"非正式客户不允许创建收款计划"];
        return;
    }
    CreatePayPlanViewCtrl *vc = [[CreatePayPlanViewCtrl alloc] init];
    __weak typeof(self) weakself = self;
    vc.createSuccess = ^{
        [weakself.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleDeleteCell:(NSIndexPath *)sender {
    NSLog(@"handle delete cell %ld", sender.row);
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"删除"] defaultItem:-1 itemClick:^(NSInteger index) {
        PayPlanMo *tmpMo = self.arrData[sender.row];
        NSString *msg = [NSString stringWithFormat:@"是否删除收款计划\"%@/%@\"",tmpMo.year, tmpMo.month];
        [Utils commonDeleteTost:@"系统提示" msg:msg cancelTitle:@"取消" confirmTitle:@"确定" confirm:^{
            [Utils showHUDWithStatus:nil];
            [Utils showToastMessage:@"删除成功"];
            [[JYUserApi sharedInstance] deleteGatheringPlanByPlanId:tmpMo.id success:^(id responseObject) {
                [Utils dismissHUD];
                [self.arrData removeObjectAtIndex:sender.row];
                [self.tableView deleteRowsAtIndexPaths:@[sender] withRowAnimation:UITableViewRowAnimationFade];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
                [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            }];
        } cancel:^{
        }];
    } cancelClick:^(BottomView *obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    [bottomView show];
}

#pragma mark - setter getter

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = COLOR_B4;
        [_headerView addSubview:self.chartView];
        [_headerView addSubview:self.labHeaderTitle];
        
        [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).offset(15);
            make.left.right.bottom.equalTo(_headerView);
        }];
        
        [_labHeaderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_headerView).offset(5);
            make.centerX.equalTo(_headerView);
        }];
    }
    return _headerView;
}

- (UILabel *)labHeaderTitle {
    if (!_labHeaderTitle) {
        _labHeaderTitle = [UILabel new];
        _labHeaderTitle.font = FONT_F13;
        _labHeaderTitle.textColor = COLOR_B2;
        _labHeaderTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labHeaderTitle;
}

- (LineChartView *)chartView {
    if (!_chartView) {
        _chartView = [[LineChartView alloc] init];
        _chartView.delegate = self;
        // 标题
        _chartView.chartDescription.enabled = NO;
        
        _chartView.dragEnabled = NO;
        [_chartView setScaleEnabled:NO];
        _chartView.drawGridBackgroundEnabled = NO;
        _chartView.pinchZoomEnabled = NO;
        _chartView.rightAxis.enabled = NO;//不绘制右边轴
        
        _chartView.backgroundColor = [UIColor whiteColor];
        
        // 图例
        ChartLegend *l = _chartView.legend;
        l.horizontalAlignment = ChartLimitLabelPositionLeftBottom;
        l.orientation = ChartLegendOrientationHorizontal;
        l.drawInside = NO;
        l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
        
        // x轴属性
        ChartXAxis *xAxis = _chartView.xAxis;
        xAxis.labelFont = [UIFont systemFontOfSize:11.f];
        xAxis.labelTextColor = [UIColor grayColor];
        xAxis.drawGridLinesEnabled = NO;
        xAxis.drawAxisLineEnabled = NO;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        
        // y轴属性
        ChartYAxis *leftAxis = _chartView.leftAxis;
        leftAxis.labelTextColor = [UIColor grayColor];
        //        leftAxis.axisMaximum = 200.0;
        leftAxis.axisMinimum = 0.0;
        leftAxis.drawGridLinesEnabled = YES;
        leftAxis.drawZeroLineEnabled = NO;
        leftAxis.granularityEnabled = YES;
        [_chartView animateWithXAxisDuration:0];
    }
    return _chartView;
}

- (void)setDataX:(NSArray *)dataX dataY:(NSArray *)dataY tag:(NSInteger)tag
{
    // X轴上面需要显示的数据
    _chartView.xAxis.valueFormatter = [[XValueFormatter alloc] initWithArr:dataX];
    // y轴需要显示的数据
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataX.count; i++) {
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i y:[dataY[i] floatValue]]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 1)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[tag];
        set1.values = yVals1;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:tag == 0?@"实际收款":@"计划收款"];
        set1.drawIconsEnabled = NO;
        [set1 setColor:tag == 0? COLOR_158ACF : COLOR_2EAD5B alpha:0.50f];
        [set1 setDrawValuesEnabled:YES];
        
        set1.axisDependency = AxisDependencyLeft;
        [set1 setColor:tag == 0? COLOR_158ACF : COLOR_2EAD5B];
        [set1 setCircleColor: tag ==0? COLOR_158ACF : COLOR_2EAD5B];
        set1.lineWidth = 2.0;
        set1.circleRadius = 3.0;
        //        set1.circleHoleColor = [UIColor redColor];
        set1.fillAlpha = 65/255.0;
        set1.fillColor =  tag ==0? [UIColor grayColor] : [UIColor redColor];
        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set1.drawCircleHoleEnabled = YES;
        
        NSNumberFormatter *setFormatter = [[NSNumberFormatter alloc] init];
        setFormatter.minimumFractionDigits = 0;
        setFormatter.maximumFractionDigits = 2;
        setFormatter.minimumIntegerDigits = 1;
        set1.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:setFormatter];
        
        [self.dataSets setObject:set1 atIndexedSubscript:tag];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:self.dataSets];
        [data setValueTextColor:UIColor.blackColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];
        _chartView.data = data;
    }
}

- (NSMutableArray *)dataSets {
    if (!_dataSets) {
        _dataSets = [NSMutableArray new];
    }
    return _dataSets;
}

- (UIView *)filterView {
    if (!_filterView) {
        _filterView = [[UIView alloc] init];
        _filterView.backgroundColor = COLOR_B4;
        
        UIView *line = [Utils getLineView];
        [_filterView addSubview:line];
        
        UILabel *labLeft = [UILabel new];
        labLeft.font = FONT_F14;
        labLeft.textColor = COLOR_B3;
        labLeft.text = @"总欠款额:";
        [_filterView addSubview:labLeft];
        
        UILabel *labRight = [UILabel new];
        labRight.font = FONT_F14;
        labRight.textColor = COLOR_B3;
        labRight.text = @"到期:";
        [_filterView addSubview:labRight];
        
        if (IS_IPHONE5) {
            labLeft.font = FONT_F12;
            labRight.font = FONT_F12;
        }
        
        [_filterView addSubview:self.labTotal];
        [_filterView addSubview:self.labOverDue];
        [_filterView addSubview:self.btnFilter];
        
        [labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_filterView);
            make.left.equalTo(_filterView).offset(15);
        }];
        
        [_labTotal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_filterView);
            make.left.equalTo(labLeft.mas_right).offset(5);
        }];
        
        [labRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_filterView);
            make.left.equalTo(_labTotal.mas_right).offset(10);
        }];
        
        [_labOverDue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_filterView);
            make.left.equalTo(labRight.mas_right).offset(5);
        }];
        
        [_btnFilter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_filterView);
            make.right.equalTo(_filterView).offset(-15);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_filterView);
            make.height.equalTo(@0.5);
        }];
        
    }
    return _filterView;
}

- (UILabel *)labTotal {
    if (!_labTotal) {
        _labTotal = [[UILabel alloc] init];
        _labTotal.font = FONT_F14;
        _labTotal.textColor = COLOR_ED746C;
    }
    return _labTotal;
}

- (UILabel *)labOverDue {
    if (!_labOverDue) {
        _labOverDue = [[UILabel alloc] init];
        _labOverDue.font = FONT_F14;
        _labOverDue.textColor = COLOR_ED746C;
    }
    return _labOverDue;
}

- (UIButton *)btnFilter {
    if (!_btnFilter) {
        _btnFilter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
        [_btnFilter setTitle:@"月份" forState:UIControlStateNormal];
        _btnFilter.titleLabel.font = FONT_F14;
        if (IS_IPHONE5) {
            _btnFilter.titleLabel.font = FONT_F12;
        }
        [_btnFilter setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        [_btnFilter setTitleColor:COLOR_C1 forState:UIControlStateSelected];
        [_btnFilter setImage:[UIImage imageNamed:@"client_down_n"] forState:UIControlStateNormal];
        [_btnFilter setImage:[UIImage imageNamed:@"drop_down_s"] forState:UIControlStateSelected];
        [_btnFilter sizeToFit];
        [_btnFilter imageRightWithTitleFix:6];
        [_btnFilter addTarget:self action:@selector(btnFilterClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFilter;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}



@end
