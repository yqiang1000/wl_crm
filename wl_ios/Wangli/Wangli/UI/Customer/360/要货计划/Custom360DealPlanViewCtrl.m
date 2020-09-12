//
//  Custom360DealPlanViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360DealPlanViewCtrl.h"
#import "SearchTopView.h"
#import "FilterView.h"
#import "FilterListView.h"
#import "DealPlanCell.h"
#import "DealPlanMo.h"
#import "CreateDealPlanViewCtrl.h"
#import "DealPlanSearchViewCtrl.h"
#import "WSDatePickerView.h"
#import "EmptyView.h"
#import "CreateDemandViewCtrl.h"

@interface Custom360DealPlanViewCtrl () <SearchTopViewDelegate, FilterViewDelegate, FilterListViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) FilterListView *filterListView;
@property (nonatomic, assign) NSInteger currentTag;

@property (nonatomic, strong) NSDate *dateTag;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *arrDaniers; // 旦数
@property (nonatomic, strong) NSMutableArray *arrAddress; // 产地
@property (nonatomic, assign) NSInteger sortTag1;
@property (nonatomic, assign) NSInteger sortTag2;

@end

@implementation Custom360DealPlanViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentTag = 0;
    _page = 0;
    _sortTag1 = -1;
    _sortTag2 = -1;
    [self addTableView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.filterView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.footerRefresh = YES;
    self.headerRefresh = YES;
    [self.tableView.mj_header beginRefreshing];
    [self getDaniers];
    [self getAddress];
}

- (void)dealloc {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
    [_filterView resetNormalState];
    [self.searchView.searchTxtField resignFirstResponder];
}

#pragma mark - network

- (void)getList:(NSInteger)page {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    
    [rules addObject:@{@"field":@"member.id",
                       @"option":@"EQ",
                       @"values":@[@(TheCustomer.customerMo.id)]}];
    
    if (_dateTag) {
        [rules addObject:@{@"field":@"year",
                           @"option":@"EQ",
                           @"values":@[[_dateTag stringWithFormat:@"yyyy"]]}];
        
        [rules addObject:@{@"field":@"month",
                           @"option":@"EQ",
                           @"values":@[[_dateTag stringWithFormat:@"MM"]]}];
    }
    
//    [rules addObject:@{@"field":@"salesMan.id",
//                       @"option":@"IN",
//                       @"values":@[@(TheUser.userMo.id)]}];
    
    if (self.arrDaniers.count > 0 && _sortTag2 != -1) {
        if (![self.arrDaniers[_sortTag2] isEqualToString:@"不限"]) {
            [rules addObject:@{@"field":@"material.denier",
                               @"option":@"EQ",
                               @"values":@[_arrDaniers[_sortTag2]]}];
        }
    }

    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    
    NSMutableArray *specialConditions = [NSMutableArray new];
    if (self.arrAddress.count > 0 && _sortTag1 != -1) {
        if (_sortTag1 != 0) {
            DicMo *tmpDic = self.arrAddress[_sortTag1-1];
            [specialConditions addObject:[NSString stringWithFormat:@"product-place-%@", tmpDic.value]];
        }
    }
    
    [[JYUserApi sharedInstance] getDemandPlanPageByParam:params page:page size:10 rules:rules specialConditions:specialConditions success:^(id responseObject) {
        [self tableViewEndRefresh];
        [Utils dismissHUD];
        NSError *error = nil;
        NSMutableArray *tmpArr = [DealPlanMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        [self tableViewEndRefresh];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getDaniers {
    [[JYUserApi sharedInstance] getMaterialFindDenierSuccess:^(id responseObject) {
        [self.arrDaniers addObject:@"不限"];
        [self.arrDaniers addObjectsFromArray:responseObject[@"content"]];
    } failure:^(NSError *error) {
    }];
}

- (void)getAddress {
    [[JYUserApi sharedInstance] getConfigDicByName:@"product-place" success:^(id responseObject) {
        self.arrAddress = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
    } failure:^(NSError *error) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 111;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"dealPlanCell";
    DealPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DealPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell loadDataWith:self.arrData[indexPath.row] orgName:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateDealPlanViewCtrl *vc = [[CreateDealPlanViewCtrl alloc] init];
    vc.mo = self.arrData[indexPath.row];
    __weak typeof(self) weakself = self;
    vc.createSuccess = ^{
        [weakself.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:NO];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:YES];
}

- (void)pushToSearchVC:(BOOL)showIFly {
    SearchStyle *searchStyle = [[SearchStyle alloc] init];
    searchStyle.type = SearchDealPlan;
    DealPlanSearchViewCtrl *vc = [[DealPlanSearchViewCtrl alloc] init];
    vc.showIFly = showIFly;
    vc.searchStyle = searchStyle;
    BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - FilterViewDelegate

- (void)filterView:(FilterView *)filterView selectedIndex:(NSInteger)index selected:(BOOL)selected {
    _currentTag = index;
    
    if (_currentTag == 0) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        
        [self.filterView resetNormalState];
        
        __block NSString *dateStr = [_dateTag stringWithFormat:@"yyyy-M"];
        
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-M"];
        NSDate *scrollToDate = [minDateFormater dateFromString:dateStr];
        
        __weak typeof(self) weakSelf = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            __strong typeof(self) strongSelf = weakSelf;
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-M"];
            
            NSLog(@"选择的日期：%@",date);
            if (![date isEqualToString:dateStr]) {
                strongSelf.dateTag = selectDate;
                [strongSelf.filterView updateTitle:[[selectDate stringWithFormat:@"M"] stringByAppendingString:@"月"] atIndex:0];
                [strongSelf.tableView.mj_header beginRefreshing];
            }
        }];
        
        datepicker.btnCancelTitle = @"重置";
        datepicker.wsCancelBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.dateTag = nil;
            [strongSelf.filterView updateTitle:@"月份" atIndex:0];
            [strongSelf.tableView.mj_header beginRefreshing];
        };
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
        
    } else {
        if (selected) {
            if (!_filterListView) {
                _filterListView = [[FilterListView alloc] initWithSourceType:0];
                _filterListView.delegate = self;
            }
            
            CGFloat top = CGRectGetMaxY(self.filterView.frame);
            [self.view addSubview:_filterListView];
            [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.filterView.mas_bottom);
                make.left.right.bottom.equalTo(self.view);
            }];
            
            _filterListView.collectionView.selectTag = _currentTag == 1 ? _sortTag1 : _sortTag2;
            if (_currentTag == 1) {
                NSMutableArray *arr = [NSMutableArray new];
                [arr addObject:@"不限"];
                for (DicMo *tmpDic in self.arrAddress) {
                    [arr addObject:tmpDic.value];
                }
                [_filterListView loadData:arr];
            } else if (_currentTag == 2) {
                [_filterListView loadData:self.arrDaniers];
            }
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-top) bottomHeight:0];
        } else {
            [_filterListView removeFromSuperview];
            _filterListView = nil;
        }
    }
}

