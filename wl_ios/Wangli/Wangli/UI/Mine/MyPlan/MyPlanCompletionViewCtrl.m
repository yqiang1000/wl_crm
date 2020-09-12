//
//  MyPlanCompletionViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/9.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyPlanCompletionViewCtrl.h"
#import "TopTabBarView.h"
#import "SearchTopView.h"
#import "FilterView.h"
#import "FilterListView.h"
#import "WSDatePickerView.h"
#import "MyPlanCompletionCell.h"
#import "PlanTableView.h"
#import "PayPlanMo.h"
#import "DealPlanMo.h"
#import "PayPlanSearchViewCtrl.h"
#import "DealPlanSearchViewCtrl.h"
#import "CreatePayPlanViewCtrl.h"
#import "CreateDealPlanViewCtrl.h"
#import "MemberChooseMo.h"
#import "MyPlanCollectionTableView.h"
#import "DealPlanCollectionMo.h"
#import "UIButton+ShortCut.h"
#import "MyPlanListViewCtrl.h"

@interface MyPlanCompletionViewCtrl () <TopTabBarViewDelegate, SearchTopViewDelegate, FilterViewDelegate, FilterListViewDelegate, UIScrollViewDelegate, PlanTableViewDelegate, MyPlanCollectionTableViewDelegate>

@property (nonatomic, strong) TopTabBarView *topView;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) FilterListView *filterListView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FilterView *filterView1;
@property (nonatomic, strong) FilterView *filterView2;
@property (nonatomic, strong) MyPlanCollectionTableView *tableView1;
@property (nonatomic, strong) PlanTableView *tableView2;
@property (nonatomic, strong) NSMutableArray *arrData1;
@property (nonatomic, strong) NSMutableArray *arrData2;

@property (nonatomic, strong) NSMutableArray *selectTags1;  // 选中了那该个tag数组
@property (nonatomic, strong) NSMutableArray *selectTags2;  // 选中了那该个tag数组

@property (nonatomic, strong) NSMutableArray *arrSort11;    // 排序条件数组11
@property (nonatomic, strong) NSMutableArray *arrSort12;    // 排序条件数组12
@property (nonatomic, strong) NSMutableArray *arrSort21;    // 排序条件数组21
@property (nonatomic, strong) NSMutableArray *arrSort22;    // 排序条件数组22
@property (nonatomic, strong) NSMutableArray *arrFactory;
@property (nonatomic, assign) NSInteger factoryTag;

@property (nonatomic, assign) NSInteger page1;
@property (nonatomic, assign) NSInteger page2;

@property (nonatomic, strong) NSDate *dateTag1;
@property (nonatomic, strong) NSDate *dateTag2;

@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, copy) NSString *searchKey1;
@property (nonatomic, copy) NSString *searchKey2;

@property (nonatomic, strong) UIView *planTopView;
@property (nonatomic, strong) UIButton *btn0;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, assign) NSInteger planTopTag;

@end

@implementation MyPlanCompletionViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的计划完成情况";
    _typeStr = @"BATCHNUMBER";
    _searchKey1 = @"";
    _searchKey2 = @"";
    _page1 = 0;
    _page2 = 0;
    _planTopTag = 1;
    _factoryTag = 0;
    _dateTag1 = _dateTag2 = [NSDate date];
    [self setUI];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.topView selectIndex:_currentTag];
        [self topTabBarView:self.topView selectIndex:_currentTag];
    });
    [self getChooseList];
    [self currentSearchView];
    [self getAddress];
    [self getPlanSort];
    [self getFactoryPage];
    [self.btn0 imageRightWithTitleFix:8];
    [self.btn3 imageRightWithTitleFix:8];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.filterListView removeFromSuperview];
    self.filterListView = nil;
}

#pragma mark - network

