//
//  TheUserDefine.h
//  Wangli
//
//  Created by yeqiang on 2018/4/2.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <JYIMKit/JYIMKit.h>

#import "AFHTTPSessionManager.h"

#define TheUser [TheUserDefine shareInstance]

@interface TheUserDefine : NSObject

@property (nonatomic, strong) JYUserMo *userMo;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isDebug;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) BOOL isLockEnable;
@property (nonatomic, assign) BOOL isTouchEnable;

@property (nonatomic, assign) AFNetworkReachabilityStatus netState;

+ (TheUserDefine *)shareInstance;

- (AFNetworkReachabilityStatus)currentNetState;

@end
