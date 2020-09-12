//
//  ChannelDevelopmentMo.m
//  Wangli
//
//  Created by yeqiang on 2019/4/24.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "ChannelDevelopmentMo.h"

@implementation ChannelDevelopmentMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"developmentProject"]||
        [propertyName isEqualToString:@"accumulateVisit"]||
        [propertyName isEqualToString:@"visitIntentional"]||
        [propertyName isEqualToString:@"finishVisit"]||
        [propertyName isEqualToString:@"ompletionRate"]||
        [propertyName isEqualToString:@"signIntention"]||
        [propertyName isEqualToString:@"actualSign"])
        return YES;
    return NO;
}

@end


@implementation VisitIntentionMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"annualSalesVolume"]||
        [propertyName isEqualToString:@"visit"])
        return YES;
    return NO;
}

@end

@implementation SignIntentionMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"sign"])
        return YES;
    return NO;
}

@end
