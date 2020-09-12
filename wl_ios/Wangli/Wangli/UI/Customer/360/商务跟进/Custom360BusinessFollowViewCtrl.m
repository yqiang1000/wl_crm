//
//  Custom360BusinessFollowViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "Custom360BusinessFollowViewCtrl.h"
#import "SwitchView.h"
#import "FilterListView.h"
#import "EmptyView.h"
#import "PurchaseCollectionView.h"
#import "BusinessFunnelView.h"
#import "BusinessClueView.h"
#import "TrendsBaseViewCtrl.h"

@interface Custom360BusinessFollowViewCtrl () <SwitchViewDelegate, FilterListViewDelegate, PurchaseCollectionViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, assign) BOOL initScrollView;
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) FilterListView *filterListView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) PurchaseCollectionView *collectionView;
@property (nonatomic, strong) BusinessFunnelView *funnelView;
@property (nonatomic, strong) BusinessClueView *clueView;

@property (nonatomic, strong) NSMutableArray *funnelData;
@property (nonatomic, strong) NSMutableArray *clueData;
@property (nonatomic, strong) NSMutableArray *arrCardData;

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) NSInteger sortTag1;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *leftTitles;
@property (nonatomic, strong) DicMo *leftDic;
@property (nonatomic, strong) DicMo *leftDicDefault;

@end

@implementation Custom360BusinessFollowViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _initScrollView = NO;
    _currentTag = 0;
    _sortTag1 = 0;
    _page = 0;
    [self.switchView selectIndex:_currentTag];
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getSummaryData];
}

- (void)dealloc {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
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

- (void)initRightView {
    _initScrollView = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.topView];
//    [self.scrollView addSubview:self.funnelView];
//    [self.scrollView addSubview:self.clueView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
    }];
    
//    [self.funnelView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topView.mas_bottom).offset(10);
//        make.left.right.equalTo(self.scrollView);
//        make.width.equalTo(self.scrollView);
////        make.bottom.equalTo(self.scrollView);
//        make.height.equalTo(@200.0);
//    }];
//
//    [self.clueView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.funnelView.mas_bottom);
//        make.left.right.equalTo(self.scrollView);
//        make.width.equalTo(self.scrollView);
//        make.bottom.lessThanOrEqualTo(self.scrollView);
//    }];
    [self refreshCollectionView];
}

- (void)initLeftView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.headerRefresh = YES;
    self.footerRefresh = YES;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - network

- (void)getData {
    [self.funnelData addObject:[[FunnelMo alloc] initWithTitle:@"01 线索" color:COLOR_C1 number:@"100"]];
    [self.funnelData addObject:[[FunnelMo alloc] initWithTitle:@"02 商机" color:COLOR_C2 number:@"70"]];
    [self.funnelData addObject:[[FunnelMo alloc] initWithTitle:@"03 报价" color:COLOR_C3 number:@"50"]];
    [self.funnelData addObject:[[FunnelMo alloc] initWithTitle:@"04 合同" color:COLOR_B2 number:@"30"]];
    [self.funnelView.funnelView loadData:self.funnelData];
    [self.clueView loadData:self.clueData];
}

- (void)getSummaryData {
    [[JYUserApi sharedInstance] getConfigDicByName:@"business_follow_feed" success:^(id responseObject) {
        NSError *error = nil;
        self.leftTitles = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.leftTitles insertObject:self.leftDicDefault atIndex:0];
    } failure:^(NSError *error) {
    }];
    [[JYUserApi sharedInstance] getBusinessFollowSummaryNumberByMemberId:TheCustomer.customerMo.id param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.arrCardData = [PurchaseItemMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self refreshCollectionView];
    } failure:^(NSError *error) {
    }];
}

- (void)refreshCollectionView {
    self.collectionView.arrCardData = self.arrCardData;
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(_collectionView.collectionViewLayout.collectionViewContentSize.height));
        }];
        [self.topView layoutIfNeeded];
    });
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
    
    if (index == 1 && !_initScrollView) [self initRightView];
    
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
            if (_currentTag == 1) {
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
            if (_currentTag == 0) {
                for (DicMo *tmpDic in self.leftTitles) {
                    [arrTitles addObject:STRING(tmpDic.remark)];
                }
                _filterListView.collectionView.selectTag = _sortTag1;
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
        self.tableView.hidden = _currentTag == 0 ? NO : YES;
        if (_initScrollView) self.scrollView.hidden = _currentTag == 1 ? NO : YES;
    }
}

#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    DicMo *tmpDic = nil;
    if (_currentTag == 0) {
        _sortTag1 = indexPath.row;
        self.leftDic = self.leftTitles[_sortTag1];
        tmpDic = self.leftDic;
        [self.tableView.mj_header beginRefreshing];
    }
    [self.switchView updateTitle:STRING(tmpDic.remark) index:_currentTag switchState:SwitchStateSelectFirst];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

#pragma mark - PurchaseCollectionViewDelegate

