//
//  SalesPriceMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SalesPriceMo : JSONModel

@property (nonatomic, assign) long long id;
//@property (nonatomic, copy) NSString <Optional> *sort;    //  10,
@property (nonatomic, copy) NSString <Optional> *createdDate;    //  "2019-01-09 15:14:55",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    //  "2019-01-09 15:14:55",
@property (nonatomic, copy) NSString <Optional> *createdBy;    //  "杨建树",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    //  "杨建树",
@property (nonatomic, copy) NSString <Optional> *unitPrice;    //  90.00,
@property (nonatomic, strong) NSArray <Optional> *attachmentList;    //  [],
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;    //  "battery_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;    //  "电池厂",
@property (nonatomic, copy) NSString <Optional> *priceMaintenance;    //  80.00,
@property (nonatomic, copy) NSString <Optional> *productName;    //  "Chan pin mingcheng",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *endDate;    //  "2019-01-12",
@property (nonatomic, copy) NSString <Optional> *productType;    //  "Champion leixing",
@property (nonatomic, copy) NSString <Optional> *startDate;    //  "2019-01-10"

@end

NS_ASSUME_NONNULL_END
