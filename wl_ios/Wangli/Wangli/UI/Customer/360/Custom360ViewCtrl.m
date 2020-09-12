//
//  Custom360ViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/11.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360ViewCtrl.h"
#import "ZJScrollPageView.h"
#import "SubjectViewCtrl.h"
#import "PopMenuView.h"

@interface Custom360ViewCtrl () <ZJScrollPageViewDelegate>

@property (strong, nonatomic) NSMutableArray<NSString *> *titles;
@property (strong, nonatomic) NSMutableArray<NSString *> *ctrlNames;
@property (nonatomic, strong) SubjectViewCtrl<ZJScrollPageViewChildVcDelegate> *childVc;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation Custom360ViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.naviView.labTitle.hidden = YES;
//    self.naviView.lineView.backgroundColor = COLOR_C1;
    self.naviView.hidden = YES;
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    // 缩放标题
    style.scaleTitle = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.normalTitleColor = COLOR_B4;
    style.selectedTitleColor = COLOR_B4;
    style.titleFont = FONT_F16;
    style.titleMargin = 25;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Wangli360ItemList" ofType:@"plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:path];
    self.titles = [NSMutableArray new];
    self.ctrlNames = [NSMutableArray new];
    for (NSDictionary *dic in data) {
        [self.titles addObject:STRING(dic[@"title"])];
        [self.ctrlNames addObject:STRING(dic[@"viewCtrl"])];
    }
    
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    // 这里可以设置头部视图的属性(背景色, 圆角, 背景图片...)
    self.scrollPageView.segmentView.backgroundColor = COLOR_C1;
    [self.view addSubview:self.scrollPageView];
    
    [self.scrollPageView setSelectedIndex:_selectIndex animated:NO];
//    [self.scrollPageView.segmentView setSelectedIndex:_selectIndex animated:NO];
//    [self.scrollPageView.segmentView adjustUIWhenBtnOnClickWithAnimate:NO taped:YES];
    
    __weak typeof(self) weakSelf = self;
    self.scrollPageView.btnBackBlock = ^{
        [weakSelf.childVc viewWillDisappear:NO];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_UPDATE_URL_SUCCESS object:nil];
    };
    
    __weak typeof(ZJScrollPageView) *weakZJPageView = self.scrollPageView;
    self.scrollPageView.btnMoreClick = ^{
        CGFloat width = 170.0;
        CGFloat heigth = 40 * weakSelf.titles.count + 10;
        
        NSArray *titles = @[@"基本资料   ",
                            @"人事组织   ",
                            @"门店信息   ",
                            @"经销商       ",
//                            @"生产及品质",
//                            @"销售状况   ",
//                            @"研发状况   ",
//                            @"商务拜访   ",
//                            @"商机跟进   ",
//                            @"合同跟踪   ",
//                            @"服务投诉   ",
//                            @"费用分析   ",
                            @"系统信息   "
                            ];
        NSArray *images = @[@"c_basic_information",
                            @"c_personnel_organization",
                            @"c_financial_risk",
                            @"c_purchase",
//                            @"c_production_status",
//                            @"c_sales",
//                            @"c_research",
//                            @"c_visit",
//                            @"c_business",
//                            @"c_contract",
//                            @"c_complain",
//                            @"c_cost",
                            @"c_system_message"
                            ];
        
        PopMenuView *menuView = [[PopMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width, Height_NavBar, width, heigth) position:ArrowPosition_RightTop arrTitle:titles arrImage:images defaultItem:-1 itemClick:^(NSInteger index) {
            weakSelf.selectIndex = index;
            [weakZJPageView setSelectedIndex:weakSelf.selectIndex animated:NO];
            [weakZJPageView.segmentView setSelectedIndex:weakSelf.selectIndex animated:NO enBlock:NO];
        } cancelClick:^(id obj) {
            [obj removeFromSuperview];
            obj = nil;
        }];
        menuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [[UIApplication sharedApplication].keyWindow addSubview:menuView];
    };
}

#pragma mark -  ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    _childVc = reuseViewController;
    if (!_childVc) {
        NSString *string = STRING(self.ctrlNames[index]);
        Class class = NSClassFromString(string);
        _childVc = [[class alloc] init];
    }
    return _childVc;
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    [childViewController viewWillAppear:NO];
    NSLog(@"%ld ---将要出现",(long)index);
    [((SubjectViewCtrl *)childViewController) addUnAuthortyView:[TheCustomer.authoritys[index] boolValue]];
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    [childViewController viewDidAppear:NO];
    NSLog(@"%ld ---已经出现",(long)index);
//    [((SubjectViewCtrl *)childViewController) addUnAuthortyView:[TheCustomer.authoritys[index] boolValue]];
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    [childViewController viewWillDisappear:NO];
    NSLog(@"%ld ---将要消失",(long)index);
    
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    [childViewController viewDidDisappear:NO];
    NSLog(@"%ld ---已经消失",(long)index);
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

@end
