//
//  JinMuMenMo.h
//  Wangli
//
//  Created by yeqiang on 2019/6/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JinMuMenMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *date;
@property (nonatomic, copy) NSString <Optional> *province;//省份
@property (nonatomic, assign) CGFloat salesTarget;//当月销售目标
@property (nonatomic, assign) CGFloat cumulativeShipments;//当月累计发货量
@property (nonatomic, assign) CGFloat projectedShipment;//当日预计发货量
@property (nonatomic, assign) CGFloat actualShipment;//当日实际发货量
@property (nonatomic, assign) CGFloat ompletionRate;//月目标完成率
@property (nonatomic, assign) CGFloat expectVisit;//预计走访客户
@property (nonatomic, assign) CGFloat actualVisit;//实际走访客户
@property (nonatomic, assign) BOOL finish;//是否完成：true：完成。false：未完成
@property (nonatomic, assign) CGFloat developmentProject;//当月开发目标
@property (nonatomic, assign) CGFloat accumulateVisit;//当月累计拜访
@property (nonatomic, assign) CGFloat visitIntentional;//当日拜访意向客户
@property (nonatomic, assign) CGFloat finishVisit;//当日完成拜访
@property (nonatomic, assign) CGFloat completionRate;//月目标完成率
@property (nonatomic, assign) CGFloat signIntention;//当日签署意向客户
@property (nonatomic, assign) CGFloat actualSign;//当日实际签署
@property (nonatomic, assign) NSInteger followUpReportingProject;//报备工程跟进
@property (nonatomic, assign) NSInteger followUpUnfulfilledProject;//超期未履行工程跟进
@property (nonatomic, copy) NSString <Optional> *provinceName;//省份
@property (nonatomic, copy) NSString <Optional> *provinceNumber;
@property (nonatomic, copy) NSString <Optional> *cityName;//城市
@property (nonatomic, copy) NSString <Optional> *cityNumber;
@property (nonatomic, copy) NSString <Optional> *areaName;//区域
@property (nonatomic, copy) NSString <Optional> *areaNumber;
@property (nonatomic, copy) NSString <Optional> *remark;//其他
@property (nonatomic, copy) NSString <Optional> *remarkCompletion;
@property (nonatomic, copy) NSString <Optional> *afterSaleUnprocessed;//售后未处理事项
@property (nonatomic, copy) NSString <Optional> *activity;//活动
@property (nonatomic, copy) NSString <Optional> *developmentProvince;//省份
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;
@property (nonatomic, strong) NSMutableArray <Optional> *jinMuMenItems;//明细
@property (nonatomic, strong) NSMutableArray <Optional> *jmVisitIntentions;//拜访意向客户明细
@property (nonatomic, strong) NSMutableArray <Optional> *jmSignIntentions;//签署意向客户明细
@property (nonatomic, strong) NSMutableArray <Optional> *jmReportingProjects;//报备工程跟进
@property (nonatomic, strong) NSMutableArray <Optional> *jmUnfulfilledProjects;//未履行工程
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@end

NS_ASSUME_NONNULL_END
