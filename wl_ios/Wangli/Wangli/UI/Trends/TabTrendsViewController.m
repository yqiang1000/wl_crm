//
//  TabTrendsViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/12/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TabTrendsViewController.h"
#import "SearchTopView.h"
#import "SearchStyle.h"
#import "ChatSearchViewCtrl.h"
#import "PopMenuView.h"
#import "ScanTool.h"
#import "QMYViewController.h"
#import "SquareGridCollectionView.h"
#import "TrendsSegmentView.h"
#import "TabTrendsCollectionView.h"
#import "TrendsMoreView.h"
#import "MainTabBarViewController.h"
#import "TrendsBaseViewCtrl.h"
#import "TrendFeedItemMo.h"

@interface TabTrendsViewController () <SearchTopViewDelegate, TrendsSegmentViewDelegate, SquareGridCollectionViewDelegate, TabTrendsCollectionViewDelegate, TrendsMoreViewDelegate>

@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) UIView *squareView;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) SquareGridCollectionView *squareGridView;
@property (nonatomic, strong) UIButton *btnSquareArrow;
@property (nonatomic, strong) TrendsSegmentView *segmentView;
@property (nonatomic, strong) TabTrendsCollectionView *tabCollectionView;
@property (nonatomic, strong) TrendsMoreView *trendsMoreView;

@property (nonatomic, strong) NSMutableArray *segmentData;
@property (nonatomic, strong) NSMutableArray *segmentTitles;
@property (nonatomic, assign) NSInteger currentTag;

@end

@implementation TabTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentTag = 0;
    [self setUI];
    [self getData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:NO];
    
//    NSArray *arr = @[@"2019-01-14 14:30:00",
//                     @"2019-01-14 14:00:00",
//                     @"2019-01-14 11:50:00",
//                     @"2019-01-14 11:45:00",
//                     @"2019-01-14 01:50:00",
//                     @"2019-01-13 23:59:00",
//                     @"2019-01-13 12:50:00",
//                     @"2019-01-13 00:50:00",
//                     @"2019-01-12 23:50:00",
//                     @"2019-01-11 13:50:00",
//                     @"2018-01-11 13:50:00"];
//    for (NSString *str in arr) {
//        NSString *string = [Utils getLastUpdateInfoLastDateStr:str];
//        NSLog(@"%@", string);
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:YES];
}


- (void)setUI {
    self.naviView.lineView.hidden = YES;
    [self.naviView addSubview:self.searchView];
    [self.naviView addSubview:self.btnMore];
    [self.view addSubview:self.squareView];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tabCollectionView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.bottom.equalTo(self.naviView).offset(-8);
        make.height.equalTo(@28);
        make.right.equalTo(self.btnMore.mas_left);
    }];
    
    [self.btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.right.equalTo(self.naviView);
        make.height.width.equalTo(@40);
    }];
    
    [self.squareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(kCellWidth*kCellRate+10));
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.squareView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49.0);
    }];
    
    [self.tabCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)getData {
    // 只需要标题
    [self.segmentView refreshTitles:self.segmentTitles];
    // 需要参数
    self.tabCollectionView.arrData = self.segmentData;
    [self.tabCollectionView reloadData];
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:NO];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:YES];
}

