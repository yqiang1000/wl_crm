//
//  MarketEngineeringMo.m
//  Wangli
//
//  Created by yeqiang on 2019/4/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "MarketEngineeringMo.h"

@implementation MarketEngineeringMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"salesTarget"]||
        [propertyName isEqualToString:@"projectedShipment"]||
        [propertyName isEqualToString:@"actualShipment"]||
        [propertyName isEqualToString:@"ompletionRate"]||
        [propertyName isEqualToString:@"expectVisit"]||
        [propertyName isEqualToString:@"cumulativeShipments"]||
        [propertyName isEqualToString:@"followUpReportingProject"]||
        [propertyName isEqualToString:@"followUpUnfulfilledProject"]||
        [propertyName isEqualToString:@"actualVisit"])
        return YES;
    return NO;
}

@end

@implementation MarketEngineeringItemMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"visit"])
        return YES;
    return NO;
}

@end

@implementation ReportingProjectMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"followUp"])
        return YES;
    return NO;
}

@end

@implementation UnfulfilledProjectMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"effective"])
        return YES;
    return NO;
}

@end
