//
//  TrendsBusinessMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/13.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBusinessMo.h"

@implementation TrendsBusinessMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"read"]||
        [propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
