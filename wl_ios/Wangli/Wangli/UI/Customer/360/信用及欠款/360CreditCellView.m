//
//  360CreditCellView.m
//  Wangli
//
//  Created by yeqiang on 2018/8/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "360CreditCellView.h"
#import "Wangli-Bridging-Header.h"
#import "Wangli-Swift.h"
#import "Charts-Swift.h"
#import "UIButton+ShortCut.h"
#import "CreditMo.h"
#import "XValueFormatter.h"
#import "CreateCreditViewCtrl.h"
#import "CreditDebtMo.h"
#import "CustDeptMo.h"

#pragma mark - CreditFirstCell

@interface CreditFirstCell ()

@property (nonatomic, strong) UIView *itemView1;
@property (nonatomic, strong) UIView *itemView2;
@property (nonatomic, strong) UIView *itemView3;
@property (nonatomic, strong) UIView *itemView4;
@property (nonatomic, strong) NSMutableArray *arrItemViews;

@end

@implementation CreditFirstCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.itemView1];
    [self addSubview:self.itemView2];
    [self addSubview:self.itemView3];
    [self addSubview:self.itemView4];
    
    [self.itemView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.height.equalTo(@100);
    }];
    [self.itemView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemView1);
        make.right.equalTo(self).offset(-15);
        make.left.equalTo(self.itemView1.mas_right).offset(10);
        make.height.width.equalTo(self.itemView1);
    }];
    [self.itemView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemView1);
        make.top.equalTo(self.itemView1.mas_bottom).offset(10);
        make.height.width.equalTo(self.itemView1);
        make.bottom.equalTo(self);
    }];
    [self.itemView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemView3);
        make.height.width.equalTo(self.itemView1);
        make.left.equalTo(self.itemView2);
    }];
}

#pragma mark - event

- (void)clickChange:(UITapGestureRecognizer *)tap {
    if (TheCustomer.customerMo.sapNumber.length != 0) {
        CreateCreditViewCtrl *vc = [[CreateCreditViewCtrl alloc] init];
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - public

- (void)loadDataWith:(NSArray *)model {
    if (model.count == 0 || model.count != 4) {
        return;
    }
    NSArray *arr = [CreditMo arrayOfModelsFromDictionaries:model error:nil];
    for (int i = 0; i < 4; i++) {
        CreditMo *mo = arr[i];
        [self itemView:self.arrItemViews[i] num:mo.fieldValue title:mo.field msg:mo.unit];
    }
    if (TheCustomer.customerMo.sapNumber.length != 0) {
        [self.itemView2 viewWithTag:14].hidden = NO;
    }
}

- (void)itemView:(UIView *)itemView num:(NSString *)num title:(NSString *)title msg:(NSString *)msg {
    UILabel *labNum = [itemView viewWithTag:11];
    labNum.text = num;
    UILabel *labTitle = [itemView viewWithTag:12];
    labTitle.text = title;
    UILabel *labWan = [itemView viewWithTag:13];
    labWan.text = msg;
}

- (UIView *)setupViewImgName:(NSString *)imgName {
    UIView *itemView = [UIView new];
    itemView.backgroundColor = COLOR_B4;
    itemView.layer.cornerRadius = 4;
    itemView.clipsToBounds = YES;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    img.image = [UIImage imageNamed:imgName];
    CAShapeLayer *shapeLayer = [Utils drawContentFrame:img.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadius:22];
    img.layer.mask = shapeLayer;
    [itemView addSubview:img];
    img.tag = 10;
    
    UILabel *labNum = [UILabel new];
    labNum.font = FONT_F18;
    labNum.textColor = COLOR_B1;
    labNum.tag = 11;
    [itemView addSubview:labNum];
    
    UILabel *labTitle = [UILabel new];
    labTitle.font = FONT_F14;
    labTitle.textColor = COLOR_B2;
    labTitle.tag = 12;
    [itemView addSubview:labTitle];
    
    UILabel *labWan = [UILabel new];
    labWan.font = FONT_F12;
    labWan.textColor = COLOR_B3;
    labWan.tag = 13;
    [itemView addSubview:labWan];
    
    UIImageView *imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    imgArrow.tag = 14;
    imgArrow.hidden = YES;
    [itemView addSubview:imgArrow];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(itemView);
        make.width.height.equalTo(@44);
        make.left.equalTo(itemView).offset(10);
    }];
    
    [labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(img.mas_centerY).offset(-5);
        make.left.equalTo(img.mas_right).offset(5);
    }];
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_centerY).offset(5);
        make.left.equalTo(img.mas_right).offset(5);
        //        make.right.lessThanOrEqualTo(itemView.mas_right).offset(-5);
    }];
    
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labTitle);
        make.left.equalTo(labTitle.mas_right).offset(5);
        make.right.lessThanOrEqualTo(itemView.mas_right).offset(-5);
    }];
    
    [labWan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(labNum);
        make.left.equalTo(labNum.mas_right).offset(3);
        make.right.lessThanOrEqualTo(itemView.mas_right).offset(-5);
    }];
    
    return itemView;
}

