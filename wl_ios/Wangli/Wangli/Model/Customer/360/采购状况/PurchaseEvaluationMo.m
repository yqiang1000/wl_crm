//
//  PurchaseEvaluationMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/9.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "PurchaseEvaluationMo.h"

@implementation PurchaseEvaluationMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
