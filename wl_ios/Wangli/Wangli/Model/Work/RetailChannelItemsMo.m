//
//  RetailChannelItemsMo.m
//  Wangli
//
//  Created by yeqiang on 2019/4/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "RetailChannelItemsMo.h"

@implementation RetailChannelItemsMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"visit"]||
        [propertyName isEqualToString:@"monopoly"]||
        [propertyName isEqualToString:@"policyProcessAdvocacy"]||
        [propertyName isEqualToString:@"comparativeSales"]||
        [propertyName isEqualToString:@"complete"]||
        [propertyName isEqualToString:@"train"])
        return YES;
    return NO;
}

- (NSMutableArray<Optional> *)attachments {
    if (!_attachments) _attachments = [[NSMutableArray alloc] init];
    return _attachments;
}

@end
