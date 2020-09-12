//
//  CommonSelectPageViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/5/31.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CommonSelectPageViewCtrl.h"
#import "SearchTopView.h"

@interface CommonSelectPageViewCtrl () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnCalendar;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *keyWord;

@end

@implementation CommonSelectPageViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.dateStr = @"";
//    self.keyWord = @"";
//    [self setUI];
//    [self.tableView.mj_header beginRefreshing];
}

//- (void)setUI {
//    UIView *topView = [UIView new];
//    topView.backgroundColor = COLOR_B4;
//    [self.view addSubview:topView];
//    [self.view addSubview:self.searchView];
//    [self.view addSubview:self.btnCalendar];
//    [self.view addSubview:self.tableView];
//
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.naviView.mas_bottom);
//        make.left.right.equalTo(self.view);
//        make.height.equalTo(@49.0);
//    }];
//
//    [self.searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(topView);
//        make.left.equalTo(self.naviView).offset(15);
//        make.height.equalTo(@28.0);
//        make.right.equalTo(self.btnCalendar.mas_left).offset(-15);
//    }];
//
//    [self.btnCalendar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.searchView);
//        make.height.width.equalTo(@17.0);
//        make.right.equalTo(self.view).offset(-15);
//    }];
//
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.searchView.mas_bottom).offset(7.5);
//        make.bottom.left.right.equalTo(self.view);
//    }];
//}
//
//- (void)getList:(NSInteger)page {
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:@(page) forKey:@"number"];
//    [param setObject:@(10) forKey:@"size"];
//    [param setObject:@"DESC" forKey:@"direction"];
//    [param setObject:@"id" forKey:@"property"];
//    NSMutableArray *rules = [NSMutableArray new];
//    if (self.keyWord.length != 0) {
//        [rules addObject:@{@"field":@"operator.name",
//                           @"option":@"LIKE_ANYWHERE",
//                           @"values":@[STRING(self.keyWord)]}];
//    }
//
//    if (self.dateStr.length != 0) {
//        [rules addObject:@{@"field":@"date",
//                           @"option":@"BTD",
//                           @"values":@[[NSString stringWithFormat:@"%@ 00:00:00", self.dateStr],
//                                       [NSString stringWithFormat:@"%@ 23:59:59", self.dateStr]]}];
//    }
//
//    if (rules.count > 0) [param setObject:rules forKey:@"rules"];
//
//    [[JYUserApi sharedInstance] getRetailChannelPageParam:param success:^(id responseObject) {
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        NSError *error = nil;
//        NSMutableArray *tmpArr = [self.customClass arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
//        if (page == 0) {
//            [self.arrData removeAllObjects];
//            self.arrData = nil;
//            self.arrData = tmpArr;
//        } else {
//            if (tmpArr.count > 0) {
//                [self.arrData addObjectsFromArray:tmpArr];
//            } else {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
//        self.page = page;
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//    }];
//}
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.arrData.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 115;
//}
//
//#pragma mark - UITableViewDelegate
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"UITableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.searchView.searchTxtField resignFirstResponder];
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}
//
//#pragma mark - SearchTopViewDelegate
//
//- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
//
//}
//
//- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
//    self.keyWord = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    [self tableViewHeaderRefreshAction];
//    [self.searchView.searchTxtField resignFirstResponder];
//}
//
//#pragma mark - event
//
//- (void)tableViewHeaderRefreshAction {
//    self.page = 0;
//    [self getList:self.page];
//}
//
//- (void)tableViewFooterRefreshAction {
//    [self getList:self.page+1];
//}
//
//- (void)clickRightButton:(UIButton *)sender {
//    RetailWorkPlanViewCtrl *vc = [[RetailWorkPlanViewCtrl alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.title = @"零售工作计划";
//    __weak typeof(self) weakself = self;
//    vc.updateSuccess = ^(id obj) {
//        __strong typeof(self) strongself = weakself;
//        [strongself.tableView.mj_header beginRefreshing];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//#pragma mark - lazy
//
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.backgroundColor = COLOR_B0;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
//        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
//    }
//    return _tableView;
//}
//
//- (SearchTopView *)searchView {
//    if (!_searchView) {
//        _searchView = [[SearchTopView alloc] initWithAudio:NO];
//        _searchView.delegate = self;
//        _searchView.searchTxtField.placeholder = @"请输入业务员姓名";
//        _searchView.btnSearch.layer.borderColor = COLOR_E6E6EA.CGColor;
//        _searchView.btnSearch.layer.borderWidth = 0.5;
//    }
//    return _searchView;
//}
//
//- (UIButton *)btnCalendar {
//    if (!_btnCalendar) {
//        _btnCalendar = [[UIButton alloc] init];
//        [_btnCalendar setImage:[UIImage imageNamed:@"work_plan_date"] forState:UIControlStateNormal];
//        [_btnCalendar addTarget:self action:@selector(calendarClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btnCalendar;
//}
//
//- (NSMutableArray *)arrData {
//    if (!_arrData) _arrData = [NSMutableArray new];
//    return _arrData;
//}

@end
