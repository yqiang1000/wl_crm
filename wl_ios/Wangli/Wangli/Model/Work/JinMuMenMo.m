//
//  JinMuMenMo.m
//  Wangli
//
//  Created by yeqiang on 2019/6/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "JinMuMenMo.h"

@implementation JinMuMenMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"salesTarget"]||
        [propertyName isEqualToString:@"cumulativeShipments"]||
        [propertyName isEqualToString:@"projectedShipment"]||
        [propertyName isEqualToString:@"actualShipment"]||
        
        [propertyName isEqualToString:@"ompletionRate"]||
        [propertyName isEqualToString:@"expectVisit"]||
        [propertyName isEqualToString:@"actualVisit"]||
        [propertyName isEqualToString:@"finish"]||
        [propertyName isEqualToString:@"developmentProject"]||
        
        [propertyName isEqualToString:@"accumulateVisit"]||
        [propertyName isEqualToString:@"visitIntentional"]||
        [propertyName isEqualToString:@"finishVisit"]||
        [propertyName isEqualToString:@"completionRate"]||
        [propertyName isEqualToString:@"signIntention"]||
        
        [propertyName isEqualToString:@"followUpReportingProject"]||
        [propertyName isEqualToString:@"followUpUnfulfilledProject"]||
        [propertyName isEqualToString:@"actualSign"])
        return YES;
    return NO;
}

- (void)setAttachments:(NSMutableArray<Optional> *)attachments {
    NSError *error = nil;
    _attachments = [QiniuFileMo arrayOfModelsFromDictionaries:attachments error:&error];
}

@end
