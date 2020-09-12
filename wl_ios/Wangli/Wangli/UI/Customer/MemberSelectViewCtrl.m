//
//  MemberSelectViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/7/9.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MemberSelectViewCtrl.h"
#import "EmptyView.h"
#import "ListSelectViewCtrl.h"
#import "SearchTopView.h"

@interface MemberSelectViewCtrl () <UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) SearchTopView *searchView;

@end

@implementation MemberSelectViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

- (void)setUI {
    self.title = @"请选择客户";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.top.equalTo(self.naviView.mas_bottom).offset(8);
        make.height.equalTo(@28);
        make.right.equalTo(self.naviView.mas_right).offset(-15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(8);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)getMemberList:(NSInteger)page {
    
//    MemberSelectFromNeedRules = 0,      //默认带rules
//    MemberSelectFromIM,                 //IM发送客户
//    MemberSelectFromOrder,              //新建订单
//    MemberSelectFromDemand,             //新建要货计划
//    MemberSelectFromPay,                //新建收款计划
    
    if (!_sendIM) {
        NSMutableArray *rules = [NSMutableArray new];
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"number"];
        
//        [rules addObject:@{@"field":@"sapNumber",
//                           @"option":@"IS_NOT_NULL"}];
//
//        [rules addObject:@{@"field":@"salesman",
//                           @"option":@"IS_NOT_NULL",
//                           @"values":@[]}];

        if (_knkli) {
            [rules addObject:@{@"field":@"knkli",
                               @"option":@"IS_NOT_NULL"}];
        }
        
        if (_isWangli) {
            [rules addObject:@{@"field": @"cooperationTypeKey",
                               @"option": @"IN",
                               @"values": @[@"direct_selling",@"double_distribution"]}];
        }
        
        if (_moduleNumber.length != 0) [param setObject:STRING(self.moduleNumber) forKey:@"moduleNumber"];
        
        if (self.customRules.count > 0) [rules addObjectsFromArray:self.customRules];
        
        [[JYUserApi sharedInstance] getSelfMemberListParam:param rules:rules specialConditions:@[STRING(_searchKey)] success:^(id responseObject) {
            [Utils dismissHUD];
            [self tableViewEndRefresh];
            NSError *error = nil;
            NSMutableArray *tmpArr = [CustomerMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            if (page == 0) {
                [self.arrData removeAllObjects];
                self.arrData = nil;
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
            [self tableViewEndRefresh];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        NSMutableArray *rules = [[NSMutableArray alloc] init];
        [rules addObject:@{@"field":@"orgName",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[STRING(_searchKey)]}];
        if (self.customRules.count > 0) [rules addObjectsFromArray:self.customRules];
        [[JYUserApi sharedInstance] getSendAbleMemberListParam:@{@"number":@(page)} toUserId:_toUserId rules:rules specialConditions:@[STRING(_searchKey)] success:^(id responseObject) {
            [Utils dismissHUD];
            [self tableViewEndRefresh];
            NSError *error = nil;
            NSMutableArray *tmpArr = [CustomerMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            if (page == 0) {
                [self.arrData removeAllObjects];
                self.arrData = nil;
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
            [self tableViewEndRefresh];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
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
    // 内容
    static NSString *identifier = @"listCell";
    ListselectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListselectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    CustomerMo *tmpMo = self.arrData[indexPath.row];
    cell.labText.text = [NSString stringWithFormat:@"%@-%@", tmpMo.orgName, tmpMo.cooperationType.length==0?@"无合作类型":tmpMo.cooperationType];
    cell.imgArrow.hidden = ((tmpMo.id == self.defaultId) ? NO : YES);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(memberSelectViewCtrl:selectedModel:indexPath:)]) {
            CustomerMo *tmpMo = self.arrData[indexPath.row];
            [_VcDelegate memberSelectViewCtrl:self selectedModel:tmpMo indexPath:self.indexPath];
        }
    }];
}

- (void)clickLeftButton:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(memberSelectViewCtrlDismiss:)]) {
            [_VcDelegate memberSelectViewCtrlDismiss:self];
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

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.hasAudio = NO;
        _searchView.searchTxtField.placeholder = @"客户名称/首字母/联系人名称/电话";
    }
    return _searchView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableArray *)customRules {
    if (!_customRules) _customRules = [NSMutableArray new];
    return _customRules;
}

@end
