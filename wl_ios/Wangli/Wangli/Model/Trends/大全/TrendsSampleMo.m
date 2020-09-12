//
//  TrendsSampleMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsSampleMo.h"

@implementation TrendsSampleMo

@end

@implementation SampleItemMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    return NO;
}

@end
