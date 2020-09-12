//
//  TabCustomerViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/3/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TabCustomerViewController.h"
#import "CustomerCardViewCtrl.h"
#import "FilterView.h"
#import "TabCustomerCell.h"
#import "FilterListView.h"
#import "FilterViewCtrl.h"
#import "SearchTopView.h"
#import "PopMenuView.h"
#import "ScanTool.h"
#import "QMYViewController.h"
#import "CustomerMo.h"
#import "MemberChooseMo.h"
#import "RiskListMo.h"
#import "ChatSearchViewCtrl.h"
#import "ChangeOwnerViewCtrl.h"
#import "EmptyView.h"
#import "MainTabBarViewController.h"
#import "ScanTool.h"
#import "JYClick.h"
#import "MemberCardViewCtrl.h"

@interface TabCustomerViewController () <UITableViewDelegate, UITableViewDataSource, FilterViewDelegate, FilterViewCtrlDelegate, FilterListViewDelegate, SearchTopViewDelegate>
{
    EmptyView *_emptyView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) SearchTopView *searchView;

//筛选
@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) FilterListView *filterListView;   // 列表选择
@property (nonatomic, strong) FilterViewCtrl *filterViewCtrl;

@property (nonatomic, strong) NSMutableArray *arrSort1;
@property (nonatomic, strong) NSMutableArray *arrSort2;
@property (nonatomic, assign) NSInteger sortTag1;
@property (nonatomic, assign) NSInteger sortTag2;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) MemberChooseMo *sortMo1;
@property (nonatomic, strong) MemberChooseMo *sortMo2;

@property (nonatomic, assign) BOOL isQuick;     // YES:快速筛选，NO:手工筛选
@property (nonatomic, strong) NSMutableArray *arrData;      // 客户列表
@property (nonatomic, strong) NSMutableArray *indexPathArr; // 选中的标记
@property (nonatomic, strong) NSMutableArray *rules;        // 规则
@property (nonatomic, strong) NSMutableArray *arrMutiData;  // 手动筛选
@property (nonatomic, copy) NSString *specialConditions;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSIndexPath *touchIndexPath;

@end

@implementation TabCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sortTag1 = _sortTag2 = 0;
    _page = 0;
    _isQuick = YES;
    TheCustomer.page = _page;
    [self setUI];
    [self.tableView.mj_header beginRefreshing];
    [self getMemberChoose];
    [self riskWarnStatistics];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewHeaderRefreshAction) name:NOTIFI_MEMBER_CHANGE_OPERATOR object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView resetNormalState];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:NO];
}

- (void)setUI {
    
    for (UIView *subView in self.naviView.subviews) {
        [subView removeFromSuperview];
    }
    
    [self.naviView addSubview:self.searchView];
    [self.naviView addSubview:self.btnMore];
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.tableView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.bottom.equalTo(self.naviView).offset(-8);
        make.height.equalTo(@28);
        make.right.equalTo(self.btnMore.mas_left);
    }];
    
    [self.btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.right.equalTo(self.naviView);
        make.height.width.equalTo(@40);
    }];
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@48);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - network

