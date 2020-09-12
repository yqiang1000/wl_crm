//
//  HelpListViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "HelpListViewCtrl.h"
#import "ContactDetailViewCtrl.h"
#import "JYUserMo.h"
#import "EmptyView.h"
#import "ListSelectViewCtrl.h"
#import "SystemInfoMo.h"

@interface HelpListViewCtrl () <UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *arrIndexPaths;

@end

@implementation HelpListViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviView.hidden = NO;
    [self setUI];
    
//    for (HelpListMo *tmpMo in self.defaultValues) {
//        [self.arrIndexPaths addObject:tmpMo];
//    }
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    if (self.updateSuccess) {
        self.updateSuccess(nil);
    }
}

- (void)setUI {
    self.title = @"协助人列表";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
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
        NSMutableArray *tmpData = [NSMutableArray new];
        NSArray *tmpArr = responseObject[@"content"];
        for (int i = 0; i < tmpArr.count; i++) {
            NSDictionary *dic = tmpArr[i];
            HelpListMo *helpMo = [[HelpListMo alloc] init];
            helpMo.moId = [dic[@"id"] longLongValue];
            helpMo.name = STRING(dic[@"name"]);
            [tmpData addObject:helpMo];
        }
        
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpData;
        } else {
            if (tmpData.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self tableViewEndRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getDefaultData {
    [[JYUserApi sharedInstance] getMemberSystemInfoByMemberId:TheCustomer.customerMo.id success:^(id responseObject) {
        [Utils dismissHUD];
        SystemInfoMo *systemInfo = [[SystemInfoMo alloc] initWithDictionary:responseObject error:nil];
        [_defaultValues removeAllObjects];
        _defaultValues = nil;
        for (NSDictionary *tmpMo in systemInfo.operators) {
            HelpListMo *helpMo = [[HelpListMo alloc] init];
            helpMo.name = STRING(tmpMo[@"name"]);
            helpMo.moId = [tmpMo[@"id"] longLongValue];
            [self.defaultValues addObject:helpMo];
        }
        for (HelpListMo *tmpMo in self.defaultValues) {
            [self.arrIndexPaths addObject:tmpMo];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
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
    HelpListMo *tmpMo = self.arrData[indexPath.row];
    cell.labText.text = STRING(tmpMo.name);
    cell.imgArrow.hidden = ![self compareindexPath:tmpMo compareComplete:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpListMo *tmpMo = self.arrData[indexPath.row];
    
    __block NSInteger tag = -1;
    BOOL isCantant = [self compareindexPath:tmpMo compareComplete:^(NSInteger index) {
        tag = index;
    }];
    
    if (isCantant) {
        if (tag >= 0 && tag < self.arrIndexPaths.count) {
            [self.arrIndexPaths removeObjectAtIndex:tag];
        }
    } else {
        [self.arrIndexPaths addObject:tmpMo];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)clickLeftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    NSMutableArray *operIds = [NSMutableArray new];
    for (HelpListMo *mo in self.arrIndexPaths) {
        [operIds addObject:@{@"id":[NSString stringWithFormat:@"%lld", mo.moId]}];
    }
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] changeAssistByMemberId:TheCustomer.customerMo.id operIds:operIds success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
//        [_defaultValues removeAllObjects];
//        _defaultValues = nil;
//        for (HelpListMo *tmpMo in self.arrIndexPaths) {
//            [self.defaultValues addObject:tmpMo];
//        }
        
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)tableViewHeaderRefreshAction {
    [_arrIndexPaths removeAllObjects];
    _arrIndexPaths = nil;
    _page = 0;
    [self getMemberList:_page];
    [self getDefaultData];
}

- (void)tableViewFooterRefreshAction {
    [self getMemberList:_page+1];
}

- (void)tableViewEndRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (BOOL)compareindexPath:(HelpListMo *)mo compareComplete:(void(^)(NSInteger index))compareComplete {
    for (int i = 0; i < self.arrIndexPaths.count; i++) {
        HelpListMo *tmpMo = self.arrIndexPaths[i];
        if (tmpMo.moId == mo.moId) {
            if (compareComplete) {
                compareComplete(i);
            }
            return YES;
        }
    }
    if (compareComplete) {
        compareComplete(-1);
    }
    return NO;
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

- (NSMutableArray *)arrIndexPaths {
    if (!_arrIndexPaths) {
        _arrIndexPaths = [NSMutableArray new];
    }
    return _arrIndexPaths;
}

- (NSMutableArray *)defaultValues {
    if (!_defaultValues) {
        _defaultValues = [NSMutableArray new];
    }
    return _defaultValues;
}

@end

#pragma mark - HelpListMo

@implementation HelpListMo

@end

