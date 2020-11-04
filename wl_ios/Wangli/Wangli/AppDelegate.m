//
//  AppDelegate.m
//  Wangli
//
//  Created by yeqiang on 2018/3/27.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "AppDelegate.h"

//#import <JYIMKit/JYIMKit.h>
#import "MainTabBarViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationCtrl.h"
#import "ApiTool.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <iflyMSC/IFlyMSC.h>
#import <Bugly/Bugly.h>
#import "OpenURLManager.h"
#import "QMYViewController.h"
#import "AttendanceViewCtrl.h"
//#import "MyFavoriteViewCtrl.h"
//#import <UMCommon/UMCommon.h>
#import "UIViewController+JYPresent.h"
#import <SDWebImage/SDWebImage.h>

#import "TUIKit.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate() <UNUserNotificationCenterDelegate>
@end
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIViewController load];
    // 初始化网络
    [ApiTool init];
    // 第三方平台
    [self initThirdApplication:application options:launchOptions];
    // 初始化UI
    [self initUI];
    // 注册推送
    [self registerAPNS];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NOTIFI_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOtherDevice:) name:NOTIFI_LOGIN_OTHER_DEVICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess:) name:NOTIFI_LOGOUT_SUCCESS object:nil];
    
    return YES;
}

- (void)checkVersion {
    
    NSDate *backgroundTime = [[NSUserDefaults standardUserDefaults] objectForKey:VERSION_CHECK_BEGINTIME];
    // 1.如果没有记录时间，则检测更新
    // 2.如果设定时间比当前时间晚，降序则检测更新
    BOOL check = YES;
    if (backgroundTime == nil) {
        // 检测
        check = YES;
    } else {
        NSDate *currentDate = [NSDate date];
        //    3*24*60*60
        NSDate *timeInterval = [backgroundTime isKindOfClass:[NSDate class]] ?  [backgroundTime addTimeInterval:3*24*60*60] : nil;
        NSLog(@"提示更新时间 %@", backgroundTime);
        NSLog(@"提示更新时间失效 %@", timeInterval);
        //开始时间和当前时间比较
        NSComparisonResult result = [currentDate compare:timeInterval];
        if (result == NSOrderedAscending) {  //升序
            // 不需要验证
            check = NO;
        } else {
            check = YES;
        }
    }
    
    if (check) {
        
        NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *param = @{@"version":STRING(version)};
        [[JYUserApi sharedInstance] checkVersionParam:param success:^(id responseObject) {
            if (![responseObject[@"remark"] isEqual:[NSNull null]]) {
                
//                NSDictionary *responseObject = @{@"remark":@"1",
//                                                 @"message":@"升级测试",
//                                                 @"address":@"https://www.baidu.com"};
                NSInteger remark = [responseObject[@"remark"] integerValue];
                if (remark == 0) {
                    
                } else {
                    // 1 建议升级
                    // 2 强制升级
                    NSString *desp = STRING(responseObject[@"desp"]);
                    NSString *tost = STRING(responseObject[@"message"]);
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GET_LANGUAGE_KEY(@"新版本提醒") message:desp.length==0?tost:desp preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action0 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"立即升级") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:VERSION_CHECK_BEGINTIME];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        NSString *urlStr = STRING(responseObject[@"address"]);
                        if (urlStr.length > 0) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                            exit(0);
                        }
                    }];
                    [alert addAction:action0];
                    
                    if (remark == 1) {
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"暂不升级") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:VERSION_CHECK_BEGINTIME];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }];
                        [alert addAction:action1];
                        
                        UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"3日内不再提醒") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSDate *enterBackgroundDate = [NSDate date];
                            [[NSUserDefaults standardUserDefaults] setObject:enterBackgroundDate forKey:VERSION_CHECK_BEGINTIME];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }];
                        [alert addAction:action2];
                    }
                    
                    if ([Utils topViewController].navigationController != nil) {
                        [[Utils topViewController].navigationController presentViewController:alert animated:YES completion:nil];
                    }
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 重写IMSDK方法

