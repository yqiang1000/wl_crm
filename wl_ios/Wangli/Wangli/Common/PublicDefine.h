//
//  PublicDefine.h
//  Wangli
//
//  Created by yeqiang on 2018/3/22.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#ifndef PublicDefine_h
#define PublicDefine_h

typedef enum MyBtnType {
    MyBtnTypeDefault   = 0x001, //默认无
    MyBtnTypeBtn       = 0x010, //按钮
}MyBtnType;

#import "UIColor+ShortCut.h"
#import "YQCategorys.h"

//zhou.huifang@Wangli.com,AAaa1qaz

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

//#define language
#pragma mark - Font
#define SYSTEM_FONT(x)            [UIFont systemFontOfSize:x]
#define SYSTEM_FONT_BOLD(x)       [UIFont boldSystemFontOfSize:x]
//字体大小
#define FONT_F30                           SYSTEM_FONT(30)
#define FONT_F21                           SYSTEM_FONT(21)
#define FONT_F18                           SYSTEM_FONT(18)
#define FONT_F17                           SYSTEM_FONT(17)
#define FONT_F16                           SYSTEM_FONT(16)
#define FONT_F15                           SYSTEM_FONT(15)
#define FONT_F14                           SYSTEM_FONT(14)
#define FONT_F13                           SYSTEM_FONT(13)
#define FONT_F12                           SYSTEM_FONT(12)
#define FONT_F11                           SYSTEM_FONT(11)
#define FONT_F10                           SYSTEM_FONT(10)
#define FONT_F9                            SYSTEM_FONT(9)

#define FONT_COVER_TIME                   SYSTEM_FONT(25)


//圆角
#define BUTTON_RADIUS                     4.0

//object为空则为@""
#define STRING(object) ((object == nil || [object isEqual:[NSNull null]]) ? @"" : object)

#define GET_LANGUAGE_KEY(str)        NSLocalizedString(str,nil)        //中英文切换

//颜色
#pragma mark - Color

#define COLOR_HEX(x) [UIColor colorWithHexString:x];


// 覆盖色
#define COLOR_LINK [UIColor colorWithHexString:@"336699"]
#define COLOR_LINK1 [UIColor colorWithRed:76/255.0 green:90/255.0 blue:166/255.0 alpha:1]
#define COLOR_LINE [UIColor colorWithHexString:@"DDDDDD"]
// 背景颜色
#define COLOR_B0 [UIColor colorWithHexString:@"F2F3F6"]
// 一级标题往下 越来越淡
#define COLOR_B1 [UIColor colorWithHexString:@"282828"]
#define COLOR_B2 [UIColor colorWithHexString:@"888888"]
#define COLOR_B3 [UIColor colorWithHexString:@"BFBFBF"]
#define COLOR_B4 [UIColor colorWithHexString:@"FFFFFF"]

#define COLOR_F8F8F8 [UIColor colorWithHexString:@"F8F8F8"]
#define COLOR_000000 [UIColor colorWithHexString:@"000000"]


#define COLOR_BDBDBD [UIColor colorWithHexString:@"BDBDBD"]
// 风险转盘颜色 f27121,＃512da8,＃673ab7
#define COLOR_12C2E9 [UIColor colorWithHexString:@"12C2E9"]
#define COLOR_C471ED [UIColor colorWithHexString:@"C471ED"]
#define COLOR_F64F59 [UIColor colorWithHexString:@"F64F59"]
#define COLOR_EDEEF2 [UIColor colorWithHexString:@"EDEEF2"]
#define COLOR_DFE5EC [UIColor colorWithHexString:@"DFE5EC"]
#define COLOR_E6E6EA [UIColor colorWithHexString:@"E6E6EA"]


