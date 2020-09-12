//
//  BrandMo.m
//  Wangli
//
//  Created by yeqiang on 2019/5/31.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BrandMo.h"

@implementation BrandMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"])
        return YES;
    return NO;
}

@end