#pragma mark - setter getter

- (UIView *)itemView1 {
    if (!_itemView1) {
        _itemView1 = [self setupViewImgName:@"client_registeredcapital"];
    }
    return _itemView1;
}

- (UIView *)itemView2 {
    if (!_itemView2) {
        _itemView2 = [self setupViewImgName:@"client_credits"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChange:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _itemView2.userInteractionEnabled = YES;
        [_itemView2 addGestureRecognizer:tap];
    }
    return _itemView2;
}

- (UIView *)itemView3 {
    if (!_itemView3) {
        _itemView3 = [self setupViewImgName:@"client_totalarrears"];
    }
    return _itemView3;
}

- (UIView *)itemView4 {
    if (!_itemView4) {
        _itemView4 = [self setupViewImgName:@"client_totaldue"];
    }
    return _itemView4;
}

- (NSMutableArray *)arrItemViews {
    if (!_arrItemViews) {
        _arrItemViews = [NSMutableArray new];
        [_arrItemViews addObject:self.itemView1];
        [_arrItemViews addObject:self.itemView2];
        [_arrItemViews addObject:self.itemView3];
        [_arrItemViews addObject:self.itemView4];
    }
    return _arrItemViews;
}

@end

#pragma mark - CreditSecondCell

@interface CreditSecondCell () <ChartViewDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation CreditSecondCell

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
    
    for (NSDictionary *dic in model[@"list"]) {
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

#pragma mark - CreditThirdCell

@interface CreditThirdCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIView *detailView;

@end

@implementation CreditThirdCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        [self setUI];
    }
    return self;
}


- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.titleView];
    [self.baseView addSubview:self.detailView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@238);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.baseView);
        make.height.equalTo(@49);
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.equalTo(self.baseView);
    }];
}

- (void)loadDataWith:(NSDictionary *)model {
    if (model.count == 0 || model.count != 2) {
        return;
    }
    CreditMo *titleMo = [[CreditMo alloc] initWithDictionary:model[@"title"] error:nil];
    NSArray *arr = [CreditMo arrayOfModelsFromDictionaries:model[@"list"] error:nil];
    self.labTitle.text = [NSString stringWithFormat:@"%@%@", titleMo.field, titleMo.fieldValue];
    for (int i = 0; i < arr.count; i++) {
        CreditMo *mo = arr[i];
        NSInteger tag1 = 110+i;
        NSInteger tag2 = 120+i;
        UILabel *labNum = [self.detailView viewWithTag:tag1];
        labNum.text = mo.fieldValue;
        UILabel *labMsg = [self.detailView viewWithTag:tag2];
        labMsg.text = mo.field;
    }
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

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_titleView addSubview:self.labTitle];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView).offset(13);
            make.height.equalTo(@15);
            make.width.equalTo(@3);
        }];
        
        [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.equalTo(_titleView);
        }];
    }
    return _titleView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F14;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UIView *)detailView {
    if (!_detailView) {
        _detailView = [[UIView alloc] init];
        _detailView.backgroundColor = COLOR_B4;
        
        UIView *firstView = nil;
        UIView *lastView = nil;
        for (int i = 0; i < 8; i++) {
            NSInteger x = i % 4;
            NSInteger y = i / 4;
            UIView *item = [self setupView:i];
            item.tag = 100+i;
            if (i == 0) {
                firstView = item;
            }
            
            [_detailView addSubview:item];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( y==0 ? _detailView : firstView.mas_bottom);
                make.left.equalTo( x==0 ? _detailView : lastView.mas_right);
                make.width.equalTo(_detailView).multipliedBy(0.25);
                make.height.equalTo(_detailView).multipliedBy(0.5);
            }];
            
            if (x == 0) {
                UIView *lineView = [Utils getLineView];
                [_detailView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (y == 0) {
                        make.top.equalTo(_detailView);
                    } else {
                        make.bottom.equalTo(lastView.mas_bottom);
                    }
                    make.left.equalTo(_detailView);
                    make.width.equalTo(_detailView);
                    make.height.equalTo(@0.5);
                }];
            }
            
            if (y == 1 && x > 0 && x < 4) {
                UIView *lineView = [Utils getLineView];
                [_detailView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(_detailView);
                    make.width.equalTo(@0.5);
                    make.left.equalTo(item);
                }];
            }
            
            lastView = item;
        }
    }
    return _detailView;
}

