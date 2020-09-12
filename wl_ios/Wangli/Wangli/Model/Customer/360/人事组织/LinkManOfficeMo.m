
//
//  LinkManOfficeMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/3.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "LinkManOfficeMo.h"

@implementation LinkManOfficeMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"totalCount"]||
        [propertyName isEqualToString:@"memberId"]||
        [propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"parentOfficeId"]||
        [propertyName isEqualToString:@"depth"]||
        [propertyName isEqualToString:@"expand"])
        return YES;
    
    return NO;
}

@end
