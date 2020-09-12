//
//  DealPlanCollectionMo.m
//  Wangli
//
//  Created by yeqiang on 2018/7/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "DealPlanCollectionMo.h"

@implementation DealPlanCollectionMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"actualShipNumber"]||
        [propertyName isEqualToString:@"totalPlanQuantity"]||
        [propertyName isEqualToString:@"actualQuantity"])
        return YES;
    
    return NO;
}

@end
