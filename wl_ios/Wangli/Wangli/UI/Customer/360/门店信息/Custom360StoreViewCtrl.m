//
//  Custom360StoreViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/3/18.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "Custom360StoreViewCtrl.h"
#import "SearchTopView.h"
#import "SearchStyle.h"
#import "SwitchView.h"
#import "FilterListView.h"
#import "WSDatePickerView.h"
#import "StoreCell.h"
#import "ProvincePageListViewCtrl.h"
#import "CreateStoreViewCtrl.h"

@interface Custom360StoreViewCtrl () <SearchTopViewDelegate, SwitchViewDelegate, FilterListViewDelegate>

@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) FilterListView *filterListView;
@property (nonatomic, strong) NSString *selectDate;
@property (nonatomic, assign) NSInteger switchId;
@property (nonatomic, assign) NSInteger sortTag;
@property (nonatomic, strong) NSMutableArray *arrSort;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) ProvinceMo *provinceMo;
@property (nonatomic, strong) UIButton *btnAdd;

@end

@implementation Custom360StoreViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _switchId = 0;
    _sortTag = 0;
    _keyWord = @"";
    _page = 0;
    [self setUI];
    [self.switchView updateSelectViewHiden:YES];
    [self.switchView updateNormalColor:COLOR_B2];
    [self.switchView refreshView];
    [self setFooterRefresh:YES];
    [self setHeaderRefresh:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setUI {
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.btnAdd];
    [self.view addSubview:self.switchView];
    [self.view addSubview:self.tableView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
//        make.right.equalTo(self.naviView).offset(-15);
        make.top.equalTo(self.view).offset(7.5);
        make.height.equalTo(@28.0);
    }];
    
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.height.width.equalTo(@44.0);
        make.left.equalTo(self.searchView.mas_right);
        make.right.equalTo(self.naviView);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(7.5);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom).offset(10);
        make.bottom.right.left.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86.0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"sotrecell";
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreMo *storeMo = self.arrData[indexPath.row];
    CreateStoreViewCtrl *vc = [[CreateStoreViewCtrl alloc] init];
    vc.title = @"门店信息";
    vc.dynamicId = @"storme-manage-entity";
    vc.isUpdate = YES;
    vc.fromTab = NO;
    vc.detailId = storeMo.id;
    vc.storeMo = storeMo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SwitchViewDelegate

- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
    // 隐藏键盘
    [self hidenKeyBoard];
    // 任何已经处于选择情况下，清空选择列表，重置按钮
    if (self.filterListView) {
        [self releaseFilterListView];
        return;
    }
    self.switchId = index;
    // 只设置当前的选中状态，其他重置
    [switchView updateTitle:@"" index:index switchState:SwitchStateSelectSecond];
    
    if (self.switchId == 0) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM"];
        NSDate *scrollToDate = [minDateFormater dateFromString:self.selectDate];
        
        __weak typeof(self) weakSelf = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            __strong typeof(self) strongSelf = weakSelf;
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM"];
            NSLog(@"选择的日期：%@",date);
            [weakSelf.switchView updateTitle:date index:weakSelf.switchId switchState:SwitchStateNormal];
            if (![strongSelf.selectDate isEqualToString:date]) {
                strongSelf.selectDate = date;
                [Utils showHUDWithStatus:nil];
                [strongSelf tableViewHeaderRefreshAction];
            }
        }];
        datepicker.btnCancelTitle = @"重置";
        datepicker.wsCancelBlock = ^{
            [weakSelf.switchView updateTitle:@"创建时间" index:weakSelf.switchId switchState:SwitchStateNormal];
            weakSelf.selectDate = nil;
        };
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    } else {
        [switchView updateTitle:@"" index:index switchState:SwitchStateNormal];
        ProvincePageListViewCtrl *vc = [[ProvincePageListViewCtrl alloc] init];
        vc.provinceId = self.provinceMo.provinceId;
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(ProvinceMo *tmpMo) {
            __strong typeof(self) strongself = weakself;
            NSString *provinceName = tmpMo.provinceName.length == 0 ? @"省份" : tmpMo.provinceName;
            [strongself.switchView updateTitle:provinceName index:strongself.switchId switchState:SwitchStateNormal];
            if (![strongself.provinceMo.provinceId isEqualToString:tmpMo.provinceId]) {
                strongself.provinceMo = tmpMo;
                [Utils showHUDWithStatus:nil];
                [strongself tableViewHeaderRefreshAction];
            }
        };
        
        BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
        [[Utils topViewController] presentViewController:navi animated:YES completion:^{
        }];
//        [self.navigationController pushViewController:vc animated:YES];
//        if (!self.filterListView) {
//            self.filterListView = [[FilterListView alloc] initWithSourceType:0];
//            self.filterListView.delegate = self;
//        }
//
//        [self.view addSubview:self.filterListView];
//        [self.filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(CGRectGetMaxY(self.switchView.frame));
//            make.left.right.bottom.equalTo(self.view);
//        }];
//
//        self.arrSort = [[NSMutableArray alloc] initWithObjects:@"不限", @"上海", @"浙江", @"北京", @"天津", nil];
//        if (self.switchId == 1) {
//            self.filterListView.collectionView.selectTag = self.sortTag;
//        }
//        [self.filterListView loadData:self.arrSort];
//        [self.filterListView updateViewHeight:SCREEN_HEIGHT-CGRectGetMaxY(self.switchView.frame) bottomHeight:0];
    }
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.switchView updateTitle:@"" index:self.switchId switchState:SwitchStateNormal];
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    [self.searchView.searchTxtField resignFirstResponder];
    self.keyWord =  [searchTopView.searchTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [Utils showHUDWithStatus:nil];
    [self tableViewHeaderRefreshAction];
}

