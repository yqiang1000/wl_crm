//
//  ProvincePageListViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/5/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "ProvincePageListViewCtrl.h"
#import "SearchTopView.h"
#import "AreaMo.h"
#import "ListSelectViewCtrl.h"
#import "EmptyView.h"

@interface ProvincePageListViewCtrl () <UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation ProvincePageListViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"省份";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    _page = 0;
    _keyWord = @"";
    [self setUI];
    [self tableViewHeaderRefreshAction];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.right.equalTo(self.naviView).offset(-15);
        make.top.equalTo(self.naviView.mas_bottom).offset(7.5);
        make.height.equalTo(@28.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(7.5);
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
    return 45;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"listCell";
    ListselectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListselectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ProvinceMo *tmpMo = self.arrData[indexPath.row];
    cell.labText.text = tmpMo.provinceName;
    cell.imgArrow.hidden = [tmpMo.provinceId isEqualToString:self.provinceId] ? NO : YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProvinceMo *tmpMo = self.arrData[indexPath.row];
    if (![self.provinceId isEqualToString:tmpMo.provinceId]) {
        self.provinceId = tmpMo.provinceId;
    } else {
        self.provinceId = @"";
    }
    [self.tableView reloadData];
    self.indexPath = indexPath;
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    [self.searchView.searchTxtField resignFirstResponder];
    self.keyWord =  [searchTopView.searchTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self tableViewHeaderRefreshAction];
}

#pragma mark - event

- (void)hidenKeyBoard {
    [self.searchView.searchTxtField resignFirstResponder];
}


- (void)getList:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(20) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    NSMutableArray *rules = [NSMutableArray new];
    if (self.keyWord.length != 0) {
        [rules addObject:@{@"field":@"provinceName",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[STRING(self.keyWord)]}];
    }
    
    if (rules.count > 0) [param setObject:rules forKey:@"rules"];
    [[JYUserApi sharedInstance] getProvincePageByParam:param success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [ProvinceMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
}

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:_page+1];
}

- (void)clickLeftButton:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)clickRightButton:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        __strong typeof(self) strongself = weakself;
        ProvinceMo *tmpMo = strongself.arrData[strongself.indexPath.row];
        if (strongself.updateSuccess) {
            if (strongself.provinceId.length > 0) {
                strongself.updateSuccess(tmpMo);
            } else {
                strongself.updateSuccess(nil);
            }
        }
    }];
}

#pragma mark - lazy

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
        _searchView.searchTxtField.placeholder = @"请输入省份关键字";
        _searchView.delegate = self;
    }
    return _searchView;
}

@end