- (void)getList:(NSInteger)page {
    [JYUserApi releaseCustomerParamsCache];
    NSMutableArray *arrSpecialConditions = [NSMutableArray new];
    if (_isQuick) {
        // 快速筛选
        if(_sortMo2) {
            [arrSpecialConditions addObject:STRING(_sortMo2.memberFeild)];
        }
        [_rules removeAllObjects];
        _rules = nil;
    } else {
        // 手工筛选
        NSDictionary *dic = [Utils specialConditions:self.indexPathArr];
        NSArray *arrKeys = [dic allKeys];
        [_rules removeAllObjects];
        _rules = nil;
        for (int i = 0; i < arrKeys.count; i++) {
            NSString *key = arrKeys[i];
            NSArray *valueArr = dic[key];
            
//            if ([key isEqualToString:@"1"]) {
//                continue;
//            }
//
            NSInteger section = [key integerValue];
            MemberChooseMo *tmpChooseMo = self.arrMutiData[section];
            NSArray *tmpBeansArr = [ChooseBeansMo arrayOfModelsFromDictionaries:tmpChooseMo.chooseBeans error:nil];
            
            if (tmpChooseMo.special) {
                for (NSIndexPath *indexPath  in valueArr) {
                    ChooseBeansMo *tmpBeansMo = tmpBeansArr[indexPath.row];
                    [arrSpecialConditions addObject:STRING(tmpBeansMo.value)];
                    
                    [self clickFeild:tmpChooseMo.memberFeild special:tmpChooseMo.special name:tmpChooseMo.name key:tmpBeansMo.key value:tmpBeansMo.value];
                }
            } else {
                NSMutableArray *tmpArr = [NSMutableArray new];
                
                NSString *option = nil;
                for (NSIndexPath *indexPath  in valueArr) {
                    ChooseBeansMo *tmpBeansMo = tmpBeansArr[indexPath.row];
                    option = tmpBeansMo.option;
                    [tmpArr addObject:STRING(tmpBeansMo.value)];
                    
                    [self clickFeild:tmpChooseMo.memberFeild special:tmpChooseMo.special name:tmpChooseMo.name key:tmpBeansMo.key value:tmpBeansMo.value];
                }
                
                NSDictionary *dic = @{@"field":STRING(tmpChooseMo.memberFeild),
                                      @"option":STRING(option),
                                      @"values":STRING(tmpArr)};
                [self.rules addObject:dic];
            }
        }
        
//        if ([dic objectForKey:@"1"]) {
//            MemberChooseMo *tmpChooseMo = self.arrMutiData[1];
//            NSArray *tmpBeansArr = [ChooseBeansMo arrayOfModelsFromDictionaries:tmpChooseMo.chooseBeans error:nil];
//            for (NSIndexPath *indexPath in dic[@"1"]) {
//                ChooseBeansMo *tmpBeansMo = tmpBeansArr[indexPath.row];
//                [arrSpecialConditions addObject:STRING(tmpBeansMo.value)];
//            }
//        }
    }
    
    [[JYUserApi sharedInstance] getCustomerListDirection:nil property:nil size:10 rules:self.rules page:page specialDirection:_sortMo1.memberFeild specialConditions:arrSpecialConditions success:^(id responseObject) {
        [Utils dismissHUD];
        [self tableViewEndRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [CustomerMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        TheCustomer.page = _page;
        [self.tableView reloadData];
        [self.tableView scrollsToTop];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self tableViewEndRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)clickFeild:(NSString *)feild special:(BOOL)special name:(NSString *)name key:(NSString *)key value:(NSString *)value {
    [[JYClick shareInstance] clickFeild:feild special:special name:name key:key value:value];
}

- (void)getMemberChoose {

    [[JYUserApi sharedInstance] getMemberChooseSuccess:^(id responseObject) {
        
        NSArray *arrData = responseObject[@"content"];
        NSError *error = nil;
        // 手动排序
        NSDictionary *dic = arrData[0];
        self.arrMutiData = [MemberChooseMo arrayOfModelsFromDictionaries:dic[@"memberChooseBeans"] error:&error];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic[@"memberChooseBeans"]];
        if (data) [[NSUserDefaults standardUserDefaults] setObject:data forKey:MEMBER_CHOOSE];
        
        //        [Utils commonDeleteTost:[NSString stringWithFormat:@"error = %@", error] msg:[NSString stringWithFormat:@"data = %@", self.arrMutiData] cancelTitle:@"确定" confirmTitle:nil confirm:nil cancel:nil];
        
        // 快速排序
        NSDictionary *dic1 = arrData[1];
        self.arrSort2 = [MemberChooseMo arrayOfModelsFromDictionaries:dic1[@"memberChooseBeans"] error:nil];
        NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:dic1[@"memberChooseBeans"]];
        if (data1) [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:MEMBER_CHOOSE_QUICK];
        
        // 排序
        NSDictionary *dic2 = arrData[2];
        self.arrSort1 = [MemberChooseMo arrayOfModelsFromDictionaries:dic2[@"memberChooseBeans"] error:nil];
        NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:dic2[@"memberChooseBeans"]];
        if (data2) [[NSUserDefaults standardUserDefaults] setObject:data2 forKey:MEMBER_CHOOSE_SORT];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSError *error) {
    }];
}

// 预获取风险预警列表
- (void)riskWarnStatistics {
    [[JYUserApi sharedInstance] riskWarnStatisticsByCustomId:TheCustomer.customerMo.id success:^(id responseObject) {
        NSMutableArray *arrRiskList = [RiskListMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
        NSMutableArray *newArr = [NSMutableArray new];
        for (int i = 0; i < arrRiskList.count; i++) {
            RiskListMo *mo = arrRiskList[i];
            [newArr addObject:[mo toJSONString]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:newArr forKey:RISK_LIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSError *error) {
    }];
}

- (void)actionClick:(UIButton *)sender {
    CustomerCardViewCtrl *vc = [[CustomerCardViewCtrl alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
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
    return indexPath.row == 0 ? 170 : 160;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TabCustomerCell";
    TabCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TabCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    
    // 注册 3Dtouch
    if ([self respondsToSelector:@selector(traitCollection)]) {
        
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                
                [self registerForPreviewingWithDelegate:(id)self sourceView:cell];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.row % 2) {
//        MemberCardViewCtrl *vc = [[MemberCardViewCtrl alloc] init];
//        CustomerMo *mo = self.arrData[indexPath.row];
//        // test
//        //    mo.id = 199;
//        mo.avatarUrl = mo.headUrl;
//        vc.mo = mo;
//        if (self.arrData.count == 1) {
//            vc.forbidRefresh = YES;
//        }
//        vc.index = indexPath.row;
//        vc.arrData = [[NSMutableArray alloc] initWithArray:self.arrData copyItems:YES];
//        TheCustomer.fromTab = 0;
//        TheCustomer.page = self.page;
//        [TheCustomer insertCustomer:mo];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
        CustomerCardViewCtrl *vc = [[CustomerCardViewCtrl alloc] init];
        CustomerMo *mo = self.arrData[indexPath.row];
        // test
        //    mo.id = 199;
        mo.avatarUrl = mo.headUrl;
        vc.mo = mo;
        if (self.arrData.count == 1) {
            vc.forbidRefresh = YES;
        }
        vc.index = indexPath.row;
        vc.arrData = self.arrData;
        TheCustomer.fromTab = 0;
        TheCustomer.page = self.page;
        [TheCustomer insertCustomer:mo];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - FilterViewDelegate

- (void)filterView:(FilterView *)filterView selectedIndex:(NSInteger)index selected:(BOOL)selected {
    _currentTag = index;
    if (selected) {
        if (index == 2) {
            [_filterListView removeFromSuperview];
            _filterListView = nil;
            if (!_filterViewCtrl) {
                _filterViewCtrl = [[FilterViewCtrl alloc] init];
                _filterViewCtrl.filterViewCtrlDelegate = self;
            }
            [[UIApplication sharedApplication].keyWindow addSubview:_filterViewCtrl.view];
            _filterViewCtrl.indexPathArr = [self.indexPathArr mutableCopy];
            [_filterViewCtrl refreshCollectionView];
            [_filterViewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        } else {
            [_filterViewCtrl.view removeFromSuperview];
            _filterViewCtrl = nil;
            
            if (!_filterListView) {
                _filterListView = [[FilterListView alloc] initWithSourceType:0];
                _filterListView.delegate = self;
            }
            
            CGFloat top = CGRectGetMaxY(self.filterView.frame);
            [[UIApplication sharedApplication].keyWindow addSubview:_filterListView];
            [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.filterView.mas_bottom);
                make.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
            }];
            
            _filterListView.collectionView.selectTag = index == 0 ? _sortTag1 : _sortTag2;
            if (index == 0) {
                NSMutableArray *arr = [NSMutableArray new];
                for (MemberChooseMo *mo in self.arrSort1) {
                    [arr addObject:mo.name];
                }
                [_filterListView loadData:arr];
            } else {
                NSMutableArray *arr = [NSMutableArray new];
                for (MemberChooseMo *mo in self.arrSort2) {
                    [arr addObject:mo.name];
                }
                [_filterListView loadData:arr];
            }
            [_filterListView updateViewHeight:(SCREEN_HEIGHT-top) bottomHeight:0];
        }
    } else {
        [_filterViewCtrl.view removeFromSuperview];
        _filterViewCtrl = nil;
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
}

#pragma mark - FilterViewCtrlDelegate

- (void)filterViewCtrlDismiss:(FilterViewCtrl *)filterViewCtrl {
    [_filterViewCtrl.view removeFromSuperview];
    _filterViewCtrl = nil;
    [self.filterView resetNormalState];
}

- (void)filterView:(FilterViewCtrl *)filterView btnOKClick:(NSMutableArray *)arrIndexPath {
    self.indexPathArr = arrIndexPath;
    _isQuick = NO;
    [self.filterView changeNormalSelectedIndex:2 isChange:arrIndexPath.count == 0 ? NO : YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)filterView:(FilterViewCtrl *)filterView btnReSetClick:(NSMutableArray *)arrIndexPath {
    self.indexPathArr = arrIndexPath;
    _isQuick = NO;
    [self.filterView changeNormalSelectedIndex:2 isChange:arrIndexPath.count == 0 ? NO : YES];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - FilterListViewDelegate

-(void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView resetNormalState];
    if (_currentTag == 0) {
        _sortTag1 = indexPath.row;
        _sortMo1 = self.arrSort1[indexPath.row];
        [self.filterView updateTitle:[Utils showText:_sortMo1.name length:4] atIndex:0];
        [[JYClick shareInstance] event:@"sort" label:_sortMo1.name];
    } else if (_currentTag == 1) {
        _sortTag2 = indexPath.row;
        _sortMo2 = self.arrSort2[indexPath.row];
        _isQuick = YES;
        [self.filterView updateTitle:[Utils showText:_sortMo2.name length:4] atIndex:1];
        [self.indexPathArr removeAllObjects];
        self.indexPathArr = nil;
        [self.filterView changeNormalSelectedIndex:2 isChange:NO];
        [[JYClick shareInstance] event:@"quickSort" label:_sortMo2.name];
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.filterView resetNormalState];
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
   
    [self.searchView.searchTxtField resignFirstResponder];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [_filterViewCtrl.view removeFromSuperview];
    _filterViewCtrl.view = nil;
    [self.filterView resetNormalState];
    
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:NO];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:YES];
}

- (void)pushToSearchVC:(BOOL)showIFly {
    SearchStyle *searchStyle = [[SearchStyle alloc] init];
    searchStyle.type = SearchCustomer;
    ChatSearchViewCtrl *vc = [[ChatSearchViewCtrl alloc] init];
    vc.showIFly = showIFly;
    vc.searchStyle = searchStyle;
    BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - 3Dtouch

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    _touchIndexPath = indexPath;
    //创建要预览的控制器
    CustomerCardViewCtrl *vc = [[CustomerCardViewCtrl alloc] init];
    CustomerMo *mo = self.arrData[indexPath.row];
    mo.avatarUrl = mo.headUrl;
    vc.mo = mo;
    if (self.arrData.count == 1) {
        vc.forbidRefresh = YES;
    }
    vc.index = indexPath.row;
    vc.arrData = self.arrData;
    TheCustomer.fromTab = 0;
    TheCustomer.page = self.page;
    [TheCustomer insertCustomer:mo];
    vc.hidesBottomBarWhenPushed = YES;
    [vc delayGotoCurrentIndex];
    
    //指定当前上下文视图Rect
    CGRect rect = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width-30, 160);
    previewingContext.sourceRect = rect;
    
    return vc;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
    
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark - event

- (void)btnMoreClick:(UIButton *)sender {
    CGFloat width = 160.0;
    CGFloat heigth = 52;//104.0;
    //    @"扫名片    "
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
    if (_filterViewCtrl) {
        [_filterViewCtrl.view removeFromSuperview];
        _filterViewCtrl.view = nil;
    }
    
    PopMenuView *menuView = [[PopMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width, CGRectGetMaxY(self.btnMore.frame), width, heigth) position:ArrowPosition_RightTop arrTitle:@[@"扫批号    "] arrImage:@[@"more_sweep_number", @"more_business_card"] defaultItem:-1 itemClick:^(NSInteger index) {
        [ScanTool scanToolSuccessBlock:^(BOOL succ) {
            if (succ) {
                [self scanAction:index];
            }
        }];
    } cancelClick:^(id obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    menuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:menuView];
}

- (void)scanAction:(NSInteger)index {
    if (index == 1) {    
        [Utils showToastMessage:@"该功能正在开发中..."];
        return;
    }
    QMYViewController *scan = [[QMYViewController alloc] init];
    [scan initWithScanViewName: nil withScanLinaName:@"qrcode_Scan_weixin_Line" withPickureZoom:1];
    scan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scan animated:YES];
}

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:_page + 1];
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
        _tableView.backgroundColor = COLOR_EEF0F1;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
    }
    return _tableView;
}

- (FilterView *)filterView {
    if (!_filterView) {
        _filterView = [[FilterView alloc] initWithTitles:@[@"排序", @"快速检索", @"手工筛选"] imgsNormal:@[@"client_down_n", @"client_down_n", @"client_filter_n"] imgsSelected:@[@"drop_down_s", @"drop_down_s", @"client_filter_s"]];
        _filterView.backgroundColor = COLOR_B4;
        _filterView.delegate = self;
    }
    return _filterView;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:YES];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = [SearchStyle placeholdString:SearchCustomer];
    }
    return _searchView;
}

- (UIButton *)btnMore {
    if (!_btnMore) {
        _btnMore = [[UIButton alloc] init];
        [_btnMore setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMore;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
    }
    return _arrData;
}

- (NSMutableArray *)arrSort1 {
    if (!_arrSort1) {
        _arrSort1 = [[NSMutableArray alloc] init];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:MEMBER_CHOOSE_SORT];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0; i < arr.count; i++) {
            MemberChooseMo *mo = [[MemberChooseMo alloc] initWithDictionary:arr[i] error:nil];
            [_arrSort1 addObject:mo];
        }
    }
    return _arrSort1;
}

- (NSMutableArray *)arrSort2 {
    if (!_arrSort2) {
        _arrSort2 = [[NSMutableArray alloc] init];
    }
    return _arrSort2;
}

- (NSMutableArray *)indexPathArr {
    if (!_indexPathArr) {
        _indexPathArr = [NSMutableArray new];
    }
    return _indexPathArr;
}

- (NSMutableArray *)rules {
    if (!_rules) {
        _rules = [NSMutableArray new];
    }
    return _rules;
}

- (NSMutableArray *)arrMutiData {
    if (!_arrMutiData) {
        _arrMutiData = [NSMutableArray new];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:MEMBER_CHOOSE];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0; i < arr.count; i++) {
            MemberChooseMo *mo = [[MemberChooseMo alloc] initWithDictionary:arr[i] error:nil];
            [_arrMutiData addObject:mo];
        }
    }
    return _arrMutiData;
}

@end
