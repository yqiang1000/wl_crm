//
//  Custom360FinancialRiskViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "Custom360FinancialRiskViewCtrl.h"
#import "WebDetailViewCtrl.h"
#import "FinancialSmallCardView.h"
#import "FinancialTrendCardView.h"
#import "FinancialArrearsDetailCardView.h"
#import "FinancialCompanyCardView.h"
#import "FinancialScoreCardView.h"
#import "CreditDebtMo.h"
#import "CustDeptMo.h"
#import "SwitchView.h"
#import "NSDate+Extension.h"
#import "FilterListView.h"
#import "EmptyView.h"
#import "FinanciaBisdCardView.h"

@interface Custom360FinancialRiskViewCtrl () <SwitchViewDelegate, FilterListViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) NSMutableDictionary *dicData;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL initTableView;
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) FinancialSmallCardView *smallCardView;
@property (nonatomic, strong) FinancialTrendCardView *trendView;
//@property (nonatomic, strong) FinancialCompanyCardView *companyView;
//@property (nonatomic, strong) FinancialArrearsDetailCardView *arrearsView;
@property (nonatomic, strong) FinancialScoreCardView *soreView;
@property (nonatomic, strong) FinanciaBisdCardView *bisdView;

@property (nonatomic, strong) FilterListView *filterListView;   // 列表选择
@property (nonatomic, strong) NSArray *arrTitles;

@property (nonatomic, strong) NSMutableArray *arrDebt;
@property (nonatomic, strong) CustDeptMo *custDeptMo;

@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) NSInteger sortTag;

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableArray *rightTitles;
@property (nonatomic, strong) DicMo *rightDic;
@property (nonatomic, strong) DicMo *rightDicDefault;

@property (nonatomic, strong) NSMutableArray *arrBisdData;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *arrCardData;

@end

@implementation Custom360FinancialRiskViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = COLOR_CLEAR;
    [self setUI];
    _currentTag = 0;
    _sortTag = 0;
    _page = 0;
    _initTableView = NO;
//    [self refreshcompanyView];
    [self getDefaultDicList];
    [self loadData];
    [self.switchView selectIndex:_currentTag];
    [self.smallCardView refreshView];
    [self.bisdView refreshView:@[]];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

- (void)dealloc {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
}

- (void)getDefaultDicList {
    [[JYUserApi sharedInstance] getDicListByName:@"intelligence_type" remark:self.rightDicDefault.remark param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.rightTitles = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.rightTitles insertObject:self.rightDicDefault atIndex:0];
        NSLog(@"%@", error);
    } failure:^(NSError *error) {
    }];
}

- (void)setUI {
    [self.view addSubview:self.switchView];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    [self initLeftView];
}

- (void)initLeftView {
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.smallCardView];
    [self.scrollView addSubview:self.soreView];
    [self.scrollView addSubview:self.trendView];
//    [self.scrollView addSubview:self.companyView];
//    [self.scrollView addSubview:self.arrearsView];
    [self.scrollView addSubview:self.bisdView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [self.smallCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.trendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smallCardView.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.soreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trendView.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.bisdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.soreView.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView).offset(-15);
    }];
    
//    [self.companyView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.soreView.mas_bottom);
//        make.left.right.equalTo(self.scrollView);
//        make.width.equalTo(self.scrollView);
//    }];
//
//    [self.arrearsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.companyView.mas_bottom);
//        make.left.right.equalTo(self.scrollView);
//        make.width.equalTo(self.scrollView);
//        make.bottom.equalTo(self.scrollView).offset(-15);
//    }];
}

