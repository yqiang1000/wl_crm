//
//  HelpPersonMo.m
//  Wangli
//
//  Created by yeqiang on 2019/3/13.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "HelpPersonMo.h"

@implementation HelpPersonMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
