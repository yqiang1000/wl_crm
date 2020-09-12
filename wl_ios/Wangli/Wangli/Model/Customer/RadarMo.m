//
//  RadarMo.m
//  Wangli
//
//  Created by yeqiang on 2018/11/2.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RadarMo.h"

@implementation RadarMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {

    if ([propertyName isEqualToString:@"fieldValue"])
        return YES;

    return NO;
}

@end
