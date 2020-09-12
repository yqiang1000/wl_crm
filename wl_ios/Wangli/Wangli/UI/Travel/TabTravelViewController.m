//
//  TabTravelViewController.m
//  Wangli
//
//  Created by yeqiang on 2019/3/18.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TabTravelViewController.h"
#import "MainTabBarViewController.h"
#import "SearchTopView.h"
#import "SearchStyle.h"
#import "ChatSearchViewCtrl.h"
#import "PopMenuView.h"
#import "QMYViewController.h"
#import "ScanTool.h"
#import "TravelTableViewCell.h"
#import "SwitchView.h"
#import "FilterListView.h"
#import "WSDatePickerView.h"
#import "EmptyView.h"
#import "CreateTravelViewCtrl.h"
#import "WebDetailViewCtrl.h"

@interface TabTravelViewController () <SearchTopViewDelegate, SwitchViewDelegate, FilterListViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) FilterListView *filterListView;
@property (nonatomic, assign) NSInteger switchId;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, strong) NSMutableArray *arrSort;
@property (nonatomic, assign) NSInteger sortTag;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *keyWord;

@end

@implementation TabTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _switchId = 0;
    _sortTag = 0;
    _keyWord = @"";
    _page = 0;
    [self setUI];
    [self.switchView updateSelectViewHiden:YES];
    [self.switchView updateNormalColor:COLOR_B2];
    [self.switchView refreshView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:YES];
    [self hidenKeyBoard];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:NO];
}

- (void)setUI {
    for (UIView *subView in self.naviView.subviews) {
        [subView removeFromSuperview];
    }
    
    [self.naviView addSubview:self.searchView];
    [self.naviView addSubview:self.btnMore];
    [self.view addSubview:self.switchView];
    [self.view addSubview:self.tableView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.bottom.equalTo(self.naviView).offset(-8);
        make.height.equalTo(@28.0);
        make.right.equalTo(self.btnMore.mas_left);
    }];
    
    [self.btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.right.equalTo(self.naviView);
        make.height.width.equalTo(@40.0);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0? 110: 100;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"travelCell";
    TravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TravelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TravelMo *model = self.arrData[indexPath.row];
    [cell loadData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hidenKeyBoard];
    TravelMo *model = self.arrData[indexPath.row];
    CreateTravelViewCtrl *tmpVC = [[CreateTravelViewCtrl alloc] init];
    tmpVC.title = @"差旅详情";
    tmpVC.dynamicId = @"travel-business";
    tmpVC.isUpdate = YES;
    tmpVC.detailId = model.id;
    tmpVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tmpVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hidenKeyBoard];
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
//    [self.searchView.searchTxtField resignFirstResponder];
//    [self pushToSearchVC:NO];
    
    // 任何已经处于选择情况下，清空选择列表，重置按钮
    if (self.filterListView) {
        [self releaseFilterListView];
        return;
    }
    // 只设置当前的选中状态，其他重置
    
    [self.switchView updateTitle:@"" index:self.switchId switchState:SwitchStateNormal];
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    [self.searchView.searchTxtField resignFirstResponder];
    self.keyWord =  [searchTopView.searchTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.tableView.mj_header beginRefreshing];
}

//- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
//    [self.searchView.searchTxtField resignFirstResponder];
//    [self pushToSearchVC:YES];
//}

//- (void)pushToSearchVC:(BOOL)showIFly {
//    SearchStyle *searchStyle = [[SearchStyle alloc] init];
//    searchStyle.type = SearchCustomer;
//    ChatSearchViewCtrl *vc = [[ChatSearchViewCtrl alloc] init];
//    vc.showIFly = showIFly;
//    vc.searchStyle = searchStyle;
//    BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
//    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
//}


#pragma mark - SwitchViewDelegate

- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
    [self hidenKeyBoard];
    // 任何已经处于选择情况下，清空选择列表，重置按钮
    if (self.filterListView) {
        [self releaseFilterListView];
        return;
    }
    self.switchId = index;
    // 只设置当前的选中状态，其他重置
    [switchView updateTitle:@"" index:index switchState:SwitchStateSelectSecond];
    
    if (self.switchId == 0) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *scrollToDate = [minDateFormater dateFromString:self.dateStr];
        
        __weak typeof(self) weakSelf = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            __strong typeof(self) strongSelf = weakSelf;
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",date);
            [weakSelf.switchView updateTitle:date index:weakSelf.switchId switchState:SwitchStateNormal];
            if (![strongSelf.dateStr isEqualToString:date]) {
                strongSelf.dateStr = date;
                [strongSelf.tableView.mj_header beginRefreshing];
            }
        }];
        datepicker.btnCancelTitle = @"重置";
        datepicker.wsCancelBlock = ^{
            [weakSelf.switchView updateTitle:@"出差日期" index:weakSelf.switchId switchState:SwitchStateNormal];
            weakSelf.dateStr = @"";
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    } else {
        if (!self.filterListView) {
            self.filterListView = [[FilterListView alloc] initWithSourceType:0];
            self.filterListView.delegate = self;
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.filterListView];
        [self.filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(CGRectGetMaxY(self.switchView.frame));
            make.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        NSMutableArray *arrSort = [NSMutableArray new];
        for (DicMo *tmpDic in self.arrSort) {
            [arrSort addObject:STRING(tmpDic.key)];
        }
        self.filterListView.collectionView.selectTag = self.sortTag;
        [self.filterListView loadData:arrSort];
        [self.filterListView updateViewHeight:SCREEN_HEIGHT-CGRectGetMaxY(self.switchView.frame) bottomHeight:0];
    }
}

#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    self.sortTag = indexPath.row;
    DicMo *dicMo = self.arrSort[indexPath.row];
    NSString *str = dicMo.key;
    if (self.sortTag == 0) str = @"状态";
    [self releaseFilterListView];
    [self.switchView updateTitle:str index:self.switchId switchState:SwitchStateNormal];
    [self.tableView.mj_header beginRefreshing];
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [self releaseFilterListView];
}

#pragma mark - event

- (void)btnMoreClick:(UIButton *)sender {
    [self hidenKeyBoard];
    CGFloat width = 160.0;
    CGFloat heigth = 52;//104.0;
    
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

- (void)releaseFilterListView {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        [self.switchView updateTitle:@"" index:_switchId switchState:SwitchStateNormal];
    }
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
    [self getList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:_page+1];
}

- (void)getList:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(10) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    NSMutableArray *rules = [NSMutableArray new];
    
    if (self.dateStr.length != 0) {
        [rules addObject:@{@"field":@"travelDate",
                           @"option":@"BTD",
                           @"values":@[[NSString stringWithFormat:@"%@ 00:00:00", self.dateStr],
                                       [NSString stringWithFormat:@"%@ 23:59:59", self.dateStr]]}];
    }
    DicMo *dicMo = self.arrSort[self.sortTag];
    if (dicMo.value.length != 0) {
        [rules addObject:@{@"field":@"travelStatus",
                           @"option":@"EQ",
                           @"values":@[STRING(dicMo.value)]}];
    }
    if (self.keyWord.length != 0) {
        [rules addObject:@{@"field":@"searchContent",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[STRING(self.keyWord)]}];
    }
    if (rules.count > 0) [param setObject:rules forKey:@"rules"];
    [[JYUserApi sharedInstance] getPageDynmicFormDynamicId:@"travel-business" param:param success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TravelMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        self.page = page;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)hidenKeyBoard {
    [self.searchView.searchTxtField resignFirstResponder];
}

#pragma mark - lazy

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = @"请输入目的地、出发地关键字";
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
    }
    return _tableView;
}

- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithTitles:@[@"出差日期", @"状态"]
                                               imgNormal:@[@"client_down_n", @"client_down_n"]
                                               imgSelect:@[@"drop_down_s", @"drop_down_s"]];
        _switchView.delegate = self;
    }
    return _switchView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableArray *)arrSort {
    if (!_arrSort) {
        _arrSort = [NSMutableArray new];
        
        DicMo *mo1 = [[DicMo alloc] init];
        mo1.key = @"不限";
        mo1.value = @"";
        [_arrSort addObject:mo1];
        
        DicMo *mo2 = [[DicMo alloc] init];
        mo2.key = @"未提交";
        mo2.value = @"NOCOMMIT";
        [_arrSort addObject:mo2];
        
        DicMo *mo3 = [[DicMo alloc] init];
        mo3.key = @"提交OA成功";
        mo3.value = @"SUCCESS";
        [_arrSort addObject:mo3];
        
        DicMo *mo4 = [[DicMo alloc] init];
        mo4.key = @"提交OA失败";
        mo4.value = @"ERROR";
        [_arrSort addObject:mo4];
    }
    return _arrSort;
}

@end
