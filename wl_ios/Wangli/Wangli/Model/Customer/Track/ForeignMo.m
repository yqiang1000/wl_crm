//
//  ForeignMo.m
//  Wangli
//
//  Created by yeqiang on 2018/6/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ForeignMo.h"

@implementation ForeignMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"])
        return YES;
    
    return NO;
}

@end