#define COLOR_A4A4A4 [UIColor colorWithHexString:@"A4A4A4"]
#define COLOR_EC675D [UIColor colorWithHexString:@"EC675D"]
#define COLOR_333333 [UIColor colorWithHexString:@"333333"]
#define COLOR_68C7A7 [UIColor colorWithHexString:@"68C7A7"]
#define COLOR_ED746C [UIColor colorWithHexString:@"ED746C"]
#define COLOR_597AF4 [UIColor colorWithHexString:@"597AF4"]
#define COLOR_E15465 [UIColor colorWithHexString:@"E15465"]
#define COLOR_1893D5 [UIColor colorWithHexString:@"1893D5"]
#define COLOR_1995D6 [UIColor colorWithHexString:@"1995D6"]
#define COLOR_CDCDCD [UIColor colorWithHexString:@"CDCDCD"]
#define COLOR_EEEEEE [UIColor colorWithHexString:@"EEEEEE"]
#define COLOR_F7F8F9 [UIColor colorWithHexString:@"F7F8F9"]
#define COLOR_FF6967 [UIColor colorWithHexString:@"FF6967"]

#define COLOR_4290F7 [UIColor colorWithHexString:@"4290F7"]
#define COLOR_627686 [UIColor colorWithHexString:@"627686"]
#define COLOR_8998A4 [UIColor colorWithHexString:@"8998A4"]
#define COLOR_EEF0F1 [UIColor colorWithHexString:@"EEF0F1"]
#define COLOR_F3F9FD [UIColor colorWithHexString:@"F3F9FD"]

#define COLOR_F2F3F5 [UIColor colorWithHexString:@"F2F3F5"]

#define COLOR_CECECE [UIColor colorWithHexString:@"CECECE"]
#define COLOR_E9E9E9 [UIColor colorWithHexString:@"E9E9E9"]

#define COLOR_0089D1 [UIColor colorWithHexString:@"0089D1"]
#define COLOR_336699 [UIColor colorWithHexString:@"336699"]

#define COLOR_C6C6C6 [UIColor colorWithHexString:@"C6C6C6"]
#define COLOR_50A9ED [UIColor colorWithHexString:@"50A9ED"]
#define COLOR_FBD35E [UIColor colorWithHexString:@"FBD35E"]
#define COLOR_F4F4F4 [UIColor colorWithHexString:@"F4F4F4"]
#define COLOR_2EAD5B [UIColor colorWithHexString:@"2EAD5B"]
#define COLOR_158ACF [UIColor colorWithHexString:@"158ACF"]
#define COLOR_0095DA [UIColor colorWithHexString:@"0095DA"]
#define COLOR_15A4F1 [UIColor colorWithHexString:@"15A4F1"]
#define COLOR_1D679D [UIColor colorWithHexString:@"1D679D"]
#define COLOR_F7CF6D [UIColor colorWithHexString:@"F7CF6D"]
#define COLOR_FFD778 [UIColor colorWithHexString:@"FFD778"]
#define COLOR_FFA300 [UIColor colorWithHexString:@"FFA300"]
#define COLOR_FE5A57 [UIColor colorWithHexString:@"FE5A57"]

#define COLOR_EDBB57 [UIColor colorWithHexString:@"EDBB57"]
#define COLOR_5BAAF9 [UIColor colorWithHexString:@"5BAAF9"]
#define COLOR_6BCE6C [UIColor colorWithHexString:@"6BCE6C"]
#define COLOR_ED7674 [UIColor colorWithHexString:@"ED7674"]




// 主色
#define COLOR_C1 [UIColor colorWithHexString:@"1793D4"]
#define COLOR_C2 [UIColor colorWithHexString:@"EC675D"]
#define COLOR_C3 [UIColor colorWithHexString:@"F4B74F"]


#define COLOR_0279E3 [UIColor colorWithHexString:@"0279E3"]
#define COLOR_62B2F9 [UIColor colorWithHexString:@"62B2F9"]
#define COLOR_E78A36 [UIColor colorWithHexString:@"E78A36"]
#define COLOR_CBCBCB [UIColor colorWithHexString:@"CBCBCB"]
#define COLOR_EAB201 [UIColor colorWithHexString:@"EAB201"]
#define COLOR_FF6A67 [UIColor colorWithHexString:@"FF6A67"]

#define COLOR_CLEAR [UIColor clearColor]

#define COLOR_MASK [UIColor colorWithWhite:0 alpha:0.4]

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

//#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)



//#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?(CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)): NO)

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
 (\
  CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
  ||\
  CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
  ||\
  CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
  ||\
  CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
 :\
 NO)

#define STATUS_BAR_HEIGHT (kDevice_Is_iPhoneX?44:20)

