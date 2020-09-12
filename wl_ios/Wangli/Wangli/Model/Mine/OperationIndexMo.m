
//
//  OperationIndexMo.m
//  Wangli
//
//  Created by yeqiang on 2018/6/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "OperationIndexMo.h"

@implementation OperationIndexMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"reward"]||
        [propertyName isEqualToString:@"level"]||
        [propertyName isEqualToString:@"demandPlan"]||
        [propertyName isEqualToString:@"demandActual"]||
        [propertyName isEqualToString:@"gatherPlan"]||
        [propertyName isEqualToString:@"gatherActual"])
        return YES;
    
    return NO;
}

@end
