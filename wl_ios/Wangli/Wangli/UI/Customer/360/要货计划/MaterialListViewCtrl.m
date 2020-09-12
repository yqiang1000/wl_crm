
//
//  MaterialListViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MaterialListViewCtrl.h"
#import "MaterialMo.h"
#import "ListSelectViewCtrl.h"
#import "EmptyView.h"
#import "SearchTopView.h"

@interface MaterialListViewCtrl () <UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) SearchTopView *searchView;

@end

@implementation MaterialListViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

// 获取物料列表
- (void)getMaterialList:(NSInteger)page {
//    {
//        "size": 30,
//        "rules":[
//                 {
//                     "field": "batchNumber",
//                     "option": "LIKE_ANYWHERE",
//                     "values": ["41"]
//                 }
//                 ]
//    }
    if (_fromSpe) {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:@(page) forKey:@"number"];
        [param setObject:@(30) forKey:@"size"];
        [param setObject:@[@{@"field":@"batchNumber",
                             @"option":@"LIKE_ANYWHERE",
                             @"values":@[STRING(self.searchKey)]}] forKey:@"rules"];
        [[JYUserApi sharedInstance] findBatchParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSMutableArray *tmpArr = responseObject[@"content"];
            if (page == 0) {
                [self.arrData removeAllObjects];
                self.arrData = nil;
                for (NSString *str in tmpArr) {
                    MaterialMo *mo = [[MaterialMo alloc] init];
                    mo.batchNumber = str;
                    [self.arrData addObject:mo];
                }
            } else {
                if (tmpArr.count > 0) {
                    _page = page;
                    for (NSString *str in tmpArr) {
                        MaterialMo *mo = [[MaterialMo alloc] init];
                        mo.batchNumber = str;
                        [self.arrData addObject:mo];
                    }
                }
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        NSArray *rules = @[@{@"field":@"batchNumber",
                             @"option":@"LIKE_ANYWHERE",
                             @"values":@[STRING(self.searchKey)]}];
        
        [[JYUserApi sharedInstance] getMaterialList:TheCustomer.customerMo.id page:page rules:rules success:^(id responseObject) {
            [Utils dismissHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSMutableArray *tmpArr = [MaterialMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
            if (page == 0) {
                [self.arrData removeAllObjects];
                self.arrData = nil;
                self.arrData = tmpArr;
            } else {
                if (tmpArr.count > 0) {
                    _page = page;
                    [self.arrData addObjectsFromArray:tmpArr];
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
}

- (void)setUI {
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
    MaterialMo *tmpMo = self.arrData[indexPath.row];
    NSString *string = [[NSString alloc] init];
    if (tmpMo.batchNumber.length != 0) {
        string = [string stringByAppendingString:tmpMo.batchNumber];
    }
    if (tmpMo.weight.length != 0) {
        string = [string stringByAppendingString:@" - "];
        string = [string stringByAppendingString:tmpMo.weight];
    }
    if (tmpMo.productLevelName.length != 0) {
        string = [string stringByAppendingString:@" - "];
        string = [string stringByAppendingString:tmpMo.productLevelName];
    }
    cell.labText.text = string;    
    cell.imgArrow.hidden = [string isEqualToString:self.defaultNum] ? NO : YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(materialListViewCtrl:selectMaterialMo:indexPath:)]) {
            MaterialMo *tmpMo = self.arrData[indexPath.row];
            [_VcDelegate materialListViewCtrl:self selectMaterialMo:tmpMo indexPath:self.indexPath];
        }
    }];
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

#pragma mark - event

- (void)clickLeftButton:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (_VcDelegate && [_VcDelegate respondsToSelector:@selector(materialListViewCtrlDismiss:)]) {
            [_VcDelegate materialListViewCtrlDismiss:self];
        }
    }];
}

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getMaterialList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getMaterialList:_page + 1];
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
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
        _searchView.searchTxtField.placeholder = @"请输入批号";
    }
    return _searchView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