#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    NSString *str = @"";
    if (self.switchId == 1) {
        self.sortTag = indexPath.row;
        str = self.arrSort[indexPath.row];
        if (self.sortTag == 0) str = @"省份";
    }
    [self releaseFilterListView];
    [self.switchView updateTitle:str index:self.switchId switchState:SwitchStateNormal];
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [self releaseFilterListView];
}

#pragma mark - event

- (void)hidenKeyBoard {
    [self.searchView.searchTxtField resignFirstResponder];
}

- (void)btnAddClick:(UIButton *)sender {
    CreateStoreViewCtrl *vc = [[CreateStoreViewCtrl alloc] init];
    vc.title = @"新建门店";
    vc.dynamicId = @"storme-manage-entity";
    vc.isUpdate = NO;
    vc.fromTab = NO;
//    typeof (self) __weak weakself = self;
//    vc.updateSuccess = ^(id obj) {
//        typeof (self) __strong strongself = weakself;
//        [strongself.tableView.mj_header beginRefreshing];
//    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getList:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(10) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    NSMutableArray *rules = [NSMutableArray new];
    
    if (self.provinceMo.provinceId > 0) {
        [rules addObject:@{@"field":@"province.provinceId",
                           @"option":@"EQ",
                           @"values":@[STRING(self.provinceMo.provinceId)]}];
    }
    
    if (self.keyWord.length != 0) {
        [rules addObject:@{@"field":@"searchContent",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[STRING(self.keyWord)]}];
    }
    if (self.selectDate.length != 0) {
        [rules addObject:@{@"field":@"createdDate",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[STRING(self.selectDate)]}];
    }
    [rules addObject:@{@"field": @"customer.id",
                       @"values": @[@(TheCustomer.customerMo.id)],
                       @"option": @"EQ"}];
    
    if (rules.count > 0) [param setObject:rules forKey:@"rules"];
    
    [[JYUserApi sharedInstance] getPageDynmicFormDynamicId:@"storme-manage-entity" param:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [StoreMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)releaseFilterListView {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        [self.switchView updateTitle:@"" index:_switchId switchState:SwitchStateNormal];
    }
}

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:_page+1];
}

- (void)handleDeleteCell:(NSIndexPath *)sender {
    NSLog(@"handle delete cell %ld", (long)sender.row);
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"删除"] defaultItem:-1 itemClick:^(NSInteger index) {
        StoreMo *tmpMo = self.arrData[sender.row];
        NSString *msg = [NSString stringWithFormat:@"是否删除\"%@\"?",tmpMo.storeName];
        [Utils commonDeleteTost:@"系统提示" msg:msg cancelTitle:@"取消" confirmTitle:@"确定" confirm:^{
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] batchDeleteObjDetailByDynamicId:@"storme-manage-entity" param:@[@(tmpMo.id)].mutableCopy success:^(id responseObject) {
                [Utils dismissHUD];
                [Utils showToastMessage:@"删除成功"];
                [self.arrData removeObjectAtIndex:sender.row];
                [self.tableView deleteRowsAtIndexPaths:@[sender] withRowAnimation:UITableViewRowAnimationFade];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
                [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            }];
        } cancel:^{
        }];
    } cancelClick:^(BottomView *obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    [bottomView show];
}

#pragma mark - lazy

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = @"请输入关键字";
    }
    return _searchView;
}

- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithTitles:@[@"创建时间", @"省份"] imgNormal:@[@"client_down_n", @"client_down_n"] imgSelect:@[@"drop_down_s", @"drop_down_s"]];
        _switchView.delegate = self;
    }
    return _switchView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [[UIButton alloc] init];
        [_btnAdd setImage:[UIImage imageNamed:@"c_goods_new"] forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAdd;
}

@end
