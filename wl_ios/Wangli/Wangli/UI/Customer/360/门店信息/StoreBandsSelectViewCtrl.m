//
//  StoreBandsSelectViewCtrl.m
//  Wangli
//
//  Created by 杜文杰 on 2019/7/15.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "StoreBandsSelectViewCtrl.h"
#import "EmptyView.h"
#import "ListSelectViewCtrl.h"
#import "SearchTopView.h"

@interface StoreBandsSelectViewCtrl () <UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) NSMutableArray *arrSelected;

@end

@implementation StoreBandsSelectViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    if (_isMultiple) {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.rightBtn.hidden = NO;
    } else {
        self.rightBtn.hidden = YES;
    }
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

- (void)setUI {
    self.title = @"请选择品牌";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
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
    NSMutableArray *rules = [NSMutableArray new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(20) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"createdDate" forKey:@"property"];
    [rules addObject:@{@"field": @"brandName",
                       @"option": @"LIKE_ANYWHERE",
                       @"values":@[STRING(_searchKey)]}];
    [[JYUserApi sharedInstance] getPageDynmicFormDynamicId:@"brand" param:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [StoreBandsMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    // 内容
    static NSString *identifier = @"listCell";
    ListselectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListselectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    StoreBandsMo *tmpMo = self.arrData[indexPath.row];
    cell.labText.text = tmpMo.brandName;
    cell.imgArrow.hidden = [self.defaultValues containsObject:[NSString stringWithFormat:@"%ld", tmpMo.id]] ? NO : YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreBandsMo *tmpMo = self.arrData[indexPath.row];
    NSString *bandId = [NSString stringWithFormat:@"%ld", tmpMo.id];
    if (_isMultiple) {
        // 多选
        if ([self.defaultValues containsObject:bandId]) {
            [self.defaultValues removeObject:bandId];
        } else {
            [self.defaultValues addObject:bandId];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        // 单选
        [self.defaultValues removeAllObjects];
        [self.defaultValues addObject:bandId];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(storeBandsSelectViewCtrl:selectIndex:indexPath:selectMo:)]) {
            [_VcDelegate storeBandsSelectViewCtrl:self selectIndex:indexPath.row indexPath:self.indexPath selectMo:tmpMo];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clickRightButton:(UIButton *)sender {
    if (self.defaultValues.count == 0) {
        [Utils showToastMessage:@"请至少选择一项"];
        return;
    }
    
    [Utils showHUDWithStatus:nil];
    for (int i = 0; i < self.defaultValues.count; i++) {
        NSString *idStr = self.defaultValues[i];
        for (StoreBandsMo *tmpMo in self.arrData) {
            if ([idStr isEqualToString:[NSString stringWithFormat:@"%ld", tmpMo.id]]) {
                [self.arrSelected addObject:tmpMo];
            }
        }
    }
    [Utils dismissHUD];
    if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(storeBandsSelectViewCtrl:selectedData:indexPath:)]) {
        [_VcDelegate storeBandsSelectViewCtrl:self selectedData:self.arrSelected indexPath:self.indexPath];
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
        _searchView.searchTxtField.placeholder = @"请输入品牌关键字";
    }
    return _searchView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

- (NSMutableArray *)arrSelected {
    if (!_arrSelected) _arrSelected = [NSMutableArray new];
    return _arrSelected;
}

- (NSMutableArray *)defaultValues {
    if (!_defaultValues) _defaultValues = [NSMutableArray new];
    return _defaultValues;
}


@end
