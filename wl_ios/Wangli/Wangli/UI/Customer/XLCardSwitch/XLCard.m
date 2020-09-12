//
//  Card.m
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XLCard.h"
#import "XLCardItem.h"
#import "CustomerCollectionView.h"
#import "MemberCenterMo.h"
#import "CardView.h"
#import "RadarMo.h"
#import "ValueAssessmentView.h"

@interface XLCard () <UIScrollViewDelegate, ValueAssessmentViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableArray *arrRadar;
@property (nonatomic, strong) SquaredCardView *squaredView;
@property (nonatomic, strong) ValueAssessmentView *valueView;
@property (nonatomic, strong) TrendsCardView *trendsView;
@property (nonatomic, strong) MonthCardView *monthView;
@property (nonatomic, strong) NSMutableArray *arrWorth;

//@property (nonatomic, strong) DashboardCardView *dashboardView;
//@property (nonatomic, strong) RadarCardView *radarView;
//@property (nonatomic, strong) PostCardView *postView;

@end

@implementation XLCard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = true;
        self.contentView.backgroundColor = COLOR_CLEAR;
        
        [self setUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAvatorSuccess:) name:NOTIFI_UPDATE_URL_SUCCESS object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateAvatorSuccess:(NSNotification *)noti {
    [self getConfig];
}

- (void)setUI {
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.squaredView];
//    [self.scrollView addSubview:self.valueView];
//    [self.scrollView addSubview:self.trendsView];
//    [self.scrollView addSubview:self.monthView];
    
//    [self.scrollView addSubview:self.dashboardView];
//    [self.scrollView addSubview:self.radarView];
//    [self.scrollView addSubview:self.postView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.squaredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
    }];
    
//    [self.valueView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.squaredView.mas_bottom);
//        make.left.width.equalTo(self.scrollView);
//    }];
    
//    [self.radarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.squaredView.mas_bottom);
//        make.left.width.equalTo(self.scrollView);
//    }];
    
//    [self.dashboardView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.radarView.mas_bottom);
//        make.left.width.equalTo(self.scrollView);
//    }];
    
//    [self.postView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.dashboardView.mas_bottom);
//        make.left.width.equalTo(self.scrollView);
//    }];
    
//    [self.trendsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.valueView.mas_bottom);
//        make.left.width.equalTo(self.scrollView);
//    }];
//
//    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.trendsView.mas_bottom);
//        make.left.width.equalTo(self.scrollView);
//        make.bottom.equalTo(self.scrollView);
//    }];
}

-(void)setItem:(XLCardItem *)item {
    _item = item;
    NSLog(@"777777777777777---%ld", (long)item.mo.id);
//    TheCustomer.customerMo = _item.mo;
    [TheCustomer updateCustomer:_item.mo];
    NSLog(@"777777777777777The---%ld", (long)TheCustomer.customerMo.id);
    [self refreshView];
//    [self.radarView refreshView:self.arrRadar];
    [self getConfig];
//    [self valueAssessmentView:self.valueView didselectTab:0];
//    [self.valueView resetSegmentView:0];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)getConfig {
    TheCustomer.centerMo = [MemberCenterMo new];
    [_arrData removeAllObjects];
    _arrData = nil;
    _arrRadar = nil;
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getMemberCenter];
    });
//    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//        [self getMemberRadar];
//    });
//    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//        [self getMemberInvoice];
//    });
    //当所有的任务都完成后会发送这个通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self layoutIfNeeded];
    });
}

- (void)getMemberCenter {
    [[JYUserApi sharedInstance] getMemberCenterByMemberId:TheCustomer.customerMo.id success:^(id responseObject) {
        NSError *error = nil;
        CustomerMo *customerMo = [[CustomerMo alloc] initWithDictionary:responseObject error:&error];
//        TheCustomer.customerMo = customerMo;
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

//- (void)getMemberRadar {
//    [[JYUserApi sharedInstance] getMemberRadarChatMemberId:TheCustomer.customerMo.id success:^(id responseObject) {
//        NSError *error = nil;
//        self.arrRadar = [RadarMo arrayOfModelsFromDictionaries:responseObject error:&error];
//        [self.radarView refreshView:self.arrRadar];
//    } failure:^(NSError *error) {
//        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//    }];
//}

//- (void)getMemberInvoice {
//    [[JYUserApi sharedInstance] getInvoiceChartMobileByMemberId:TheCustomer.customerMo.id success:^(id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSMutableDictionary class]]) {
//            [self.postView loadDataWith:responseObject];
//        }
//    } failure:^(NSError *error) {
//        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//    }];
//}

- (void)refreshView {
    self.squaredView.arrData = self.arrData;
    [self.squaredView refreshView:TheCustomer.customerMo];
//    [self.dashboardView refreshView:TheCustomer.customerMo centerMo:TheCustomer.centerMo];
//    [self.trendsView refreshView:TheCustomer.centerMo];
//    [self.monthView refreshView:TheCustomer.centerMo];
//    self.valueView.labLevel.text = [NSString stringWithFormat:@"信用等级:%@", TheCustomer.centerMo.creditLevelValue.length == 0 ? @"暂无" : TheCustomer.centerMo.creditLevelValue];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CUSTOMER_360_SCROLL object:nil userInfo:@{@"offsetY": [NSNumber numberWithDouble:offsetY]}];
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
        [[JYUserApi sharedInstance] getWorthbeanMemberId:TheCustomer.customerMo.id key:arr[tabIndex] param:nil success:^(id responseObject) {
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



//__strong typeof(self) strongSelf = weakSelf;
//strongSelf.tagStr = titles[index];
//[strongSelf.tableView reloadData];

#pragma mark - setter getter

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
        NSMutableArray *arrName = [NSMutableArray new];
        [arrName addObject:@"基本资料"];
        [arrName addObject:[NSString stringWithFormat:@"人事组织(%ld)", (long)TheCustomer.centerMo.linkManCount]];
        [arrName addObject:[NSString stringWithFormat:@"门店信息(%ld)", (long)TheCustomer.centerMo.stormeManageCount]];
        [arrName addObject:[NSString stringWithFormat:@"经销商(%ld)", (long)TheCustomer.centerMo.dealerPlanCount]];
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

- (NSMutableArray *)arrRadar {
    if (!_arrRadar) {
        _arrRadar = [NSMutableArray new];
    }
    return _arrRadar;
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

//- (DashboardCardView *)dashboardView {
//    if (!_dashboardView) {
//        _dashboardView = [[DashboardCardView alloc] init];
//    }
//    return _dashboardView;
//}

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

//- (RadarCardView *)radarView {
//    if (!_radarView) {
//        _radarView = [[RadarCardView alloc] init];
//    }
//    return _radarView;
//}
//
//- (PostCardView *)postView {
//    if (!_postView) {
//        _postView = [[PostCardView alloc] init];
//    }
//    return _postView;
//}

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

@end
