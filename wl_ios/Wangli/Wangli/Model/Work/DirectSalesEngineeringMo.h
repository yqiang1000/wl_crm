//
//  DirectSalesEngineeringMo.h
//  Wangli
//
//  Created by yeqiang on 2019/4/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DirectSalesEngineeringMo : JSONModel

@property (nonatomic, assign) long long id;  // 13,
@property (nonatomic, assign) CGFloat monthReceivedPayments;  // 123.00,
@property (nonatomic, assign) CGFloat accumulatePayments;  // 423.00,
@property (nonatomic, assign) CGFloat expectReceivedPayments;  // 0.00,
@property (nonatomic, assign) CGFloat actualReceivedPayments;  // 0.00,
@property (nonatomic, assign) CGFloat ompletionRate;  // 0.00,
@property (nonatomic, assign) NSInteger expectVisit;  // 1,
@property (nonatomic, assign) NSInteger actualVisit;  // 1,

@property (nonatomic, copy) NSString <Optional> *date;  //;  // "2019-04-25",
@property (nonatomic, copy) NSString <Optional> *cityNumber;  // null,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-25 13:59:45",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "管理员",
@property (nonatomic, strong) NSMutableArray <Optional> *directSalesEngineeringItems;  // [],
@property (nonatomic, copy) NSString <Optional> *areaNumber;  // null,
@property (nonatomic, copy) NSString <Optional> *remark;  // null,
@property (nonatomic, strong) NSDictionary <Optional> *operator;  // ,
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-25 13:59:45",
@property (nonatomic, copy) NSString <Optional> *cityName;  // null,
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *areaName;  // null,
@property (nonatomic, copy) NSString <Optional> *provinceNumber;  // null,
@property (nonatomic, copy) NSString <Optional> *provinceName;  // null
@property (nonatomic, copy) NSString <Optional> *province;
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@end

@interface DirectSalesEngineeringItemMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-25 13:59:45",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-25 13:59:45",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *project;  // "2",
@property (nonatomic, copy) NSString <Optional> *achieveResults;  // "i",
@property (nonatomic, assign) long long id;  // 16,
@property (nonatomic, assign) BOOL visit;  // true

@end

NS_ASSUME_NONNULL_END
