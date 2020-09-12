//
//  LinkManDemandMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "LinkManDemandMo.h"

@implementation LinkManDemandMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"needFeedBack"])
        return YES;
    
    return NO;
}

@end
