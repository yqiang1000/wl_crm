//
//  BusinessReceptionMo.m
//  Wangli
//
//  Created by yeqiang on 2019/3/11.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BusinessReceptionMo.h"

@implementation BusinessReceptionMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"needPlanTicket"]||
        [propertyName isEqualToString:@"meetingNameplate"]||
        [propertyName isEqualToString:@"needCar"]||
        [propertyName isEqualToString:@"needHotel"]||
        [propertyName isEqualToString:@"needMeetingRoom"]||
        [propertyName isEqualToString:@"needMeal"]||
        [propertyName isEqualToString:@"needGift"]||
        [propertyName isEqualToString:@"needVisitWorkShop"])
        return YES;
    
    return NO;
}

@end
