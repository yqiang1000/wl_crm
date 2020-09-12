//
//  SalesPriceMo.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "SalesPriceMo.h"

@implementation SalesPriceMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"market"]||
        [propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"customerPrice"])
        return YES;
    
    return NO;
}

@end
