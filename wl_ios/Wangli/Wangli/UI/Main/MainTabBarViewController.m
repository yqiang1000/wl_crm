//
//  MainTabBarViewController.m
//  Wangli
//
//  Created by yeqiang on 2018/3/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "BaseViewCtrl.h"
#import "TabChatViewController.h"
#import "BaseNavigationCtrl.h"
#import "TouchLoginViewCtrl.h"
#import "TabAddView.h"
#import "MemberSelectViewCtrl.h"
#import "OrderSelectViewCtrl.h"
#import "TaskSelectViewCtrl.h"
#import "ContactSelectViewCtrl.h"
#import "JYClick.h"
#import "TabNewChatViewCtrl.h"

typedef void(^MoreViewClickBlock)(id obj);

@interface MainTabBarViewController () <MemberSelectViewCtrlDelegate, OrderSelectViewCtrlDelegate, TaskSelectViewCtrlDelegate, ContactSelectViewCtrlDelegate, UITabBarDelegate>

@property (nonatomic, strong) TouchLoginViewCtrl *touchVC;
@property (nonatomic, strong) UIButton *btnCreate;
@property (nonatomic, strong) TabAddView *addView;

@property (nonatomic, copy) MoreViewClickBlock moreBlock;

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTouchView:) name:NOTIFI_SHOW_TOUCH_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenTouchView:) name:NOTIFI_TOUCH_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenTouchView:) name:NOTIFI_LOGOUT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenTouchView:) name:NOTIFI_LOGIN_SUCCESS object:nil];
    
    
    //#define NOTI_CUSTOMER_MESSAGE_ACTION @"NOTI_CUSTOMER_MESSAGE_ACTION"
    //#define NOTI_CONTACT_MESSAGE_ACTION @"NOTI_CONTACT_MESSAGE_ACTION"
    //#define NOTI_ORDER_MESSAGE_ACTION @"NOTI_ORDER_MESSAGE_ACTION"
    //#define NOTI_TASK_MESSAGE_ACTION @"NOTI_TASK_MESSAGE_ACTION"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customerClick:) name:@"NOTI_CUSTOMER_MESSAGE_ACTION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactClick:) name:@"NOTI_CONTACT_MESSAGE_ACTION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderClick:) name:@"NOTI_ORDER_MESSAGE_ACTION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskClick:) name:@"NOTI_TASK_MESSAGE_ACTION" object:nil];
    
    [self setUI];
    [self.view addSubview:self.btnCreate];
    [self.btnCreate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view).offset(-10-Height_TabBar);
        make.height.width.equalTo(@66);
    }];
    
    if (@available(iOS 12.1, *)) {
        [[UITabBar appearance] setTranslucent:NO];
    }
}

- (void)setUI {
    [self setViewControllers:@[
        [self configController:@"TabNewChatViewCtrl"
                         title:@"消息"
                         image:[UIImage imageNamed:@"tab_news_n"]
                 selectedImage:[UIImage imageNamed:@"tab_news_s"]],
        [self configController:@"TabCustomerViewController"
                         title:@"客户"
                         image:[UIImage imageNamed:@"tab_client_n"]
                 selectedImage:[UIImage imageNamed:@"tab_client_s"]],
        [self configController:@"TabTravelViewController"
                         title:@"差旅"
                         image:[UIImage imageNamed:@"tab_business_travel_n"]
                 selectedImage:[UIImage imageNamed:@"tab_business_travel_s"]],
        [self configController:@"TabUsedViewController"
                         title:@"常用"
                         image:[UIImage imageNamed:@"tab_commonlyused_n"]
                 selectedImage:[UIImage imageNamed:@"tab_commonlyused_s"]],
        [self configController:@"TabMineViewController"
                         title:@"我的"
                         image:[UIImage imageNamed:@"tab_mine_n"]
                 selectedImage:[UIImage imageNamed:@"tab_mine_s"]],
    ]];
}



- (BaseNavigationCtrl *)configController:(NSString *)ctrlName
                                   title:(NSString *)title
                                   image:(UIImage *)image
                           selectedImage:(UIImage *)selectImage {
    Class class = NSClassFromString(ctrlName);
    BaseViewCtrl *vc = [[class alloc] init];
    vc.title = title;
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                  image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                          selectedImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationCtrl *nav = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    return nav;
}

- (void)showTouchView:(NSNotification *)noti {
    // 设置当前锁屏状态
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:USER_LOCKED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!_touchVC) {
        _touchVC = [[TouchLoginViewCtrl alloc] init];
        _touchVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [[UIApplication sharedApplication].keyWindow addSubview:_touchVC.view];
        [_touchVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }
}

- (void)hidenTouchView:(NSNotification *)noti {
    // 解锁后，设置当前未锁屏状态
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:USER_LOCKED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (_touchVC) {
        [_touchVC.view removeFromSuperview];
        _touchVC = nil;
    }
}

- (void)customerClick:(NSNotification *)noti {
    _moreBlock = noti.object;
    MemberSelectViewCtrl *vc = [[MemberSelectViewCtrl alloc] init];
    vc.needRules = YES;
    vc.VcDelegate = self;
    vc.sendIM = YES;
    vc.toUserId = noti.userInfo[@"toUserId"];
    BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [[Utils topViewController] presentViewController:navi animated:YES completion:^{
    }];
}

- (void)contactClick:(NSNotification *)noti {
    _moreBlock = noti.object;
    ContactSelectViewCtrl *vc = [[ContactSelectViewCtrl alloc] init];
    vc.VcDelegate = self;
    vc.VcDelegate = self;
    vc.toUserId = noti.userInfo[@"toUserId"];
    BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [[Utils topViewController] presentViewController:navi animated:YES completion:^{
    }];
}

