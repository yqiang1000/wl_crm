//
//  DicMo.m
//  Wangli
//
//  Created by yeqiang on 2018/6/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "DicMo.h"

@implementation DicMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"builtIn"]||
        [propertyName isEqualToString:@"cached"])
        return YES;
    
    return NO;
}

@end
