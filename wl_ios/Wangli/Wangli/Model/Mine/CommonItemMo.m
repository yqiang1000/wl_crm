//
//  CommonItemMo.m
//  Wangli
//
//  Created by yeqiang on 2018/4/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "CommonItemMo.h"

@implementation CommonItemMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"itemId"]||
        [propertyName isEqualToString:@"statisticsCount"])
        return YES;
    
    return NO;
}

@end
