//
//  UsedMo.m
//  Wangli
//
//  Created by yeqiang on 2018/6/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "UsedMo.h"

@implementation UsedMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"sort"])
        return YES;
    
    return NO;
}

@end



@implementation TabUsedMo

@end
