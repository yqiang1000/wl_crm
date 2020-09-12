//
//  RetailChannelMo.h
//  Wangli
//
//  Created by yeqiang on 2019/4/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface RetailChannelMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *date;  //;  // "2019-04-19",
@property (nonatomic, copy) NSString <Optional> *afterSaleUnprocessed;  // "售后是想",
@property (nonatomic, copy) NSString <Optional> *cityNumber;  // "",
@property (nonatomic, copy) NSString <Optional> *activity;  // "哈哈哈活动",
@property (nonatomic, assign) CGFloat cumulativeShipments;  // 122,
@property (nonatomic, assign) CGFloat actualShipment;  // 1,
@property (nonatomic, copy) NSString <Optional> *remark;  // "其他备注",
@property (nonatomic, assign) CGFloat ompletionRate;  // 100.00,
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, strong) NSMutableArray <Optional> *retailChannelItems;
@property (nonatomic, copy) NSString <Optional> *cityName;  // null,
@property (nonatomic, copy) NSString <Optional> *areaName;  // "图木舒克市",
@property (nonatomic, copy) NSString <Optional> *provinceNumber;  // "820000",
@property (nonatomic, assign) BOOL finish;  // null,
@property (nonatomic, assign) long long id;  // 21,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-19 10:21:07",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *areaNumber;  // "659003",
@property (nonatomic, assign) CGFloat salesTarget;  // 123,
@property (nonatomic, copy) NSString <Optional> *sort;  // 10,
@property (nonatomic, assign) NSInteger expectVisit;  // 1,
@property (nonatomic, assign) NSInteger actualVisit;  // null,
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-19 10:21:07",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *provinceName;  // "澳门特别行政区",
@property (nonatomic, assign) CGFloat projectedShipment;  // 90
@property (nonatomic, copy) NSString <Optional> *province;
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@end

NS_ASSUME_NONNULL_END
