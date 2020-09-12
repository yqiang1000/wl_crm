//
//  JYUserMo.m
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "JYUserMo.h"

@implementation Roles

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"builtIn"])
        return YES;
    
    return NO;
}

@end

@implementation JYUserMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"activated"]||
        [propertyName isEqualToString:@"parentId"]||
        [propertyName isEqualToString:@"depth"]||
        [propertyName isEqualToString:@"expand"])
        return YES;
    
    return NO;
}

- (void)setOaCode:(NSString<Optional> *)oaCode {
    _oaCode = oaCode;
}

@end
