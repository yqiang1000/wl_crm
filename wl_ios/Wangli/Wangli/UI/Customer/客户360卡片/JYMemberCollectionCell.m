//
//  JYMemberCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2019/3/18.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "JYMemberCollectionCell.h"
#import "MemberCenterMo.h"
#import "CardView.h"
#import "ValueAssessmentView.h"

@interface JYMemberCollectionCell () <UIScrollViewDelegate, ValueAssessmentViewDelegate>

// View;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SquaredCardView *squaredView;
@property (nonatomic, strong) ValueAssessmentView *valueView;
@property (nonatomic, strong) TrendsCardView *trendsView;
@property (nonatomic, strong) MonthCardView *monthView;
@property (nonatomic, strong) UIView *topGgView;

// data;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableArray *arrWorth;

@end

@implementation JYMemberCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.topGgView];
    [self.topGgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@215.0);
    }];
    
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.squaredView];
    [self.scrollView addSubview:self.valueView];
    [self.scrollView addSubview:self.trendsView];
    [self.scrollView addSubview:self.monthView];
    

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];

    [self.squaredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.valueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.squaredView.mas_bottom);
        make.left.width.equalTo(self.scrollView);
    }];

    [self.trendsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueView.mas_bottom);
        make.left.width.equalTo(self.scrollView);
    }];

    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trendsView.mas_bottom);
        make.left.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
    }];
}

    
#pragma mark - ValueAssessmentViewDelegate
    
- (void)valueAssessmentView:(ValueAssessmentView *)valueAssessmentView didselectTab:(NSInteger)tabIndex {
    NSArray *arr = @[@"VALUECONTRIBUTION",
                     @"DEMANDANALYSIS",
                     @"STRATEGICANALYSIS",
                     @"COMPETITIONANALYSIS",
                     @"QUALITYCOST",
                     @"KEYDEMAND",
                     @"KEYINDICATORS"];
    if (tabIndex >=0 && tabIndex < arr.count) {
        [[JYUserApi sharedInstance] getWorthbeanMemberId:self.model.id key:arr[tabIndex] param:nil success:^(id responseObject) {
            NSError *error = nil;
            self.arrWorth = [WorthBeanMo arrayOfModelsFromDictionaries:responseObject[@"data"] error:&error];
            WorthBeanMo *beanMo = [[WorthBeanMo alloc] init];
            beanMo.leftContent = @"评价指标";
            beanMo.rightContent = @"指标柱状图";
            beanMo.score = @"得分";
            beanMo.isTitle = YES;
            [self.arrWorth insertObject:beanMo atIndex:0];
            [self.valueView refreshView:self.arrWorth];
            [self layoutIfNeeded];
        } failure:^(NSError *error) {
            
        }];
    }
}

    
- (void)loadData:(CustomerMo *)model {
    if (_model != model) _model = model;
    [TheCustomer updateCustomer:_model];
    [self valueAssessmentView:self.valueView didselectTab:0];
    [self.valueView resetSegmentView:0];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self getConfig];
}
    
- (void)getConfig {
    TheCustomer.centerMo = [MemberCenterMo new];
    [_arrData removeAllObjects];
    _arrData = nil;
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getMemberCenter];
    });
    //当所有的任务都完成后会发送这个通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self layoutIfNeeded];
    });
}
    
- (void)getMemberCenter {
    [[JYUserApi sharedInstance] getMemberCenterByMemberId:_model.id success:^(id responseObject) {
        NSError *error = nil;
        CustomerMo *customerMo = [[CustomerMo alloc] initWithDictionary:responseObject error:&error];
        
//        self.model = customerMo;
//        self.centerMo = [[MemberCenterMo alloc] initWithDictionary:responseObject error:&error];
//        self.authorityBean = [[AuthorityBean alloc] initWithDictionary:responseObject[@"authorityBean"] error:nil];
        
        [TheCustomer updateCustomer:customerMo];
        TheCustomer.centerMo = [[MemberCenterMo alloc] initWithDictionary:responseObject error:&error];
        TheCustomer.authorityBean = [[AuthorityBean alloc] initWithDictionary:responseObject[@"authorityBean"] error:nil];
        [_arrData removeAllObjects];
        _arrData = nil;
        [self refreshView];
        [self confirmTopFlag:[responseObject[@"authorityBean"][@"topFlag"] boolValue]];
    } failure:^(NSError *error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}
    
- (void)confirmTopFlag:(BOOL)topFlag {
    if (!topFlag) {
        [Utils showToastMessage:@"暂无权限"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[Utils topViewController].navigationController popViewControllerAnimated:YES];
        });
    }
}
    
