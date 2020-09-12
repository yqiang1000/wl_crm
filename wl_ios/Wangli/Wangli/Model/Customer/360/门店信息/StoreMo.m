//
//  StoreMo.m
//  Wangli
//
//  Created by yeqiang on 2019/4/29.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "StoreMo.h"

@implementation StoreMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