- (void)pushToSearchVC:(BOOL)showIFly {
    if (_trendsMoreView) {
        [self.segmentView resetBtnStateNormal];
        return;
    }
    
    SearchStyle *searchStyle = [[SearchStyle alloc] init];
    searchStyle.type = SearchCustomer;
    ChatSearchViewCtrl *vc = [[ChatSearchViewCtrl alloc] init];
    vc.showIFly = showIFly;
    vc.searchStyle = searchStyle;
    BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - SquareGridCollectionViewDelegate

- (void)squareGridCollectionView:(SquareGridCollectionView *)squareGridCollectionView didSelectIndex:(NSInteger)index title:(NSString *)title {
    NSLog(@"index:%ld,title:%@", index, title);
    if (_trendsMoreView) {
        [self.segmentView resetBtnStateNormal];
        return;
    }
    
    if (index == 11) {
        [Utils showToastMessage:[NSString stringWithFormat:@"%@功能将于19年4月1日上线", title]];
        return;
    }
    NSArray *vcs = @[@"TrendsInteligenceViewCtrl",
                     @"TrendsMarketActiveViewCtrl",
                     @"TrendsClueViewCtrl",
                     @"TrendsBusinessViewCtrl",
                     
                     @"TrendsSampleViewCtrl",
                     @"TrendsQuoteViewCtrl",
                     @"TrendsContractViewCtrl",
                     @"TrendsOrderViewCtrl",
                     
                     @"TrendsShipViewCtrl",
                     @"TrendsInvoiceViewCtrl",
                     @"TrendsReceiptViewCtrl",
                     @"TrendsComplaintViewCtrl"];
    
    NSArray *vcDics = @[@"intelligence_big_category",
                        @"market_activity_status",
                        @"clue_status",
                        @"business_chance_status",
                        
                        @"",
                        @"auoted_price_status",
                        @"",
                        @"order_status",
                        
                        @"invoice_status",
                        @"billing_status",
                        @"contract_company",
                        @""];
    
    NSArray *vcSortKey1 = @[@"intelligence_business_type",
                            @"market_activity_type",
                            @"clue_resource",
                            @"business_chance_resource",
                            
                            @"sample_application",
                            @"gathering_currency",
                            @"contract_type",
                            @"order_type",
                            
                            @"",
                            @"",
                            @"currency_type",
                            @""];
    
    NSArray *vcSortKey2 = @[@"intelligence_info_type",
                            @"importance",
                            @"importance",
                            @"importance",
                            
                            @"sample_preparation",
                            @"",
                            @"market_organization",
                            @"market_organization",
                            
                            @"",
                            @"",
                            @"receipt_model",
                            @""];
    TrendsBaseViewCtrl *vc = nil;
    Class trendsBaseVC = NSClassFromString(vcs[index]);
    if (trendsBaseVC) {
        vc = [[trendsBaseVC alloc] init];
        vc.switchDicName = vcDics[index];
        vc.sortKey1 = vcSortKey1[index];
        vc.sortKey2 = vcSortKey2[index];
    }
    if (vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - TrendsSegmentViewDelegate

- (void)trendsSegmentView:(TrendsSegmentView *)trendsSegmentView didSelectIndex:(NSInteger)index title:(NSString *)title {
    NSLog(@"index:%ld,title:%@", index, title);
    _currentTag = index;
    if (_trendsMoreView) {
        [self.segmentView resetBtnStateNormal];
        return;
    }
    self.tabCollectionView.isChange = YES;
    [self.tabCollectionView selectIndex:_currentTag];
}

- (void)trendsSegmentView:(TrendsSegmentView *)trendsSegmentView didClick:(UIButton *)sender {
    if (sender.selected) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.trendsMoreView];
        self.trendsMoreView.arrData = self.segmentTitles;
        self.trendsMoreView.currentTag = _currentTag;
        [self.trendsMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.segmentView.mas_bottom);
            make.left.bottom.right.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        [self.trendsMoreView showView];
    } else {
        if (_trendsMoreView) [self.trendsMoreView hidenView];
    }
}

#pragma mark - TabTrendsCollectionViewDelegate

- (void)tabTrendsCollectionView:(TabTrendsCollectionView *)tabTrendsCollectionView didScrollToIndex:(NSInteger)index title:(NSString *)title {
    _currentTag = index;
    [self.segmentView selectIndex:_currentTag];
}

#pragma mark - TrendsMoreViewDelegate

- (void)trendsMoreView:(TrendsMoreView *)trendsMoreView didSelectIndex:(NSInteger)index title:(NSString *)title {
    [self.segmentView resetBtnStateNormal];
    if (index == -1) {
        return;
    }
    _currentTag = index;
    [self.segmentView selectIndex:_currentTag];
    self.tabCollectionView.isChange = YES;
    [self.tabCollectionView selectIndex:_currentTag];
}

- (void)trendsMoreViewDismiss:(TrendsMoreView *)trendsMoreView {
    [_trendsMoreView removeFromSuperview];
    _trendsMoreView = nil;
}

#pragma mark - event

- (void)btnMoreClick:(UIButton *)sender {
    
    if (_trendsMoreView) {
        [self.segmentView resetBtnStateNormal];
        return;
    }
    
    CGFloat width = 160.0;
    CGFloat heigth = 52;//104.0;
    //    @"扫名片    "
    PopMenuView *menuView = [[PopMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width, CGRectGetMaxY(self.btnMore.frame), width, heigth) position:ArrowPosition_RightTop arrTitle:@[@"扫批号    "] arrImage:@[@"more_sweep_number", @"more_business_card"] defaultItem:-1 itemClick:^(NSInteger index) {
        [ScanTool scanToolSuccessBlock:^(BOOL succ) {
            if (succ) {
                [self scanAction:index];
            }
        }];
    } cancelClick:^(id obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    menuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:menuView];
}

- (void)scanAction:(NSInteger)index {
    if (_trendsMoreView) {
        [self.segmentView resetBtnStateNormal];
        return;
    }
    if (index == 1) {
        [Utils showToastMessage:@"该功能正在开发中..."];
        return;
    }
    QMYViewController *scan = [[QMYViewController alloc] init];
    [scan initWithScanViewName: nil withScanLinaName:@"qrcode_Scan_weixin_Line" withPickureZoom:1];
    scan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scan animated:YES];
}

- (void)btnSquareArrowClick:(UIButton *)sender {
    self.btnSquareArrow.selected = !self.btnSquareArrow.selected;
    [self.squareGridView updateDirection:self.btnSquareArrow.selected];
    [UIView animateWithDuration:0.35 animations:^{
        [self.squareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kCellWidth*kCellRate*(self.btnSquareArrow.selected?3:1)+10));
        }];
        
        if (_trendsMoreView) {
            [self.segmentView resetBtnStateNormal];
            [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.tabCollectionView.isChange = NO;
        [self.tabCollectionView reloadData];
    }];
}

