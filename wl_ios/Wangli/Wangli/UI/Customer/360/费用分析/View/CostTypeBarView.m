//
//  CostTypeBarView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CostTypeBarView.h"
#import "Wangli-Bridging-Header.h"
#import "Wangli-Swift.h"
#import "Charts-Swift.h"
#import "XValueFormatter.h"

@interface CostTypeBarView () <ChartViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BarChartView *barView;
@property (nonatomic, strong) PieChartView *pieView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation CostTypeBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self loadData];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.scrollView];
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = COLOR_B4;
    [self.scrollView addSubview:leftView];
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = COLOR_B4;
    [self.scrollView addSubview:rightView];
    [self.scrollView addSubview:self.barView];
    [self.scrollView addSubview:self.pieView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 14)];
    lineView.layer.mask = [Utils drawContentFrame:lineView.bounds corners:UIRectCornerAllCorners cornerRadius:1.5];
    lineView.backgroundColor = COLOR_C1;
    [self addSubview:lineView];
    [self addSubview:self.labTitle];
    
    [self addSubview:self.pageControl];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
        make.left.equalTo(leftView.mas_right);
    }];
    
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView).offset(10);
        make.right.equalTo(leftView).offset(-10);
        make.top.equalTo(leftView).offset(45);
        make.bottom.equalTo(leftView).offset(-20);
    }];
    
    [self.pieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView).offset(10);
        make.right.equalTo(rightView).offset(-10);
        make.top.equalTo(rightView).offset(45);
        make.bottom.equalTo(rightView).offset(-20);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.scrollView);
        make.height.equalTo(@35.0);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scrollView).offset(15);
        make.width.equalTo(@3.0);
        make.height.equalTo(@14.0);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right).offset(8);
    }];
}

- (void)loadData {

    NSArray *dataX = @[@"差旅", @"招待" , @"礼品", @"服务", @"其他"];
    NSArray *dataY = @[@"100", @"30" , @"270", @"90", @"500"];
    [self setBarDataX:dataX dataY:dataY];
    
    NSArray *arrX = @[@"AR", @"SR", @"FR"];
    NSArray *arrY = @[@"205", @"360", @"251"];
    [self setPieData:arrX dataY:arrY];
}

#pragma mark - ChartViewDelegate

- (void)setBarDataX:(NSArray *)dataX dataY:(NSArray *)dataY {
    _barView.xAxis.valueFormatter = [[XValueFormatter alloc] initWithArr:dataX];
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < dataX.count; i++)
    {
        CGFloat val = [dataY[i] floatValue];
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:val]];
    }
    
    
    NSArray *colors = @[COLOR_B2 , COLOR_B3, COLOR_C1, COLOR_C2, COLOR_C3];
    BarChartDataSet *set1 = nil;
    if (_barView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_barView.data.dataSets[0];
        set1.values = yVals;
        set1.valueColors = colors;
        set1.colors = colors;
        [_barView.data notifyDataChanged];
        [_barView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
        [set1 setColors:ChartColorTemplates.material];
        set1.drawIconsEnabled = NO;
        set1.valueColors = colors;
        set1.colors = colors;
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        data.barWidth = 0.9f;
        
        _barView.data = data;
    }
}

