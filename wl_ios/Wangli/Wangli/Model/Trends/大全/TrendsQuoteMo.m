//
//  TrendsQuoteMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsQuoteMo.h"

@implementation TrendsQuoteDetailMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end


@implementation TrendsQuoteMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"read"])
        return YES;
    
    return NO;
}

@end
