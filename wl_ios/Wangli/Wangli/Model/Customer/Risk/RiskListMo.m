//
//  RiskListMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RiskListMo.h"

@implementation RiskListMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"count"]||
        [propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