#define Height_NavContentBar 44.0f
#define Height_StatusBar ((kDevice_Is_iPhoneX==YES)?44.0f: 20.0f)

#define Height_NavBar    ((kDevice_Is_iPhoneX==YES)?88.0f: 64.0f)

#define Height_TabBar    ((kDevice_Is_iPhoneX==YES)?83.0f: 49.0f)

#define KMagrinBottom   ((kDevice_Is_iPhoneX==YES)?34.f : 0.f)

//通知ID
#pragma mark - Notification
#define NOTIFI_LOGIN_SUCCESS @"NOTIFICATION_LOGIN_SUCCESS"
#define NOTIFI_LOGOUT_SUCCESS @"NOTIFICATION_LOGOUT_SUCCESS"
#define NOTIFI_LOGIN_OTHER_DEVICE @"NOTIFI_LOGIN_OTHER_DEVICE"
#define NOTIFI_SHOW_TOUCH_LOGIN @"NOTIFI_SHOW_TOUCH_LOGIN"
#define NOTIFI_TOUCH_LOGIN_SUCCESS @"NOTIFI_TOUCH_LOGIN_SUCCESS"
#define NOTIFI_CONTACT_UPDATE @"NOTIFI_CONTACT_UPDATE"
#define NOTIFI_UPDATE_URL_SUCCESS @"NOTIFI_UPDATE_URL_SUCCESS"

#define NOTIFI_MEMBER_CHANGE_OPERATOR @"NOTIFI_MEMBER_CHANGE_OPERATOR"
#define NOTIFI_ORDER_LIST_REFRESH @"NOTIFI_ORDER_LIST_REFRESH"
#define NOTIFI_CLEAN_USED @"NOTIFI_CLEAN_USED"


// 客户360通知
#define NOTIFI_CUSTOMER_360_SCROLL @"NOTIFI_CUSTOMER_360_SCROLL"
#define NOTIFI_CUSTOMER_360_SELECT @"NOTIFI_CUSTOMER_360_SELECT"

#pragma mark - 字典中对应的Key

#define VERSION_NUM             @"VersionNum"
#define APP_COOKIES             @"AppCookies"
#define APP_TOKEN               @"AppToken"
#define USER_OACODE             @"USER_OACODE"
#define USER_OFFICENAME         @"USER_OFFICENAME"
#define USER_SIGN               @"USER_SIGN"
#define SIGN_TYPE_DIC           @"SIGN_TYPE_DIC"

// 是否处于锁屏状态
#define USER_LOCKED             @"USER_LOCKED"
// 是否设置锁屏密码
#define USER_LOCK_ENABLE        @"USER_LOCK_ENABLE"
// 锁屏密码
#define APP_LOCK_PASS           @"APP_LOCK_PASS"
// 是否设置touch解锁
#define USER_TOUCH_ENABLE       @"USER_TOUCH_ENABLE"
// 解锁错误次数
#define USER_WRONG_COUNT        @"USER_WRONG_COUNT"
#define DATE_ENTER_BACKGROUND   @"DATE_ENTER_BACKGROUND"

#define VERSION_CHECK_BEGINTIME @"VERSION_CHECK_BEGINTIME"

#define CURRENT_USER_ID         @"CURRENT_USER_ID"
#define USER_INFO               @"UserInfo"
#define PHONE_NUM               @"PhoneNumber"
#define USER_PASSWORD           @"Passwprd"
#define ISREMEBER_PWD           @"IsRememberPwd"
#define CLOUD_FILE              @"CloudFile"
#define DEBUG_FLAG              @"DEBUG_FLAG"
#define ISROBOT_FLAG            @"ISROBOT_FLAG"
#define LOGIN_IN_DEV            @"LOGIN_IN_DEV"
#define DEVICE_TOKEN            @"DEVICE_TOKEN"

#define MEMBER_CHOOSE           @"MEMBER_CHOOSE"
#define MEMBER_CHOOSE_SORT      @"MEMBER_CHOOSE_SORT"
#define MEMBER_CHOOSE_QUICK     @"MEMBER_CHOOSE_QUICK"
#define TASK_CHOOSE             @"TASK_CHOOSE"

#define RISK_LIST               @"RISK_LIST"
#define MARKET_LIST             @"MARKET_LIST"
#define PRODUCT_LIST            @"PRODUCT_LIST"
#define TRACK_LIST              @"TRACK_LIST"

