//
//  RetailChannelMo.m
//  Wangli
//
//  Created by yeqiang on 2019/4/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "RetailChannelMo.h"

@implementation RetailChannelMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"salesTarget"]||
        [propertyName isEqualToString:@"projectedShipment"]||
        [propertyName isEqualToString:@"cumulativeShipments"]||
        [propertyName isEqualToString:@"ompletionRate"]||
        [propertyName isEqualToString:@"expectVisit"]||
        [propertyName isEqualToString:@"actualVisit"]||
        [propertyName isEqualToString:@"finish"]||
        [propertyName isEqualToString:@"actualShipment"])
        return YES;
    return NO;
}

- (void)setAttachments:(NSMutableArray<Optional> *)attachments {
    NSError *error = nil;
    _attachments = [QiniuFileMo arrayOfModelsFromDictionaries:attachments error:&error];
}


@end
