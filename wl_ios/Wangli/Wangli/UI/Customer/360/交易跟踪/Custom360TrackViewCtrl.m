//
//  Custom360TrackViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360TrackViewCtrl.h"
#import "RiskFollowMo.h"
#import "CreateRiskViewCtrl.h"
#import "RiskListMo.h"
#import "RiskFollowCell.h"
#import "FilterListView.h"
#import "TrackTableView.h"
#import "CustomTrackDetailViewCtrl.h"
#import "EmptyView.h"
#import "RiskTopView.h"
#import "WebDetailViewCtrl.h"

@interface Custom360TrackViewCtrl () <RiskTopViewDelegate, FilterListViewDelegate, TrackTableViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) FilterListView *filterListView;   // 列表选择
@property (nonatomic, strong) RiskTopView *filterView;
@property (nonatomic, strong) NSMutableArray *arrFollow;
@property (nonatomic, strong) NSMutableArray *arrTotal;
@property (nonatomic, strong) NSMutableArray *arrListData;
@property (nonatomic, strong) TrackTableView *trackTableView;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) NSInteger sortTag;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) RiskListMo *selectListMo;
@property (nonatomic, strong) JYWebView *webView;

@end

@implementation Custom360TrackViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentTag = 0;
    _sortTag = 0;
    _number = 0;
    [self addTableView];
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.trackTableView];
    [self.view bringSubviewToFront:self.btnNew];

    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];

    [self.trackTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.tableView);
    }];

    self.trackTableView.hidden = YES;
    [self riskWarnStatistics];
    self.headerRefresh = YES;
    self.footerRefresh = YES;
    [self.filterView updateIndex:0 selected:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
}

- (void)btnNewClick:(UIButton *)sender {


    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"40D/H650/9556-01标准大箱" forKey:@"field"];
    NSMutableArray *arr = [NSMutableArray new];
    for (int j = 0; j < 12; j++) {
        [arr addObject:@{@"field":[NSString stringWithFormat:@"%d月", j],
                         @"fieldValue":[NSString stringWithFormat:@"%u", arc4random()%100]}];
    }
    [dic setObject:arr forKey:@"fieldValue"];

    [self.arrListData addObject:dic];
    [self refreshTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_currentTag == 1) {
        [self riskWarnStatistics];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
    [self.filterView updateIndex:0 selected:_currentTag==0?YES:NO];
}

#pragma mark - network

