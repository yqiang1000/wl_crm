//
//  TheUserDefine.m
//  Wangli
//
//  Created by yeqiang on 2018/4/2.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TheUserDefine.h"

static TheUserDefine *instance;

@implementation TheUserDefine

+ (TheUserDefine *)shareInstance {
    static TheUserDefine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TheUserDefine alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 用户信息
        if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO]) {
            NSError *error = nil;
            _userMo = [[JYUserMo alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO] error:&error];
            [[NSUserDefaults standardUserDefaults] setObject:STRING(_userMo.department[@"name"]) forKey:USER_OFFICENAME];
            NSLog(@"%@",error);
        }
        // 锁屏是否可用
        _isLockEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOCK_ENABLE] boolValue];
        _isTouchEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOUCH_ENABLE] boolValue];
        
        // token是否可用
        if ([[NSUserDefaults standardUserDefaults] objectForKey:APP_TOKEN]) {
            [JYUserApi sharedInstance].token = [[NSUserDefaults standardUserDefaults] objectForKey:APP_TOKEN];
            _isLogin = _userMo != nil ? YES : NO;
            
            if (_isLogin) {
                
                // 获取时间
                NSDate *backgroundTime = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_ENTER_BACKGROUND];
                NSDate *currentDate = [NSDate date];
                NSDate *timeInterval = [backgroundTime isKindOfClass:[NSDate class]] ? [backgroundTime addTimeInterval:kBackGroundTime] : nil;
                //开始时间和当前时间比较
                NSComparisonResult result = [currentDate compare:timeInterval];
                
                if (result == NSOrderedAscending) {  //升序
                    // 不需要验证
                } else {
                    // 需要验证
                    BOOL isLockEnable = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_LOCK_ENABLE] boolValue];
                    if (isLockEnable) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SHOW_TOUCH_LOGIN object:nil];
                        });
                    }
                }
            }
        }
        
        _netState = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    }
    return self;
}

- (AFNetworkReachabilityStatus)currentNetState {
    _netState = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    return _netState;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
