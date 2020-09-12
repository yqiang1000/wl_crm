//
//  TrackViewCell.m
//  Wangli
//
//  Created by yeqiang on 2018/6/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrackViewCell.h"
#import "Wangli-Bridging-Header.h"
#import "Wangli-Swift.h"
#import "Charts-Swift.h"
#import "XValueFormatter.h"

@interface TrackViewCell ()<ChartViewDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *midLine;

@end

@implementation TrackViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.contentView addSubview:self.coverView];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.midLine];
    [self.contentView addSubview:self.labLeft];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.chartView];

    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(10);
        make.right.equalTo(self.baseView).offset(-10);
        make.bottom.equalTo(self.baseView);
        make.height.equalTo(@163);
    }];
    
    [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.coverView);
        make.left.equalTo(self.coverView).offset(50);
        make.width.equalTo(@0.5);
    }];

    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coverView);
        make.left.equalTo(self.coverView);
        make.right.equalTo(self.midLine.mas_left);
    }];

    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.midLine.mas_right);
        make.top.equalTo(self.coverView).offset(5);
        make.right.equalTo(self.coverView);
    }];

    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(2);
        make.left.equalTo(self.midLine.mas_right).offset(3);
        make.right.equalTo(self.coverView).offset(-3);
        make.bottom.equalTo(self.coverView).offset(-3);
    }];

    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverView);
        make.bottom.equalTo(self.coverView.mas_top);
        make.right.lessThanOrEqualTo(self.coverView);
        make.height.equalTo(@48);
    }];
}

// type :0 底部有间距; 1 底部没有边距
// cornerType 0:无圆角。1:上两角 2:下边两角 3:四圆角
- (void)loadData:(NSDictionary *)dicData type:(NSInteger)type cornerType:(NSInteger)cornerType hidenTitle:(BOOL)hidenTitle {
    if (type == 0) {
        [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.baseView).offset(-15);
        }];
    } else if (type == 1) {
        [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.baseView);
        }];
    }
    //cornerType 0:无圆角。1:上两角 2:下边两角 3:四圆角
    if (cornerType == 0) {
        self.baseView.layer.cornerRadius = 0;
    } else {
        self.baseView.layer.cornerRadius = 5;
        self.baseView.clipsToBounds = YES;
        if (cornerType == 1) {
            if (@available(iOS 11.0, *)) {
                self.baseView.layer.maskedCorners = kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner;
            } else {
                
            }
        } else if (cornerType == 2) {
            if (@available(iOS 11.0, *)) {
                self.baseView.layer.maskedCorners = kCALayerMinXMaxYCorner|kCALayerMaxXMaxYCorner;
            } else {
                
            }
            
        } else if (cornerType == 3) {
            if (@available(iOS 11.0, *)) {
                self.baseView.layer.maskedCorners = kCALayerMinXMaxYCorner|kCALayerMaxXMaxYCorner|kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner;
            } else {
                
            }
        }
    }
    
    self.titleView.hidden = hidenTitle;
    self.labTitle.text = STRING(dicData[@"fieldTitle"]);
    self.labLeft.text = STRING(dicData[@"field"]);
    NSMutableArray *months = [NSMutableArray new];
    NSMutableArray *dataY = [NSMutableArray new];
    for (NSDictionary *dic in dicData[@"fieldValue"]) {
        [months addObject:STRING(dic[@"field"])];
        [dataY addObject:STRING(dic[@"fieldValue"])];
    }
    [self setDataX:months dataY:dataY];
    [self layoutIfNeeded];
}

//#pragma mark - ChartViewDelegate
//
//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//    NSLog(@"chartValueSelected");
//
//    [_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
//    //[_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
//    //[_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
//
//}
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//    NSLog(@"chartValueNothingSelected");
//}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.layer.borderColor = COLOR_LINE.CGColor;
        _coverView.layer.borderWidth = 0.5;
    }
    return _coverView;
}

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [UILabel new];
        _labLeft.font = FONT_F15;
        _labLeft.textColor = COLOR_B2;
        _labLeft.numberOfLines = 0;
        _labLeft.textAlignment = NSTextAlignmentCenter;
    }
    return _labLeft;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.font = FONT_F12;
        _labTitle.textColor = COLOR_B2;
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}

- (UIView *)topLine {
    if (!_topLine) _topLine = [Utils getLineView];
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) _bottomLine = [Utils getLineView];
    return _bottomLine;
}

- (UIView *)leftLine {
    if (!_leftLine) _leftLine = [Utils getLineView];
    return _leftLine;
}

- (UIView *)rightLine {
    if (!_rightLine) _rightLine = [Utils getLineView];
    return _rightLine;
}

- (UIView *)midLine {
    if (!_midLine) _midLine = [Utils getLineView];
    return _midLine;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        UILabel *lab = [[UILabel alloc] init];
        lab = [[UILabel alloc] init];
        lab.font = FONT_F14;
        lab.textColor = COLOR_B1;
        lab.text = @"产品价格走势";
        [_titleView addSubview:lab];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView);
            make.height.equalTo(@18);
            make.width.equalTo(@3);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
        }];
    }
    return _titleView;
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
        [_chartView animateWithXAxisDuration:0];
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
        
        NSNumberFormatter *setFormatter = [[NSNumberFormatter alloc] init];
        setFormatter.minimumFractionDigits = 0;
        setFormatter.maximumFractionDigits = 2;
        setFormatter.minimumIntegerDigits = 1;
        set1.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:setFormatter];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.blackColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];
        _chartView.data = data;
    }
}

@end
