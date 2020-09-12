//
//  TabUsedViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/3/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TabUsedViewController.h"
#import "UsedCollectionView.h"
#import "CommonItemMo.h"
#import "SearchTopView.h"
#import "ChatSearchViewCtrl.h"
#import "OrgContactViewCtrl.h"
#import "TaskViewCtrl.h"
#import "UsedMo.h"
#import "BaseWebViewCtrl.h"
#import "MainTabBarViewController.h"
#import "QMYViewController.h"
#import "PopMenuView.h"
#import "ScanTool.h"
#import "CreatePlanOrderViewCtrl.h"
#import "JYClick.h"
#import "RetailPageViewCtrl.h"
#import "ChannelDevelopPageViewCtrl.h"
#import "MarketEngineeringPageViewCtrl.h"
#import "StrategicEngineeringPageViewCtrl.h"
#import "DirectSalesEngineeringPageViewCtrl.h"
#import "NengchengPageViewCtrl.h"
#import "HuajuePageViewCtrl.h"
#import "JYWorkPageViewCtrl.h"

@interface TabUsedViewController () <SearchTopViewDelegate, UsedCollectionViewDelegate>

@property (nonatomic, strong) UsedCollectionView *collectionView;

@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) NSMutableArray *arrData;      // 所有数据
@property (nonatomic, strong) NSMutableArray *arrUsed;      // 历史数据
@property (nonatomic, strong) NSMutableArray *arrUsedId;    // 历史id
@property (nonatomic, strong) NSMutableArray *arrTotal;     // 大全数据

@end

@implementation TabUsedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstInUsed"]) {
        [self getList];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CONTACT_RECENT];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USED_RECETENT];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstInUsed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getList];
    }
    [self setUI];
    self.collectionView.arrData = self.arrData;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanAction) name:NOTIFI_CLEAN_USED object:nil];
}

- (void)cleanAction {
    self.arrData = nil;
    self.arrUsedId = nil;
    self.arrUsed = nil;
    self.arrTotal = nil;
    [self getList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    MainTabBarViewController *tabVC = (MainTabBarViewController *)self.navigationController.tabBarController;
    [tabVC hidenBtnCreate:YES];
}

- (void)getList {
    
//    @[@{@"category":@"",
//        @"items":@[UsedMo]},
//      @{@"category":@"",
//        @"items":@[UsedMo]}]
    
    [[JYUserApi sharedInstance] getApplicationItemPageParam:nil rules:nil success:^(id responseObject) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
        if (data) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:USED_TOTAL];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self.collectionView.mj_header endRefreshing];
        NSError *error = nil;
        [_arrTotal removeAllObjects];
        [_arrData removeAllObjects];
        [_arrUsed removeAllObjects];
        _arrTotal = nil;
        _arrData = nil;
        _arrUsed = nil;
        self.arrTotal = [TabUsedMo arrayOfModelsFromDictionaries:responseObject error:&error];
//        self.collectionView.arrData = self.arrData;
//        [self.collectionView reloadData];
        [self dealRecent];
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)dealRecent {
    NSLock *lock = [NSLock new];
    [lock lock];
    _arrUsed = nil;
    // 1.遍历记录的id
    // 2.遍历原始列表数据，如果id没有一至的，则从记录id的数组中移除
    for (int i = 0; i < self.arrUsedId.count; i++) {
        NSString *moId = self.arrUsedId[i];
        BOOL has = NO;
        for (int j = 0; j < self.arrTotal.count; j++) {
            TabUsedMo *tabUsedMo = self.arrTotal[j];
            for (NSDictionary *tmpDic in tabUsedMo.items) {
                if ([tmpDic[@"id"] integerValue] == [moId integerValue]) {
                    has = YES;
                    [self.arrUsed addObject:tmpDic];
                    break;
                }
            }
        }
        if (!has && i < self.arrUsedId.count) {
            [self.arrUsedId removeObjectAtIndex:i];
        }
    }
    
    TabUsedMo *dic = [[TabUsedMo alloc] init];
    dic.category = @"最近打开";
    dic.items = self.arrUsed.count == 0 ? [NSMutableArray new] : self.arrUsed;
    [_arrData removeAllObjects];
    _arrData = nil;
    [self.arrData addObject:dic];
    [self.arrData addObjectsFromArray:self.arrTotal];
    self.collectionView.arrData = self.arrData;
    [self.collectionView reloadData];
    [lock unlock];
}

