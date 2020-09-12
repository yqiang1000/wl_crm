//
//  TabNewChatViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "TabNewChatViewCtrl.h"
#import "TUIConversationListController.h"
#import "ChatViewController.h"
#import "TPopView.h"
#import "TPopCell.h"
#import "THeader.h"
#import "Toast/Toast.h"
#import "TUIContactSelectController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "TIMUserProfile+DataProvider.h"
#import "TNaviBarIndicatorView.h"
#import "TUIKit.h"
#import "THelper.h"
#import "TCUtil.h"
#import "VideoCallManager.h"
#import "TIMUserProfile+DataProvider.h"
#import "MainTabBarViewController.h"

#import <ImSDK/ImSDK.h>
#import "JYIMUtils.h"

#import "YQConversationListViewModel.h"
#import "SearchStyle.h"
#import "ChatSearchViewCtrl.h"
#import "BaseNavigationCtrl.h"
#import "SearchTopView.h"
#import "PopMenuView.h"
#import "QMYViewController.h"
#import "ScanTool.h"

@interface TabNewChatViewCtrl () <TUIConversationListControllerDelegagte, TPopViewDelegate, SearchTopViewDelegate>

@property (nonatomic, strong) TNaviBarIndicatorView *titleView;
@property (nonatomic, strong) YQConversationListViewModel *yqViewModel;

@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) SearchTopView *searchView;

@end

@implementation TabNewChatViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置默认的头像 以及 圆角
    [TUIKit sharedInstance].config.avatarType = TAvatarTypeRounded;
    [TUIKit sharedInstance].config.defaultAvatarImage = [UIImage imageNamed:@"client_default_avatar"];

    [self setupUI];
    TUIConversationListController *conv = [[TUIConversationListController alloc] init];
    conv.delegate = self;
    conv.viewModel = self.yqViewModel;
    conv.tableView.backgroundColor = COLOR_B0;
    [self addChildViewController:conv];
    [self.view addSubview:conv.view];
    
    [conv.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    //如果不加这一行代码，依然可以实现点击反馈，但反馈会有轻微延迟，体验不好。
    conv.tableView.delaysContentTouches = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(onNewMessageNotification:) name:TUIKitNotification_TIMMessageListener object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(noti_im_login_success:) name:NOTI_IM_LOGIN_SUCCESS
      object:nil];
    
    [self getTimHelper];
}

- (void)setupUI {
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
}

/* 重新连接刷新数据 */
- (void)noti_im_login_success:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.yqViewModel loadConversation];
    });
}

- (YQConversationListViewModel *)yqViewModel
{
    if (!_yqViewModel) {
        _yqViewModel = [YQConversationListViewModel new];
        _yqViewModel.listFilter = ^BOOL(TUIConversationCellData * _Nonnull data) {
            // 不是小助手对象
            if (![data.convId containsString:@"_helper"]) {
                if (data.avatarUrl.absoluteString.length > 0) {
                    data.avatarUrl = [NSURL URLWithString:[Utils imgUrlWithKey:data.avatarUrl.absoluteString]];
                }
            }
            return (data.convType != TIM_SYSTEM);
        };
    }
    return _yqViewModel;
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

- (void)getTimHelper {
//    NSDictionary *param = @{@"page":@"0",
//                            @"size":@"100",
//                            @"dataAssignsJson":@"[]",
//                            @"propertyNames":@"dict.code",
//                            @"propertyValues":@"tim_helper",
//                            };
//    [[JYUserApi sharedInstance] getHelperListParam:param success:^(id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            [Utils showToastMessage:STRING(responseObject[@"description"])];
//        } else if ([responseObject isKindOfClass:[NSArray class]]) {
//            [JYIMUtils standardJYIMUtils].imHelperList = [NSArray yy_modelArrayWithClass:[JYDictItemMo class] json:responseObject];
//            [NSUserDefaults setUserDefaultsWithKey:IM_HELPER_TYPE_LIST data:responseObject];
//            [NSUserDefaults synchronize];
//        }
//    } failure:^(NSError *error) {
//    }];
//
//    NSDictionary *paramConfig = @{@"page":@"0",
//                            @"size":@"100",
//                            @"dataAssignsJson":@"[]",
//                            @"propertyNames":@"dict.code",
//                            @"propertyValues":@"rightStyle",
//                            };
//    [[JYUserApi sharedInstance] getDictItemListParam:paramConfig success:^(id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            [Utils showToastMessage:STRING(responseObject[@"description"])];
//        } else if ([responseObject isKindOfClass:[NSArray class]]) {
//            [JYIMUtils standardJYIMUtils].imStyleList = [NSArray yy_modelArrayWithClass:[JYDictItemMo class] json:responseObject];
//            [NSUserDefaults setUserDefaultsWithKey:IM_CONFIG_STYLE_LIST data:responseObject];
//            [NSUserDefaults synchronize];
//        }
//    } failure:^(NSError *error) {
//    }];
}

/**
 *在消息列表内，点击了某一具体会话后的响应函数
 */
- (void)conversationListController:(TUIConversationListController *)conversationController didSelectConversation:(TUIConversationCell *)conversation
{
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = conversation.convData;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}


- (void)onNewMessageNotification:(NSNotification *)no
{
    NSArray<TIMMessage *> *msgs = no.object;
    for (TIMMessage *msg in msgs) {
        
        TIMElem *elem = [msg getElem:0];
        if ([elem isKindOfClass:[TIMCustomElem class]]) {
            TIMCustomElem *custom = (TIMCustomElem *)elem;
            NSDictionary *param = [TCUtil jsonData2Dictionary:[custom data]];
            if (param != nil && [param[@"version"] integerValue] == 2) {
                [[VideoCallManager shareInstance] onNewVideoCallMessage:msg];
            }
        }
    }
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

#pragma mark - event

- (void)btnMoreClick:(UIButton *)sender {
    
    CGFloat width = 160.0;
    CGFloat heigth = 52;//104.0;
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
    if (index == 0) {
        QMYViewController *scan = [[QMYViewController alloc] init];
        [scan initWithScanViewName: nil withScanLinaName:@"qrcode_Scan_weixin_Line" withPickureZoom:1];
        scan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scan animated:YES];
    }
}

#pragma mark - lazy

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
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