- (void)getFactoryPage {
    [[JYUserApi sharedInstance] getFindFactoryPage:0 success:^(id responseObject) {
        self.arrFactory = [[NSMutableArray alloc] initWithArray:responseObject];
        [self.arrFactory insertObject:@"不限" atIndex:0];
    } failure:^(NSError *error) {
    }];
}

- (void)getChooseList {
    [[JYUserApi sharedInstance] getMaterialFindSpecSuccess:^(id responseObject) {
        self.arrSort11 = [[NSMutableArray alloc] initWithArray:responseObject[@"content"]];
        [self.arrSort11 insertObject:@"不限" atIndex:0];
    } failure:^(NSError *error) {
    }];
}

- (void)getAddress {
    [[JYUserApi sharedInstance] getConfigDicByName:@"product-place" success:^(id responseObject) {
        NSMutableArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
        for (DicMo *tmpMo in arr) {
            [self.arrSort12 addObject:STRING(tmpMo.value)];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)getPlanSort {
    [[JYUserApi sharedInstance] getGatheringPlanFindSort:nil success:^(id responseObject) {
        self.arrSort22 = [ChooseBeansMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
    } failure:^(NSError *error) {
    }];
}

// 要货计划
- (void)getDealPlanList:(NSInteger)page tableView:(PlanTableView *)tableView {
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSString *datestr = [[self currentDateTag] stringWithFormat:@"yyyy-MM"];
//    datestr = [datestr stringByAppendingString:@"-10"];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(10) forKey:@"size"];
    [param setObject:@"ASC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    [param setObject:@[STRING(_typeStr)] forKey:@"specialConditions"];
    
    NSMutableArray *rules = [NSMutableArray new];
    [rules addObject:@{@"field":@"date",
                       @"option":@"EQ",
                       @"values":@[datestr]}];
    [rules addObject:@{@"field":@"searchValue",
                       @"option":@"EQ",
                       @"values":@[_planTopTag == 1?_searchKey1:_searchKey2]}];
    if (_factoryTag != 0) {
        [rules addObject:@{@"field":@"factory",
                           @"option":@"EQ",
                           @"values":@[STRING(self.arrFactory[_factoryTag])]}];
    }
    
    [[JYUserApi sharedInstance] getCollectionSendTotal:param rules:rules success:^(id responseObject) {
//        [self.tableView1 headerFooterEndRefreshing];
//        [Utils dismissHUD];
//        NSError *error = nil;
//        self.arrData1 = [DealPlanCollectionMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
//        self.tableView1.arrData = self.arrData1;
//        [self.tableView1 reloadData];
//
//
        [self.tableView1 headerFooterEndRefreshing];
        [Utils dismissHUD];
        NSError *error = nil;
        NSMutableArray *tmpArr = [DealPlanCollectionMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData1 removeAllObjects];
            self.arrData1 = nil;
            self.arrData1 = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page1 = page;
                [self.arrData1 addObjectsFromArray:tmpArr];
            } else {
                [self.tableView1.mj_footer endRefreshingWithNoMoreData];
            }
        }
        self.tableView1.arrData = self.arrData1;
        [self.tableView1 reloadData];
    } failure:^(NSError *error) {
        [self.tableView1 headerFooterEndRefreshing];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}


// 收款计划
- (void)getPayPlanList:(NSInteger)page tableView:(PlanTableView *)tableView {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    
    NSMutableArray *rules = [[NSMutableArray alloc] init];
//    [rules addObject:@{@"field":@"operator.id",
//                       @"option":@"IN",
//                       @"values":@[@(TheUser.userMo.id)]}];
    
    if ([[self currentSelectTags][1] integerValue] != 0) {
        NSString *str = nil;
        if ([[self currentSelectTags][1] integerValue] == 1) {
            str = @"99.999%";
        } else {
            str = @"100%";
        }
        [rules addObject:@{@"field":@"actualShip",
                           @"option":@"EQ",
                           @"values":@[str]}];
    }
    
    if ([[self currentSelectTags][2] integerValue] != 0) {
        NSInteger index = [[self currentSelectTags][2] integerValue];
        ChooseBeansMo *tmpMo = [self currentArrSort2][index-1];
        [param setObject:STRING(tmpMo.option) forKey:@"direction"];
        [param setObject:STRING(tmpMo.value) forKey:@"property"];
    }
    
    [rules addObject:@{@"field":@"year",
                       @"option":@"EQ",
                       @"values":@[[[self currentDateTag] stringWithFormat:@"yyyy"]]}];
    
    [rules addObject:@{@"field":@"month",
                       @"option":@"EQ",
                       @"values":@[[[self currentDateTag] stringWithFormat:@"MM"]]}];
    
    [[JYUserApi sharedInstance] getGatheringPlanPageByParam:param page:page size:10 rules:rules specialConditions:nil success:^(id responseObject) {
        [tableView headerFooterEndRefreshing];
        [Utils dismissHUD];
        NSError *error = nil;
        NSMutableArray *tmpArr = [PayPlanMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData2 removeAllObjects];
            self.arrData2 = nil;
            self.arrData2 = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page2 = page;
                [self.arrData2 addObjectsFromArray:tmpArr];
            } else {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        tableView.arrData = self.arrData2;
        [tableView reloadData];
    } failure:^(NSError *error) {
        [tableView headerFooterEndRefreshing];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.filterView1];
    [self.scrollView addSubview:self.filterView2];
    [self.scrollView addSubview:self.tableView1];
    [self.scrollView addSubview:self.tableView2];
    [self.scrollView addSubview:self.planTopView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.top.equalTo(self.topView.mas_bottom).offset(8);
        make.height.equalTo(@28);
        make.right.equalTo(self.naviView.mas_right).offset(-15);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(8);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.filterView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@40);
    }];
    
    [self.planTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.filterView1);
    }];
    
    [self.filterView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.filterView1.mas_right);
        make.height.equalTo(self.filterView1);
        make.width.equalTo(self.filterView1);
        make.right.equalTo(self.scrollView);
    }];
    
    [self.tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView1.mas_bottom);
        make.left.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView).offset(-40);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView1.mas_bottom);
        make.left.equalTo(self.tableView1.mas_right);
        make.height.equalTo(self.scrollView).offset(-40);
        make.width.equalTo(self.scrollView);
        make.right.equalTo(self.scrollView);
    }];
}