- (void)initRightView {
    _initTableView = YES;
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.headerRefresh = YES;
    self.footerRefresh = YES;
    [self.tableView.mj_header beginRefreshing];
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"RiskFollowCell";
    RiskFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[RiskFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == self.arrData.count - 1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    [cell loadDataWithFeedMo:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    RiskFollowMo *mo = self.arrFollow[indexPath.row];
    //    if (mo.url.length != 0) {
    //        NSString *urlStr = [NSString stringWithFormat:@"%@%@token=%@&officeName=%@", mo.url, [mo.url containsString:@"?"]?@"&":@"?", [Utils token], [Utils officeName]];
    //        WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    //        vc.urlStr = urlStr;
    //        vc.titleStr = mo.title;
    //        vc.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
}

#pragma mark - SwitchViewDelegate

- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
    
    if (index == 1 && !_initTableView) [self initRightView];
    
    // 相同按钮
    if (_currentTag == index) {
        // 重置原先的
        if (_currentTag == 0) {
            [switchView updateTitle:@"" index:1 switchState:SwitchStateNormal];
        } else if (_currentTag == 1) {
            [switchView updateTitle:@"" index:0 switchState:SwitchStateNormal];
        }
        // 更新当前的
        if (state == SwitchStateSelectFirst) {
            
            if (_currentTag == 0) {
                [switchView updateTitle:@"" index:index switchState:SwitchStateSelectFirst];
                return;
            }
            
            [switchView updateTitle:@"" index:index switchState:SwitchStateSelectSecond];
            if (!_filterListView) {
                _filterListView = [[FilterListView alloc] initWithSourceType:0];
                _filterListView.delegate = self;
            }
            
            [[UIApplication sharedApplication].keyWindow addSubview:_filterListView];
            [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo([UIApplication sharedApplication].keyWindow).offset(44+STATUS_BAR_HEIGHT+49);
                make.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            
            NSMutableArray *arrTitles = [NSMutableArray new];
            if (_currentTag == 1) {
                for (DicMo *tmpDic in self.rightTitles) {
                    [arrTitles addObject:STRING(tmpDic.value)];
                }
                _filterListView.collectionView.selectTag = _sortTag;
            }
            [_filterListView loadData:arrTitles];
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-44-STATUS_BAR_HEIGHT - 49) bottomHeight:0];
            
        } else if (state == SwitchStateSelectSecond) {
            [switchView updateTitle:@"" index:index switchState:SwitchStateSelectFirst];
            
            [_filterListView removeFromSuperview];
            _filterListView = nil;
        }
    } else {
        // 不同按钮 切换操作
        _currentTag = index;
        [switchView updateTitle:@"" index:index switchState:SwitchStateSelectFirst];
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        self.scrollView.hidden = _currentTag == 0 ? NO : YES;
        if (_initTableView) self.tableView.hidden = _currentTag == 1 ? NO : YES;
    }
    
    if (_currentTag == 0) [self loadData];
}

#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    DicMo *tmpDic = nil;
    if (_currentTag == 1) {
        _sortTag = indexPath.row;
        self.rightDic = self.rightTitles[_sortTag];
        tmpDic = self.rightDic;
        [self.tableView.mj_header beginRefreshing];
    }
    [self.switchView updateTitle:STRING(tmpDic.value) index:_currentTag switchState:SwitchStateSelectFirst];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

#pragma mark - network

- (void)loadData {
    [Utils showHUDWithStatus:nil];
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    [Utils showHUDWithStatus:nil];
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getCardData];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getCharData];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getBisdData];
    });
    //当所有的任务都完成后会发送这个通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [Utils dismissHUD];
    });
}

///** 获取财务资金方块 */
//- (void)getFinanceThirdMobileMemberId:(long long)memberId
//                                param:(NSDictionary *)param
//                              success:(void (^)(id responseObject))success
//                              failure:(void (^)(NSError *error))fail;
///** 获取财务走势图 */
//- (void)getFinanceBalanceAmountMemberId:(long long)officeId
//                                  param:(NSDictionary *)param
//                                success:(void (^)(id responseObject))success
//                                failure:(void (^)(NSError *error))fail;

