//
//  JYWorkMo.m
//  Wangli
//
//  Created by yeqiang on 2019/8/27.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "JYWorkMo.h"

#pragma mark - 工作计划

@implementation JYWorkMo

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

#pragma mark - 走访客户

@implementation JYWorkItemMo

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

#pragma mark - 报备工程跟进

@implementation JYReportingProjectMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"followUp"])
        return YES;
    return NO;
}

@end

#pragma mark - 未履行工程

@implementation JYUnfulfilledProjectMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"effective"])
        return YES;
    return NO;
}

@end

#pragma mark - 拜访意向客户

@implementation JYVisitIntentionMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"annualSalesVolume"]||
        [propertyName isEqualToString:@"visit"])
        return YES;
    return NO;
}

@end

#pragma mark - 签署意向客户

@implementation JYSignIntentionMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"sign"])
        return YES;
    return NO;
}

@end
