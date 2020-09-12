
//
//  DealerMo.m
//  Wangli
//
//  Created by yeqiang on 2019/4/28.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "DealerMo.h"

@implementation DealerMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"november"]||
        [propertyName isEqualToString:@"octoberToNovember"]||
        [propertyName isEqualToString:@"april"]||
        [propertyName isEqualToString:@"totalForTheWholeYear"]||
        
        [propertyName isEqualToString:@"julyToSeptember"]||
        [propertyName isEqualToString:@"september"]||
        [propertyName isEqualToString:@"dealerType"]||
        [propertyName isEqualToString:@"may"]||
        [propertyName isEqualToString:@"august"]||

        [propertyName isEqualToString:@"januaryToJune"]||
        [propertyName isEqualToString:@"february"]||
        [propertyName isEqualToString:@"july"]||
        [propertyName isEqualToString:@"march"]||
        [propertyName isEqualToString:@"june"]||
        
        [propertyName isEqualToString:@"january"]||
        [propertyName isEqualToString:@"october"])
        return YES;
    
    return NO;
}

@end
