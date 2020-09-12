
//
//  DealPlanMo.m
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "DealPlanMo.h"

@implementation DealPlanMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"quantity"]||
        [propertyName isEqualToString:@"adjustedQuantity"]||
        [propertyName isEqualToString:@"issuedQuantity"]||
        [propertyName isEqualToString:@"showQuantity"])
        return YES;
    return NO;
}

@end
