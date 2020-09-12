//
//  CountryMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/23.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CountryMo.h"

@implementation CountryMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    return NO;
}

@end
