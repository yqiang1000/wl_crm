//
//  WeightMo.m
//  Wangli
//
//  Created by yeqiang on 2018/7/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "WeightMo.h"

@implementation WeightMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"enable"])
        return YES;

    return NO;
}


@end
