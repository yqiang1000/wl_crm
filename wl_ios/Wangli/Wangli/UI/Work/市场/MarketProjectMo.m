//
//  MarketProjectMo.m
//  Wangli
//
//  Created by yeqiang on 2021/1/12.
//  Copyright © 2021 yeqiang. All rights reserved.
//

#import "MarketProjectMo.h"

@implementation MarketProjectMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"])
        return YES;
    
    return NO;
}

@end
