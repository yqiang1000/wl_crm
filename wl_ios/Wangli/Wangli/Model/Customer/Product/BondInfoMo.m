//
//  BondInfoMo.m
//  Wangli
//
//  Created by yeqiang on 2018/11/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BondInfoMo.h"

@implementation BondInfoMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"issuedPrice"])
        return YES;
    
    return NO;
}

@end