- (UIView *)setupView:(NSInteger)tag {
    UIView *bottomView = [UIView new];
    UILabel *labNum = [UILabel new];
    labNum.textColor = COLOR_B1;
    labNum.font = FONT_F17;
    // 110， 111， 112， 113， 114，115，116，117
    labNum.tag = 110 + tag;
    [bottomView addSubview:labNum];
    
    UILabel *labMsg = [UILabel new];
    labMsg.textColor = COLOR_B2;
    labMsg.font = FONT_F12;
    labMsg.numberOfLines = 0;
    labMsg.textAlignment = NSTextAlignmentCenter;
    
    // 120， 121， 122， 123， 124，125，126，127
    labMsg.tag = 120 + tag;
    [bottomView addSubview:labMsg];
    
    [labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.top.equalTo(bottomView).offset(IS_IPHONE5?20:30);
        make.left.greaterThanOrEqualTo(bottomView).offset(5);
    }];
    
    [labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.top.equalTo(labNum.mas_bottom).offset(15);
        make.left.greaterThanOrEqualTo(bottomView).offset(5);
    }];
    
    return bottomView;
}

@end

#pragma mark - CreditFouthCell

@interface CreditFouthCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation CreditFouthCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        [self setUI];
    }
    return self;
}


- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.titleView];
    [self.baseView addSubview:self.tableView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.baseView);
        make.height.equalTo(@49);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(-5);
        make.bottom.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-10);
    }];
}

#pragma mark - public

- (void)loadDataWith:(NSDictionary *)model {
    if (model.count == 0 || model.count != 2) {
        return;
    }
    CreditMo *titleMo = [[CreditMo alloc] initWithDictionary:model[@"title"] error:nil];
    NSMutableArray *arr = [CreditMo arrayOfModelsFromDictionaries:model[@"list"] error:nil];
    self.labTitle.text = titleMo.field;
    self.tableView.arrData = arr;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(25*arr.count));
    }];
    [self.tableView reloadData];
}

- (void)btnMoreClick:(UIButton *)sender {
    if (_btnDetailBlock) {
        _btnDetailBlock();
    }
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

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_titleView addSubview:self.labTitle];
        [_titleView addSubview:self.btnDetail];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView).offset(13);
            make.height.equalTo(@15);
            make.width.equalTo(@3);
        }];
        
        [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.equalTo(_btnDetail.mas_left).offset(-10);
        }];
        
        [self.btnDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.right.equalTo(_titleView).offset(-13);
        }];
    }
    return _titleView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F14;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UIButton *)btnDetail {
    if (!_btnDetail) {
        _btnDetail = [[UIButton alloc] init];
        _btnDetail.titleLabel.font = FONT_F13;
        [_btnDetail setTitle:@"欠款明细表" forState:UIControlStateNormal];
        [_btnDetail setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [_btnDetail setImage:[UIImage imageNamed:@"client_search"] forState:UIControlStateNormal];
        if (IS_IPHONE5) {
            [_btnDetail imageLeftWithTitleFix:3];
            _btnDetail.titleLabel.font = FONT_F12;
        } else {
            [_btnDetail imageLeftWithTitleFix:6];
        }
        [_btnDetail addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDetail;
}

- (CreditTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CreditTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


@end



#pragma mark - CreditFiftyCell

@interface CreditFiftyCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIButton *btnDetail;

@end

@implementation CreditFiftyCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        [self setUI];
    }
    return self;
}


- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.tableView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.baseView);
    }];
}

#pragma mark - public

- (void)creditFiftyRefreshView {
    self.tableView.arrData = self.arrData;
    CGFloat height = 0;
    for (int i = 0; i < self.arrData.count; i++) {
        CreditDebtMo *tmpMo = self.arrData[i];
        height = height+49+32+25*tmpMo.companyList.count+53+10;
        if (i == self.arrData.count - 1) {
            height = height - 10;
        }
    }
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    [self.tableView reloadData];
    [self layoutIfNeeded];
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

- (CreditDebtTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CreditDebtTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = COLOR_B0;
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


#pragma mark - CreditSixthCell

@interface CreditSixthCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *labTitle;

@property (nonatomic, strong) UILabel *labAll;
@property (nonatomic, strong) UILabel *labZero;
@property (nonatomic, strong) UILabel *labNine;
@property (nonatomic, strong) UILabel *labNineMore;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CreditSixthCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        [self setUI];
    }
    return self;
}


- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.titleView];
    [self.baseView addSubview:self.bottomView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.baseView);
        make.height.equalTo(@49);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView);
    }];
}

#pragma mark - public

