//
//  CustDeptMo.m
//  Wangli
//
//  Created by yeqiang on 2018/9/19.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CustDeptMo.h"

@implementation CustDeptMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"zeroToAccount"]||
        [propertyName isEqualToString:@"accountToNinety"]||
        [propertyName isEqualToString:@"moreThanNinety"]||
        [propertyName isEqualToString:@"owedTotalAmount"]||
        [propertyName isEqualToString:@"quantity"]||
        [propertyName isEqualToString:@"receivedAmount"]||
        [propertyName isEqualToString:@"planTotalAmount"])
        return YES;
    
    return NO;
}

@end
