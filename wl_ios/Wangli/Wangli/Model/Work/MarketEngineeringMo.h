//
//  MarkEngineeringMo.h
//  Wangli
//
//  Created by yeqiang on 2019/4/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketEngineeringMo : JSONModel

@property (nonatomic, assign) CGFloat actualShipment;  // 22,
@property (nonatomic, assign) CGFloat ompletionRate;  // 461.79,
@property (nonatomic, assign) long long id;  // 20,
@property (nonatomic, assign) NSInteger expectVisit;  // 1,
@property (nonatomic, assign) CGFloat salesTarget;  // 123,
@property (nonatomic, assign) NSInteger actualVisit;  // 1,
@property (nonatomic, assign) CGFloat projectedShipment;  // 2
@property (nonatomic, assign) CGFloat cumulativeShipments;  // 546,
@property (nonatomic, assign) NSInteger followUpReportingProject;  // null,
@property (nonatomic, assign) NSInteger followUpUnfulfilledProject;  // null,

@property (nonatomic, copy) NSString <Optional> *date;  // "2019-04-25",
@property (nonatomic, copy) NSString <Optional> *cityNumber;  // "640100",
@property (nonatomic, copy) NSString <Optional> *remark;  // null,
@property (nonatomic, copy) NSString <Optional> *remarkCompletion;
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *cityName;  // "银川市",
@property (nonatomic, copy) NSString <Optional> *areaName;  // "市辖区",
@property (nonatomic, strong) NSMutableArray <Optional> *unfulfilledProjects;  // [],
@property (nonatomic, strong) NSMutableArray <Optional> *marketEngineeringItems;  // [],
@property (nonatomic, strong) NSMutableArray <Optional> *reportingProjects;  // [],
@property (nonatomic, copy) NSString <Optional> *provinceNumber;  // "640000",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "刘锋",
@property (nonatomic, copy) NSString <Optional> *areaNumber;  // "640101",
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *provinceName;  // "宁夏回族自治区",
@property (nonatomic, copy) NSString <Optional> *province;
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@end

@interface MarketEngineeringItemMo : JSONModel

@property (nonatomic, assign) long long id;  // 14,
@property (nonatomic, assign) BOOL visit;  // true
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "刘锋",
@property (nonatomic, copy) NSString <Optional> *handlingMatters;  // "yyy",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "刘锋",
@property (nonatomic, strong) NSDictionary <Optional> *member;

@end

@interface ReportingProjectMo : JSONModel

@property (nonatomic, assign) long long id;  // 10,
@property (nonatomic, assign) BOOL followUp;  //;  // true,
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "刘锋",
@property (nonatomic, copy) NSString <Optional> *followUpResults;  // "u",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "刘锋",
@property (nonatomic, copy) NSString <Optional> *engineering;  // "i"

@end

@interface UnfulfilledProjectMo : JSONModel

@property (nonatomic, assign) long long id;  // 13,
@property (nonatomic, assign) BOOL effective;  // false,
@property (nonatomic, copy) NSString <Optional> *estimatedOrderTime;  // "2019-04-25",
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "刘锋",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "刘锋",
@property (nonatomic, copy) NSString <Optional> *reasonsNoPerformance;  // "g",
@property (nonatomic, copy) NSString <Optional> *engineering;  // "uu"

@end

NS_ASSUME_NONNULL_END
