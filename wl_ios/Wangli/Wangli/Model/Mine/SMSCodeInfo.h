//
//  SMSCodeInfo.h
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMSCodeInfo;
@protocol SMSCodeInfoDelegate <NSObject>

@optional

- (void)smsCodeInfo:(SMSCodeInfo *)codeInfo timeValue:(int)value;

@end

@interface SMSCodeInfo : NSObject

//获取验证码倒计时
@property (nonatomic, assign) BOOL isCancel;        //是否停止
@property (nonatomic, weak) id<SMSCodeInfoDelegate> smsCodeInfoDelegate;

//获得验证码
- (void)getSMSCode:(NSString *)strPhone
           success:(void (^)(NSString *code))success
              fail:(void (^)(NSError *error))fail;

//开始倒计时60s
- (void)startCountDown;
- (void)stopCountDown;

@end