- (void)popToRootViewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的帐号于另一台手机上登录。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil];
    }];
    [alert addAction:action1];
    [[Utils topViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)enterLoginUI {
    [self initUI];
}

- (void)enterMainUI {
    [self initUI];
}

#pragma mark - 重写IMSDK方法

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initThirdApplication:(UIApplication *)application options:(NSDictionary *)launchOptions {
    // IM
    [[TUIKit sharedInstance] setupWithAppId:SDKAPPID];

    // 高德地图
    [AMapServices sharedServices].apiKey = @"f14600bc0fff8ec6fecc68a68416cca6";
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    
    // 友盟统计 || bugly
#if DEBUG
    [Bugly startWithAppId:@"f4edc97d28"];
//    [UMConfigure initWithAppkey:@"5cff79643fc19536ff0002b7" channel:@"DEBUG"];
#else
    [Bugly startWithAppId:@"45ff6fbbcb"];
//    [UMConfigure initWithAppkey:@"5cff79643fc19536ff0002b7" channel:@"HFPRD"];
#endif
    
    // 讯飞
    [IFlySetting setLogFile:LVL_ALL];
    [IFlySetting showLogcat:YES];
    //Appid是应用的身份信息，具有唯一性，初始化时必须要传入Appid。
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"5cff5748"];
    [IFlySpeechUtility createUtility:initString];
//    #define USERWORDS   @"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"德国盐猪手\",\"1912酒吧街\",\"清蒸鲈鱼\",\"挪威三文鱼\",\"黄埔军校\",\"横沙牌坊\",\"科大讯飞\"]}]}"
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"top1990" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSString *keyword = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\",\""];
    keyword = [@"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"" stringByAppendingString:keyword];
    keyword = [keyword stringByAppendingString:@"\"]}]}"];
    
    //创建上传对象
    IFlyDataUploader *uploader = [[IFlyDataUploader alloc] init];
    //用户词表
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:keyword ];
    //设置上传参数
    [uploader setParameter:@"uup" forKey:@"sub"];
    [uploader setParameter:@"userword" forKey:@"dtt"];
    //启动上传（请注意name参数的不同）
    [uploader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error){
        NSLog(@"%@", error);
    }name: @"userwords" data:[iFlyUserWords toString]];
}

