//
//  TrendFeedItemMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendFeedItemMo.h"

@implementation TrendFeedItemMo


+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"index"]||
        [propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
