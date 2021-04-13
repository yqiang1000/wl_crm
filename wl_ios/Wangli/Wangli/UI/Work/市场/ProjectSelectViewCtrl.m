//
//  ProjectSelectViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2021/1/12.
//  Copyright © 2021 yeqiang. All rights reserved.
//

#import "ProjectSelectViewCtrl.h"
#import "EmptyView.h"
#import "ListSelectViewCtrl.h"
#import "SearchTopView.h"

@interface ProjectSelectViewCtrl () <UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *brandKey;
@property (nonatomic, strong) NSString *teleKey;

@property (nonatomic, strong) SearchTopView *brandView;
@property (nonatomic, strong) SearchTopView *teleView;

@end

@implementation ProjectSelectViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

- (void)setUI {
    self.title = @"请选择项目";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    [self.view addSubview:self.brandView];
    [self.view addSubview:self.teleView];
    [self.view addSubview:self.tableView];
    
    [self.brandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.top.equalTo(self.naviView.mas_bottom).offset(8);
        make.height.equalTo(@28);
        make.right.equalTo(self.naviView.mas_right).offset(-15);
    }];
    
    [self.teleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.brandView);
        make.top.equalTo(self.brandView.mas_bottom);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teleView.mas_bottom).offset(8);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)getMemberList:(NSInteger)page {
    NSMutableArray *rules = [NSMutableArray new];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    [param setObject:@"10" forKey:@"size"];

    if (self.brandKey.length > 0) {
        [rules addObject:@{@"field":@"project-projectBrand",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[self.brandKey]}];
    }
    if (self.teleKey.length > 0) {
        [rules addObject:@{@"field":@"contactName-contactPhone",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[self.teleKey]}];
    }
    if (rules.count > 0) {
        [param setObject:rules forKey:@"rules"];
    }
    [[JYUserApi sharedInstance] getEngineeringReportPageByParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self tableViewEndRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [MarketProjectMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
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
    [self.brandView.searchTxtField resignFirstResponder];
    [self.teleView.searchTxtField resignFirstResponder];
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    if (searchTopView == self.brandView) {
        [self.brandView.searchTxtField resignFirstResponder];
        self.brandKey =  [searchTopView.searchTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        [self.teleView.searchTxtField resignFirstResponder];
        self.teleKey =  [searchTopView.searchTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 内容
    static NSString *identifier = @"listCell";
    ListselectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListselectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MarketProjectMo *tmpMo = self.arrData[indexPath.row];
    cell.labText.text = [NSString stringWithFormat:@"%@-%@-%@", tmpMo.project, tmpMo.projectBrand, tmpMo.projectUser];
    cell.imgArrow.hidden = ((tmpMo.id == self.defaultId) ? NO : YES);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(projectSelectViewCtrl:selectedModel:indexPath:)]) {
            MarketProjectMo *tmpMo = self.arrData[indexPath.row];
            [_VcDelegate projectSelectViewCtrl:self selectedModel:tmpMo indexPath:self.indexPath];
        }
    }];
}

- (void)clickLeftButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(projectSelectViewCtrlDismiss:)]) {
            [_VcDelegate projectSelectViewCtrlDismiss:self];
        }
    }];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getMemberList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getMemberList:_page+1];
}

- (void)tableViewEndRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
    }
    return _tableView;
}

- (SearchTopView *)brandView {
    if (!_brandView) {
        _brandView = [[SearchTopView alloc] initWithAudio:NO];
        _brandView.delegate = self;
        _brandView.hasAudio = NO;
        _brandView.searchTxtField.placeholder = @"项目/品牌";
    }
    return _brandView;
}

- (SearchTopView *)teleView {
    if (!_teleView) {
        _teleView = [[SearchTopView alloc] initWithAudio:NO];
        _teleView.delegate = self;
        _teleView.hasAudio = NO;
        _teleView.searchTxtField.placeholder = @"联系人/电话";
    }
    return _teleView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