- (void)refreshView {
//    self.squaredView.arrData = self.arrData;
//    [self.squaredView refreshView:self.model];
//    [self.trendsView refreshView:self.centerMo];
//    [self.monthView refreshView:self.centerMo];
//    self.valueView.labLevel.text = [NSString stringWithFormat:@"信用等级:%@", self.centerMo.creditLevelValue.length == 0 ? @"暂无" : self.centerMo.creditLevelValue];
    
    self.squaredView.arrData = self.arrData;
    [self.squaredView refreshView:TheCustomer.customerMo];
    //    [self.dashboardView refreshView:TheCustomer.customerMo centerMo:TheCustomer.centerMo];
    [self.trendsView refreshView:TheCustomer.centerMo];
    [self.monthView refreshView:TheCustomer.centerMo];
    self.valueView.labLevel.text = [NSString stringWithFormat:@"信用等级:%@", TheCustomer.centerMo.creditLevelValue.length == 0 ? @"暂无" : TheCustomer.centerMo.creditLevelValue];
}

#pragma mark - lazy

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_C2;
    }
    return _baseView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
        NSMutableArray *arrName = [NSMutableArray new];
        [arrName addObject:@"基本资料"];
        [arrName addObject:[NSString stringWithFormat:@"人事组织(%ld)", (long)self.centerMo.linkManCount]];
        [arrName addObject:[NSString stringWithFormat:@"门店信息(%ld)", (long)self.centerMo.warningCount]];
        [arrName addObject:[NSString stringWithFormat:@"经销商(%ld)", (long)self.centerMo.procurementStatusCount]];
        [arrName addObject:@"系统信息"];
        
        NSArray *arrImg = @[@"c_basic_information",
                            @"c_personnel_organization",
                            @"c_shop_information",
                            @"c_purchase",
                            @"c_production_status"];
        
        for (int i = 0; i < arrImg.count; i++) {
            NSArray *arr = @[arrName[i], arrImg[i]];
            [_arrData addObject:arr];
        }
    }
    return _arrData;
}
    
    
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.contentSize = CGSizeZero;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
    
- (SquaredCardView *)squaredView {
    if (!_squaredView) {
        _squaredView = [[SquaredCardView alloc] init];
    }
    return _squaredView;
}
    
- (TrendsCardView *)trendsView {
    if (!_trendsView) {
        _trendsView = [[TrendsCardView alloc] init];
    }
    return _trendsView;
}
    
- (MonthCardView *)monthView {
    if (!_monthView) {
        _monthView = [[MonthCardView alloc] init];
    }
    return _monthView;
}
    
- (ValueAssessmentView *)valueView {
    if (!_valueView ) {
        _valueView = [[ValueAssessmentView alloc] init];
        _valueView.valueAssessmentViewDelegate = self;
    }
    return _valueView;
}
    
- (NSMutableArray *)arrWorth {
    if (!_arrWorth) {
        _arrWorth = [NSMutableArray new];
    }
    return _arrWorth;
}

- (UIView *)topGgView {
    if (!_topGgView) {
        _topGgView = [[UIView alloc] init];
        _topGgView.backgroundColor = COLOR_C1;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)COLOR_0279E3.CGColor, (__bridge id)COLOR_62B2F9.CGColor];
        //        gradientLayer.locations = @[@0.3, @0.5, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0,1.0);
        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 215);
        [_topGgView.layer addSublayer:gradientLayer];
    }
    return _topGgView;
}

- (MemberCenterMo *)centerMo {
    if (!_centerMo) {
        _centerMo = [[MemberCenterMo alloc] init];
    }
    return _centerMo;
}

- (AuthorityBean *)authorityBean {
    if (!_authorityBean) _authorityBean = [[AuthorityBean alloc] init];
    return _authorityBean;
}

@end
