//
//  AddressMo.m
//  Wangli
//
//  Created by yeqiang on 2018/5/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "AddressMo.h"

@implementation AddressMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"defaults"])
        return YES;
    
    return NO;
}

@end
