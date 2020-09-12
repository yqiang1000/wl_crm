//
//  TrendMarketActivityMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/14.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendMarketActivityMo : TrendsBaseMo

//@property (nonatomic, copy) NSString <Optional> *id;  // 50,
//@property (nonatomic, copy) NSString <Optional> *sort;  // 10,
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-01-14 15:50:57",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-01-14 15:50:58",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "何达能",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "何达能",
@property (nonatomic, copy) NSString <Optional> *content;  // "是打开快递反馈",
@property (nonatomic, strong) NSArray <Optional> *publishWaySet;
@property (nonatomic, copy) NSString <Optional> *approveStatus;  // "approvalInCrm",
@property (nonatomic, copy) NSString <Optional> *status;  // "draft",
@property (nonatomic, copy) NSString <Optional> *activityTypeKey;  // "media_event",
@property (nonatomic, strong) NSArray <Optional> *actualPeopleItemSet;  // [],
@property (nonatomic, copy) NSString <Optional> *approveStatusValue;  // "审批中",
@property (nonatomic, copy) NSString <Optional> *title;  // "活动动态测试1",
@property (nonatomic, copy) NSString <Optional> *endDate;  // "2019-01-14",
@property (nonatomic, copy) NSString <Optional> *statusValue;  // "草稿",
@property (nonatomic, copy) NSString <Optional> *beginDate;  // "2019-01-10",
@property (nonatomic, strong) NSArray <Optional> *attachmentList;  // [],
@property (nonatomic, strong) NSDictionary <Optional> *createOperator;
@property (nonatomic, strong) NSArray <Optional> *invitePeopleItemSet;  // [],
@property (nonatomic, copy) NSString <Optional> *activityTypeValue;  // "媒体活动",
@property (nonatomic, copy) NSString <Optional> *planPeopleCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *actualPeopleCount;  // 0,
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, strong) NSDictionary <Optional> *department;
@property (nonatomic, copy) NSString <Optional> *budgetAmount;  //;  // 1000,
@property (nonatomic, copy) NSString <Optional> *importantValue;  // "重要",
@property (nonatomic, copy) NSString <Optional> *importantKey;  // "important"

@end

NS_ASSUME_NONNULL_END