#pragma mark - FilterViewDelegate

- (void)filterView:(FilterView *)filterView selectedIndex:(NSInteger)index selected:(BOOL)selected {
    if (selected) {
        if (index == 0) {
            // 时间
            if (_filterListView) {
                [_filterListView removeFromSuperview];
                _filterListView = nil;
            }
            
            __weak typeof(self) weakself = self;
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:[self currentDateTag] CompleteBlock:^(NSDate *selectDate) {
                NSString *date = [selectDate stringWithFormat:@"yyyy-M"];
                NSLog(@"选择的日期：%@",date);
                if (weakself.currentTag == 0) {
                    weakself.dateTag1 = selectDate;
                } else {
                    weakself.dateTag2 = selectDate;
                }
                [[weakself currentFilterView] updateTitle:date atIndex:0];
                [[weakself currentFilterView] resetNormalState];
                [[weakself currentTableView].mj_header beginRefreshing];
            }];
            
            datepicker.wsCancelBlock = ^{
                [[weakself currentFilterView] resetNormalState];
            };
            datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
            datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
            datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            [datepicker show];
        } else {
            // 规格 && 产地
            if (!_filterListView) {
                _filterListView = [[FilterListView alloc] initWithSourceType:0];
                _filterListView.delegate = self;
            }
            _filterListView.filterTag = index;
            CGFloat top = CGRectGetMinY(self.scrollView.frame)+49;
            [[UIApplication sharedApplication].keyWindow addSubview:_filterListView];
            [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.filterView1.mas_bottom);
                make.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            
            _filterListView.collectionView.selectTag = index == 1 ? [[self currentSelectTags][1] integerValue] : [[self currentSelectTags][2] integerValue];
            if (index == 1) {
                [_filterListView loadData:[self currentArrSort1]];
            } else if (index == 2) {
                if (_currentTag == 0) {
                    // 产地
                    NSMutableArray *arr = [[self currentArrSort2] mutableCopy];
                    [arr insertObject:@"不限" atIndex:0];
                    [_filterListView loadData:arr];
                } else {
                    // 排序
                    NSMutableArray *tmpArr = [NSMutableArray new];
                    [tmpArr addObject:@"不限"];
                    for (ChooseBeansMo *tmpMo in [self currentArrSort2]) {
                        [tmpArr addObject:tmpMo.key];
                    }
                    [_filterListView loadData:tmpArr];
                }
            }
//            [_filterListView loadData:index == 1 ? [self currentArrSort1] : [self currentArrSort2]];
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-top) bottomHeight:0];
        }
    } else {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
}

