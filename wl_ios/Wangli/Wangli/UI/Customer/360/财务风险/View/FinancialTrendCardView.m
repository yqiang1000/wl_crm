//
//  FinancialTrendCardView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "FinancialTrendCardView.h"
#import "Wangli-Bridging-Header.h"
#import "Wangli-Swift.h"
#import "Charts-Swift.h"
#import "XValueFormatter.h"

@interface FinancialTrendCardView () <ChartViewDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation FinancialTrendCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.chartView];
    [self.baseView addSubview:self.labTitle];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@190);
    }];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.bottom.equalTo(self.baseView).offset(20);
        make.left.equalTo(self.baseView).offset(5);
        make.right.equalTo(self.baseView).offset(-5);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.baseView).offset(5);
        make.centerX.equalTo(self.baseView);
    }];
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

#pragma mark - public

- (void)loadDataWith:(NSDictionary *)model {
    NSMutableArray *months = [NSMutableArray new];
    NSMutableArray *dataY = [NSMutableArray new];
    
    for (NSDictionary *dic in model[@"beanList"]) {
        [months addObject:STRING(dic[@"field"])];
        [dataY addObject:STRING(dic[@"fieldValue"])];
    }
    [self setDataX:months dataY:dataY];
    self.labTitle.text = model[@"title"];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 4;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B2;
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}

- (LineChartView *)chartView {
    if (!_chartView) {
        _chartView = [[LineChartView alloc] init];
        _chartView.delegate = self;
        // 标题
        _chartView.chartDescription.enabled = NO;
        //        _chartView.chartDescription.text = @"2017年度月欠款走势图(万元)";
        //        _chartView.chartDescription.font = FONT_F4;
        
        _chartView.dragEnabled = NO;
        [_chartView setScaleEnabled:NO];
        _chartView.drawGridBackgroundEnabled = NO;
        _chartView.pinchZoomEnabled = NO;
        _chartView.rightAxis.enabled = NO;//不绘制右边轴
        
        _chartView.backgroundColor = [UIColor whiteColor];
        
        ChartLegend *l = _chartView.legend;
        l.form = ChartLegendFormNone;
        l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
        l.textColor = UIColor.blackColor;
        l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
        l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
        l.orientation = ChartLegendOrientationHorizontal;
        l.drawInside = NO;
        
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
        [_chartView animateWithXAxisDuration:2.5];
    }
    return _chartView;
}

- (void)setDataX:(NSArray *)dataX dataY:(NSArray *)dataY
{
    
    //X轴上面需要显示的数据
    _chartView.xAxis.valueFormatter = [[XValueFormatter alloc] initWithArr:dataX];
    
    // y轴需要显示的数据
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataX.count; i++) {
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i y:[dataY[i] floatValue]]];
    }
    
    LineChartDataSet *set1 = nil;
    
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals1;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:nil];
        set1.axisDependency = AxisDependencyLeft;
        [set1 setColor:[UIColor grayColor]];
        [set1 setCircleColor:[UIColor grayColor]];
        set1.lineWidth = 2.0;
        set1.circleRadius = 3.0;
        //        set1.circleHoleColor = [UIColor redColor];
        set1.fillAlpha = 65/255.0;
        set1.fillColor = [UIColor grayColor];
        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set1.drawCircleHoleEnabled = YES;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.blackColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];
        _chartView.data = data;
    }
}


@end
