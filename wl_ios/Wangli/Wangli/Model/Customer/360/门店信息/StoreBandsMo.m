//
//  StoreBandsMo.m
//  Wangli
//
//  Created by 杜文杰 on 2019/7/15.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "StoreBandsMo.h"

@implementation StoreBandsMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
