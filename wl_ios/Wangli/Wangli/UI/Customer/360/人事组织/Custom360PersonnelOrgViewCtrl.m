//
//  Custom360PersonnelOrgViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "Custom360PersonnelOrgViewCtrl.h"
#import "SwitchView.h"
#import "FilterListView.h"
#import "UIButton+ShortCut.h"
#import "EmptyView.h"
#import "PersonnelPageViewCtrl.h"
#import "LinkManOfficeMo.h"
#import "LinkManOfficeViewCtrl.h"
#import "CreatePersonnelDemandViewCtrl.h"
#import "NewContactViewCtrl.h"
#import "PersonnelCreateViewCtrl.h"
#import "CreateIntelligenceViewCtrl.h"

@interface Custom360PersonnelOrgViewCtrl () <SwitchViewDelegate, FilterListViewDelegate>
{
    EmptyView *_emptyView;
}

@property (nonatomic, strong) PersonnelPageViewCtrl *pageViewCtrl;
@property (nonatomic, strong) UIView *leftBaseView;
@property (nonatomic, assign) BOOL initTableView;
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) FilterListView *filterListView;   // 列表选择

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSArray *arrTitles;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) NSInteger sortTag1;
@property (nonatomic, assign) NSInteger sortTag2;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray <LinkManOfficeMo *> *linkManOfficeMos;
@property (nonatomic, strong) LinkManOfficeMo *linkMo;
@property (nonatomic, assign) long long officeId;

@property (nonatomic, strong) DicMo *rightDicDefault;
@property (nonatomic, strong) DicMo *rightDic;
@property (nonatomic, strong) NSMutableArray *rightTitles;

@end

