//
//  JYWorkMo.h
//  Wangli
//
//  Created by yeqiang on 2019/8/27.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 工作计划

@interface JYWorkMo : JSONModel

@property (nonatomic, assign) NSInteger actualSign;//   1,
@property (nonatomic, assign) CGFloat cumulativeShipments;//   912,
@property (nonatomic, assign) CGFloat actualShipment;//   20,
@property (nonatomic, assign) CGFloat completionRate;//   2.44,
@property (nonatomic, assign) CGFloat ompletionRate;//   757.72,
@property (nonatomic, assign) BOOL finish;//   true,
@property (nonatomic, assign) long long id;//   3,
@property (nonatomic, assign) NSInteger visitIntentional;//   1,
@property (nonatomic, assign) NSInteger expectVisit;//   3,
@property (nonatomic, assign) CGFloat developmentProject;//   123,
@property (nonatomic, assign) CGFloat salesTarget;//   123,
@property (nonatomic, assign) NSInteger finishVisit;//   1,
@property (nonatomic, assign) NSInteger followUpReportingProject;//   "1",
@property (nonatomic, assign) NSInteger signIntention;//   1,
@property (nonatomic, assign) NSInteger actualVisit;//   1,
@property (nonatomic, assign) NSInteger accumulateVisit;//   2,
@property (nonatomic, assign) NSInteger followUpUnfulfilledProject;//   "1",
@property (nonatomic, assign) CGFloat projectedShipment;//   1

@property (nonatomic, copy) NSString <Optional> *date;//   "2019-05-08",
@property (nonatomic, copy) NSString <Optional> *afterSaleUnprocessed;//   "a",
@property (nonatomic, copy) NSString <Optional> *cityNumber;//   "640100",
@property (nonatomic, copy) NSString <Optional> *activity;//   "b",
@property (nonatomic, strong) NSMutableArray <Optional> *workPlanUnfulfilledProjects;
@property (nonatomic, copy) NSString <Optional> *remark;//   "aa",
@property (nonatomic, copy) NSString <Optional> *remarkCompletion;
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, strong) NSMutableArray <Optional> *workPlanVisitIntentions;
@property (nonatomic, strong) NSMutableArray <Optional> *workPlanSignIntentions;
@property (nonatomic, copy) NSString <Optional> *cityName;//   "银川市",
@property (nonatomic, copy) NSString <Optional> *areaName;//   "西夏区",
@property (nonatomic, copy) NSString <Optional> *provinceNumber;//   "640000",
@property (nonatomic, strong) NSMutableArray <Optional> *workPlanReportingProjects;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;//   "2019-05-08 18:36:56",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;//   "管理员",
@property (nonatomic, strong) NSMutableArray <Optional> *workPlanItems;
@property (nonatomic, copy) NSString <Optional> *areaNumber;//   "640105",
@property (nonatomic, copy) NSString <Optional> *createdDate;//   "2019-05-08 18:36:55",
@property (nonatomic, copy) NSString <Optional> *createdBy;//   "管理员",
@property (nonatomic, copy) NSString <Optional> *provinceName;//   "宁夏回族自治区",
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;
@property (nonatomic, copy) NSString <Optional> *province;
@property (nonatomic, copy) NSString <Optional> *developmentProvince;
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@property (nonatomic, copy) NSString <Optional> *workPlanType;

@end

#pragma mark - 走访客户

@interface JYWorkItemMo : JSONModel

@property (nonatomic, strong) NSDictionary <Optional> *memberAttribute;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;//   "2019-05-08 18:36:56",
@property (nonatomic, copy) NSString <Optional> *engineerProcessingMatters;//   工程处理事项,
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;//   "管理员",
@property (nonatomic, copy) NSString <Optional> *content;//   null,
@property (nonatomic, copy) NSString <Optional> *createdDate;//   "2019-05-08 18:36:56",
@property (nonatomic, copy) NSString <Optional> *createdBy;//   "管理员",
@property (nonatomic, strong) NSDictionary <Optional> *member;

@property (nonatomic, assign) BOOL policyProcessAdvocacy;//   政策引导,
@property (nonatomic, assign) BOOL monopoly;//   专卖,
@property (nonatomic, assign) BOOL comparativeSales;//   null,
@property (nonatomic, assign) long long id;//   57,
@property (nonatomic, assign) BOOL visit;//   null,
@property (nonatomic, assign) BOOL complete;//   null,
@property (nonatomic, assign) BOOL train;//   null

@property (nonatomic, strong) NSMutableArray <Optional> *attachments;

@end

#pragma mark - 报备工程跟进

@interface JYReportingProjectMo : JSONModel

@property (nonatomic, assign) long long id;  // 10,
@property (nonatomic, assign) BOOL followUp;  //;  // true,
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-25 14:43:24",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "刘锋",
@property (nonatomic, copy) NSString <Optional> *followUpResults;  // "u",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "刘锋",
@property (nonatomic, copy) NSString <Optional> *engineering;  // "i"

@end

#pragma mark - 未履行工程

@interface JYUnfulfilledProjectMo : JSONModel

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

#pragma mark - 拜访意向客户

@interface JYVisitIntentionMo : JSONModel

@property (nonatomic, assign) long long id;   //32,
@property (nonatomic, assign) CGFloat annualSalesVolume;   //2,
@property (nonatomic, assign) BOOL visit;   //false,
@property (nonatomic, copy) NSString <Optional> *createdDate;   //"2019-04-24 11:49:01",
@property (nonatomic, copy) NSString <Optional> *managementBrand;   //"u",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;   //"2019-04-24 11:49:01",
@property (nonatomic, copy) NSString <Optional> *createdBy;   //"刘锋",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;   //"刘锋",
@property (nonatomic, copy) NSString <Optional> *member;   //"q",
@property (nonatomic, copy) NSString <Optional> *cooperationIntention;   //"y"

@end

#pragma mark - 签署意向客户

@interface JYSignIntentionMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdDate;   //;   //"2019-04-24 11:49:01",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;   //"2019-04-24 11:49:01",
@property (nonatomic, copy) NSString <Optional> *createdBy;   //"刘锋",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;   //"刘锋",
@property (nonatomic, copy) NSString <Optional> *member;   //"mmm",
@property (nonatomic, assign) BOOL sign;   //true,
@property (nonatomic, assign) long long id;   //14,

@end

NS_ASSUME_NONNULL_END
