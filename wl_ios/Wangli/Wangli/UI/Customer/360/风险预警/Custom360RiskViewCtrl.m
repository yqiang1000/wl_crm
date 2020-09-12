
//
//  Custom360RiskViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360RiskViewCtrl.h"
#import "RiskTotalCollectionView.h"
#import "RiskFollowCell.h"
#import "RiskFollowMo.h"
#import "CreateRiskViewCtrl.h"
#import "RiskListMo.h"
#import "FilterListView.h"
#import "RiskMo.h"
#import "EmptyView.h"
#import "RiskTopView.h"
#import "WebDetailViewCtrl.h"

@interface Custom360RiskViewCtrl () <FilterListViewDelegate, RiskTotalCollectionViewDelegate, RiskTopViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) FilterListView *filterListView;   // 列表选择
@property (nonatomic, strong) RiskTopView *filterView;
@property (nonatomic, strong) NSMutableArray *arrFollow;
@property (nonatomic, strong) NSMutableArray *arrTotal;
@property (nonatomic, strong) RiskTotalCollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) NSInteger sortTag;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) RiskListMo *selectListMo;

@end

@implementation Custom360RiskViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentTag = 0;
    _sortTag = 0;
    _number = 0;
    [self addTableView];
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.collectionView];
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
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.tableView);
    }];
    
    self.collectionView.hidden = YES;
    [self addBtnNew];
    [self riskWarnStatistics];
    self.headerRefresh = YES;
    self.footerRefresh = YES;
    self.collectionView.arrData = self.arrTotal;
    [self.filterView updateIndex:0 selected:YES];
    [self.tableView.mj_header beginRefreshing];
    [self.collectionView reloadData];
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

- (void)dealloc {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
}

#pragma mark - network

