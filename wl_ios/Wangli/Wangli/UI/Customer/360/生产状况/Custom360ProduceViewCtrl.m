//
//  Custom360ProduceViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360ProduceViewCtrl.h"
#import "SwitchView.h"
#import "FilterListView.h"
#import "EmptyView.h"
#import "ProducePageViewCtrl.h"

@interface Custom360ProduceViewCtrl () <SwitchViewDelegate, FilterListViewDelegate>

{
    EmptyView *_emptyView;
}
@property (nonatomic, assign) BOOL initTableView;
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) FilterListView *filterListView;
@property (nonatomic, strong) UIView *showListView;

@property (nonatomic, strong) ProducePageViewCtrl *pageViewCtrl;

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableArray *leftTitles;
@property (nonatomic, strong) NSMutableArray *rightTitles;
@property (nonatomic, strong) DicMo *leftDic;
@property (nonatomic, strong) DicMo *rightDic;
@property (nonatomic, strong) DicMo *leftDicDefault;
@property (nonatomic, strong) DicMo *rightDicDefault;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) NSInteger sortTag1;
@property (nonatomic, assign) NSInteger sortTag2;
@property (nonatomic, assign) NSInteger page;

@end

@implementation Custom360ProduceViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _initTableView = NO;
    _currentTag = 0;
    _sortTag1 = 0;
    _sortTag2 = 0;
    _page = 0;
    [_switchView selectIndex:_currentTag];
    [_switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
    [self getDefaultDicList];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getDefaultDicList];
}

- (void)getDefaultDicList {
    [[JYUserApi sharedInstance] getDicListByName:@"intelligence_type" remark:self.rightDicDefault.remark param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.rightTitles = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.rightTitles insertObject:self.rightDicDefault atIndex:0];
        NSLog(@"%@", error);
    } failure:^(NSError *error) {
    }];
    
    [[JYUserApi sharedInstance] getConfigDicByName:@"pur_pro_sale_sea" success:^(id responseObject) {
        NSError *error = nil;
        self.leftTitles = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.leftTitles insertObject:self.leftDicDefault atIndex:0];
        NSLog(@"%@", error);
    } failure:^(NSError *error) {
    }];
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

- (void)initLeftView {
    [self.view addSubview:self.pageViewCtrl.view];
    [self.pageViewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)initRightView {
    _initTableView = YES;
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
                    [arrTitles addObject:STRING(tmpDic.value)];
                }
                _filterListView.collectionView.selectTag = _sortTag1;
            } else {
                for (DicMo *tmpDic in self.rightTitles) {
                    [arrTitles addObject:STRING(tmpDic.value)];
                }
                _filterListView.collectionView.selectTag = _sortTag2;
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
        self.showListView.hidden = _currentTag == 0 ? NO : YES;
        if (_initTableView) self.tableView.hidden = _currentTag == 1 ? NO : YES;
    }
}

#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    DicMo *tmpDic = nil;
    if (_currentTag == 0) {
        _sortTag1 = indexPath.row;
        self.leftDic = self.leftTitles[_sortTag1];
        tmpDic = self.leftDic;
        self.pageViewCtrl.currentDic = self.leftDic;
        [self.pageViewCtrl.pageScrollView.mainTableView.mj_header beginRefreshing];
    } else if (_currentTag == 1) {
        _sortTag2 = indexPath.row;
        self.rightDic = self.rightTitles[_sortTag2];
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
        _switchView = [[SwitchView alloc] initWithTitles:@[@"业务类型", @"生产情报"]
                                               imgNormal:@[@"client_down_n", @"client_down_n"]
                                               imgSelect:@[@"drop_down_s", @"drop_down_s"]];
        _switchView.delegate = self;
    }
    return _switchView;
}

- (UIView *)showListView {
    if (!_showListView) {
        _showListView = [UIView new];
        _showListView.backgroundColor = COLOR_B0;
    }
    return _showListView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [[NSMutableArray alloc] init];
    return _arrData;
}

- (ProducePageViewCtrl *)pageViewCtrl {
    if (!_pageViewCtrl) {
        _pageViewCtrl = [[ProducePageViewCtrl alloc] init];
        _pageViewCtrl.currentDic = self.leftDic;
    }
    return _pageViewCtrl;
}

- (NSMutableArray *)leftTitles {
    if (!_leftTitles) _leftTitles = [NSMutableArray new];
    return _leftTitles;
}

- (NSMutableArray *)rightTitles {
    if (!_rightTitles) _rightTitles = [NSMutableArray new];
    return _rightTitles;
}

- (DicMo *)rightDic {
    if (!_rightDic) {
        _rightDic = [[DicMo alloc] init];
        _rightDic.id = @"0";
        _rightDic.value = @"所有";
        _rightDic.key = @"all";
        _rightDic.remark = @"product_type";
    }
    return _rightDic;
}

- (DicMo *)leftDic {
    if (!_leftDic) {
        _leftDic = [[DicMo alloc] init];
        _leftDic.id = @"0";
        _leftDic.value = @"所有";
        _leftDic.key = @"all";
        _leftDic.remark = @"purchare_type";
    }
    return _leftDic;
}

- (DicMo *)rightDicDefault {
    if (!_rightDicDefault) {
        _rightDicDefault = [[DicMo alloc] init];
        _rightDicDefault.id = @"0";
        _rightDicDefault.value = @"所有";
        _rightDicDefault.key = @"all";
        _rightDicDefault.remark = @"product_type";
    }
    return _rightDicDefault;
}

- (DicMo *)leftDicDefault {
    if (!_leftDicDefault) {
        _leftDicDefault = [[DicMo alloc] init];
        _leftDicDefault.id = @"0";
        _leftDicDefault.value = @"所有";
        _leftDicDefault.key = @"all";
        _leftDicDefault.remark = @"purchare_type";
    }
    return _leftDicDefault;
}

@end