#pragma mark - FilterListViewDelegate

-(void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView resetNormalState];
    if (_currentTag == 1) {
        _sortTag1 = indexPath.row;
        if (_sortTag1 == 0) {
            [_filterView updateTitle:@"不限" atIndex:1];
        } else {
            DicMo *tmpMo = self.arrAddress[_sortTag1-1];
            [_filterView updateTitle:STRING(tmpMo.value) atIndex:1];
        }
    } else if (_currentTag == 2) {
        _sortTag2 = indexPath.row;
        [_filterView updateTitle:STRING(self.arrDaniers[_sortTag2]) atIndex:2];
    }
    _page = 0;
    [self getList:_page];
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView resetNormalState];
}

#pragma mark - event

- (void)btnAddClick:(UIButton *)sender {
    if (TheCustomer.customerMo.sapNumber.length == 0) {
        [Utils showToastMessage:@"非正式客户不允许创建要货计划"];
        return;
    }
    CreateDemandViewCtrl *vc = [[CreateDemandViewCtrl alloc] init];
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        [weakself.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:_page+1];
}

- (void)handleDeleteCell:(NSIndexPath *)sender {
    NSLog(@"handle delete cell %ld", sender.row);
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"删除"] defaultItem:-1 itemClick:^(NSInteger index) {
        DealPlanMo *tmpMo = self.arrData[sender.row];
        if ([tmpMo.status isEqualToString:@"APPROVALED"]) {
            [Utils showToastMessage:@"不能删除已审批要货计划"];
        } else {
            NSString *msg = [NSString stringWithFormat:@"是否删除要货计划\"%@/%@/%@\"",tmpMo.year, tmpMo.month, STRING(tmpMo.material[@"batchNumber"])];
            [Utils commonDeleteTost:@"系统提示" msg:msg cancelTitle:@"取消" confirmTitle:@"确定" confirm:^{
                [Utils showHUDWithStatus:nil];
                [Utils showToastMessage:@"删除成功"];
                [[JYUserApi sharedInstance] deleteDemandPlanByPlanId:tmpMo.id success:^(id responseObject) {
                    [Utils dismissHUD];
                    [self.arrData removeObjectAtIndex:sender.row];
                    [self.tableView deleteRowsAtIndexPaths:@[sender] withRowAnimation:UITableViewRowAnimationFade];
                } failure:^(NSError *error) {
                    [Utils dismissHUD];
                    [Utils showToastMessage:STRING(error.userInfo[@"message"])];
                }];
            } cancel:^{
            }];
        }
    } cancelClick:^(BottomView *obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    [bottomView show];
}

#pragma mark - setter getter

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = COLOR_B0;
        [_topView addSubview:self.btnAdd];
        [_topView addSubview:self.searchView];
        
        [_btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_topView);
            make.height.width.equalTo(@44);
            make.left.equalTo(_topView).offset(4);
        }];
        
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_topView);
            make.height.equalTo(@28);
            make.left.equalTo(_btnAdd.mas_right).offset(4);
            make.right.equalTo(_topView).offset(-15);
        }];
    }
    return _topView;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.searchTxtField.placeholder = [SearchStyle placeholdString:SearchDealPlan];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [[UIButton alloc] init];
        [_btnAdd setImage:[UIImage imageNamed:@"c_goods_new"] forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAdd;
}

- (FilterView *)filterView {
    if (!_filterView) {
        _filterView = [[FilterView alloc] initWithTitles:@[@"月份", @"产地", @"旦数"] imgsNormal:@[@"client_down_n", @"client_down_n", @"client_down_n"] imgsSelected:@[@"drop_down_s", @"drop_down_s", @"drop_down_s"]];
        _filterView.backgroundColor = COLOR_B4;
        _filterView.delegate = self;
    }
    return _filterView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableArray *)arrDaniers {
    if (!_arrDaniers) {
        _arrDaniers = [NSMutableArray new];
    }
    return _arrDaniers;
}

- (NSMutableArray *)arrAddress {
    if (!_arrAddress) {
        _arrAddress = [NSMutableArray new];
    }
    return _arrAddress;
}

@end