#define USED_RECETENT           @"USED_RECETENT"
#define USED_TOTAL              @"USED_TOTAL"
#define CONTACT_RECENT          @"CONTACT_RECENT"


#define DIFF_TIMESTAMP  @"DIFF_TIMESTAMP"

#define kFirstRun @"firstRun"

#define kBackGroundTime 30


#define ALI_API_APPKEY  @"24858208"
#define ALI_API_APPSECRET  @"25a5c44f95aedac07407e4b0d6b05d04"



#ifdef DEBUG

#pragma mark ======================== 开发环境 ===========================

#define NLog(...)       NSLog(@"%s %s %s [Line %d] %s\n",__DATE__, __TIME__, __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#define Dealloc(...)    NLog(@"\n------dealloc-----%@\n",[NSString stringWithUTF8String:object_getClassName(__VA_ARGS__)])
#define NLogFunc        NLog(@"%s", __func__)

#else

#pragma mark ======================== 发布环境 ===========================

#define NLog(...)
#define Dealloc(...)
#define NLogFunc(...)

#endif

#pragma mark ======================== 通知 ===========================

#define NOTI_LOGIN_SUCCESS              @"NOTI_LOGIN_SUCCESS"
#define NOTI_LOGOUT_SUCCESS             @"NOTI_LOGOUT_SUCCESS"
#define NOTI_LOGIN_OTHER_DEVICE         @"NOTI_LOGIN_OTHER_DEVICE"
#define NOTI_SHOW_TOUCH_LOGIN           @"NOTI_SHOW_TOUCH_LOGIN"
#define NOTI_CLEAN_USED                 @"NOTI_CLEAN_USED"
#define NOTI_IM_LOGIN_SUCCESS           @"NOTI_IM_LOGIN_SUCCESS"
#define NOTI_CLEAN_USED                 @"NOTI_CLEAN_USED"
#define NOTI_CONTACT_UPDATE             @"NOTI_CONTACT_UPDATE"
#define NOTI_UPDATE_URL_SUCCESS         @"NOTI_UPDATE_URL_SUCCESS"
#define NOTI_CUSTOMER_360_SCROLL        @"NOTI_CUSTOMER_360_SCROLL"
#define NOTI_CUSTOMER_360_SELECT        @"NOTI_CUSTOMER_360_SELECT"
#define NOTI_MEMBER_CHANGE_OPERATOR     @"NOTI_MEMBER_CHANGE_OPERATOR"
#define NOTI_TOUCH_LOGIN_SUCCESS        @"NOTI_TOUCH_LOGIN_SUCCESS"

// 助手消息点击链接
#define NOTI_CELL_LINK_SELECT           @"NOTI_CELL_LINK_SELECT"

#pragma mark ======================== 缓存 ===========================

// 用户信息
#define USER_INFO                       @"USER_INFO"
// 用户token
#define USER_TOKEN                      @"USER_TOKEN"
// 用户user_login
#define USER_LOGIN                      @"USER_LOGIN"
// 用户Sign
#define USER_SIGN                       @"USER_SIGN"
// 用户officeName
#define USER_OFFICENAME                 @"USER_OFFICENAME"
// 是否处于锁屏状态
#define USER_LOCKED                     @"USER_LOCKED"
// 是否设置锁屏密码
#define USER_LOCK_ENABLE                @"USER_LOCK_ENABLE"
// 锁屏密码
#define APP_LOCK_PASS                   @"APP_LOCK_PASS"
// 是否设置touch解锁
#define USER_TOUCH_ENABLE               @"USER_TOUCH_ENABLE"
// 解锁错误次数
#define USER_WRONG_COUNT                @"USER_WRONG_COUNT"

#define DATE_ENTER_BACKGROUND           @"DATE_ENTER_BACKGROUND"
// 开始检查版本时间
#define VERSION_CHECK_BEGINTIME         @"VERSION_CHECK_BEGINTIME"
// 上次登陆的用户ID
#define CURRENT_USER_ID                 @"CURRENT_USER_ID"
// 设备token
#define DEVICE_TOKEN                    @"DEVICE_TOKEN"
// 最近联系人
#define CONTACT_RECENT                  @"CONTACT_RECENT"
// 客户筛选条件
#define MEMBER_CHOOSE           @"MEMBER_CHOOSE"
#define MEMBER_CHOOSE_SORT      @"MEMBER_CHOOSE_SORT"
#define MEMBER_CHOOSE_QUICK     @"MEMBER_CHOOSE_QUICK"