- (void)riskWarnStatistics {
    [[JYUserApi sharedInstance] getTrackingSituationListById:TheCustomer.customerMo.id success:^(id responseObject) {
        self.arrTotal = [RiskListMo arrayOfModelsFromDictionaries:responseObject[@"content"][@"content"] error:nil];
        [self refreshTableView];
        NSMutableArray *newArr = [NSMutableArray new];
        for (int i = 0; i < self.arrTotal.count; i++) {
            RiskListMo *mo = self.arrTotal[i];
            [newArr addObject:[mo toJSONString]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:newArr forKey:TRACK_LIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.arrListData = [[NSMutableArray alloc] initWithArray:responseObject[@"average"]];
        [self refreshTableView];
    } failure:^(NSError *error) {

    }];
}

- (void)refreshTableView {
    NSMutableArray *arr = [self.arrTotal mutableCopy];
    for (int i = 0; i < arr.count; i++) {
        RiskListMo *tmpMo = arr[i];
        if ([tmpMo.fieldValue isEqualToString:@"所有"]) {
            [arr removeObjectAtIndex:i];
            break;
        }
    }
    self.trackTableView.arrTopList = arr;
    self.trackTableView.arrListData = self.arrListData;
    [self.trackTableView reloadData];
}

- (void)getRiskDetailListFrom:(NSInteger)number {
    NSMutableArray *arrRules = [NSMutableArray new];
    [arrRules addObject:@{@"field":@"memberId",
                          @"option":@"EQ",
                          @"values":@[@(TheCustomer.customerMo.id)]}];

    [arrRules addObject:@{@"field":@"bigCategory",
                          @"option":@"EQ",
                          @"values":@[@"feed_transaction_tracking"]}];

//    if (self.selectListMo != nil && ![self.selectListMo.fieldValue isEqualToString:@"所有"]) {
//        [arrRules addObject:@{@"field":@"childCategoryId",
//                              @"option":@"EQ",
//                              @"values":@[self.selectListMo.field]}];
//    }
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getFeedFlowPageByCustomerId:TheCustomer.customerMo.id number:number size:10 rules:arrRules success:^(id responseObject) {
        [self tableViewEndRefresh];
        [Utils dismissHUD];
        NSMutableArray *tmpArr = [RiskFollowMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
        if (number == 0) {
            [self.arrFollow removeAllObjects];
            self.arrFollow = nil;
            self.arrFollow = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _number = number;
                [self.arrFollow addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self tableViewEndRefresh];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrFollow.count == 0) {
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
    return self.arrFollow.count;
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
    static NSString *cellId = @"riskFollowCell";
    RiskFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[RiskFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == self.arrFollow.count - 1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    [cell loadDataWith:self.arrFollow[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RiskFollowMo *mo = self.arrFollow[indexPath.row];
    if (mo.url.length != 0) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@token=%@&officeName=%@", mo.url, [mo.url containsString:@"?"]?@"&":@"?", [Utils token], [Utils officeName]];
        WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
        vc.urlStr = urlStr;
        vc.titleStr = mo.title;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - RiskTopViewDelegate

//imgSelect:@[@"drop_down_s", @""] imgNormal:@[@"client_down_n"
- (void)riskTopView:(RiskTopView *)riskTopView selectIndex:(NSInteger)index {
    // 当前列表页面，执行巴拉巴拉的操作
    if (_currentTag == index) {
        // 第一页
        if (_currentTag == 0) {
            self.filterView.btn1.selected = NO;
            BOOL selected = self.filterView.btn0.selected;
            if (!selected) {
                [self.filterView btn0Normal];
            } else {
                [self.filterView btn0Select];
            }

            [self filterAction:self.filterView.btn0.selected];
            self.filterView.btn0.selected = !self.filterView.btn0.selected;
        } else {
            self.filterView.btn1.selected = YES;
            self.filterView.btn0.selected = NO;
            [self.filterView resetNormalState:0];
            [_filterListView removeFromSuperview];
            _filterListView = nil;
            [self filterAction:self.filterView.btn1.selected];
        }
    }
    // 当前纵览页面，切换操作
    else {
        _currentTag = index;
        [self.filterView updateIndex:0 selected:index==0?YES:NO];
        [self.filterView updateIndex:1 selected:index==1?YES:NO];
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        self.trackTableView.hidden = _currentTag == 0? YES : NO;
        [self setWebHidden];
        [self.filterView btn0Normal];
        if (_currentTag == 1) {
            [self riskWarnStatistics];
        }
    }
}

- (void)setWebHidden {
    if (!self.trackTableView.hidden) {
        _webView.hidden = YES;
        self.tableView.hidden = YES;
    } else {
        self.tableView.hidden = _sortTag == 0 ? NO : YES;
        _webView.hidden = _sortTag == 1 ? NO : YES;
    }
}

- (void)filterAction:(BOOL)selected {
    // 筛选逻辑
    if (selected) {
        if (_currentTag == 1) {
            _trackTableView.hidden = NO;
            if (_filterListView) {
                [_filterListView removeFromSuperview];
                _filterListView = nil;
            }
            //            [self.filterView resetNormalState];
        } else {
            //            [self.filterView resetNormalState];

            if (!_filterListView) {
                _filterListView = [[FilterListView alloc] initWithSourceType:0];
                _filterListView.delegate = self;
            }

            [[UIApplication sharedApplication].keyWindow addSubview:_filterListView];
            [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo([UIApplication sharedApplication].keyWindow).offset(44+STATUS_BAR_HEIGHT+49);
                make.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            }];

//            NSMutableArray *titleArr = [NSMutableArray new];
//            for (RiskListMo *mo in self.arrTotal) {
//                [titleArr addObject:STRING(mo.fieldValue)];
//            }
            _filterListView.collectionView.selectTag = _sortTag;
            [_filterListView loadData:@[@"时间轴显示", @"表格显示"]];
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-44-STATUS_BAR_HEIGHT - 49) bottomHeight:0];
        }
    } else {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        _trackTableView.hidden = _currentTag == 0 ? YES : NO;
    }
}


#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    [self.filterView updateIndex:0 selected:_currentTag==0?YES:NO];
    
    NSArray *title = @[@"时间轴显示", @"表格显示"];
//    self.selectListMo = self.arrTotal[indexPath.row];
    _sortTag = indexPath.row;
    [self.filterView updateTitle:title[_sortTag] index:0];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    _trackTableView.hidden = YES;
    // 刷新列表
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    _number = 0;
//    [self getRiskDetailListFrom:0];
    if (_sortTag == 1 && !_webView) {
        [self.view addSubview:self.webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.tableView);
        }];
    }
    self.tableView.hidden = _sortTag == 0 ? NO  : YES;
    _webView.hidden = _sortTag == 0 ? YES  : NO;
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView updateIndex:0 selected:_currentTag==0?YES:NO];
}

#pragma mark - TrackTableViewDelegate

- (void)trackTableView:(TrackTableView *)tableView topCellDidSelectIndexPath:(NSIndexPath *)indexPath {
    CustomTrackDetailViewCtrl *vc = [[CustomTrackDetailViewCtrl alloc] init];
    vc.currentTag = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)trackTableView:(TrackTableView *)tableView didSelectIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    _number = 0;
    [self getRiskDetailListFrom:_number];
}

- (void)tableViewFooterRefreshAction {
    [self getRiskDetailListFrom:_number + 1];
}

#pragma mark - setter and getter

- (RiskTopView *)filterView {
    if (!_filterView) {
        _filterView = [[RiskTopView alloc] initWithItems:@[@"时间轴显示", @"信息总览"] imgSelect:@[@"drop_down_s", @""] imgNormal:@[@"client_down_n", @""] colorSelect:COLOR_C1 colorNormal:COLOR_B2];
        _filterView.backgroundColor = COLOR_B4;
        _filterView.delegate = self;
    }
    return _filterView;
}

- (TrackTableView *)trackTableView {
    if (!_trackTableView) {
        _trackTableView = [[TrackTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _trackTableView.trackDelegate = self;
        _trackTableView.layer.cornerRadius = 5;
        _trackTableView.clipsToBounds = YES;
    }
    return _trackTableView;
}

- (NSMutableArray *)arrFollow {
    if (!_arrFollow) {
        _arrFollow = [NSMutableArray new];
    }
    return _arrFollow;
}

- (NSMutableArray *)arrTotal {
    if (!_arrTotal) {
        _arrTotal = [NSMutableArray new];
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:TRACK_LIST];
        for (int i = 0; i < arr.count; i++) {
            RiskListMo *mo = [[RiskListMo alloc] initWithString:arr[i] error:nil];
            [_arrTotal addObject:mo];
        }
    }
    return _arrTotal;
}

- (NSMutableArray *)arrListData {
    if (!_arrListData) {
        _arrListData = [NSMutableArray new];
    }
    return _arrListData;
}

- (JYWebView *)webView {
    if (!_webView) {
        _webView = [[JYWebView alloc] init];
        _webView.hidenProgress = YES;
        _webView.scrollView.backgroundColor = COLOR_B0;
        NSString *encodedString = [NSString stringWithFormat:@"%@memberId=%ld&token=%@&officeName=%@", TRACKING_TRANSACTION, (long)TheCustomer.customerMo.id, [Utils token], [Utils officeName]];
        encodedString = [encodedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
    }
    return _webView;
}

@end
