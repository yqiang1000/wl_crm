//
//  SalesImportMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/9.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SalesImportMo : JSONModel

@property (nonatomic, assign) long long id;
//@property (nonatomic, copy) NSString <Optional> *sort;    //  10,
@property (nonatomic, copy) NSString <Optional> *createdDate;    //  "2019-01-09 16:15:24",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    //  "2019-01-09 16:15:24",
@property (nonatomic, copy) NSString <Optional> *createdBy;    //  "杨建树",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    //  "杨建树",
@property (nonatomic, copy) NSString <Optional> *country;    //  "8999",
@property (nonatomic, copy) NSString <Optional> *dataResource;    //  "777",
@property (nonatomic, copy) NSString <Optional> *lastYearQ1S;    //  8.00,
@property (nonatomic, copy) NSString <Optional> *lastYearQ1D;    //  7766.00,
@property (nonatomic, copy) NSString <Optional> *lastYearQ2S;    //  4455.00,
@property (nonatomic, copy) NSString <Optional> *lastYearQ2D;    //  666.00,
@property (nonatomic, copy) NSString <Optional> *lastYearQ3S;    //  777.00,
@property (nonatomic, copy) NSString <Optional> *lastYearQ3D;    //  77.00,
@property (nonatomic, copy) NSString <Optional> *lastYearQ4S;    //  66.00,
@property (nonatomic, copy) NSString <Optional> *lastYearQ4D;    //  55.00,
@property (nonatomic, copy) NSString <Optional> *thisYearQ1S;    //  554433.00,
@property (nonatomic, copy) NSString <Optional> *thisYearQ1D;    //  44.00,
@property (nonatomic, copy) NSString <Optional> *thisYearQ2S;    //  4.00,
@property (nonatomic, copy) NSString <Optional> *thisYearQ2D;    //  44.00,
@property (nonatomic, copy) NSString <Optional> *thisYearQ3S;    //  44.00,
@property (nonatomic, copy) NSString <Optional> *thisYearQ3D;    //  5.00,
@property (nonatomic, copy) NSString <Optional> *thisYearQ4S;    //  55.00,
@property (nonatomic, copy) NSString <Optional> *thisYearQ4D;    //  4.00,
@property (nonatomic, copy) NSString <Optional> *nextYearQ1S;    //  44.00,
@property (nonatomic, copy) NSString <Optional> *nextYearQ1D;    //  44.00,
@property (nonatomic, copy) NSString <Optional> *nextYearQ2S;    //  44.00,
@property (nonatomic, copy) NSString <Optional> *nextYearQ2D;    //  45.00,
@property (nonatomic, copy) NSString <Optional> *nextYearQ3S;    //  55.00,
@property (nonatomic, copy) NSString <Optional> *nextYearQ3D;    //  55.00,
@property (nonatomic, copy) NSString <Optional> *nextYearQ4S;    //  444.00,
@property (nonatomic, copy) NSString <Optional> *nextYearQ4D;    //  55.00,
@property (nonatomic, strong) NSArray <Optional> *attachmentList;    //  [],
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;    //  "component_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;    //  "组件厂",
@property (nonatomic, copy) NSString <Optional> *productName;    //  "Powering",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *productType;    //  "Wipers"

@end

NS_ASSUME_NONNULL_END