- (void)initShortcutItems {
    if (@available(iOS 9.1, *)) {
        if ([UIApplication sharedApplication].shortcutItems.count >= 2)
            return;
    } else {
        if ([UIApplication sharedApplication].shortcutItems.count >= 3)
            return;
    }
    
    NSMutableArray *arrShortcutItem = (NSMutableArray *)[UIApplication sharedApplication].shortcutItems;
    
//    NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//
//    UIApplicationShortcutItem *shoreItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"HF_Share" localizedTitle:[NSString stringWithFormat:@"分享\"%@\"",app_Name] localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare] userInfo:nil];
//    [arrShortcutItem addObject:shoreItem1];
    
    if (@available(iOS 9.1, *)) {
        UIApplicationShortcutItem *shoreItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"HF_Scan" localizedTitle:@"扫批号" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCapturePhoto] userInfo:nil];
        [arrShortcutItem addObject:shoreItem2];
    }
    
    UIApplicationShortcutItem *shoreItem3 = [[UIApplicationShortcutItem alloc] initWithType:@"HF_Sign" localizedTitle:@"签到" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLocation] userInfo:nil];
    [arrShortcutItem addObject:shoreItem3];
    
    [UIApplication sharedApplication].shortcutItems = arrShortcutItem;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    //这里可以获的shortcutItem对象的唯一标识符
    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
    if (!TheUser.isLogin) {
        return;
    }
    if ([shortcutItem.type isEqualToString:@"HF_Share"]) {
        
    } else if ([shortcutItem.type isEqualToString:@"HF_Scan"]) {
        if ([Utils topViewController].navigationController) {
            QMYViewController *scan = [[QMYViewController alloc] init];
            scan.hidesBottomBarWhenPushed = YES;
            [scan initWithScanViewName: nil withScanLinaName:@"qrcode_Scan_weixin_Line" withPickureZoom:1];
            [[Utils topViewController].navigationController pushViewController:scan animated:YES];
        }
    } else if ([shortcutItem.type isEqualToString:@"HF_Sign"]) {
        if ([Utils topViewController].navigationController) {
            AttendanceViewCtrl *vc = [[AttendanceViewCtrl alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        }
    } else if ([shortcutItem.type isEqualToString:@"HF_Love"]) {
        if ([Utils topViewController].navigationController) {
//            MyFavoriteViewCtrl *vc = [[MyFavoriteViewCtrl alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)initUI {
    if (TheUser.isLogin) {
        [self jumpTpMainTabBarCtrl];
    }else{
        UIViewController *mainVC = self.window.rootViewController;
        if ([mainVC isKindOfClass:[MainTabBarViewController class]]) {
            for (int i = 0; i < ((MainTabBarViewController *)mainVC).viewControllers.count; i++) {
                UIViewController *vc = ((MainTabBarViewController *)mainVC).viewControllers[i];
                vc = nil;
            }
        }
        mainVC = nil;
        self.window.rootViewController = [[BaseNavigationCtrl alloc] initWithRootViewController:[LoginViewController new]];
        [self.window makeKeyAndVisible];
    }
}

- (void)jumpTpMainTabBarCtrl {
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    TIMLoginParam *param = [[TIMLoginParam alloc] init];
//    param.appidAt3rd = @(SDKAPPID);
//    param.identifier = TheUser.userMo.timIdentifier;
//    param.userSig = TheUser.userMo.tim_signature;
//
//    [[TIMManager sharedInstance] login:param succ:^{
//        [Utils dismissHUD];
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        NSData *deviceToken = delegate.deviceToken;
//        if (deviceToken) {
//            TIMTokenParam *param = [[TIMTokenParam alloc] init];
//            /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
//            //企业证书 ID
//            param.busiId = sdkBusiId;
//            [param setToken:deviceToken];
//            [[TIMManager sharedInstance] setToken:param succ:^{
//                NSLog(@"-----> 上传 token 成功 ");
//                //推送声音的自定义化设置
//                TIMAPNSConfig *config = [[TIMAPNSConfig alloc] init];
//                config.openPush = 1;
//                config.c2cSound = @"00.caf";
//                config.groupSound = @"01.caf";
//                [[TIMManager sharedInstance] setAPNS:config succ:^{
//                    NSLog(@"-----> 设置 APNS 成功");
//                } fail:^(int code, NSString *msg) {
//                    NSLog(@"-----> 设置 APNS 失败");
//                }];
//            } fail:^(int code, NSString *msg) {
//                NSLog(@"-----> 上传 token 失败 ");
//            }];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_IM_LOGIN_SUCCESS object:nil userInfo:nil];
//
//    } fail:^(int code, NSString *msg) {
//        [Utils dismissHUD];
//        [Utils showToastMessage:@"IM登陆失败"];
//    }];
    
    self.window.rootViewController = [[MainTabBarViewController alloc] init];
    TheUser.isLogin = YES;
}

- (void)loginSuccess:(NSNotification *)noti
{
    [ApiTool setToken:TheUser.userMo.id_token];
    [self jumpTpMainTabBarCtrl];
}

-(void)loginOtherDevice:(NSNotification *) noti
{
    [self loginOutSuccess:noti];
}

-(void) loginOutSuccess:(NSNotification *) noti
{
    [ApiTool setToken:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:APP_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_SIGN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SIGN_TYPE_DIC];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    TheUser.isLogin = NO;
    TheUser.userMo = nil;
    [self initUI];
    
    [[TIMManager sharedInstance] logout:^{
        NSLog(@"IM------->退出登录成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"IM------->退出登录失败");

    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        //不管有没有完成，结束 background_task 任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    //获取未读计数
    int unReadCount = 0;
    NSArray *convs = [[TIMManager sharedInstance] getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_SYSTEM){
            continue;
        }
        unReadCount += [conv getUnReadMessageNum];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
    
    //doBackground
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:unReadCount];
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        NSLog(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
    
    // 如果当前已经处于锁屏状态，则不去覆盖原先的时间
    BOOL isLocked = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOCKED] boolValue];
    if (!isLocked) {
        NSDate *enterBackgroundDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:enterBackgroundDate forKey:DATE_ENTER_BACKGROUND];
        NSLog(@"进入后台时间 %@", enterBackgroundDate);
    }
    // 进入后台清除缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[JYChatKit shareJYChatKit] jyApplicationWillEnterForeground:application];
    NSLog(@"即将进入前台");
    NSDate *backgroundTime = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_ENTER_BACKGROUND];
    NSDate *currentDate = [NSDate date];
    NSDate *timeInterval = [backgroundTime isKindOfClass:[NSDate class]] ?  [backgroundTime addTimeInterval:kBackGroundTime] : nil;
    NSLog(@"进入后台时间 %@", backgroundTime);
    NSLog(@"进入前台时间 %@", currentDate);
    NSLog(@"失效时间 %@", timeInterval);
    //开始时间和当前时间比较
    NSComparisonResult result = [currentDate compare:timeInterval];
    if (result == NSOrderedAscending) {  //升序
        // 不需要验证
    } else {
        // 需要验证
        BOOL isLockEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOCK_ENABLE] boolValue];
        if (isLockEnable) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SHOW_TOUCH_LOGIN object:nil];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[TIMManager sharedInstance] doForeground:^() {
        NSLog(@"doForegroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
    [self checkVersion];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *localUrl = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([localUrl containsString:@"action"]) {
        [OpenURLManager handleOpenURL:localUrl];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //IM
//    NSString* newToken = [deviceToken description];
//    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    NSString *title = nil;
//#if DEBUG
//    /**用户测试服务器*/
//    title = @"debug";
//#else
//    /**正式服务器*/
//    title = @"release";
//#endif
//
//    if (title.length != 0) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:newToken preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alert addAction:action1];
//        [[Utils topViewController] presentViewController:alert animated:YES completion:nil];
//    }
    
    [NSUserDefaults removeUserDefaultsWithKey:DEVICE_TOKEN];
    [NSUserDefaults setUserDefaultsWithKey:DEVICE_TOKEN data:deviceToken];
    [NSUserDefaults synchronize];
    NSLog(@"------> deviceToken %@", deviceToken);
    _deviceToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"register APNS fail.\nreason : %@", error);
}


/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"receive Notification");
    
//    [Utils commonDeleteTost:@"收到通知" msg:[NSString stringWithFormat:@"%@", userInfo] cancelTitle:nil confirmTitle:nil confirm:^{
//        [Utils dismissHUD];
//    } cancel:^{
//        [Utils dismissHUD];
//    }];
//    [[JYChatKit shareJYChatKit] jyApplication:application didReceiveRemoteNotification:userInfo];
}


/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"receive slient Notification");
    NSLog(@"userinfo %@", userInfo);
//    [Utils commonDeleteTost:@"静默推送" msg:[NSString stringWithFormat:@"%@", userInfo] cancelTitle:nil confirmTitle:nil confirm:^{
//        [Utils dismissHUD];
//    } cancel:^{
//        [Utils dismissHUD];
//    }];
//    [[JYChatKit shareJYChatKit] jyApplication:application didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"click notification");
    NSLog(@"userinfo %@", response.notification.request.content.userInfo);
    
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

- (void)registerAPNS {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        // iOS 8-9
        [self registerPush8to9];
    } else {
        // before iOS 8
        [self registerPushBefore8];
    }
#else
    if (sysVer < 8) {
        // before iOS 8
        [self registerPushBefore8];
    } else {
        // iOS 8-9
        [self registerPush8to9];
    }
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"注册成功");
        }
    }];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
        NSLog(@"%@", settings);
        
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush8to9{
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)registerPushBefore8{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


@end
