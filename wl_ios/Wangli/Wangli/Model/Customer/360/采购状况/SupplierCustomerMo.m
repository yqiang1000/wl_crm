//
//  SupplierCustomerMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/22.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "SupplierCustomerMo.h"

@implementation SupplierCustomerMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end

@implementation SubSupplierMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end

