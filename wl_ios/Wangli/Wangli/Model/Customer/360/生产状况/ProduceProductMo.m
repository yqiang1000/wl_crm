//
//  ProduceProductMo.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ProduceProductMo.h"

@implementation ProduceProductMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"sort"])
        return YES;
    
    return NO;
}

@end