- (void)setUI {
    for (UIView *subView in self.naviView.subviews) {
        [subView removeFromSuperview];
    }
    
    [self.naviView addSubview:self.searchView];
    [self.naviView addSubview:self.btnMore];
    
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
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
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
    searchStyle.type = SearchCustomer;
    ChatSearchViewCtrl *vc = [[ChatSearchViewCtrl alloc] init];
    vc.showIFly = showIFly;
    vc.searchStyle = searchStyle;
    BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - UsedCollectionViewDelegate

- (void)usedCollectionView:(UsedCollectionView *)usedCollectionView selected:(NSDictionary *)item indexPath:(NSIndexPath *)indexPath {
    BaseViewCtrl *pushVC = nil;
    JYWorkPageViewCtrl *workPageVC = [[JYWorkPageViewCtrl alloc] init];
    
    UsedMo *model = [[UsedMo alloc] initWithDictionary:item error:nil];
    if ([model.flag isEqualToString:@"agency_directory"]) {
        // 机构通讯录
        OrgContactViewCtrl *vc = [[OrgContactViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.flag isEqualToString:@"task_collaboration"]) {
        // 任务协作
        TaskViewCtrl *vc = [[TaskViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.flag isEqualToString:@"out_plan"]) {
        CreatePlanOrderViewCtrl *vc = [[CreatePlanOrderViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.url isEqualToString:@"action:7110"]) {
        RetailPageViewCtrl *vc = [[RetailPageViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.url isEqualToString:@"action:7120"]) {
        ChannelDevelopPageViewCtrl *vc = [[ChannelDevelopPageViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.url isEqualToString:@"action:7130"]) {
        MarketEngineeringPageViewCtrl *vc = [[MarketEngineeringPageViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.url isEqualToString:@"action:7140"]) {
        StrategicEngineeringPageViewCtrl *vc = [[StrategicEngineeringPageViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.url isEqualToString:@"action:7150"]) {
        DirectSalesEngineeringPageViewCtrl *vc = [[DirectSalesEngineeringPageViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.url isEqualToString:@"action:7160"]) {
        NengchengPageViewCtrl *vc = [[NengchengPageViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.url isEqualToString:@"action:7170"]) {
        HuajuePageViewCtrl *vc = [[HuajuePageViewCtrl alloc] init];
        pushVC = vc;
    } else if ([model.url isEqualToString:@"action:7180"]) {
        workPageVC.workType = JYWorkTypeJinMuMen;
        pushVC = workPageVC;
    } else if ([model.url isEqualToString:@"action:7190"]) {
        workPageVC.workType = JYWorkTypeMuMen;
        pushVC = workPageVC;
    } else if ([model.url isEqualToString:@"action:7200"]) {
        workPageVC.workType = JYWorkTypeLvMuMen;
        pushVC = workPageVC;
    } else if ([model.url isEqualToString:@"action:7210"]) {
        workPageVC.workType = JYWorkTypeTongMuMen;
        pushVC = workPageVC;
    } else if ([model.url isEqualToString:@"action:7220"]) {
        workPageVC.workType = JYWorkTypeZhiNengSuo;
        pushVC = workPageVC;
    } else {
        BaseWebViewCtrl *vc = [[BaseWebViewCtrl alloc] init];
        NSString *urlStr = [NSString stringWithFormat:@"%@?id=%ld&officeName=%@&token=%@", model.url, TheUser.userMo.id, [Utils officeName], [Utils token]];
        vc.urlStr = urlStr;
        vc.titleStr = model.name;
        pushVC = vc;
    }
    if (pushVC) {
        pushVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushVC animated:YES];
    }
    
    [[JYClick shareInstance] event:@"usedApplication" label:model.name];
    
    // 只记录点击的id
    NSString *usedMoId = [NSString stringWithFormat:@"%ld", model.id];
    // 查找是否存在
    if ([self.arrUsedId containsObject:usedMoId]) {
        [self.arrUsedId removeObject:usedMoId];
    }
    
    [self.arrUsedId insertObject:STRING(usedMoId) atIndex:0];
    if (self.arrUsedId.count > 8) {
        [self.arrUsedId removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.arrUsedId forKey:USED_RECETENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dealRecent];
}

#pragma mark - event

- (void)btnMoreClick:(UIButton *)sender {
//    JinMuMenPageViewCtrl *vc = [[JinMuMenPageViewCtrl alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    CGFloat width = 160.0;
    CGFloat heigth = 52;//104.0;
    //    @"扫名片    "
    
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


- (void)collectionViewHeaderRefreshAction {
    [self getList];
}

#pragma mark - setter getter

- (UsedCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UsedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.usedDelegate = self;
        _collectionView.backgroundColor = COLOR_B0;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(collectionViewHeaderRefreshAction)];
    }
    return _collectionView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
//        [_arrData addObject:self.arrUsed];
//        [_arrData addObject:self.arrTotal];
    }
    return _arrData;
}

- (NSMutableArray *)arrUsed {
    if (!_arrUsed) {
        _arrUsed = [[NSMutableArray alloc] init];
    }
    return _arrUsed;
}

- (NSMutableArray *)arrUsedId {
    if (!_arrUsedId) {
        _arrUsedId = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:USED_RECETENT]];
    }
    return _arrUsedId;
}

- (NSMutableArray *)arrTotal {
    if (!_arrTotal) {
        _arrTotal = [[NSMutableArray alloc] init];
    }
    return _arrTotal;
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

@end
