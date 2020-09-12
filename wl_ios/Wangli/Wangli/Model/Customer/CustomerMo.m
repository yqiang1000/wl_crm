
//
//  CustomerMo.m
//  Wangli
//
//  Created by yeqiang on 2018/5/2.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "CustomerMo.h"

@implementation TagMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"isSelect"])
        return YES;
    
    return NO;
}

@end

@implementation AuthorityBean

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"base"]||
        [propertyName isEqualToString:@"linkMan"]||
        [propertyName isEqualToString:@"financialRisk"]||
        [propertyName isEqualToString:@"procurementStatus"]||
        [propertyName isEqualToString:@"productionStatus"]||
        
        [propertyName isEqualToString:@"salesStatus"]||
        [propertyName isEqualToString:@"developmentStatus"]||
        [propertyName isEqualToString:@"businessVisit"]||
        [propertyName isEqualToString:@"businessFollow"]||
        [propertyName isEqualToString:@"contractTracking"]||
        
        [propertyName isEqualToString:@"serviceComplaint"]||
        [propertyName isEqualToString:@"topFlag"]||
        [propertyName isEqualToString:@"system"]||
        [propertyName isEqualToString:@"costAnalysis"])
        return YES;
    
    return NO;
}

@end


@implementation CustomerMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"accountPeriod"]||
//        [propertyName isEqualToString:@"credit"]||
        [propertyName isEqualToString:@"registeredCapital"]||
        [propertyName isEqualToString:@"maxDueDays"]||
        
        [propertyName isEqualToString:@"salesmanId"]||
        [propertyName isEqualToString:@"officeId"]||
        [propertyName isEqualToString:@"memberRelease"]||
        [propertyName isEqualToString:@"transfer"]||
        [propertyName isEqualToString:@"claim"]||
        [propertyName isEqualToString:@"lastTransactionDayCount"]||
        [propertyName isEqualToString:@"owedTotalAmount"]||
        [propertyName isEqualToString:@"dueTotalAmount"]||
        [propertyName isEqualToString:@"badDebt"]||
        [propertyName isEqualToString:@"memberId"]||
        
        [propertyName isEqualToString:@"linkManTotalCount"]||
        [propertyName isEqualToString:@"operatorId"]||
        
        [propertyName isEqualToString:@"arId"]||
        [propertyName isEqualToString:@"frId"]||
        [propertyName isEqualToString:@"srId"])
        
        return YES;
    
    return NO;
}


+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"memberRelease":@"release",
                                                                  }];
}

- (void)setMemberId:(long long)memberId {
    _memberId = memberId;
    _id = _memberId;
}


@end