- (void)loadDataWith:(CustDeptMo *)model {
//    dispatch_async(dispatch_get_main_queue(), ^{
        self.labAll.text = [Utils getPrice:model.owedTotalAmount];
        self.labZero.text = [Utils getPrice:model.zeroToAccount];
        self.labNine.text = [Utils getPrice:model.accountToNinety];
        self.labNineMore.text = [Utils getPrice:model.moreThanNinety];
//    });
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

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_titleView addSubview:self.labTitle];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView).offset(13);
            make.height.equalTo(@15);
            make.width.equalTo(@3);
        }];
        
        [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.equalTo(_titleView);
        }];
        
        UIView *bottomLine = [Utils getLineView];
        [_titleView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_titleView);
            make.height.equalTo(@0.5);
        }];
    }
    return _titleView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F14;
        _labTitle.textColor = COLOR_B1;
        _labTitle.text = @"信贷账户欠款分布";
    }
    return _labTitle;
}

- (UILabel *)labAll {
    if (!_labAll) {
        _labAll = [[UILabel alloc] init];
        _labAll.font = FONT_F12;
        _labAll.textColor = COLOR_C2;
        _labAll.text = @"0";
        _labAll.numberOfLines = 0;
    }
    return _labAll;
}

- (UILabel *)labZero {
    if (!_labZero) {
        _labZero = [[UILabel alloc] init];
        _labZero.font = FONT_F12;
        _labZero.textColor = COLOR_C2;
        _labZero.text = @"0";
        _labZero.numberOfLines = 0;
    }
    return _labZero;
}

- (UILabel *)labNine {
    if (!_labNine) {
        _labNine = [[UILabel alloc] init];
        _labNine.font = FONT_F12;
        _labNine.textColor = COLOR_C2;
        _labNine.text = @"0";
        _labNine.numberOfLines = 0;
    }
    return _labNine;
}

- (UILabel *)labNineMore {
    if (!_labNineMore) {
        _labNineMore = [[UILabel alloc] init];
        _labNineMore.font = FONT_F12;
        _labNineMore.textColor = COLOR_C2;
        _labNineMore.text = @"0";
        _labNineMore.numberOfLines = 0;
    }
    return _labNineMore;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.font = FONT_F13;
        lab1.textColor = COLOR_B1;
        lab1.text = @"欠款总额:";
        [_bottomView addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc] init];
        lab2.font = FONT_F13;
        lab2.textColor = COLOR_B1;
        lab2.text = @"0至账期:";
        [_bottomView addSubview:lab2];
        
        UILabel *lab3 = [[UILabel alloc] init];
        lab3.font = FONT_F13;
        lab3.textColor = COLOR_B1;
        lab3.text = @"账期至90天:";
        [_bottomView addSubview:lab3];
        
        UILabel *lab4 = [[UILabel alloc] init];
        lab4.font = FONT_F13;
        lab4.textColor = COLOR_B1;
        lab4.text = @"大于90天:";
        [_bottomView addSubview:lab4];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView.mas_top).offset(20);
            make.left.equalTo(_bottomView).offset(23);
            make.width.equalTo(@75);
//            make.width.equalTo(lab3);
        }];
        
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView.mas_top).offset(20);
            make.left.equalTo(_bottomView.mas_centerX).offset(23);
            make.width.equalTo(@60);
        }];
        
        [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab1.mas_bottom).offset(15);
            make.left.equalTo(lab1);
            make.width.equalTo(lab1);
            make.bottom.equalTo(_bottomView).offset(-20);
        }];
        
        [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab1.mas_bottom).offset(15);
            make.left.equalTo(lab2);
            make.width.equalTo(lab2);
        }];
        
        [_bottomView addSubview:self.labAll];
        [_bottomView addSubview:self.labZero];
        [_bottomView addSubview:self.labNine];
        [_bottomView addSubview:self.labNineMore];
        
        [self.labAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lab1);
            make.left.equalTo(lab1.mas_right).offset(3);
            make.right.lessThanOrEqualTo(lab2.mas_left).offset(-5);
        }];
        
        [self.labZero mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lab2);
            make.left.equalTo(lab2.mas_right).offset(3);
            make.right.lessThanOrEqualTo(_bottomView.mas_right).offset(-20);
        }];
        
        [self.labNine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lab3);
            make.left.equalTo(lab3.mas_right).offset(3);
            make.right.lessThanOrEqualTo(lab4.mas_left).offset(-5);
        }];
        
        [self.labNineMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lab4);
            make.left.equalTo(lab4.mas_right).offset(3);
            make.right.lessThanOrEqualTo(_bottomView.mas_right).offset(-20);
        }];
    }
    return _bottomView;
}

@end