- (void)orderClick:(NSNotification *)noti {
    _moreBlock = noti.object;
    OrderSelectViewCtrl *vc = [[OrderSelectViewCtrl alloc] init];
    vc.VcDelegate = self;
        NSString *toUserId = noti.userInfo[@"toUserId"];
        if ([toUserId containsString:@"huafon_op_"]) {
            toUserId = [toUserId substringFromIndex:@"huafon_op_".length];
        }
    vc.toUserId = toUserId;
    BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [[Utils topViewController] presentViewController:navi animated:YES completion:^{
    }];
}

- (void)taskClick:(NSNotification *)noti {
    _moreBlock = noti.object;
    TaskSelectViewCtrl *vc = [[TaskSelectViewCtrl alloc] init];
    vc.VcDelegate = self;
    BaseNavigationCtrl *navi = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [[Utils topViewController] presentViewController:navi animated:YES completion:^{
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSArray *labels = @[@"消息标签", @"客户标签", @"订单标签", @"常用标签", @"我的标签"];
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index < labels.count) {
        [[JYClick shareInstance] event:@"tabTitle" label:labels[index]];
    }
}

#pragma mark - MemberSelectViewCtrlDelegate

//userAction：消息类型 0助手消息，1客户信息 2联系人信息 3订单信息 4任务信息
- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"1" forKey:@"userAction"];
    [dic setObject:@"1" forKey:@"typeId"];
    [dic setObject:@"客户信息" forKey:@"typeValue"];
    [dic setObject:@(model.id) forKey:@"titleId"];
    [dic setObject:STRING(model.orgName) forKey:@"titleValue"];
    if (_moreBlock) {
        _moreBlock(dic);
    }
}

- (void)memberSelectViewCtrlDismiss:(MemberSelectViewCtrl *)memberSelectViewCtrl {
    memberSelectViewCtrl = nil;
}

#pragma mark - OrderSelectViewCtrlDelegate

- (void)orderSelectViewCtrl:(OrderSelectViewCtrl *)orderSelectViewCtrl selectedModel:(OrderMo *)model indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"3" forKey:@"userAction"];
    [dic setObject:@"3" forKey:@"typeId"];
    [dic setObject:@"订单信息" forKey:@"typeValue"];
    [dic setObject:@(model.id) forKey:@"titleId"];
    [dic setObject:[NSString stringWithFormat:@"订单号%@", model.crmNumber] forKey:@"titleValue"];
    if (_moreBlock) {
        _moreBlock(dic);
    }
}

- (void)orderSelectViewCtrlDismiss:(OrderSelectViewCtrl *)orderSelectViewCtrl {
    orderSelectViewCtrl = nil;
}

#pragma mark - TaskSelectViewCtrlDelegate

- (void)taskSelectViewCtrl:(TaskSelectViewCtrl *)taskSelectViewCtrl selectedModel:(TaskMo *)model indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"4" forKey:@"userAction"];
    [dic setObject:@"4" forKey:@"typeId"];
    [dic setObject:@"任务信息" forKey:@"typeValue"];
    [dic setObject:@(model.id) forKey:@"titleId"];
    [dic setObject:[NSString stringWithFormat:@"%@", model.title] forKey:@"titleValue"];
    if (_moreBlock) {
        _moreBlock(dic);
    }
}

- (void)taskSelectViewCtrlDismiss:(TaskSelectViewCtrl *)taskSelectViewCtrl {
    taskSelectViewCtrl = nil;
}

#pragma mark - ContactSelectViewCtrlDelegate

- (void)contactSelectViewCtrl:(ContactSelectViewCtrl *)contactSelectViewCtrl selectedModel:(ContactMo *)model indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"2" forKey:@"userAction"];
    [dic setObject:@"2" forKey:@"typeId"];
    [dic setObject:@"联系人信息" forKey:@"typeValue"];
    [dic setObject:@(model.id) forKey:@"titleId"];
    NSString *orgName = model.member[@"abbreviation"];
    NSString *text = orgName.length == 0 ? [NSString stringWithFormat:@"%@", model.name] : [NSString stringWithFormat:@"%@-%@", orgName, model.name];
    [dic setObject:[NSString stringWithFormat:@"%@", text] forKey:@"titleValue"];
    if (_moreBlock) {
        _moreBlock(dic);
    }
}

- (void)contactSelectViewCtrlDismiss:(ContactSelectViewCtrl *)contactSelectViewCtrl {
    contactSelectViewCtrl = nil;
}

#pragma mark -  event

- (void)hidenBtnCreate:(BOOL)hidenBtn {
    self.btnCreate.hidden = hidenBtn;
}

- (void)btnCreateClick:(UIButton *)sender {
    _addView = [[TabAddView alloc] initWithFrame:[UIScreen mainScreen].bounds btnClick:^(NSInteger index) {
    } cancel:^(TabAddView *obj) {
        [_addView removeFromSuperview];
        _addView = nil;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:_addView];
}

#pragma mark - lazy

- (UIButton *)btnCreate {
    if (!_btnCreate) {
        _btnCreate = [[UIButton alloc] init];
        [_btnCreate setImage:[UIImage imageNamed:@"news_add"] forState:UIControlStateNormal];
//        _btnCreate.layer.cornerRadius = 22.5;
//        _btnCreate.clipsToBounds = YES;
        [_btnCreate addTarget:self action:@selector(btnCreateClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCreate;
}

@end
