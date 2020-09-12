
//
//  StrategicEngineeringMo.m
//  Wangli
//
//  Created by yeqiang on 2019/4/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "StrategicEngineeringMo.h"

@implementation StrategicEngineeringMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"salesTarget"]||
        [propertyName isEqualToString:@"cumulativeShipments"]||
        [propertyName isEqualToString:@"projectedShipment"]||
        [propertyName isEqualToString:@"actualShipment"]||
        [propertyName isEqualToString:@"expectVisit"]||
        [propertyName isEqualToString:@"actualVisit"]||
        [propertyName isEqualToString:@"ompletionRate"])
        return YES;
    return NO;
}

@end

@implementation StrategicEngineeringItemMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"visit"])
        return YES;
    return NO;
}

@end


