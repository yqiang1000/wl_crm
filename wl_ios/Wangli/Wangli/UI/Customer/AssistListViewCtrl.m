//
//  AssistListViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/7/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "AssistListViewCtrl.h"
#import "EmptyView.h"
#import "ListSelectViewCtrl.h"

@interface AssistListViewCtrl () <UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger page;

@end

@implementation AssistListViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

- (void)setUI {
    self.title = @"请选择联系人";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    
    [self.leftBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];  //设置水平方向抗压缩优先级高 水平方向可以正常显示
    [self.leftBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];  //设置垂直方向挤压缩优先级高 垂直方向可以正常显示
}

- (void)getMemberList:(NSInteger)page {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"id" forKey:@"property"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@(20) forKey:@"size"];
    [params setObject:@(page) forKey:@"number"];
    
    [[JYUserApi sharedInstance] getOperatorAssistListParam:params success:^(id responseObject) {
        [Utils dismissHUD];
        [self tableViewEndRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [JYUserMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 内容
    static NSString *identifier = @"listCell";
    ListselectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListselectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    JYUserMo *tmpMo = self.arrData[indexPath.row];
    cell.labText.text = STRING(tmpMo.name);
    cell.imgArrow.hidden = tmpMo.id == self.defaultId ? NO : YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(assistListViewCtrl:selectedModel:indexPath:)]) {
        JYUserMo *tmpMo = self.arrData[indexPath.row];
        [_VcDelegate assistListViewCtrl:self selectedModel:tmpMo indexPath:self.indexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickLeftButton:(UIButton *)sender {
    if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(assistListViewCtrlDismiss:)]) {
        [_VcDelegate assistListViewCtrlDismiss:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
