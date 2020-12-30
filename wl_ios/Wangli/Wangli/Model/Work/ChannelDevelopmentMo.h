//
//  ChannelDevelopmentMo.h
//  Wangli
//
//  Created by yeqiang on 2019/4/24.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelDevelopmentMo : JSONModel

@property (nonatomic, assign) NSInteger actualSign;   //;   // 1,
@property (nonatomic, assign) NSInteger developmentProject;   // 123,
@property (nonatomic, assign) NSInteger finishVisit;   // 2,
@property (nonatomic, assign) CGFloat ompletionRate;   // 1.63,
@property (nonatomic, assign) NSInteger signIntention;   // 1,
@property (nonatomic, assign) NSInteger accumulateVisit;   // 443,
@property (nonatomic, assign) long long id;   // 16,
@property (nonatomic, assign) NSInteger visitIntentional;   // 3
@property (nonatomic, copy) NSString <Optional> *date;   // "2019-04-24",
@property (nonatomic, copy) NSString <Optional> *cityNumber;   // null,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;   // "2019-04-24 11:49:01",
@property (nonatomic, strong) NSMutableArray <Optional> *visitIntentions;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;   // "刘锋",
@property (nonatomic, copy) NSString <Optional> *areaNumber;   // null,
@property (nonatomic, copy) NSString <Optional> *remark;   // "mm",
@property (nonatomic, copy) NSString <Optional> *remarkCompletion;
@property (nonatomic, copy) NSString <Optional> *sort;   // 10,
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *createdDate;   // "2019-04-24 11:49:01",
@property (nonatomic, copy) NSString <Optional> *cityName;   // null,
@property (nonatomic, copy) NSString <Optional> *createdBy;   // "刘锋",
@property (nonatomic, copy) NSString <Optional> *areaName;   // null,
@property (nonatomic, strong) NSMutableArray <Optional> *signIntentions;
@property (nonatomic, copy) NSString <Optional> *provinceNumber;   // null,
@property (nonatomic, copy) NSString <Optional> *provinceName;   // null,
@property (nonatomic, copy) NSString <Optional> *province;
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@end


@interface VisitIntentionMo : JSONModel

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


@interface SignIntentionMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdDate;   //;   //"2019-04-24 11:49:01",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;   //"2019-04-24 11:49:01",
@property (nonatomic, copy) NSString <Optional> *createdBy;   //"刘锋",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;   //"刘锋",
@property (nonatomic, copy) NSString <Optional> *member;   //"mmm",
@property (nonatomic, assign) BOOL sign;   //true,
@property (nonatomic, assign) long long id;   //14,

@end

NS_ASSUME_NONNULL_END
