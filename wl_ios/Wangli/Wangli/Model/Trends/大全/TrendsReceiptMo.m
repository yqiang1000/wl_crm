//
//  TrendsReceiptMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/20.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsReceiptMo.h"

@implementation TrendsReceiptMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"read"])
        return YES;
    
    return NO;
}

@end