- (void)setPieData:(NSArray *)titles dataY:(NSArray *)dataY {
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    CGFloat total = 0;
    for (int i = 0; i < titles.count; i++) {
        total = total + [dataY[i] floatValue];
        [values addObject:[[PieChartDataEntry alloc] initWithValue:[dataY[i] floatValue] label:[NSString stringWithFormat:@"%@ %@k", titles[i], dataY[i]]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
    dataSet.drawIconsEnabled = NO;
    dataSet.sliceSpace = 2.0;
    dataSet.iconsOffset = CGPointMake(0, 40);
    
    NSArray *colors = @[COLOR_C1, COLOR_C2, COLOR_C3];
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    _pieView.centerText = [NSString stringWithFormat:@"%.0fk", total];
    _pieView.data = data;
    [_pieView highlightValues:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    self.pageControl.currentPage = index;
    self.labTitle.text = index == 0 ? @"费用类型分析" : @"铁三角费用分析";
}


#pragma mark - event

- (void)valueChanged:(UIPageControl *)sender {
    NSInteger index = sender.currentPage;
    [self.scrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.scrollView.frame) ,0) animated:YES];
    self.labTitle.text = index == 0 ? @"费用类型分析" : @"铁三角费用分析";
}


#pragma mark - lazy

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.backgroundColor = COLOR_B4;
        _scrollView.layer.cornerRadius = 5;
        _scrollView.clipsToBounds = YES;
        _scrollView.contentSize = CGSizeZero;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = 2;
        _pageControl.currentPageIndicatorTintColor = COLOR_0095DA;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:COLOR_0095DA.red green:COLOR_0095DA.green blue:COLOR_0095DA.blue alpha:0.3];
        [_pageControl addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _pageControl;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_B1;
        _labTitle.text = @"费用类型分析";
    }
    return _labTitle;
}

- (BarChartView *)barView {
    if (!_barView) {
        _barView = [[BarChartView alloc] init];
        _barView.delegate = self;
        _barView.noDataText = @"暂无数据";//没有数据时的文字提示
        _barView.drawBarShadowEnabled = NO;
        _barView.drawValueAboveBarEnabled = YES;
        _barView.dragEnabled = NO;
        [_barView setScaleEnabled:NO];
        
        _barView.chartDescription.enabled = NO;
        _barView.maxVisibleCount = 60;
        _barView.rightAxis.enabled = NO;
        
        ChartXAxis *xAxis = _barView.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.labelFont = [UIFont systemFontOfSize:10.f];
        xAxis.drawGridLinesEnabled = NO;
        xAxis.granularity = 1.0; // only intervals of 1 day
//        xAxis.labelCount = 7;
        
        NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
        leftAxisFormatter.minimumFractionDigits = 0;
        leftAxisFormatter.maximumFractionDigits = 1;
        leftAxisFormatter.negativeSuffix = @"k";
        leftAxisFormatter.positiveSuffix = @"k";
        
        ChartYAxis *leftAxis = _barView.leftAxis;
        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
        leftAxis.labelCount = 8;
        
        leftAxis.drawGridLinesEnabled = NO;
        leftAxis.axisMinimum = 0.0;
        leftAxis.drawGridLinesEnabled = NO;
        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
        
        ChartLegend *l = _barView.legend;
        l.form = ChartLegendFormNone;
        
    }
    return _barView;
}

- (PieChartView *)pieView {
    if (!_pieView) {
        _pieView = [[PieChartView alloc] init];
        _pieView.usePercentValuesEnabled = YES;
        _pieView.drawSlicesUnderHoleEnabled = NO;
        _pieView.holeRadiusPercent = 0.5;
        _pieView.transparentCircleRadiusPercent = 0.1;
        _pieView.chartDescription.enabled = NO;
        [_pieView setExtraOffsetsWithLeft:0.0 top:0.0 right:0.0 bottom:0.0];
        _pieView.drawCenterTextEnabled = YES;
        _pieView.centerText = @"0k";
        _pieView.drawHoleEnabled = YES;
        _pieView.rotationAngle = 0.0;
        _pieView.rotationEnabled = YES;
        _pieView.highlightPerTapEnabled = YES;
        
        ChartLegend *l = _pieView.legend;
        l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
        l.verticalAlignment = ChartLegendVerticalAlignmentTop;
        l.orientation = ChartLegendOrientationVertical;
        l.drawInside = NO;
        l.xEntrySpace = 7.0;
        l.yEntrySpace = 0.0;
        l.yOffset = 0.0;
    }
    return _pieView;
}


@end
