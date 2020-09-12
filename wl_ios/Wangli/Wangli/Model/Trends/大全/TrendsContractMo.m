//
//  TrendsContractMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/14.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsContractMo.h"

@implementation TrendsContractMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"read"])
        return YES;
    
    return NO;
}

@end
