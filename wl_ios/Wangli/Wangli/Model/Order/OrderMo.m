//
//  OrderMo.m
//  Wangli
//
//  Created by yeqiang on 2018/4/20.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "OrderMo.h"

@implementation OrderMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"])
        return YES;
    
    return NO;
}


@end
