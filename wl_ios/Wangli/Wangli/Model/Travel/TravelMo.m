//
//  TravelMo.m
//  Wangli
//
//  Created by yeqiang on 2019/4/28.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TravelMo.h"

@implementation TravelMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    return NO;
}

@end
