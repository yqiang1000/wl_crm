//
//  MaterialPageSelectViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/16.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "MaterialPageSelectViewCtrl.h"
#import "EmptyView.h"
#import "ListSelectViewCtrl.h"
#import "SearchTopView.h"

@interface MaterialPageSelectViewCtrl () <UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) NSMutableArray *arrIndexPaths;

@end

@implementation MaterialPageSelectViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

- (void)setUI {
    self.title = @"产品大类";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    if (!self.isSignal) {
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.rightBtn.hidden = NO;
    }
    
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
    NSMutableArray *rules = [NSMutableArray new];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(20) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    if (self.searchKey.length > 0) [rules addObject:@{@"field":@"name",
                                                      @"option":@"LIKE_ANYWHERE",
                                                      @"values":@[STRING(self.searchKey)]}];
    if (rules.count > 0) [param setObject:rules forKey:@"rules"];
    [[JYUserApi sharedInstance] getBigMaterialTypePage:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self tableViewEndRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [MaterialMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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

- (BOOL)compareindexPath:(MaterialMo *)mo compareComplete:(void(^)(NSInteger index))compareComplete {
    for (int i = 0; i < self.arrIndexPaths.count; i++) {
        MaterialMo *tmpMo = self.arrIndexPaths[i];
        if (tmpMo.id == mo.id) {
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

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 内容
    static NSString *identifier = @"listCell";
    ListselectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListselectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MaterialMo *tmpMo = self.arrData[indexPath.row];
    cell.labText.text = tmpMo.name;
    cell.imgArrow.hidden = ![self compareindexPath:tmpMo compareComplete:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MaterialMo *tmpMo = self.arrData[indexPath.row];
    
    if (self.isSignal) {
        if (_vcDelegate && [_vcDelegate respondsToSelector:@selector(materialPageSelectViewCtrl:didSelectData:indexPath:)]) {
            [_vcDelegate materialPageSelectViewCtrl:self didSelectData:@[tmpMo] indexPath:self.indexPath];
        }
        
        [self clickLeftButton:self.leftBtn];
        return;
    }
    
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
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (_vcDelegate && [_vcDelegate respondsToSelector:@selector(materialPageSelectViewCtrlDismiss:)]) {
            [_vcDelegate materialPageSelectViewCtrlDismiss:self];
        }
    }];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    if (self.arrIndexPaths.count == 0) {
        [Utils showToastMessage:@"至少选择一个大类"];
        return;
    }
//    NSMutableArray *operIds = [NSMutableArray new];
//    for (MaterialMo *mo in self.arrIndexPaths) {
//        [operIds addObject:@{@"id":[NSString stringWithFormat:@"%lld", mo.id]}];
//    }
    if (_vcDelegate && [_vcDelegate respondsToSelector:@selector(materialPageSelectViewCtrl:didSelectData:indexPath:)]) {
        [_vcDelegate materialPageSelectViewCtrl:self didSelectData:self.arrIndexPaths indexPath:self.indexPath];
    }
    
    [self clickLeftButton:self.leftBtn];
}

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
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return _tableView;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.hasAudio = NO;
        _searchView.searchTxtField.placeholder = @"请输入类别关键字";
    }
    return _searchView;
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

@end
