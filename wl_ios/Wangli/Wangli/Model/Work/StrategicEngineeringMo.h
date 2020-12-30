//
//  StrategicEngineeringMo.h
//  Wangli
//
//  Created by yeqiang on 2019/4/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface StrategicEngineeringMo : JSONModel

@property (nonatomic, assign) long long id;  // 18,
@property (nonatomic, assign) CGFloat salesTarget;  // 123,
@property (nonatomic, assign) CGFloat cumulativeShipments;  // 546,
@property (nonatomic, assign) CGFloat projectedShipment;  // 2
@property (nonatomic, assign) CGFloat actualShipment;  // 3,
@property (nonatomic, assign) NSInteger expectVisit;  // 1,
@property (nonatomic, assign) NSInteger actualVisit;  // 1,
@property (nonatomic, assign) CGFloat ompletionRate;  // 446.34,

@property (nonatomic, copy) NSString <Optional> *date;  //;  // "2019-04-25",
@property (nonatomic, copy) NSString <Optional> *cityNumber;  // null,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-25 14:21:36",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *areaNumber;  // null,
@property (nonatomic, copy) NSString <Optional> *remark;  // null,
@property (nonatomic, copy) NSString <Optional> *remarkCompletion;
@property (nonatomic, strong) NSMutableArray <Optional> *strategicEngineeringItems;  // [],
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-25 14:21:36",
@property (nonatomic, copy) NSString <Optional> *cityName;  // null,
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *areaName;  // null,
@property (nonatomic, copy) NSString <Optional> *provinceNumber;  // null,
@property (nonatomic, copy) NSString <Optional> *provinceName;  // null,
@property (nonatomic, copy) NSString <Optional> *province;
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@end

@interface StrategicEngineeringItemMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *constructionSite;  // "q",
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-25 14:21:36",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-25 14:21:36",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *achieveResults;  // "x",
@property (nonatomic, assign) long long id;  // 21,
@property (nonatomic, assign) BOOL visit;  // true

@end


NS_ASSUME_NONNULL_END
