//
//  PurchaseItemMo.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchaseItemMo.h"

@implementation PurchaseItemMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"count"]||
        [propertyName isEqualToString:@"newCount"]||
        [propertyName isEqualToString:@"fieldTitle"])
        return YES;
    
    return NO;
}

@end
