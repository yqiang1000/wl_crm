//
//  TaskViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TaskViewCtrl.h"
#import "TopTabBarView.h"
#import "SearchTopView.h"
#import "FilterView.h"
#import "TaskCell.h"
#import "FilterListView.h"
#import "WSDatePickerView.h"
#import "CreateTaskViewCtrl.h"
#import "TaskSearchViewCtrl.h"
#import "MemberChooseMo.h"
#import "TaskMo.h"
#import "EmptyView.h"
#import "WebDetailViewCtrl.h"

@interface TaskViewCtrl () <TopTabBarViewDelegate, SearchTopViewDelegate, FilterViewDelegate, UITableViewDelegate, UITableViewDataSource, FilterListViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) TopTabBarView *topView;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) FilterListView *filterListView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) NSInteger sortTag;
@property (nonatomic, strong) NSMutableArray *arrSort;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *statusStr;

@end

@implementation TaskViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务协作列表";
    _currentTag = 0;
    _page = 0;
    _sortTag = 0;
    _dateStr = nil;
    [self setUI];
    [self getConfig];
    [Utils showHUDWithStatus:nil];
    [self getTaskList:_page];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView resetNormalState];
}

#pragma mark - netwrok

- (void)getConfig {
    [[JYUserApi sharedInstance] getTaskConditionList:nil rules:nil success:^(id responseObject) {
        NSDictionary *moDic = responseObject[@"content"][0];

        self.arrSort = [MemberChooseMo arrayOfModelsFromDictionaries:moDic[@"memberChooseBeans"] error:nil];
        NSMutableArray *arr = [NSMutableArray new];
        for (int i = 0; i < self.arrSort.count; i++) {
            [arr addObject:[self.arrSort[i] toJSONString]];
        }
        if (arr.count > 0) [[NSUserDefaults standardUserDefaults] setObject:arr forKey:TASK_CHOOSE];
        [self.arrSort insertObject:@"不限" atIndex:0];
    } failure:^(NSError *error) {
    }];
}

- (void)getTaskList:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSMutableArray *rules = [NSMutableArray new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(10) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"createdDate" forKey:@"property"];
    
    if (_sortTag != 0) {
        MemberChooseMo *tmpMo = self.arrSort[_sortTag];
        [param setObject:@[STRING(tmpMo.memberFeild)] forKey:@"specialConditions"];
    }
    if (_dateStr.length > 0) {
        [rules addObject:@{@"field":@"date",
                           @"option":@"EQ",
                           @"values":@[_dateStr]}];
    }
    
    if (_statusStr.length > 0) {
        [rules addObject:@{@"field":@"statusKey",
                           @"option":@"EQ",
                           @"values":@[_statusStr]}];
    }
    
    [[JYUserApi sharedInstance] getTaskPageParam:param rules:rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TaskMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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

#pragma mark - UI

- (void)setUI {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.btnAdd];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.tableView];

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(4);
        make.centerY.equalTo(self.searchView);
        make.height.width.equalTo(@44);
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnAdd.mas_right).offset(4);
        make.right.equalTo(self.naviView).offset(-15);
        make.top.equalTo(self.topView.mas_bottom).offset(7.5);
        make.height.equalTo(@28);
    }];
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(7.5);
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
    return 167;
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
    static NSString *identifier = @"taskCell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskMo *tmpMo = self.arrData[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@loginid=%lld&id=%lld&token=%@", TASK_DETAIL_URL, TheUser.userMo.id, tmpMo.id, [Utils token]];
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.urlStr = urlStr;
    vc.titleStr = @"任务详情";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TopTabBarViewDelegate