#pragma mark - FilterListViewDelegate

-(void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath filterTag:(NSInteger)filterTag {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    NSInteger index = indexPath.row;
    // 第二项
    if (filterTag == 1) {
        [[self currentSelectTags] replaceObjectAtIndex:filterTag withObject:@(index)];
        [[self currentFilterView] updateTitle:[self currentArrSort1][index] atIndex:filterTag];
    }
    // 第三项
    else if (filterTag == 2) {
        [[self currentSelectTags] replaceObjectAtIndex:filterTag withObject:@(index)];
        
        if (index == 0) {
            [[self currentFilterView] updateTitle:@"不限" atIndex:filterTag];
        } else {
            if (_currentTag == 0) {
                [[self currentFilterView] updateTitle:[self currentArrSort2][index-1] atIndex:filterTag];
            } else {
                ChooseBeansMo *tmpMo = self.arrSort22[index-1];
                [[self currentFilterView] updateTitle:[Utils showText:tmpMo.key length:4] atIndex:filterTag];
            }
        }
//        [[self currentFilterView] updateTitle:[self currentArrSort2][index] atIndex:filterTag];
    }
    // 工厂
    else if (filterTag == 10) {
        [self.btn3 setTitle:self.arrFactory[index] forState:UIControlStateNormal];
        [self.btn3 imageRightWithTitleFix:8];
        self.btn3.selected = NO;
        self.factoryTag = index;
    }
    [[self currentTableView].mj_header beginRefreshing];
    [[self currentFilterView] resetNormalState];
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [[self currentFilterView] resetNormalState];
    if (filterListView.filterTag == 10) {
        self.btn3.selected = NO;
    }
}

#pragma mark - TopTabBarViewDelegate

- (void)topTabBarView:(TopTabBarView *)topTabBarView selectIndex:(NSInteger)index {
    [self.searchView.searchTxtField resignFirstResponder];
    _currentTag = index;
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    if (_currentTag == 0) {
        if (_arrData1.count == 0) {
            [self.tableView1.mj_header beginRefreshing];
        } else {
            _page1 = 0;
            [self getDealPlanList:_page1 tableView:self.tableView1];
        }
    } else if (_currentTag == 1 && _arrData2.count == 0) {
        if (_arrData2.count == 0) {
            [self.tableView2.mj_header beginRefreshing];
        } else {
            _page2 = 0;
            [self getPayPlanList:_page2 tableView:self.tableView2];
        }
    }
    if (_currentTag == 1) {
        [self currentSearchView];
        self.searchView.searchTxtField.text = @"";
    } else {
        self.searchView.searchTxtField.text = _planTopTag==1 ? _searchKey1:_searchKey2;
        self.searchView.searchTxtField.placeholder = _planTopTag==1 ? @"请输入批号":@"请输入客户";
    }
    [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
    self.btn3.selected = NO;
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    if (_currentTag == 0) {
        self.btn3.selected = NO;
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    } else {
        [self.searchView.searchTxtField resignFirstResponder];
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        
        [[self currentFilterView] resetNormalState];
        [self.searchView.searchTxtField resignFirstResponder];
        [self pushToSearchVC:NO];
    }
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    if (_currentTag == 0) {
        if (_planTopTag == 1) {
            _searchKey1 = textField.text;
        } else if (_planTopTag == 2) {
            _searchKey2 = textField.text;
        }
    }
    [self.tableView1.mj_header beginRefreshing];
    [self.searchView.searchTxtField resignFirstResponder];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:YES];
}

- (void)pushToSearchVC:(BOOL)showIFly {
    SearchStyle *searchStyle = [[SearchStyle alloc] init];
    searchStyle.type = [self currentSearchType];
    BaseSearchViewCtrl *vc = [self currentSearchVC];
    vc.showIFly = showIFly;
    vc.searchStyle = searchStyle;
    BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - PlanTableViewDelegate

- (void)planTableView:(PlanTableView *)planTableView didSelectIndexPath:(NSIndexPath *)indexPath {
    if (_currentTag == 0) {
        CreateDealPlanViewCtrl *vc = [[CreateDealPlanViewCtrl alloc] init];
        DealPlanMo *dealMo = self.arrData1[indexPath.row];
        vc.mo = dealMo;
        __weak typeof(self) weakself = self;
        vc.createSuccess = ^{
            [weakself.tableView1.mj_header beginRefreshing];
        };
        TheCustomer.customerMo = [[CustomerMo alloc] initWithDictionary:dealMo.member error:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_currentTag == 1) {
        CreatePayPlanViewCtrl *vc = [[CreatePayPlanViewCtrl alloc] init];
        PayPlanMo *payMo = self.arrData2[indexPath.row];
        vc.mo = payMo;
        TheCustomer.customerMo = [[CustomerMo alloc] initWithDictionary:payMo.member error:nil];
        __weak typeof(self) weakself = self;
        vc.createSuccess = ^{
            [weakself.tableView2.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 如果没有数据动态刷新，有数据静态刷新
    if (scrollView == _scrollView) {
        _currentTag = _scrollView.contentOffset.x / SCREEN_WIDTH;
        if (_currentTag == 0) {
            if (_arrData1.count == 0) {
                [self.tableView1.mj_header beginRefreshing];
            } else {
                _page1 = 0;
                [self getDealPlanList:_page1 tableView:self.tableView1];
            }
        } else if (_currentTag == 1 && _arrData2.count == 0) {
            if (_arrData2.count == 0) {
                [self.tableView2.mj_header beginRefreshing];
            } else {
                _page2 = 0;
                [self getPayPlanList:_page2 tableView:self.tableView2];
            }
        }
        [self.topView selectIndex: _scrollView.contentOffset.x / SCREEN_WIDTH];
        self.btn3.selected = NO;
    }
}

#pragma mark - MyPlanCollectionTableViewDelegate

- (void)myPlanCollectionTableView:(MyPlanCollectionTableView *)myPlanCollectionTableView didSelectIndexPath:(NSIndexPath *)indexPath {
    DealPlanCollectionMo *mo = self.arrData1[indexPath.row];
    MyPlanListViewCtrl *vc = [[MyPlanListViewCtrl alloc] init];
    vc.model = mo;
    vc.currentTag = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    if (_currentTag == 0) {
        _page1 = 0;
        [self getDealPlanList:_page1 tableView:self.tableView1];
        [self.searchView.searchTxtField resignFirstResponder];
    } else {
        _page2 = 0;
        [self getPayPlanList:_page2 tableView:self.tableView2];
    }
}

- (void)tableViewFooterRefreshAction {
    if (_currentTag == 0) {
        [self getDealPlanList:_page1+1 tableView:self.tableView1];
        [self.searchView.searchTxtField resignFirstResponder];
    } else {
        [self getPayPlanList:_page2+1 tableView:self.tableView2];
    }
}

- (void)planTopViewClick:(UIButton *)sender {
    NSInteger tag = sender.tag - 20;
    [self.searchView.searchTxtField resignFirstResponder];
    if (tag == 0) {
        if (_filterListView) {
            [_filterListView removeFromSuperview];
            _filterListView = nil;
        }
        self.btn3.selected = NO;
        __weak typeof(self) weakself = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:[self currentDateTag] CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:@"yyyy-M"];
            NSLog(@"选择的日期：%@",date);
            if (weakself.currentTag == 0) {
                weakself.dateTag1 = selectDate;
            } else {
                weakself.dateTag2 = selectDate;
            }
            [weakself.btn0 setTitle:date forState:UIControlStateNormal];
            [weakself.btn0 imageRightWithTitleFix:8];
            [weakself.tableView1.mj_header beginRefreshing];
        }];
        
        datepicker.wsCancelBlock = ^{
            [[weakself currentFilterView] resetNormalState];
        };
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    } else if (tag == 3) {
        _btn3.selected = !_btn3.selected;
        if (_btn3.selected) {
            // 工厂
            if (!_filterListView) {
                _filterListView = [[FilterListView alloc] initWithSourceType:0];
                _filterListView.delegate = self;
            }
            _filterListView.filterTag = 10;
            CGFloat top = CGRectGetMinY(self.scrollView.frame)+49;
            [[UIApplication sharedApplication].keyWindow addSubview:_filterListView];
            [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.planTopView.mas_bottom);
                make.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            
            _filterListView.collectionView.selectTag = self.factoryTag;
            [_filterListView loadData:self.arrFactory];
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-top) bottomHeight:0];
        } else {
            if (_filterListView) {
                [_filterListView removeFromSuperview];
                _filterListView = nil;
            }
        }
    } else {
        if (_filterListView) {
            [_filterListView removeFromSuperview];
            _filterListView = nil;
        }
        self.btn3.selected = NO;
        if (_planTopTag == tag) {
            return;
        }
        _planTopTag = tag;
        if (_currentTag == 0) {
            // 批号 && 客户
            self.btn1.selected = tag == 1 ? YES : NO;
            self.btn2.selected = tag == 2 ? YES : NO;
            self.typeStr = tag == 1 ? @"BATCHNUMBER" : @"MEMBER";
            self.searchView.searchTxtField.text = tag==1 ? _searchKey1:_searchKey2;
            self.searchView.searchTxtField.placeholder = tag==1 ? @"请输入批号":@"请输入客户";
            [self.tableView1.mj_header beginRefreshing];
        }
    }
}

#pragma mark - private

- (PlanTableView *)currentTableView {
    return (_currentTag == 0) ? self.tableView1 : self.tableView2;
}

- (NSDate *)currentDateTag {
    return (_currentTag == 0) ? self.dateTag1 : self.dateTag2;
}

- (NSMutableArray *)currentSelectTags {
    return (_currentTag == 0) ? self.selectTags1 : self.selectTags2;
}

- (FilterView *)currentFilterView {
    return (_currentTag == 0) ? self.filterView1 : self.filterView2;
}

- (NSMutableArray *)currentArrSort1 {
    return (_currentTag == 0) ? self.arrSort11 : self.arrSort21;
}

- (NSMutableArray *)currentArrSort2 {
    return (_currentTag == 0) ? self.arrSort12 : self.arrSort22;
}

- (void)currentSearchView {
    self.searchView.searchTxtField.placeholder = [SearchStyle placeholdString:[self currentSearchType]];
}

- (SearchType)currentSearchType {
    return (_currentTag == 0) ? SearchCollectionDeal : SearchPayPlan;
}

- (BaseSearchViewCtrl *)currentSearchVC {
    DealPlanSearchViewCtrl *vc = [DealPlanSearchViewCtrl new];
    vc.fromCollection = YES;
    return (_currentTag == 0) ? vc : [PayPlanSearchViewCtrl new];
}

#pragma mark - setter getter

- (TopTabBarView *)topView {
    if (!_topView) {
        _topView = [[TopTabBarView alloc] initWithItems:@[@"发货计划汇总", @"收款计划"] colorSelect:COLOR_C1 colorNormal:COLOR_B1];
        _topView.delegate = self;
        _topView.showLine = YES;
        _topView.bgColor = COLOR_B4;
        _topView.lineWidth = SCREEN_WIDTH / 2.0;
        _topView.labFont = FONT_F15;
    }
    return _topView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.contentSize = CGSizeZero;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (MyPlanCollectionTableView *)tableView1 {
    if (!_tableView1) {
        _tableView1 = [[MyPlanCollectionTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView1.backgroundColor = COLOR_B0;
        _tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        _tableView1.myPlanCollectionTableViewDelegate = self;
    }
    return _tableView1;
}

- (PlanTableView *)tableView2 {
    if (!_tableView2) {
        _tableView2 = [[PlanTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView2.backgroundColor = COLOR_B0;
        _tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        _tableView2.planDelegate = self;
    }
    return _tableView2;
}

- (UIView *)planTopView {
    if (!_planTopView) {
        _planTopView = [[UIView alloc] init];
        _planTopView.backgroundColor = COLOR_B4;
        [_planTopView addSubview:self.btn0];
        [_planTopView addSubview:self.btn1];
        [_planTopView addSubview:self.btn2];
        [_planTopView addSubview:self.btn3];
        
        _btn0.tag = 20;
        _btn1.tag = 21;
        _btn2.tag = 22;
        _btn3.tag = 23;
        
        [_btn0 addTarget:self action:@selector(planTopViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn1 addTarget:self action:@selector(planTopViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn2 addTarget:self action:@selector(planTopViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn3 addTarget:self action:@selector(planTopViewClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _btn1.selected = YES;
        
        [_btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_planTopView);
            make.left.equalTo(_planTopView);
            make.height.equalTo(_planTopView);
        }];
        
        [_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btn0);
            make.height.width.equalTo(_btn0);
            make.left.equalTo(_btn0.mas_right);
        }];
        
        [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btn0);
            make.height.width.equalTo(_btn0);
            make.left.equalTo(_btn3.mas_right);
        }];
        
        [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btn0);
            make.height.width.equalTo(_btn0);
            make.left.equalTo(_btn1.mas_right);
            make.right.equalTo(_planTopView);
        }];
        
        UIView *lineView = [Utils getLineView];
        [_planTopView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_planTopView);
            make.height.equalTo(@0.5);
        }];
    }
    return _planTopView;
}

- (UIButton *)btn0 {
    if (!_btn0) {
        _btn0 = [[UIButton alloc] init];
        _btn0.titleLabel.font = FONT_F14;
        [_btn0 setTitle:[_dateTag1 stringWithFormat:@"yyyy-M"] forState:UIControlStateNormal];
        [_btn0 setImage:[UIImage imageNamed:@"client_down_n"] forState:UIControlStateNormal];
        [_btn0 setImage:[UIImage imageNamed:@"drop_down_s"] forState:UIControlStateSelected];
        [_btn0 setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btn0 setTitleColor:COLOR_C1 forState:UIControlStateSelected];
    }
    return _btn0;
}

- (UIButton *)btn3 {
    if (!_btn3) {
        _btn3 = [[UIButton alloc] init];
        _btn3.titleLabel.font = FONT_F14;
        [_btn3 setTitle:@"工厂" forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"client_down_n"] forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"drop_down_s"] forState:UIControlStateSelected];
        [_btn3 setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btn3 setTitleColor:COLOR_C1 forState:UIControlStateSelected];
    }
    return _btn3;
}

- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [[UIButton alloc] init];
        _btn1.titleLabel.font = FONT_F14;
        [_btn1 setTitle:@"批号" forState:UIControlStateNormal];
        [_btn1 setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btn1 setTitleColor:COLOR_C1 forState:UIControlStateSelected];
    }
    return _btn1;
}

- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = [[UIButton alloc] init];
        _btn2.titleLabel.font = FONT_F14;
        [_btn2 setTitle:@"客户" forState:UIControlStateNormal];
        [_btn2 setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btn2 setTitleColor:COLOR_C1 forState:UIControlStateSelected];
    }
    return _btn2;
}

- (FilterView *)filterView1 {
    if (!_filterView1) {
        _filterView1 = [[FilterView alloc] initWithTitles:@[[_dateTag1 stringWithFormat:@"yyyy-M"], @"批号", @"客户"] imgsNormal:@[@"client_down_n", @"", @""] imgsSelected:@[@"drop_down_s", @"", @""]];
        _filterView1.backgroundColor = COLOR_B4;
        _filterView1.delegate = self;
        _filterView1.hidden = YES;
    }
    return _filterView1;
}

- (FilterView *)filterView2 {
    if (!_filterView2) {
        _filterView2 = [[FilterView alloc] initWithTitles:@[[_dateTag2 stringWithFormat:@"yyyy-M"], @"完成情况", @"排序"] imgsNormal:@[@"client_down_n", @"client_down_n", @"client_down_n"] imgsSelected:@[@"drop_down_s", @"drop_down_s", @"drop_down_s"]];
        _filterView2.backgroundColor = COLOR_B4;
        _filterView2.delegate = self;
    }
    return _filterView2;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = @"请输入批号";
    }
    return _searchView;
}

