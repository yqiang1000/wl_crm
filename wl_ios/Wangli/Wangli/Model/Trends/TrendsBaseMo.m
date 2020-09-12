//
//  TrendsBaseMo.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

@implementation TrendsBaseMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"read"])
        return YES;
    
    return NO;
}


@end