- (void)topTabBarView:(TopTabBarView *)topTabBarView selectIndex:(NSInteger)index {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    NSArray *arr = @[@"", @"distributed", @"received", @"finished", @"confirm_finished"];
    self.statusStr = arr[index];
    [self.filterView resetNormalState];
    [self.tableView.mj_header beginRefreshing];
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
    searchStyle.type = SearchTask;
    TaskSearchViewCtrl *vc = [[TaskSearchViewCtrl alloc] init];
    vc.showIFly = showIFly;
    vc.searchStyle = searchStyle;
    BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - FilterViewDelegate

- (void)filterView:(FilterView *)filterView selectedIndex:(NSInteger)index selected:(BOOL)selected {
    _currentTag = index;
    if (selected) {
        if (index == 0) {
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
            
            _filterListView.collectionView.selectTag = self.sortTag;
            NSMutableArray *arr = [NSMutableArray new];
            [arr addObject:@"不限"];
            for (int i = 1; i < self.arrSort.count; i++) {
                MemberChooseMo *tmpMo = self.arrSort[i];
                [arr addObject:tmpMo.name];
            }
            [_filterListView loadData:arr];
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-top) bottomHeight:0];
            
        } else {
            if (_filterListView) {
                [_filterListView removeFromSuperview];
                _filterListView = nil;
            }
            
            NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
            [minDateFormater setDateFormat:@"yyyy-MM-dd"];
            NSDate *scrollToDate = [minDateFormater dateFromString:_filterView.titles[1]];
            __weak typeof(self) weakself = self;
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
                
                NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
                NSLog(@"选择的日期：%@",date);
                weakself.dateStr = date;
                [weakself.filterView updateTitle:date atIndex:1];
                [weakself.filterView resetNormalState];
                [weakself.tableView.mj_header beginRefreshing];
            }];
            
            datepicker.wsCancelBlock = ^{
                weakself.dateStr = nil;
                [weakself.filterView updateTitle:@"任务截止日期" atIndex:1];
                [weakself.filterView resetNormalState];
                [weakself.tableView.mj_header beginRefreshing];
            };
            datepicker.btnCancelTitle = @"重置";
            datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
            datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
            datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            [datepicker show];
        }
    } else {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
}

#pragma mark - FilterListViewDelegate

-(void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView resetNormalState];
    if (_currentTag == 0) {
        _sortTag = indexPath.row;
    }
    if (_sortTag == 0) {
        [_filterView updateTitle:self.arrSort[_sortTag] atIndex:0];
    } else {
        MemberChooseMo *tmpMo = self.arrSort[_sortTag];
        [_filterView updateTitle:tmpMo.name atIndex:0];
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterView resetNormalState];
}

#pragma mark - event

//- (void)clickRightButton:(UIButton *)sender {
//    CreateTaskViewCtrl *vc = [[CreateTaskViewCtrl alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)btnAddClick:(UIButton *)sender {
    CreateTaskViewCtrl *vc = [[CreateTaskViewCtrl alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getTaskList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getTaskList:_page+1];
}

#pragma mark - setter getter

- (TopTabBarView *)topView {
    if (!_topView) {
        _topView = [[TopTabBarView alloc] initWithItems:@[@"所有", @"待认领", @"处理中", @"已完成", @"确认完成"] colorSelect:COLOR_C1 colorNormal:COLOR_B1];
        _topView.delegate = self;
        _topView.showLine = YES;
        _topView.bgColor = COLOR_B4;
        _topView.lineWidth = SCREEN_WIDTH / 4.0;
        _topView.labFont = FONT_F15;
    }
    return _topView;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = [SearchStyle placeholdString:SearchTask];
    }
    return _searchView;
}

- (FilterView *)filterView {
    if (!_filterView) {
        _filterView = [[FilterView alloc] initWithTitles:@[@"不限", @"任务截止日期"] imgsNormal:@[@"client_down_n", @"client_down_n"] imgsSelected:@[@"drop_down_s", @"drop_down_s"]];
        _filterView.backgroundColor = COLOR_B4;
        _filterView.delegate = self;
    }
    return _filterView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        
    }
    return _tableView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
    }
    return _arrData;
}

- (NSMutableArray *)arrSort {
    if (!_arrSort) {
        _arrSort = [NSMutableArray new];
        [_arrSort addObject:@"不限"];
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:TASK_CHOOSE];
        for (int i = 0; i < arr.count; i++) {
            MemberChooseMo *mo = [[MemberChooseMo alloc] initWithString:arr[i] error:nil];
            [_arrSort addObject:mo];
        }
    }
    return _arrSort;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [[UIButton alloc] init];
        [_btnAdd setImage:[UIImage imageNamed:@"c_goods_new"] forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAdd;
}

@end
