//
//  ContactMo.m
//  Wangli
//
//  Created by yeqiang on 2018/5/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ContactMo.h"

@implementation ContactMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"important"]||
        [propertyName isEqualToString:@"incumbency"])
        return YES;
    
    return NO;
}

@end
