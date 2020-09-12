
//
//  DirectSalesEngineeringMo.m
//  Wangli
//
//  Created by yeqiang on 2019/4/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "DirectSalesEngineeringMo.h"

@implementation DirectSalesEngineeringMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"monthReceivedPayments"]||
        [propertyName isEqualToString:@"accumulatePayments"]||
        [propertyName isEqualToString:@"expectReceivedPayments"]||
        [propertyName isEqualToString:@"actualReceivedPayments"]||
        [propertyName isEqualToString:@"ompletionRate"]||
        [propertyName isEqualToString:@"expectVisit"]||
        [propertyName isEqualToString:@"actualVisit"])
        return YES;
    return NO;
}

@end

@implementation DirectSalesEngineeringItemMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"visit"])
        return YES;
    return NO;
}

@end
