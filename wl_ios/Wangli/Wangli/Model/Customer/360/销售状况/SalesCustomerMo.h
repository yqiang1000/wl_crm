//
//  SalesCustomerMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/9.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SalesCustomerMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;    //"组件厂",
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;    //"component_factory",
@property (nonatomic, copy) NSString <Optional> *createdDate;    //"2019-01-22 07:36:42",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    //"2019-01-22 07:36:42",
@property (nonatomic, copy) NSString <Optional> *createdBy;    //"林玲",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    //"林玲",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *memberOfMember;
//@property (nonatomic, copy) NSString <Optional> *sort;    //10,
@property (nonatomic, strong) NSDictionary <Optional> *operator;

@property (nonatomic, copy) NSString <Optional> *productCount;
@property (nonatomic, copy) NSString <Optional> *purchaseCount;
@property (nonatomic, copy) NSString <Optional> *salesCount;

@end

@interface SubSalesCustomerMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *crmNumber;    //"200439",
@property (nonatomic, copy) NSString <Optional> *statusValue;    //"正式",
@property (nonatomic, copy) NSString <Optional> *srOperatorName;    //"曹康",
@property (nonatomic, copy) NSString <Optional> *office;    //null,
@property (nonatomic, copy) NSString <Optional> *creditLevelValue;    //"AAAAA",
@property (nonatomic, copy) NSString <Optional> *sapNumber;    //"200439",
@property (nonatomic, copy) NSString <Optional> *arOperatorName;    //"徐超",
@property (nonatomic, strong) NSDictionary <Optional> *frOperator;
@property (nonatomic, copy) NSString <Optional> *memberLevelValue;    //"战略",
@property (nonatomic, copy) NSString <Optional> *employeeSizeValue;    //"5-10",
@property (nonatomic, copy) NSString <Optional> *registeredCapital;    //5000.00,
@property (nonatomic, copy) NSString <Optional> *simpleSpell;    //"dfrs",
@property (nonatomic, copy) NSString <Optional> *statusKey;    //"formal",
@property (nonatomic, strong) NSDictionary <Optional> *srOperator;
@property (nonatomic, assign) long long id;    //5600,
@property (nonatomic, copy) NSString <Optional> *companyTypeValue;    //"有限责任公司分公司",
@property (nonatomic, copy) NSString <Optional> *orgName;    //"东方日升（常州）新能源有限公司",
@property (nonatomic, strong) NSDictionary <Optional> *arOperator;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    //"2019-01-22 01:52:17",
@property (nonatomic, copy) NSString <Optional> *avatarUrl;    //null,
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    //"费婷",
@property (nonatomic, copy) NSString <Optional> *riskLevelKey;    //null,
@property (nonatomic, copy) NSString <Optional> *creditModifyDate;    //null,
//@property (nonatomic, copy) NSString <Optional> *sort;    //10,
@property (nonatomic, copy) NSString <Optional> *abbreviation;    //"东方日升",
@property (nonatomic, copy) NSString <Optional> *customerDemand;    //"1",
@property (nonatomic, copy) NSString <Optional> *createdDate;    //"2019-01-21 20:41:45",
@property (nonatomic, copy) NSString <Optional> *createdBy;    //"系统自动创建",
@property (nonatomic, copy) NSString <Optional> *dealer;    //null,
@property (nonatomic, copy) NSString <Optional> *cooperationTypeValue;    //"直销",
@property (nonatomic, copy) NSString <Optional> *provinceName;    //"江苏省",
@property (nonatomic, copy) NSString <Optional> *riskLevelValue;    //null,
@property (nonatomic, copy) NSString <Optional> *frOperatorName;    //"秦光明"
@property (nonatomic, copy) NSString <Optional> *businessScope;

@end


NS_ASSUME_NONNULL_END
