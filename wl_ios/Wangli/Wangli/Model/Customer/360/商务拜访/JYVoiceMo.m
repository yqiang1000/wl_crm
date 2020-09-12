//
//  JYVoiceMo.m
//  Wangli
//
//  Created by yeqiang on 2018/12/29.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "JYVoiceMo.h"

@implementation JYVoiceMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"secondCount"]||
        [propertyName isEqualToString:@"fileSize"])
        return YES;
    
    return NO;
}

@end
