//
//  HuajueMo.h
//  Wangli
//
//  Created by yeqiang on 2019/5/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuajueMo : JSONModel

@property (nonatomic, assign) CGFloat cumulativeShipments;//   932,
@property (nonatomic, assign) CGFloat actualShipment;//   100,
@property (nonatomic, assign) CGFloat ompletionRate;//   839.02,
@property (nonatomic, assign) BOOL finish;//   true,
@property (nonatomic, assign) long long id;//   1,
@property (nonatomic, assign) NSInteger expectVisit;//   4,
@property (nonatomic, assign) CGFloat salesTarget;//   123,
@property (nonatomic, assign) NSInteger followUpReportingProject;//   "10",
@property (nonatomic, assign) NSInteger actualVisit;//   1,
@property (nonatomic, assign) NSInteger followUpUnfulfilledProject;//   "100",
@property (nonatomic, assign) CGFloat projectedShipment;//   50

@property (nonatomic, copy) NSString <Optional> *date;//   "2019-05-08",
@property (nonatomic, copy) NSString <Optional> *afterSaleUnprocessed;//   "售后未处理事项",
@property (nonatomic, copy) NSString <Optional> *cityNumber;//   "110100",
@property (nonatomic, copy) NSString <Optional> *areaNumber;//   "110113",
@property (nonatomic, copy) NSString <Optional> *activity;//   "活动",
@property (nonatomic, copy) NSString <Optional> *remark;//   "111",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *cityName;//   "市辖区",
@property (nonatomic, copy) NSString <Optional> *areaName;//   "顺义区",
@property (nonatomic, copy) NSString <Optional> *provinceNumber;//   "110000",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;//   "2019-05-08 19:23:16",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;//   "管理员",
@property (nonatomic, strong) NSMutableArray <Optional> *hjReportingProjects;
@property (nonatomic, strong) NSMutableArray <Optional> *huaJueItems;
@property (nonatomic, copy) NSString <Optional> *createdDate;//   "2019-05-08 19:23:15",
@property (nonatomic, copy) NSString <Optional> *createdBy;//   "管理员",
@property (nonatomic, copy) NSString <Optional> *provinceName;//   "北京市",
@property (nonatomic, strong) NSMutableArray <Optional> *hjUnfulfilledProjects;
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;
@property (nonatomic, copy) NSString <Optional> *province;
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@end

NS_ASSUME_NONNULL_END
