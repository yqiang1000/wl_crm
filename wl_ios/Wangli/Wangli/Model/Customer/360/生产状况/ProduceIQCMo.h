//
//  ProduceIQCMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProduceIQCMo : JSONModel

@property (nonatomic, assign) long long id;     //7,
@property (nonatomic, copy) NSString <Optional> *createdDate;     //1546769216915,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;     //1546769216915,
@property (nonatomic, copy) NSString <Optional> *createdBy;     //"1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;     //"1016078",
@property (nonatomic, copy) NSString <Optional> *result;     //"结果",
@property (nonatomic, strong) NSDictionary <Optional> *member;     //
@property (nonatomic, copy) NSString <Optional> *checkDate;     //"2019-01-06",
@property (nonatomic, copy) NSString <Optional> *memberFactory;     //"工厂",
@property (nonatomic, copy) NSString <Optional> *arrivalBatch;     //"6789",
@property (nonatomic, copy) NSString <Optional> *checkQuanity;     //10.00,
@property (nonatomic, copy) NSString <Optional> *outward;     //"外观好",
@property (nonatomic, copy) NSString <Optional> *elword;     //"EL好",
@property (nonatomic, copy) NSString <Optional> *pressure;     //"压力",
@property (nonatomic, copy) NSString <Optional> *pull;     //"拉力",
@property (nonatomic, copy) NSString <Optional> *lid;     //"LID",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;     //"silicon_factory",
@property (nonatomic, copy) NSString <Optional> *batteryTypeValue;
@property (nonatomic, copy) NSString <Optional> *finishedProductCode;     //"成品编码",
@property (nonatomic, copy) NSString <Optional> *sapinvoiceNumber;     //"12345",
@property (nonatomic, copy) NSString <Optional> *arrivalQuantity;     //50.00,
@property (nonatomic, copy) NSString <Optional> *efficiencyFile;     //"90",
@property (nonatomic, copy) NSString <Optional> *actualEfficient;     //"80"

@end

NS_ASSUME_NONNULL_END
