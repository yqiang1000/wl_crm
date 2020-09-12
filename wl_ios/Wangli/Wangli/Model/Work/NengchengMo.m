//
//  NengchengMo.m
//  Wangli
//
//  Created by yeqiang on 2019/5/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "NengchengMo.h"

@implementation NengchengMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"actualSign"]||
        [propertyName isEqualToString:@"cumulativeShipments"]||
        [propertyName isEqualToString:@"actualShipment"]||
        [propertyName isEqualToString:@"completionRate"]||
        
        [propertyName isEqualToString:@"ompletionRate"]||
        [propertyName isEqualToString:@"finish"]||
        [propertyName isEqualToString:@"visitIntentional"]||
        [propertyName isEqualToString:@"expectVisit"]||
        [propertyName isEqualToString:@"developmentProject"]||
        
        [propertyName isEqualToString:@"salesTarget"]||
        [propertyName isEqualToString:@"finishVisit"]||
        [propertyName isEqualToString:@"followUpReportingProject"]||
        [propertyName isEqualToString:@"signIntention"]||
        [propertyName isEqualToString:@"actualVisit"]||
        
        [propertyName isEqualToString:@"accumulateVisit"]||
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

@implementation NengChengItemMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"policyProcessAdvocacy"]||
        [propertyName isEqualToString:@"monopoly"]||
        [propertyName isEqualToString:@"comparativeSales"]||
        [propertyName isEqualToString:@"visit"]||
        [propertyName isEqualToString:@"complete"]||
        [propertyName isEqualToString:@"train"])
        return YES;
    return NO;
}

@end
