//
//  LinkManBusinessMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "LinkManBusinessMo.h"

@implementation LinkManBusinessMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"favorited"]||
        [propertyName isEqualToString:@"viewed"]||
        [propertyName isEqualToString:@"viewedCount"]||
        [propertyName isEqualToString:@"liked"]||
        [propertyName isEqualToString:@"likedCount"])
        return YES;
    
    return NO;
}

@end
