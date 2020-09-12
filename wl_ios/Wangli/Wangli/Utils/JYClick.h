//
//  JYClick.h
//  Wangli
//
//  Created by yeqiang on 2018/10/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYClick : NSObject

+ (JYClick *)shareInstance;

- (void)event:(NSString *)eventId;

- (void)event:(NSString *)eventId label:(NSString *)labelId;

- (void)clickFeild:(NSString *)feild special:(BOOL)special name:(NSString *)name key:(NSString *)key value:(NSString *)value;

@end
