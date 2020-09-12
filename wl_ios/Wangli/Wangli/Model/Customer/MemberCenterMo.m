
//
//  MemberCenterMo.m
//  Wangli
//
//  Created by yeqiang on 2018/6/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MemberCenterMo.h"

//@implementation ContenBeansMo
//
//+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    
//    if ([propertyName isEqualToString:@"dueAmount"]||
//        [propertyName isEqualToString:@"totalAmount"])
//        return YES;
//    
//    return NO;
//}
//
//@end

@implementation MemberCenterMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"linkManCount"]||
        [propertyName isEqualToString:@"warningCount"]||
        [propertyName isEqualToString:@"procurementStatusCount"]||
        [propertyName isEqualToString:@"productStatusCount"]||
        [propertyName isEqualToString:@"salesStatusCount"]||
        
        [propertyName isEqualToString:@"researchStatusCount"]||
        [propertyName isEqualToString:@"businessVisitCount"]||
        [propertyName isEqualToString:@"businessChanceCount"]||
        [propertyName isEqualToString:@"contractCount"]||
        [propertyName isEqualToString:@"serviceComplaintCount"]||
        
        [propertyName isEqualToString:@"costAnalysisCount"]||
        [propertyName isEqualToString:@"favorite"]||
        [propertyName isEqualToString:@"riskShip"]||
        [propertyName isEqualToString:@"stormeManageCount"]||
        [propertyName isEqualToString:@"dealerPlanCount"]||
        
        [propertyName isEqualToString:@"contractSumMonth"]||
        [propertyName isEqualToString:@"orderSumMounth"]||
        [propertyName isEqualToString:@"billingSumMonth"]||
        [propertyName isEqualToString:@"receivedSumMonth"]||
        [propertyName isEqualToString:@"contractShip"]||
        [propertyName isEqualToString:@"orderShip"]||
        [propertyName isEqualToString:@"billingShip"]||
        [propertyName isEqualToString:@"receivedShip"])
        return YES;
    
    return NO;
}

- (void)setRiskWarnings:(NSArray<RiskFollowMo *><RiskFollowMo,Optional> *)riskWarnings {
    NSError *error = nil;
    _riskWarnings = (NSArray<RiskFollowMo *><RiskFollowMo,Optional> *)[RiskFollowMo arrayOfModelsFromDictionaries:riskWarnings error:&error];
    
//    NSLog(@"%@", error);
}


- (void)setIntelligenceItemBeans:(NSArray<IntelligenceItemBeanMo *><IntelligenceItemBeanMo,Optional> *)intelligenceItemBeans {
    NSError *error = nil;
    _intelligenceItemBeans = (NSArray<IntelligenceItemBeanMo *><IntelligenceItemBeanMo,Optional> *)[IntelligenceItemBeanMo arrayOfModelsFromDictionaries:intelligenceItemBeans error:&error];
//    NSLog(@"%@", error);
}

//- (void)setContenBeans:(NSArray<ContenBeansMo *><ContentBeansMo,Optional> *)contenBeans {
//    NSError *error = nil;
//    _contenBeans = (NSArray<ContenBeansMo *><ContentBeansMo,Optional> *)[ContenBeansMo arrayOfModelsFromDictionaries:contenBeans error:&error];
//
//    NSLog(@"%@", error);
//}

@end