#pragma mark - lazy

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:YES];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = [SearchStyle placeholdString:SearchCustomer];
    }
    return _searchView;
}

- (UIButton *)btnMore {
    if (!_btnMore) {
        _btnMore = [[UIButton alloc] init];
        [_btnMore setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMore;
}

- (SquareGridCollectionView *)squareGridView {
    if (!_squareGridView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _squareGridView = [[SquareGridCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _squareGridView.squareGridCollectionViewDelegate = self;
    }
    return _squareGridView;
}

- (UIView *)squareView {
    if (!_squareView) {
        _squareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCellRate*kCellWidth+10)];
        _squareView.backgroundColor = COLOR_C1;
        [_squareView addSubview:self.squareGridView];
        [_squareView addSubview:self.btnSquareArrow];
        [_squareGridView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_squareView);
            make.bottom.equalTo(_squareView).offset(-10);
        }];
        
        [_btnSquareArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_squareView);
            make.bottom.equalTo(_squareView.mas_bottom).offset(-10);
            make.width.equalTo(@22.0);
            make.height.equalTo(@12.0);
        }];
    }
    return _squareView;
}

- (UIButton *)btnSquareArrow {
    if (!_btnSquareArrow) {
        _btnSquareArrow = [[UIButton alloc] init];
        [_btnSquareArrow setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        [_btnSquareArrow setImage:[UIImage imageNamed:@"pack_up"] forState:UIControlStateSelected];
        [_btnSquareArrow addTarget:self action:@selector(btnSquareArrowClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSquareArrow;
}

- (TrendsSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[TrendsSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) showBtn:YES];
        _segmentView.trendsSegmentViewDelegate = self;
        UIView *lineView = [Utils getLineView];
        [_segmentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_segmentView);
            make.height.equalTo(@0.5);
        }];
    }
    return _segmentView;
}

- (TabTrendsCollectionView *)tabCollectionView {
    if (!_tabCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _tabCollectionView = [[TabTrendsCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _tabCollectionView.tabTrendsCollectionViewDelegate = self;
    }
    return _tabCollectionView;
}

- (TrendsMoreView *)trendsMoreView {
    if (!_trendsMoreView) {
        _trendsMoreView = [[TrendsMoreView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.segmentView.frame))];
        _trendsMoreView.trendsMoreViewDelegate = self;
    }
    return _trendsMoreView;
}

- (NSMutableArray *)segmentData {
    if (!_segmentData) {
        NSArray *arrKeys = @[@"",
                             @"INTELLIGENCE_ITEM",
                             @"MARKEND_ACTIVITY",
                             @"CLUE",
                             @"BUSINESS_CHANCE",
                             
                             @"SAMPLE",
                             @"QUOTED_PRICE",
//                             @"VISIT_ACTIVITY",
//                             @"接待",
                             @"SALES_CONTRACT",
                             
                             @"RECEIPT_TRACKING",
//                             @"咨询",
//                             @"客诉",
                             @"ARTICLE",
//                             @"客户",
                             
                             @"WORKING_CIRCLE"];
        _segmentData = [NSMutableArray new];
        for (int i = 0; i < self.segmentTitles.count; i++) {
            TrendFeedItemMo *tmpMo = [[TrendFeedItemMo alloc] init];
            tmpMo.text = self.segmentTitles[i];
            tmpMo.id = i;
            tmpMo.index = i;
            tmpMo.key = arrKeys[i];
            [_segmentData addObject:tmpMo];
        }
    }
    return _segmentData;
}

- (NSMutableArray *)segmentTitles {
    if (!_segmentTitles) {
        _segmentTitles = [[NSMutableArray alloc] initWithArray:@[@"所有",
                                                                 @"情报",
                                                                 @"活动",
                                                                 @"线索",
                                                                 @"商机",
                                                                 
                                                                 @"样品",
                                                                 @"报价",
//                                                                 @"拜访",
//                                                                 @"接待",
                                                                 @"合同",
                                                                 
                                                                 @"收款",
//                                                                 @"咨询",
//                                                                 @"客诉",
                                                                 @"公告",
//                                                                 @"客户",
                                                                 
                                                                 @"工作圈"]];
    }
    return _segmentTitles;
}

@end

