//
//  TabOrderViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/3/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TabOrderViewController.h"
#import "SearchTopView.h"
#import "FilterView.h"
#import "TopTabBarView.h"
#import "FilterListView.h"
#import "OrderMo.h"
#import "TabOrderCell.h"
#import "ChatSearchViewCtrl.h"
#import "WSDatePickerView.h"
#import "EmptyView.h"
#import "MemberChooseMo.h"
#import "OrderSearchViewCtrl.h"
#import "WebDetailViewCtrl.h"
#import "MainTabBarViewController.h"
#import "QMYViewController.h"
#import "PopMenuView.h"
#import "ScanTool.h"

@interface TabOrderViewController () <SearchTopViewDelegate, UITableViewDelegate, UITableViewDataSource, FilterViewDelegate, TopTabBarViewDelegate, FilterListViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TopTabBarView *topView;

@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) FilterListView *filterListView;   // 列表选择

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger sortTag1;
@property (nonatomic, assign) NSInteger sortTag2;
@property (nonatomic, strong) NSMutableArray *arrSort1;
@property (nonatomic, strong) NSMutableArray *arrSort2;
@property (nonatomic, strong) NSString *sortMo1;
@property (nonatomic, strong) NSString *sortMo2;
@property (nonatomic, strong) NSString *selectDate;
@property (nonatomic, copy) NSString *states;

@end

@implementation TabOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentTag = 0;
    _page = 0;
    _sortTag1 = 0;
    _sortTag2 = 0;
    _states = @"ALL";
    self.view.backgroundColor = COLOR_B0;
    [self setUI];
    [self getChooseList];
    [Utils showHUDWithStatus:nil];
    [self getOrderList:_page];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewHeaderRefreshAction) name:NOTIFI_ORDER_LIST_REFRESH object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [_filterView resetNormalState];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:NO];
}

#pragma mark - network

- (void)getOrderList:(NSInteger)page {

//    ":[{"field":"createdDate","option":"EQ","values":["2018-08-10"]}],"

    NSMutableArray *rules = [[NSMutableArray alloc] init];
    if (![_states isEqualToString:@"ALL"]) {
        [rules addObject:@{@"field":@"status",
                           @"option":@"EQ",
                           @"values":@[_states]}];
    }
    if (_sortTag1 > 0) {
        [rules addObject:@{@"field":@"spec",
                           @"option":@"EQ",
                           @"values":@[STRING(_sortMo1)]}];
    }
    if (_sortTag2 > 0) {
        [rules addObject:@{@"field":@"grade",
                           @"option":@"EQ",
                           @"values":@[STRING(_sortMo2)]}];
    }
    if (_selectDate.length > 0) {
        [rules addObject:@{@"field":@"createdDate",
                           @"option":@"EQ",
                           @"values":@[_selectDate]}];
    }

    [[JYUserApi sharedInstance] getOrderPage:page size:10 rules:rules specialConditions:nil success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [OrderMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getChooseList {
    [[JYUserApi sharedInstance] getMaterialFindSpecSuccess:^(id responseObject) {
        self.arrSort1 = [[NSMutableArray alloc] initWithArray:responseObject[@"content"]];
        [self.arrSort1 insertObject:@"不限" atIndex:0];
    } failure:^(NSError *error) {
    }];
    
    [[JYUserApi sharedInstance] getMaterialFindGradeSuccess:^(id responseObject) {
        self.arrSort2 = [[NSMutableArray alloc] initWithArray:responseObject[@"content"]];
        [self.arrSort2 insertObject:@"不限" atIndex:0];
    } failure:^(NSError *error) {
    }];
}

- (void)setUI {
    
    for (UIView *subView in self.naviView.subviews) {
        [subView removeFromSuperview];
    }
    
    [self.naviView addSubview:self.searchView];
    [self.naviView addSubview:self.btnMore];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.tableView];
    
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
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@46);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 143.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TabOrderCell";
    TabOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TabOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderMo *tmpMo = self.arrData[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@orderID=%ld&token=%@", ORDER_DETAIL_URL, tmpMo.id, [Utils token]];
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.urlStr = urlStr;
    vc.titleStr = @"订单详情";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView resetNormalState];
    
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:NO];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:YES];
}