- (void)purchaseCollectionView:(PurchaseCollectionView *)purchaseCollectionView didSelectedIndexPath:(NSIndexPath *)indexPath purchaseItemMo:(PurchaseItemMo *)purchaseItemMo {
    NSLog(@"index:%ld,title:%@", indexPath.item, purchaseItemMo.fieldValue);
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
    NSInteger index = 0;
    // 线索
    if ([purchaseItemMo.field isEqualToString:@"Clue"]) index = 0;
    // 商机
    if ([purchaseItemMo.field isEqualToString:@"BusinessChance"]) index = 1;
    // 报价
    if ([purchaseItemMo.field isEqualToString:@"QuotedPrice"]) index = 2;
    // 样品
    if ([purchaseItemMo.field isEqualToString:@"Sample"]) index = 3;
    
    NSArray *vcs = @[@"TrendsClueViewCtrl",
                     @"TrendsBusinessViewCtrl",
                     @"TrendsQuoteViewCtrl",
                     @"TrendsSampleViewCtrl"];
    
    NSArray *vcDics = @[@"clue_status",
                        @"business_chance_status",
                        @"auoted_price_status",
                        @"sample_status"];
    
    NSArray *vcSortKey1 = @[@"clue_resource",
                            @"business_chance_resource",
                            @"gathering_currency",
                            @"sample_type"];
    
    NSArray *vcSortKey2 = @[@"importance",
                            @"importance",
                            @"battery_type",
                            @"sample_preparation"];
    
    TrendsBaseViewCtrl *vc = nil;
    Class trendsBaseVC = NSClassFromString(vcs[index]);
    if (trendsBaseVC) {
        vc = [[trendsBaseVC alloc] init];
        vc.switchDicName = vcDics[index];
        vc.sortKey1 = vcSortKey1[index];
        vc.sortKey2 = vcSortKey2[index];
        vc.memberId = TheCustomer.customerMo.id;
    }
    if (vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

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
                          @"values":@[@"business_follow"]}];
    
    if (![self.leftDic.key isEqualToString:@"all"]) {
        [arrRules addObject:@{@"field":@"childCategoryId",
                              @"option":@"EQ",
                              @"values":@[self.leftDic.id]}];
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

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeZero;
    }
    return _scrollView;
}

- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithTitles:@[@"所有", @"总览"]
                                               imgNormal:@[@"client_down_n", @""]
                                               imgSelect:@[@"drop_down_s", @""]];
        _switchView.delegate = self;
    }
    return _switchView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        [_topView addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(_topView);
        }];
    }
    return _topView;
}

- (PurchaseCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[PurchaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.purchaseCollectionViewDelegate = self;
        _collectionView.arrCardData = self.arrCardData;
    }
    return _collectionView;
}

- (BusinessFunnelView *)funnelView {
    if (!_funnelView) {
        _funnelView = [[BusinessFunnelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 205)];
    }
    return _funnelView;
}

- (BusinessClueView *)clueView {
    if (!_clueView) {
        _clueView = [[BusinessClueView alloc] init];
    }
    return _clueView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [[NSMutableArray alloc] init];
    return _arrData;
}

- (NSMutableArray *)arrCardData {
    if (!_arrCardData) {
        _arrCardData = [NSMutableArray new];
        
        PurchaseItemMo *mo1 = [[PurchaseItemMo alloc] init];
        mo1.iconUrl = @"sale_system";
        mo1.fieldValue = @"销售体系文件";
        mo1.count = 0;
        [_arrCardData addObject:mo1];
        
        PurchaseItemMo *mo2 = [[PurchaseItemMo alloc] init];
        mo2.iconUrl = @"customer_directory";
        mo2.fieldValue = @"客户名录";
        mo2.count = 1;
        [_arrCardData addObject:mo2];
        
        PurchaseItemMo *mo3 = [[PurchaseItemMo alloc] init];
        mo3.iconUrl = @"sales_quotation";
        mo3.fieldValue = @"销售报价";
        mo3.count = 2;
        [_arrCardData addObject:mo3];
        
        PurchaseItemMo *mo4 = [[PurchaseItemMo alloc] init];
        mo4.iconUrl = @"imports_and_exports";
        mo4.fieldValue = @"进出口产品";
        mo4.count = 0;
        [_arrCardData addObject:mo4];
    }
    return _arrCardData;
}

- (NSMutableArray *)funnelData {
    if (!_funnelData) {
        _funnelData = [NSMutableArray new];
    }
    return _funnelData;
}

- (NSMutableArray *)clueData {
    if (!_clueData) {
        _clueData = [NSMutableArray new];
        for (int i = 0; i < 4; i++) {
            [_clueData addObject:@"1"];
        }
    }
    return _clueData;
}


- (NSMutableArray *)leftTitles {
    if (!_leftTitles) _leftTitles = [NSMutableArray new];
    return _leftTitles;
}

- (DicMo *)leftDic {
    if (!_leftDic) {
        _leftDic = [[DicMo alloc] init];
        _leftDic.id = @"0";
        _leftDic.remark = @"所有";
        _leftDic.key = @"all";
        _leftDic.name = @"business_follow_feed";
    }
    return _leftDic;
}

- (DicMo *)leftDicDefault {
    if (!_leftDicDefault) {
        _leftDicDefault = [[DicMo alloc] init];
        _leftDicDefault.id = @"0";
        _leftDicDefault.remark = @"所有";
        _leftDicDefault.key = @"all";
        _leftDicDefault.name = @"business_follow_feed";
    }
    return _leftDicDefault;
}


@end