- (void)riskWarnStatistics {
    [[JYUserApi sharedInstance] riskWarnStatisticsByCustomId:TheCustomer.customerMo.id success:^(id responseObject) {
        self.arrTotal = [RiskListMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
        self.collectionView.arrData = self.arrTotal;
        [self.collectionView reloadData];
        NSMutableArray *newArr = [NSMutableArray new];
        for (int i = 0; i < self.arrTotal.count; i++) {
            RiskListMo *mo = self.arrTotal[i];
            [newArr addObject:[mo toJSONString]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:newArr forKey:RISK_LIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getRiskDetailListFrom:(NSInteger)number {
    
    NSMutableArray *arrRules = [NSMutableArray new];
    [arrRules addObject:@{@"field":@"memberId",
                          @"option":@"EQ",
                          @"values":@[@(TheCustomer.customerMo.id)]}];
    
    [arrRules addObject:@{@"field":@"bigCategory",
                          @"option":@"EQ",
                          @"values":@[@"feed_risk_warning"]}];
    
    if (self.selectListMo != nil && ![self.selectListMo.fieldValue isEqualToString:@"所有"]) {
        [arrRules addObject:@{@"field":@"childCategoryId",
                              @"option":@"EQ",
                              @"values":@[self.selectListMo.field]}];
    }
    
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] getFeedFlowPageByCustomerId:TheCustomer.customerMo.id number:number size:10 rules:arrRules success:^(id responseObject) {
        [self tableViewEndRefresh];
        [Utils dismissHUD];
        NSError *error = nil;
        NSMutableArray *tmpArr = [RiskFollowMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
    // 当前列表页面，执行正常的操作
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
        self.collectionView.hidden = _currentTag == 0? YES : NO;
        self.tableView.hidden = _currentTag == 0? NO : YES;
        [self.filterView btn0Normal];
        if (_currentTag == 1) {
            [self riskWarnStatistics];
        }
    }
}

- (void)filterAction:(BOOL)selected {
    // 筛选逻辑
    if (selected) {
        if (_currentTag == 1) {
            _collectionView.hidden = NO;
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
            
            NSMutableArray *titleArr = [NSMutableArray new];
            for (RiskListMo *mo in self.arrTotal) {
                [titleArr addObject:STRING(mo.fieldValue)];
            }
            _filterListView.collectionView.selectTag = _sortTag;
            [_filterListView loadData:titleArr];
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-44-STATUS_BAR_HEIGHT - 49) bottomHeight:0];
        }
    } else {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        _collectionView.hidden = _currentTag == 0 ? YES : NO;
    }
}

#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {

    [self.filterView updateIndex:0 selected:_currentTag==0?YES:NO];
    
    self.selectListMo = self.arrTotal[indexPath.row];
    _sortTag = indexPath.row;
    [self.filterView updateTitle:self.selectListMo.fieldValue index:0];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    _collectionView.hidden = YES;
    // 刷新列表
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    _number = 0;
    [self getRiskDetailListFrom:0];
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView updateIndex:0 selected:_currentTag==0?YES:NO];
}

#pragma mark - RiskTotalCollectionViewDelegate

- (void)riskTotalCollectionView:(RiskTotalCollectionView *)riskTotalCollectionView didSelectIndexPath:(NSIndexPath *)indexPath {
    _currentTag = 0;
    _collectionView.hidden = YES;
    self.tableView.hidden = NO;
    [self.filterView selectIndex:0];
    self.filterView.btn1.selected = NO;
    [self.filterView updateIndex:0 selected:YES];
    [self filterListView:nil didSelectIndexPath:indexPath];
}

#pragma mark - event

- (void)btnNewClick:(UIButton *)sender {
    CreateRiskViewCtrl *vc = [[CreateRiskViewCtrl alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.createUpdateSuccess = ^(RiskFollowMo *riskFollowMo) {
        [weakSelf.tableView.mj_header beginRefreshing];
        [weakSelf riskWarnStatistics];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewHeaderRefreshAction {
    _number = 0;
    [self getRiskDetailListFrom:_number];
}

- (void)tableViewFooterRefreshAction {
    [self getRiskDetailListFrom:_number + 1];
}

- (void)handleDeleteCell:(NSIndexPath *)sender {
    NSLog(@"handle delete cell %ld", (long)sender.row);
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"删除"] defaultItem:-1 itemClick:^(NSInteger index) {
        RiskFollowMo *tmpMo = self.arrFollow[sender.row];
        NSString *msg = [NSString stringWithFormat:@"是否删除\"%@\"?",tmpMo.title];
        [Utils commonDeleteTost:@"系统提示" msg:msg cancelTitle:@"取消" confirmTitle:@"确定" confirm:^{
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] deleteRiskWarnDetailRiskId:tmpMo.id success:^(id responseObject) {
                [Utils dismissHUD];
                [Utils showToastMessage:@"删除成功"];
                [self.arrFollow removeObjectAtIndex:sender.row];
                [self.tableView deleteRowsAtIndexPaths:@[sender] withRowAnimation:UITableViewRowAnimationFade];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
                [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            }];
        } cancel:^{
        }];
    } cancelClick:^(BottomView *obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    [bottomView show];
}

#pragma mark - setter and getter

- (RiskTopView *)filterView {
    if (!_filterView) {
        _filterView = [[RiskTopView alloc] initWithItems:@[@"所有", @"风险总览"] imgSelect:@[@"drop_down_s", @""] imgNormal:@[@"client_down_n", @""] colorSelect:COLOR_C1 colorNormal:COLOR_B2];
        _filterView.backgroundColor = COLOR_B4;
        _filterView.delegate = self;
    }
    return _filterView;
}

- (RiskTotalCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
        _collectionView = [[RiskTotalCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = COLOR_B0;
        _collectionView.viewDelegate = self;
    }
    return _collectionView;
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
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:RISK_LIST];
        for (int i = 0; i < arr.count; i++) {
            RiskListMo *mo = [[RiskListMo alloc] initWithString:arr[i] error:nil];
            [_arrTotal addObject:mo];
        }
    }
    return _arrTotal;
}

@end
