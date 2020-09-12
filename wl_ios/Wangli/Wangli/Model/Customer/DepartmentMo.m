//
//  DepartmentMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/16.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "DepartmentMo.h"

@implementation DepartmentMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"approval"]||
        [propertyName isEqualToString:@"totalCount"]||
        [propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"subDepartmentCount"]||
        [propertyName isEqualToString:@"checked"])
        return YES;
    return NO;
}

@end
