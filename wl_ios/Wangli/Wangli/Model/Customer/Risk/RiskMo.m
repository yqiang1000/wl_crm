//
//  RiskMo.m
//  Wangli
//
//  Created by yeqiang on 2018/5/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RiskMo.h"

@implementation RiskMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
