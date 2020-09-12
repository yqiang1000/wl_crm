//
//  WorthBeanMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "WorthBeanMo.h"

@implementation WorthBeanMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"type"]||
        [propertyName isEqualToString:@"isTitle"]||
        [propertyName isEqualToString:@"isText"])
        return YES;
    return NO;
}

@end
