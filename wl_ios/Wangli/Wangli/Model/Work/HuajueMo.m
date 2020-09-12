//
//  HuajueMo.m
//  Wangli
//
//  Created by yeqiang on 2019/5/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "HuajueMo.h"

@implementation HuajueMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"cumulativeShipments"]||
        [propertyName isEqualToString:@"actualShipment"]||
        [propertyName isEqualToString:@"ompletionRate"]||
        [propertyName isEqualToString:@"finish"]||
        
        [propertyName isEqualToString:@"expectVisit"]||
        [propertyName isEqualToString:@"salesTarget"]||
        [propertyName isEqualToString:@"followUpReportingProject"]||
        [propertyName isEqualToString:@"actualVisit"]||
        [propertyName isEqualToString:@"followUpUnfulfilledProject"]||
        
        [propertyName isEqualToString:@"projectedShipment"])
        return YES;
    return NO;
}

- (void)setAttachments:(NSMutableArray<Optional> *)attachments {
    NSError *error = nil;
    _attachments = [QiniuFileMo arrayOfModelsFromDictionaries:attachments error:&error];
}

@end
