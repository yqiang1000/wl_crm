//
//  PayPlanMo.m
//  Wangli
//
//  Created by yeqiang on 2018/6/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PayPlanMo.h"

@implementation PayPlanMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"quantity"]||
        [propertyName isEqualToString:@"adjustedQuantity"]||
        [propertyName isEqualToString:@"issuedQuantity"])
        return YES;
    
    return NO;
}

@end