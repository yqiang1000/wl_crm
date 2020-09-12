
//
//  QueryAddressMo.m
//  Wangli
//
//  Created by yeqiang on 2019/9/9.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "QueryAddressMo.h"

@implementation QueryAddressMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
