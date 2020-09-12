//
//  Custom360ContractTrackingViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "Custom360ContractTrackingViewCtrl.h"
#import "SwitchView.h"
#import "FilterListView.h"
#import "EmptyView.h"
#import "PurchaseCollectionView.h"
#import "TrendsBaseViewCtrl.h"

@interface Custom360ContractTrackingViewCtrl () <SwitchViewDelegate, FilterListViewDelegate, PurchaseCollectionViewDelegate>

{
    EmptyView *_emptyView;
}
@property (nonatomic, assign) BOOL initPageView;
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) FilterListView *filterListView;
@property (nonatomic, strong) NSMutableArray *arrCardData;
@property (nonatomic, strong) PurchaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSArray *arrTitles;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) NSInteger sortTag1;
@property (nonatomic, assign) NSInteger sortTag2;

@property (nonatomic, strong) NSMutableArray *leftTitles;
@property (nonatomic, strong) DicMo *leftDic;
@property (nonatomic, strong) DicMo *leftDicDefault;

@property (nonatomic, assign) NSInteger page;

@end

@implementation Custom360ContractTrackingViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _initPageView = NO;
    _currentTag = 0;
    _sortTag1 = 0;
    _sortTag2 = 0;
    _page = 0;
    [_switchView selectIndex:_currentTag];
    [_switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
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
    _initPageView = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.collectionView.mj_header beginRefreshing];
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

- (void)getSummaryData {
    [[JYUserApi sharedInstance] getConfigDicByName:@"contract_follow_feed_icon" success:^(id responseObject) {
        NSError *error = nil;
        self.leftTitles = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.leftTitles insertObject:self.leftDicDefault atIndex:0];
    } failure:^(NSError *error) {
    }];
    
    [[JYUserApi sharedInstance] getContractSummaryNumberByMemberId:TheCustomer.customerMo.id param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.arrCardData = [PurchaseItemMo arrayOfModelsFromDictionaries:responseObject error:&error];
        self.collectionView.arrCardData = self.arrCardData;
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
    }];
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
    
    
    if (index == 1 && !_initPageView) [self initRightView];
    
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
        if (_initPageView) self.collectionView.hidden = _currentTag == 1 ? NO : YES;
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
    // 合同
    if ([purchaseItemMo.field isEqualToString:@"Contract"]) index = 0;
    // 订单
    if ([purchaseItemMo.field isEqualToString:@"Order"]) index = 1;
    // 发货
    if ([purchaseItemMo.field isEqualToString:@"Invoice"]) index = 2;
    // 发票
    if ([purchaseItemMo.field isEqualToString:@"SalesBilling"]) index = 3;
    // 付款
    if ([purchaseItemMo.field isEqualToString:@"ReceiptTracking"]) index = 4;
    
    NSArray *vcs = @[@"TrendsContractViewCtrl",
                     @"TrendsOrderViewCtrl",
                     @"TrendsShipViewCtrl",
                     @"TrendsInvoiceViewCtrl",
                     @"TrendsReceiptViewCtrl"];
    
    NSArray *vcDics = @[@"",
                        @"order_status",
                        @"invoice_status",
                        @"billing_status",
                        @"contract_company"];
    
    NSArray *vcSortKey1 = @[@"contract_type",
                            @"order_type",
                            @"",
                            @"order_type",
                            @"currency_type"];
    
    NSArray *vcSortKey2 = @[@"market_organization",
                            @"market_organization",
                            @"",
                            @"market_organization",
                            @"receipt_type"];
    
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
                          @"values":@[@"contract"]}];
    
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

- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithTitles:@[@"所有", @"总览"]
                                               imgNormal:@[@"client_down_n", @""]
                                               imgSelect:@[@"drop_down_s", @""]];
        _switchView.delegate = self;
    }
    return _switchView;
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

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [[NSMutableArray alloc] init];
    return _arrData;
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
        _leftDic.name = @"contract_follow_feed_icon";
    }
    return _leftDic;
}

- (DicMo *)leftDicDefault {
    if (!_leftDicDefault) {
        _leftDicDefault = [[DicMo alloc] init];
        _leftDicDefault.id = @"0";
        _leftDicDefault.remark = @"所有";
        _leftDicDefault.key = @"all";
        _leftDicDefault.name = @"contract_follow_feed_icon";
    }
    return _leftDicDefault;
}


- (NSMutableArray *)arrCardData {
    if (!_arrCardData) {
        _arrCardData = [NSMutableArray new];
        
//        PurchaseItemMo *mo1 = [[PurchaseItemMo alloc] init];
//        mo1.iconUrl = @"contract";
//        mo1.fieldValue = @"合同";
//        mo1.count = 0;
//        [_arrCardData addObject:mo1];
//
//        PurchaseItemMo *mo2 = [[PurchaseItemMo alloc] init];
//        mo2.iconUrl = @"order";
//        mo2.fieldValue = @"订单";
//        mo2.count = 1;
//        [_arrCardData addObject:mo2];
//
//        PurchaseItemMo *mo3 = [[PurchaseItemMo alloc] init];
//        mo3.iconUrl = @"delivery";
//        mo3.fieldValue = @"发货";
//        mo3.count = 2;
//        [_arrCardData addObject:mo3];
//
//        PurchaseItemMo *mo4 = [[PurchaseItemMo alloc] init];
//        mo4.iconUrl = @"invoice";
//        mo4.fieldValue = @"发票";
//        mo4.count = 0;
//        [_arrCardData addObject:mo4];
//
//        PurchaseItemMo *mo5 = [[PurchaseItemMo alloc] init];
//        mo5.iconUrl = @"receivables";
//        mo5.fieldValue = @"收款";
//        mo5.count = 0;
//        [_arrCardData addObject:mo5];
//
//        PurchaseItemMo *mo6 = [[PurchaseItemMo alloc] init];
//        mo6.iconUrl = @"reconciliation";
//        mo6.fieldValue = @"对账";
//        mo6.count = 0;
//        [_arrCardData addObject:mo6];
    }
    return _arrCardData;
}


@end
