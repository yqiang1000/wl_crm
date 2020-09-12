//
//  TabChatViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/3/29.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TabChatViewController.h"
//#import <JYIMKit/JYIMKit.h>
#import "SearchTopView.h"
#import "ChatSearchViewCtrl.h"
#import "NewContactViewCtrl.h"
#import "CreateTaskViewCtrl.h"
#import "CreateCustomerViewCtrl.h"
#import "CreateMarketViewCtrl.h"
#import "CreateContractViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "WebDetailViewCtrl.h"
#import "URLConfig.h"
#import "MainTabBarViewController.h"
#import "PopMenuView.h"
#import "ScanTool.h"
#import "QMYViewController.h"
#import "PDFReaderViewCtrl.h"
#import "BusinessVisitActiveViewCtrl.h"

@interface TabChatViewController () <SearchTopViewDelegate>

@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) UIButton *btnMore;

@end

@implementation TabChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self setUI];
    [self getUsedList];
}

- (void)setUI {
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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

//- (void)conversationListViewController:(UIViewController *)listCtrl selectUserMo:(UserMo *)userMo indexPath:(NSIndexPath *)indexPath title:(NSString *)title {
//    [[JYChatKit shareJYChatKit] pushToChatViewControllerWith:userMo from:self title:title];
//}

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

#pragma mark - event

- (void)btnMoreClick:(UIButton *)sender {
//    BusinessVisitActiveViewCtrl *vc = [[BusinessVisitActiveViewCtrl alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    BusinessVisitActivityMo *model = [[BusinessVisitActivityMo alloc] init];
//    model.id = 66;
//    vc.model = model;
//    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
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

#pragma mark - network

- (void)getUsedList {
    [[JYUserApi sharedInstance] getApplicationItemPageParam:nil rules:nil success:^(id responseObject) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
        if (data) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:USED_TOTAL];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - setter getter

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
