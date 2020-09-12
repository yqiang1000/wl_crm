//
//  GroupMo.m
//  Wangli
//
//  Created by yeqiang on 2018/5/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "GroupMo.h"

@implementation GroupMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"parentId"]||
        [propertyName isEqualToString:@"depth"]||
        [propertyName isEqualToString:@"expand"])
        return YES;
    
    return NO;
}

@end
