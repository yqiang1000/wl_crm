//
//  PurchaseCatalogMo.m
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchaseCatalogMo.h"

@implementation PurchaseCatalogMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
