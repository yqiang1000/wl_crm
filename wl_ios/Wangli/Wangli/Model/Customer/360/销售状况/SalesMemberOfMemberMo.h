//
//  SalesMemberOfMemberMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/9.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SalesMemberOfMemberMo : JSONModel

@property (nonatomic, assign) long long id;
//@property (nonatomic, copy) NSString <Optional> *sort;    // 1,
@property (nonatomic, copy) NSString <Optional> *createdDate;    // "2018-12-29 18:25:37",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    // "2019-01-08 17:48:59",
@property (nonatomic, copy) NSString <Optional> *createdBy;    // "系统自动创建",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    // "系统自动创建",
@property (nonatomic, copy) NSString <Optional> *cooperationTypeValue;    // "直销",
@property (nonatomic, copy) NSString <Optional> *memberLevelValue;    // "",
@property (nonatomic, copy) NSString <Optional> *employeeSizeValue;    // "",
@property (nonatomic, copy) NSString <Optional> *companyTypeValue;    // "",
@property (nonatomic, copy) NSString <Optional> *customerDemand;    // "",
@property (nonatomic, copy) NSString <Optional> *creditModifyDate;    // 0,
@property (nonatomic, copy) NSString <Optional> *registeredCapital;    // 0,
@property (nonatomic, strong) NSDictionary <Optional> *office;    // {},
@property (nonatomic, copy) NSString <Optional> *riskLevelKey;    // "",
@property (nonatomic, copy) NSString <Optional> *abbreviation;    // "NEELAM",
@property (nonatomic, copy) NSString <Optional> *orgName;    // "Neelam Holdings Limited",
@property (nonatomic, copy) NSString <Optional> *statusValue;    // "正式",
@property (nonatomic, copy) NSString <Optional> *crmNumber;    // "100037",
@property (nonatomic, copy) NSString <Optional> *sapNumber;    // "100037",
@property (nonatomic, copy) NSString <Optional> *provinceName;    // "",
@property (nonatomic, copy) NSString <Optional> *statusKey;    // "formal",
@property (nonatomic, copy) NSString <Optional> *arOperatorName;    // "未分配",
@property (nonatomic, copy) NSString <Optional> *frOperatorName;    // "未分配",
@property (nonatomic, copy) NSString <Optional> *srOperatorName;    // "未分配",
@property (nonatomic, copy) NSString <Optional> *creditLevelValue;    // "",
@property (nonatomic, copy) NSString <Optional> *riskLevelValue;    // "",
@property (nonatomic, strong) NSDictionary <Optional> *dealer;    // {},
@property (nonatomic, copy) NSString <Optional> *simpleSpell;    // "NEELAM"
@property (nonatomic, copy) NSString <Optional> *businessScope;
@property (nonatomic, copy) NSString <Optional> *avatarUrl;

@end

NS_ASSUME_NONNULL_END