- (NSMutableArray *)arrData1 {
    if (!_arrData1) {
        _arrData1 = [NSMutableArray new];
    }
    return _arrData1;
}

- (NSMutableArray *)arrData2 {
    if (!_arrData2) {
        _arrData2 = [NSMutableArray new];
    }
    return _arrData2;
}

- (NSMutableArray *)arrSort11 {
    if (!_arrSort11) {
        _arrSort11 = [NSMutableArray new];
    }
    return _arrSort11;
}

- (NSMutableArray *)arrSort12 {
    if (!_arrSort12) {
        _arrSort12 = [NSMutableArray new];
    }
    return _arrSort12;
}

- (NSMutableArray *)arrSort21 {
    if (!_arrSort21) {
        _arrSort21 = [NSMutableArray new];
        [_arrSort21 addObject:@"不限"];
        [_arrSort21 addObject:@"未完成"];
        [_arrSort21 addObject:@"已完成"];
    }
    return _arrSort21;
}

- (NSMutableArray *)arrFactory {
    if (!_arrFactory) {
        _arrFactory = [NSMutableArray new];
    }
    return _arrFactory;
}

- (NSMutableArray *)arrSort22 {
    if (!_arrSort22) {
        _arrSort22 = [NSMutableArray new];
    }
    return _arrSort22;
}

- (NSMutableArray *)selectTags1 {
    if (!_selectTags1) {
        _selectTags1 = [NSMutableArray new];
        [_selectTags1 addObject:@(0)];
        [_selectTags1 addObject:@(0)];
        [_selectTags1 addObject:@(0)];
    }
    return _selectTags1;
}

- (NSMutableArray *)selectTags2 {
    if (!_selectTags2) {
        _selectTags2 = [NSMutableArray new];
        [_selectTags2 addObject:@(0)];
        [_selectTags2 addObject:@(0)];
        [_selectTags2 addObject:@(0)];
    }
    return _selectTags2;
}

@end