// 消息分类
#define IM_HELPER_TYPE_LIST             @"IM_HELPER_TYPE_LIST"
// 腾讯IM配置风格
#define IM_CONFIG_STYLE_LIST            @"IM_CONFIG_STYLE_LIST"
// 常用历史记录
#define USED_RECETENT                   @"USED_RECETENT"
// 常用所有的本地记录
#define USED_TOTAL                      @"USED_TOTAL"
// 用户搜索记录
#define CONTACT_RECENT                  @"CONTACT_RECENT"

#pragma mark ======================== 机型判断 ===========================

static inline BOOL isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

#define IS_IPhoneX_SERIES   isIPhoneXSeries()

#define IS_IPHONE6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark ======================== 尺寸、比例 ===========================

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define kStatusBarHeight        ((IS_IPhoneX_SERIES)?44.0f:20.0f)
#define kNavBarHeight           ((IS_IPhoneX_SERIES)?88.0f:64.0f)
#define kSafeAreaBottom         ((IS_IPhoneX_SERIES)?34.0f:0.0f)
#define kHeightTabBar           ((IS_IPhoneX_SERIES==YES)?83.0f: 49.0f)
#define kTabBarHeight           (kSafeAreaBottom+49)
#define kSafe_Bootom(x)         ((IS_IPhoneX_SERIES)?34.0f:x)

//以iphone6适配
#define FontAuto(Size)          roundf((Size) * (SCREEN_WIDTH/375.0f))
#define KScreenWidthRatio       (SCREEN_WIDTH/375.0)
#define KScreenHeightRatio      (SCREEN_HEIGHT/667.0)
#define AdaptedWidth(x)         roundf((x) * KScreenWidthRatio)
#define AdaptedHeight(x)        roundf((x) * KScreenHeightRatio)

#define SCREEN_RATE (SCREEN_WIDTH / 375.0)

#define DEVICE_VALUE(x) ((SCREEN_WIDTH / 375.0)*x)

#pragma mark ======================== 颜色 ===========================

//#define COLOR_CLEAR             (UIColor.clearColor)
#define YQ_COLOR(x)             ([UIColor colorWithRGB:x])
#define YQ_COLOR_A(x, a)        ([UIColor colorWithRGB:x alpha:a])

//// 覆盖色
//#define COLOR_LINK              YQ_COLOR(0x336699)
//#define COLOR_LINE              YQ_COLOR(0xDDDDDD)
//#define COLOR_MASK              YQ_COLOR_A(0x000000, 0.4)
//// 主色
//#define COLOR_C1                YQ_COLOR(0x1793D4)
//#define COLOR_C2                YQ_COLOR(0xEC675D)
//#define COLOR_C3                YQ_COLOR(0xF4B74F)
//// 背景颜色
//#define COLOR_B0                YQ_COLOR(0xF2F3F6)
//// 一级标题往下 越来越淡
//#define COLOR_B1                YQ_COLOR(0x282828)
//#define COLOR_B2                YQ_COLOR(0x888888)
//#define COLOR_B3                YQ_COLOR(0xBFBFBF)
//#define COLOR_B4                YQ_COLOR(0xFFFFFF)

#define Font_Regular(x)         ([UIFont pingFangSCWithWeight:PFFontWeightStyleRegular size:x])
#define Font_Medium(x)          ([UIFont pingFangSCWithWeight:PFFontWeightStyleMedium size:x])

#pragma mark ======================== 其他 ===========================

#define WS(weakSelf)            __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf)          __strong __typeof(&*weakSelf)strongSelf = weakSelf;
#define UIIMAGE(a)              [UIImage imageNamed:a]

#define App_Version             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define App_BundleId            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

#define STRING(object) ((object == nil || [object isEqual:[NSNull null]]) ? @"" : object)

#define GET_LANGUAGE_KEY(str)   NSLocalizedString(str,nil)        //中英文切换


#endif /* PublicDefine_h */