- (void)getCardData {
    [[JYUserApi sharedInstance] getFinanceThirdMobileMemberId:TheCustomer.customerMo.id param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.arrCardData = [CreditMo arrayOfModelsFromDictionaries:responseObject[@"beanList"] error:&error];
        self.smallCardView.msg = responseObject[@"title"];
        self.smallCardView.arrSmallData = self.arrCardData;
        [self.smallCardView refreshView];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getBisdData {
    [[JYUserApi sharedInstance] getFinanceBisdGroupByBurksMemberId:TheCustomer.customerMo.id param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.arrBisdData = [CreditMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.bisdView refreshView:self.arrBisdData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getCharData {
    
    [[JYUserApi sharedInstance] getFinanceBalanceAmountMemberId:TheCustomer.customerMo.id param:nil success:^(id responseObject) {
        [self.trendView loadDataWith:responseObject];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
    
//    [[JYUserApi sharedInstance] getCreditCountByCustomerId:TheCustomer.customerMo.id yearStr:[[NSDate date] stringWithFormat:@"yyyy"] success:^(id responseObject) {
//        self.dicData = responseObject[@"content"];
//        [self refreshView];
//    } failure:^(NSError *error) {
//        [Utils dismissHUD];
//        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//    }];
}

//- (void)getSameCompany {
//    [[JYUserApi sharedInstance] getCreditSameCompanyByCustomerId:TheCustomer.customerMo.id yearStr:[[NSDate date] stringWithFormat:@"yyyy"] success:^(id responseObject) {
//        NSError *err = nil;
//        self.arrDebt = [CreditDebtMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&err];
//        [self refreshcompanyView];
//    } failure:^(NSError *error) {
//        [Utils dismissHUD];
//        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//    }];
//}

//- (void)refreshcompanyView {
//    if (self.arrDebt.count == 0) {
//        self.companyView.hidden = YES;
//        [self.arrearsView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.trendView.mas_bottom);
//            make.left.right.equalTo(self.scrollView);
//            make.width.equalTo(self.scrollView);
//            make.bottom.equalTo(self.scrollView).offset(-15);
//        }];
//    } else {
//        self.companyView.hidden = NO;
//        [self.arrearsView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.companyView.mas_bottom);
//            make.left.right.equalTo(self.scrollView);
//            make.width.equalTo(self.scrollView);
//            make.bottom.equalTo(self.scrollView).offset(-15);
//        }];
//    }
//    self.companyView.arrData = self.arrDebt;
//    [self.companyView creditFiftyRefreshView];
//    [self.view layoutIfNeeded];
//}


#pragma mark - network

- (void)tableViewHeaderRefreshAction {
    self.page = 0;
    [self getDataByPage:self.page];
}

- (void)tableViewFooterRefreshAction {
    [self getDataByPage:self.page+1];
}

- (void)getDataByPage:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"10" forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    [param setObject:@(page) forKey:@"number"];
    
    NSMutableArray *arrRules = [NSMutableArray new];
    [arrRules addObject:@{@"field":@"member.id",
                          @"option":@"EQ",
                          @"values":@[@(TheCustomer.customerMo.id)]}];
    
    [arrRules addObject:@{@"field":@"bigCategory",
                          @"option":@"EQ",
                          @"values":@[STRING(self.rightDic.remark)]}];
    
    if (![self.rightDic.key isEqualToString:@"all"]) {
        [arrRules addObject:@{@"field":@"childCategoryId",
                              @"option":@"EQ",
                              @"values":@[self.rightDic.id]}];
    }
    [param setObject:arrRules forKey:@"rules"];
    
    [[JYUserApi sharedInstance] getFeedLowPageTrendParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TrendsFeedMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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


#pragma mark - lazy

- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithTitles:@[@"财务状况", @"财务情报"]
                                               imgNormal:@[@"", @"client_down_n"]
                                               imgSelect:@[@"", @"drop_down_s"]];
        _switchView.delegate = self;
    }
    return _switchView;
}


- (NSMutableDictionary *)dicData {
    if (!_dicData) {
        _dicData = [NSMutableDictionary new];
    }
    return _dicData;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeZero;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (FinancialSmallCardView *)smallCardView {
    if (!_smallCardView) {
        _smallCardView = [FinancialSmallCardView new];
    }
    return _smallCardView;
}

- (FinancialTrendCardView *)trendView {
    if (!_trendView) {
        _trendView = [[FinancialTrendCardView alloc] init];
    }
    return _trendView;
}

//- (FinancialArrearsDetailCardView *)arrearsView {
//    if (!_arrearsView) {
//        _arrearsView = [[FinancialArrearsDetailCardView alloc] init];
//        __weak typeof(self) weakSelf = self;
//        _arrearsView.btnDetailBlock = ^{
//            NSString *urlStr = [NSString stringWithFormat:@"%@kunnr=%ld&token=%@", CREDIT_URL, (long)TheCustomer.customerMo.id, [Utils token]];
//            WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
//            vc.urlStr = urlStr;
//            vc.titleStr = @"欠款明细表";
//            vc.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        };
//    }
//    return _arrearsView;
//}
//
//- (FinancialCompanyCardView *)companyView {
//    if (!_companyView) {
//        _companyView = [[FinancialCompanyCardView alloc] init];
//    }
//    return _companyView;
//}

- (FinancialScoreCardView *)soreView {
    if (!_soreView) {
        _soreView = [[FinancialScoreCardView alloc] init];
    }
    return _soreView;
}

- (FinanciaBisdCardView *)bisdView {
    if (!_bisdView) _bisdView = [[FinanciaBisdCardView alloc] init];
    return _bisdView;
}

- (NSMutableArray *)arrDebt {
    if (!_arrDebt) {
        _arrDebt = [NSMutableArray new];
    }
    return _arrDebt;
}

- (NSMutableArray *)arrCardData {
    if (!_arrCardData) _arrCardData = [NSMutableArray new];
    return _arrCardData;
}

- (CustDeptMo *)custDeptMo {
    if (!_custDeptMo) {
        _custDeptMo = [[CustDeptMo alloc] init];
    }
    return _custDeptMo;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [[NSMutableArray alloc] init];
    return _arrData;
}

- (NSMutableArray *)rightTitles {
    if (!_rightTitles) _rightTitles = [NSMutableArray new];
    return _rightTitles;
}

- (NSMutableArray *)arrBisdData {
    if (!_arrBisdData) _arrBisdData = [NSMutableArray new];
    return _arrBisdData;
}

- (DicMo *)rightDic {
    if (!_rightDic) {
        _rightDic = [[DicMo alloc] init];
        _rightDic.id = @"0";
        _rightDic.value = @"所有";
        _rightDic.key = @"all";
        _rightDic.remark = @"finance_type";
    }
    return _rightDic;
}


- (DicMo *)rightDicDefault {
    if (!_rightDicDefault) {
        _rightDicDefault = [[DicMo alloc] init];
        _rightDicDefault.id = @"0";
        _rightDicDefault.value = @"所有";
        _rightDicDefault.key = @"all";
        _rightDicDefault.remark = @"finance_type";
    }
    return _rightDicDefault;
}

@end
