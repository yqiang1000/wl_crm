//
//  ProduceStatusMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProduceStatusMo : JSONModel

@property (nonatomic, assign) long long id;     //7,
@property (nonatomic, copy) NSString <Optional> *createdDate;     //1546769345703,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;     //1546769345703,
@property (nonatomic, copy) NSString <Optional> *createdBy;     //"1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;     //"1016078",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *putDate;     //"2019-01-06",
@property (nonatomic, copy) NSString <Optional> *productType;     //"类型",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *finishedCode;     //"编码",
@property (nonatomic, copy) NSString <Optional> *bomInfo;     //"BOM",
@property (nonatomic, copy) NSString <Optional> *putFactory;     //"投产工厂",
@property (nonatomic, copy) NSString <Optional> *putBatch;     //"批次",
@property (nonatomic, copy) NSString <Optional> *outputCount;     //30.00,
@property (nonatomic, copy) NSString <Optional> *ydamageCount;     //8.00,
@property (nonatomic, copy) NSString <Optional> *ydamageRatio;     //9.00,
@property (nonatomic, copy) NSString <Optional> *gdamageCount;     //7.00,
@property (nonatomic, copy) NSString <Optional> *gdamageRatio;     //6.00,
@property (nonatomic, copy) NSString <Optional> *reworkCount;     //19.00,
@property (nonatomic, copy) NSString <Optional> *reworkRatio;     //29.00,
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;     //"battery_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;
@property (nonatomic, copy) NSString <Optional> *supervisionInfo;     //"监造",
@property (nonatomic, copy) NSString <Optional> *sapInoviceNumber;     //"缴获单",
@property (nonatomic, copy) NSString <Optional> *putBatteryCount;     //100.00,
@property (nonatomic, copy) NSString <Optional> *totalDamageCount;     //899.00,
@property (nonatomic, copy) NSString <Optional> *totalDamageRatio;     //399.00

@end

NS_ASSUME_NONNULL_END
