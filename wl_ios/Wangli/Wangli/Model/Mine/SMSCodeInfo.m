
//
//  SMSCodeInfo.m
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "SMSCodeInfo.h"


static dispatch_source_t _timer;

@implementation SMSCodeInfo

- (void)getSMSCode:(NSString *)strPhone success:(void (^)(NSString *))success fail:(void (^)(NSError *))fail {
    [[JYUserApi sharedInstance] getSMSCodeByMobile:strPhone success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"OK"]) {
            if (success) {
                success(responseObject);
            }
        }
    } failure:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 开启倒计时效果
- (void)startCountDown {
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    if (!_isCancel) {
        dispatch_source_set_event_handler(_timer, ^{
            
            if(time <= 0) { //倒计时结束，关闭
                
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (_smsCodeInfoDelegate && [_smsCodeInfoDelegate respondsToSelector:@selector(smsCodeInfo:timeValue:)]) {
                        [_smsCodeInfoDelegate smsCodeInfo:self timeValue:0];
                    }
                });
                
            } else {
                
                int seconds = time % 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (_smsCodeInfoDelegate && [_smsCodeInfoDelegate respondsToSelector:@selector(smsCodeInfo:timeValue:)]) {
                        NSLog(@"----%d", seconds);
                        [_smsCodeInfoDelegate smsCodeInfo:self timeValue:seconds];
                    }
                });
                time--;
            }
        });
    } else {
        if (_smsCodeInfoDelegate && [_smsCodeInfoDelegate respondsToSelector:@selector(smsCodeInfo:timeValue:)]) {
            [_smsCodeInfoDelegate smsCodeInfo:self timeValue:0];
        }
    }
    dispatch_resume(_timer);
}


// 结束倒计时
- (void)stopCountDown {
    _isCancel = YES;
}

@end
