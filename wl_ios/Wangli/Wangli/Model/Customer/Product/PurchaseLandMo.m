//
//  PurchaseLandMo.m
//  Wangli
//
//  Created by yeqiang on 2018/11/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchaseLandMo.h"

@implementation PurchaseLandMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