@implementation Custom360PersonnelOrgViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _initTableView = NO;
    _currentTag = 0;
    _sortTag1 = 0;
    _sortTag2 = 0;
    _officeId = 0;
    _page = 0;
    [self getDefaultDicList];
    [_switchView selectIndex:_currentTag];
    [_switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
    [self refreshView];
}
- (void)getDefaultDicList {
    [[JYUserApi sharedInstance] getDicListByName:@"intelligence_type" remark:self.rightDicDefault.remark param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.rightTitles = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self.rightTitles insertObject:self.rightDicDefault atIndex:0];
        NSLog(@"%@", error);
    } failure:^(NSError *error) {
    }];
    
    [[JYUserApi sharedInstance] getLinkManTotalCount:TheCustomer.customerMo.id param:nil success:^(id responseObject) {
        TheCustomer.customerMo.linkManTotalCount = [responseObject[@"count"] integerValue];
    } failure:^(NSError *error) {
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

- (void)dealloc {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
}

- (void)refreshView {
    NSLog(@"选择了部门： %@", self.linkMo.name);
    [self.switchView updateTitle:STRING(self.linkMo.name) index:0 switchState:SwitchStateSelectFirst];
    [self.pageViewCtrl getNewOfficeId:self.officeId page:0];
}

- (void)setUI {
    [self.view addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    [self initLeftView];
}

- (void)initLeftView {
    [self.view addSubview:self.leftBaseView];
    [self.leftBaseView addSubview:self.pageViewCtrl.view];
    [self.leftBaseView addSubview:self.bottomView];
    
    [self.leftBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.leftBaseView);
        make.height.equalTo(@(KMagrinBottom+44));
    }];
    
    [self.pageViewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftBaseView);
        make.left.right.equalTo(self.leftBaseView);
        make.width.equalTo(self.leftBaseView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)initRightView {
    _initTableView = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.headerRefresh = YES;
    self.footerRefresh = YES;
    [self.tableView.mj_header beginRefreshing];
    [self addBtnNew];
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"RiskFollowCell";
    RiskFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[RiskFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == self.arrData.count - 1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    [cell loadDataWithFeedMo:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    RiskFollowMo *mo = self.arrFollow[indexPath.row];
//    if (mo.url.length != 0) {
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@token=%@&officeName=%@", mo.url, [mo.url containsString:@"?"]?@"&":@"?", [Utils token], [Utils officeName]];
//        WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
//        vc.urlStr = urlStr;
//        vc.titleStr = mo.title;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - SwitchViewDelegate

- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
    
    if (index == 1 && !_initTableView) [self initRightView];
    
    // 相同按钮
    if (_currentTag == index) {
        // 重置原先的
        if (_currentTag == 0) {
            [switchView updateTitle:@"" index:1 switchState:SwitchStateNormal];
        } else if (_currentTag == 1) {
            [switchView updateTitle:@"" index:0 switchState:SwitchStateNormal];
        }
        // 更新当前的
        if (state == SwitchStateSelectFirst) {
            [switchView updateTitle:@"" index:index switchState:SwitchStateSelectSecond];
            
            if (_currentTag == 0) {
                LinkManOfficeViewCtrl *vc = [[LinkManOfficeViewCtrl alloc] init];
                BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
                __weak typeof(self) weakself = self;
                vc.updateSuccess = ^(LinkManOfficeMo *tmpMo) {
                    __weak typeof(self) strongself = weakself;
                    strongself.linkMo = tmpMo;
                    strongself.officeId = tmpMo.id;
                    [strongself refreshView];
                };
                [[Utils topViewController].navigationController presentViewController:navi animated:YES completion:^{
                    [switchView updateTitle:@"" index:index switchState:SwitchStateSelectFirst];
                }];
                return;
            }
            
            if (!_filterListView) {
                _filterListView = [[FilterListView alloc] initWithSourceType:0];
                _filterListView.delegate = self;
            }
            
            [[UIApplication sharedApplication].keyWindow addSubview:_filterListView];
            [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo([UIApplication sharedApplication].keyWindow).offset(44+STATUS_BAR_HEIGHT+49);
                make.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            
            NSMutableArray *arrTitles = [NSMutableArray new];
            if (_currentTag == 0) {
                _filterListView.collectionView.selectTag = _sortTag1;
            } else {
                for (DicMo *tmpDic in self.rightTitles) {
                    [arrTitles addObject:STRING(tmpDic.value)];
                }
                _filterListView.collectionView.selectTag = _sortTag2;
            }
            [_filterListView loadData:arrTitles];
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-44-STATUS_BAR_HEIGHT - 49) bottomHeight:0];
        } else if (state == SwitchStateSelectSecond) {
            [switchView updateTitle:@"" index:index switchState:SwitchStateSelectFirst];
            
            [_filterListView removeFromSuperview];
            _filterListView = nil;
        }
    } else {
        // 不同按钮 切换操作
        _currentTag = index;
        [switchView updateTitle:@"" index:index switchState:SwitchStateSelectFirst];
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        self.leftBaseView.hidden = _currentTag == 0 ? NO : YES;
        if (_initTableView) self.tableView.hidden = _currentTag == 1 ? NO : YES;
        if (_initTableView) self.btnNew.hidden = _currentTag == 1 ? NO : YES;
    }
}


#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    DicMo *tmpDic = nil;
    if (_currentTag == 0) {
//        _sortTag1 = indexPath.row;
//        self.leftDic = self.leftTitles[_sortTag1];
//        tmpDic = self.leftDic;
    } else if (_currentTag == 1) {
        _sortTag2 = indexPath.row;
        self.rightDic = self.rightTitles[_sortTag2];
        tmpDic = self.rightDic;
        [self.tableView.mj_header beginRefreshing];
    }
    [self.switchView updateTitle:STRING(tmpDic.value) index:_currentTag switchState:SwitchStateSelectFirst];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

#pragma mark - network

- (void)tableViewHeaderRefreshAction {
    self.page = 0;
    [self getDataByPage:self.page];
}

- (void)tableViewFooterRefreshAction {
    [self getDataByPage:self.page+1];
}

- (void)getDataByPage:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"10" forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    [param setObject:@(page) forKey:@"number"];
    
    NSMutableArray *arrRules = [NSMutableArray new];
    //    [arrRules addObject:@{@"field":@"memberId",
    //                          @"option":@"EQ",
    //                          @"values":@[@(TheCustomer.customerMo.id)]}];
    
    [arrRules addObject:@{@"field":@"bigCategory",
                          @"option":@"EQ",
                          @"values":@[STRING(self.rightDic.remark)]}];
    
    if (![self.rightDic.key isEqualToString:@"all"]) {
        [arrRules addObject:@{@"field":@"childCategoryId",
                              @"option":@"EQ",
                              @"values":@[self.rightDic.id]}];
    }
    [param setObject:arrRules forKey:@"rules"];
    
    [[JYUserApi sharedInstance] getFeedLowPageTrendParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TrendsFeedMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrData removeAllObjects];
            _arrData = nil;
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - event

- (void)addPersonClick:(UIButton *)sender {
    PersonnelCreateViewCtrl *vc = [[PersonnelCreateViewCtrl alloc] init];
    vc.from360 = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addDemandClick:(UIButton *)sender {
    CreatePersonnelDemandViewCtrl *vc = [[CreatePersonnelDemandViewCtrl alloc] init];
    vc.fromTab = NO;
    vc.contactMo = self.pageViewCtrl.currentMo;
    vc.title = @"新建需求";
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself.pageViewCtrl.pageScrollView.mainTableView.mj_header beginRefreshing];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnNewClick:(UIButton *)sender {
    CreateIntelligenceViewCtrl *vc = [[CreateIntelligenceViewCtrl alloc] init];
    vc.title = @"新情报";
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy

- (UIView *)leftBaseView {
    if (!_leftBaseView) {
        _leftBaseView = [UIView new];
    }
    return _leftBaseView;
}

- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithTitles:@[STRING(TheCustomer.customerMo.abbreviation)]
                                               imgNormal:@[@"client_down_n"]
                                               imgSelect:@[@"drop_down_s"]];
//        _switchView = [[SwitchView alloc] initWithTitles:@[STRING(TheCustomer.customerMo.abbreviation), @"人事情报"]
//                                               imgNormal:@[@"client_down_n", @"client_down_n"]
//                                               imgSelect:@[@"drop_down_s", @"drop_down_s"]];
        _switchView.delegate = self;
    }
    return _switchView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = COLOR_B4;
        
        UIButton *btn1 = [[UIButton alloc] init];
        [btn1 setTitle:@"新建关键人" forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"360_contacts"] forState:UIControlStateNormal];
        [btn1 setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(addPersonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 imageLeftWithTitleFix:8];
        [_bottomView addSubview:btn1];
        
        UIButton *btn2 = [[UIButton alloc] init];
        [btn2 setTitle:@"新建需求" forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"360_basic_information"] forState:UIControlStateNormal];
        [btn2 setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(addDemandClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 imageLeftWithTitleFix:8];
        
        UIView *topLineView = [Utils getLineView];
        UIView *midLineView = [Utils getLineView];
        
        [_bottomView addSubview:btn1];
        [_bottomView addSubview:btn2];
        [_bottomView addSubview:topLineView];
        [_bottomView addSubview:midLineView];
        
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_bottomView);
            make.height.equalTo(@0.5);
        }];
        
        [midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomView);
            make.centerY.equalTo(_bottomView.mas_top).offset(22);
            make.width.equalTo(@0.5);
            make.height.equalTo(@15.0);
        }];
        
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLineView.mas_bottom);
            make.left.equalTo(_bottomView);
            make.right.equalTo(midLineView.mas_left);
            make.height.equalTo(@44.0);
        }];
        
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLineView.mas_bottom);
            make.right.equalTo(_bottomView);
            make.left.equalTo(midLineView.mas_right);
            make.height.equalTo(@44.0);
        }];
    }
    return _bottomView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [[NSMutableArray alloc] init];
    return _arrData;
}

- (PersonnelPageViewCtrl *)pageViewCtrl {
    if (!_pageViewCtrl) {
        _pageViewCtrl = [[PersonnelPageViewCtrl alloc] init];
    }
    return _pageViewCtrl;
}

- (DicMo *)rightDic {
    if (!_rightDic) {
        _rightDic = [[DicMo alloc] init];
        _rightDic.id = @"0";
        _rightDic.value = @"所有";
        _rightDic.key = @"all";
        _rightDic.remark = @"personnel_type";
    }
    return _rightDic;
}

- (DicMo *)rightDicDefault {
    if (!_rightDicDefault) {
        _rightDicDefault = [[DicMo alloc] init];
        _rightDicDefault.id = @"0";
        _rightDicDefault.value = @"所有";
        _rightDicDefault.key = @"all";
        _rightDicDefault.remark = @"personnel_type";
    }
    return _rightDicDefault;
}

- (NSMutableArray *)rightTitles {
    if (!_rightTitles) _rightTitles = [NSMutableArray new];
    return _rightTitles;
}

@end
