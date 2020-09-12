//
//  TravelArriveCityViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/8/26.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "TravelArriveCityViewCtrl.h"
#import "EmptyView.h"
#import "SearchTopView.h"
#import "BrandMo.h"
#import "ListSelectViewCtrl.h"
#import "TravelCityMo.h"

@interface TravelArriveCityViewCtrl () <UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) NSMutableArray *arrSelect;

@end

@implementation TravelArriveCityViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"到达地";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    [self setUI];
    self.rightBtn.hidden = YES;
    [self tableViewHeaderRefreshAction];
}

- (void)setUI {
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.top.equalTo(self.naviView.mas_bottom).offset(8);
        make.height.equalTo(@28.0);
        make.right.equalTo(self.naviView.mas_right).offset(-15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(8);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)getMemberList:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (self.searchKey.length > 0) [param setObject:STRING(self.searchKey) forKey:@"cityname"];
    [[JYUserApi sharedInstance] getTravelCityListParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self tableViewEndRefresh];
        NSError *error = nil;
        self.arrData = [TravelCityMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self tableViewEndRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
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
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchView.searchTxtField resignFirstResponder];
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    [self.searchView.searchTxtField resignFirstResponder];
    self.searchKey =  [searchTopView.searchTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"listCell";
    ListselectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListselectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TravelCityMo *tmpMo = self.arrData[indexPath.row];
    cell.labText.text = STRING(tmpMo.cityname);
    cell.imgArrow.hidden = ([self.arrSelect containsObject:tmpMo] ? NO : YES);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TravelCityMo *tmpMo = self.arrData[indexPath.row];
    if (self.updateSuccess) {
        self.updateSuccess(tmpMo.cityname);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickLeftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getMemberList:_page];
}

//- (void)tableViewFooterRefreshAction {
//    [self getMemberList:_page+1];
//}

- (void)tableViewEndRefresh {
    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return _tableView;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.hasAudio = NO;
        _searchView.searchTxtField.placeholder = @"请输入到达地关键字";
    }
    return _searchView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

- (NSMutableArray *)arrSelect {
    if (!_arrSelect) _arrSelect = [NSMutableArray new];
    return _arrSelect;
}

@end