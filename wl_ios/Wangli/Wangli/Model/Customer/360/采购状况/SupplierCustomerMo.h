//
//  SupplierCustomerMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/22.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SupplierCustomerMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *salesCount;    //;    //1,
@property (nonatomic, copy) NSString <Optional> *typeKey;    //"wafer",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    //"2019-01-22 06:29:30",
@property (nonatomic, copy) NSString <Optional> *purchaseCount;    //5,
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    //"曹康",
@property (nonatomic, copy) NSString <Optional> *sort;    //10,
@property (nonatomic, copy) NSString <Optional> *productCount;    //1,
@property (nonatomic, copy) NSString <Optional> *operator;    //null,
@property (nonatomic, copy) NSString <Optional> *createdDate;    //"2019-01-22 06:29:30",
@property (nonatomic, copy) NSString <Optional> *createdBy;    //"曹康",
@property (nonatomic, strong) NSDictionary <Optional> *supplier;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *rank;    //14,
@property (nonatomic, copy) NSString <Optional> *typeValue;    //null,
@property (nonatomic, assign) long long id;    //42
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;

@end

@interface SubSupplierMo : JSONModel

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
@property (nonatomic, copy) NSString <Optional> *sort;    //10,
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


