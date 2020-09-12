//
//  NSString+YQCategorys.m
//  HangGuo
//
//  Created by yeqiang on 2020/1/22.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "NSString+YQCategorys.h"

@implementation NSString (YQCategorys)

/// 去掉首位空格
- (NSString *)withOutSpace {
    if (self && [self isKindOfClass:[NSString class]]) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return @"";
}

/// 判断字符串不为空
- (BOOL)isAvailable {
    if(self && [self isKindOfClass:[NSString class]] && [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0){
        return YES;
    }
    return NO;
}

@end