- (void)pushToSearchVC:(BOOL)showIFly {
    SearchStyle *searchStyle = [[SearchStyle alloc] init];
    searchStyle.type = SearchOrder;
    OrderSearchViewCtrl *vc = [[OrderSearchViewCtrl alloc] init];
    vc.showIFly = showIFly;
    vc.searchStyle = searchStyle;
    BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - TopTabBarViewDelegate

- (void)topTabBarView:(TopTabBarView *)topTabBarView selectIndex:(NSInteger)index {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    NSArray *states = @[@"ALL",@"PRICE_REVIEW",@"DELIVERYED",@"RECEIVED"];
    _states = states[index];
//    _sortMo1 = nil;
//    _sortMo2 = nil;
//    _sortTag1 = -1;
//    _sortTag1 = -1;
//    _selectDate = nil;
//    [self.filterView updateTitle:@"产品规格" atIndex:0];
//    [self.filterView updateTitle:@"等级" atIndex:1];
//    [self.filterView updateTitle:@"订单日期" atIndex:2];
    [self.filterView resetNormalState];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - FilterViewDelegate

- (void)filterView:(FilterView *)filterView selectedIndex:(NSInteger)index selected:(BOOL)selected {
    _currentTag = index;
    
    if (_currentTag == 2) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        
        [self.filterView resetNormalState];
        
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-M"];
        NSDate *scrollToDate = [minDateFormater dateFromString:_selectDate];
        
        __weak typeof(self) weakSelf = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            __strong typeof(self) strongSelf = weakSelf;
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            
            NSLog(@"选择的日期：%@",date);
            [strongSelf.filterView updateTitle:date atIndex:2];
            if (![strongSelf.selectDate isEqualToString:date]) {
                strongSelf.selectDate = date;
                [strongSelf.tableView.mj_header beginRefreshing];
            }
        }];
        datepicker.btnCancelTitle = @"重置";
        datepicker.wsCancelBlock = ^{
            [weakSelf.filterView updateTitle:@"订单日期" atIndex:2];
            weakSelf.selectDate = nil;
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
        
    } else {
        if (selected) {
            if (!_filterListView) {
                _filterListView = [[FilterListView alloc] initWithSourceType:0];
                _filterListView.delegate = self;
            }
            
            CGFloat top = CGRectGetMaxY(self.filterView.frame);
            [[UIApplication sharedApplication].keyWindow addSubview:_filterListView];
            [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.filterView.mas_bottom);
                make.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            
            _filterListView.collectionView.selectTag = _currentTag == 0 ? _sortTag1 : _sortTag2;
            [_filterListView loadData:_currentTag == 0 ? self.arrSort1 : self.arrSort2];
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-top) bottomHeight:0];
        } else {
            [_filterListView removeFromSuperview];
            _filterListView = nil;
        }
    }
}

#pragma mark - FilterListViewDelegate

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView resetNormalState];
}

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    if (_currentTag == 0) {
        _sortTag1 = indexPath.row;
        _sortMo1 = self.arrSort1[indexPath.row];
        [self.filterView updateTitle:_sortMo1 atIndex:0];
    } else if (_currentTag == 1) {
        _sortTag2 = indexPath.row;
        _sortMo2 = self.arrSort2[indexPath.row];
        [self.filterView updateTitle:_sortMo2 atIndex:1];
    }
    [self.filterView resetNormalState];
    _page = 0;
    [self getOrderList:_page];
}

#pragma mark - event

- (void)btnMoreClick:(UIButton *)sender {
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
    if (index == 1) {
        [Utils showToastMessage:@"该功能正在开发中..."];
        return;
    }
    QMYViewController *scan = [[QMYViewController alloc] init];
    [scan initWithScanViewName: nil withScanLinaName:@"qrcode_Scan_weixin_Line" withPickureZoom:1];
    scan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scan animated:YES];
}


- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getOrderList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getOrderList:_page+1];
}

#pragma mark - setter getter

- (TopTabBarView *)topView {
    if (!_topView) {
        _topView = [[TopTabBarView alloc] initWithItems:@[@"所有", @"审批中", @"发货中", @"已完成"] colorSelect:COLOR_C1 colorNormal:COLOR_B1];
        _topView.delegate = self;
        _topView.showLine = YES;
        _topView.bgColor = COLOR_B4;
//        _topView.lineWidth = SCREEN_WIDTH / 4.0;
        _topView.labFont = FONT_F15;
    }
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
    }
    return _tableView;
}

- (FilterView *)filterView {
    if (!_filterView) {
        _filterView = [[FilterView alloc] initWithTitles:@[@"产品规格", @"等级", @"订单日期"] imgsNormal:@[@"client_down_n", @"client_down_n", @"client_down_n"] imgsSelected:@[@"drop_down_s", @"drop_down_s", @"drop_down_s"]];
        _filterView.backgroundColor = COLOR_B4;
        _filterView.delegate = self;
    }
    return _filterView;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:YES];
        _searchView.searchTxtField.placeholder = [SearchStyle placeholdString:SearchOrder];
        _searchView.delegate = self;
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

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
    }
    return _arrData;
}

- (NSMutableArray *)arrSort1 {
    if (!_arrSort1) {
        _arrSort1 = [NSMutableArray new];
//        for (int i = 0; i < 20; i++) {
//            MemberChooseMo *mo = [[MemberChooseMo alloc] init];
//            mo.name = [NSString stringWithFormat:@"排序方式%d", i];
//            mo.memberFeild = [NSString stringWithFormat:@"%d", i];
//            [_arrSort1 addObject:mo];
//        }
    }
    return _arrSort1;
}

- (NSMutableArray *)arrSort2 {
    if (!_arrSort2) {
        _arrSort2 = [NSMutableArray new];
//        for (int i = 0; i < 10; i++) {
//            MemberChooseMo *mo = [[MemberChooseMo alloc] init];
//            mo.name = [NSString stringWithFormat:@"检索方式%d", i];
//            mo.memberFeild = [NSString stringWithFormat:@"%d", i];
//            [_arrSort2 addObject:mo];
//        }
    }
    return _arrSort2;
}

@end
