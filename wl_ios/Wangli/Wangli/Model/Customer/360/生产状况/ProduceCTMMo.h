//
//  ProduceCTMMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProduceCTMMo : JSONModel

@property (nonatomic, assign) long long id;     //8,
@property (nonatomic, copy) NSString <Optional> *createdDate;     //1546769411552,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;     //1546769411552,
@property (nonatomic, copy) NSString <Optional> *createdBy;     //"1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;     //"1016078",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *putDate;     //"2019-01-06",
@property (nonatomic, copy) NSString <Optional> *productType;     //"产品类型",
@property (nonatomic, copy) NSString <Optional> *memberFactory;     //"工厂",
@property (nonatomic, copy) NSString <Optional> *arrivalBatch;     //"批次",
@property (nonatomic, copy) NSString <Optional> *remark;     //"备注",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *bom;     //"BOM",
@property (nonatomic, copy) NSString <Optional> *standardBoard;     //"组建标版",
@property (nonatomic, copy) NSString <Optional> *processType;     //"工艺类型",
@property (nonatomic, copy) NSString <Optional> *finishedCode;     //"陈编码",
@property (nonatomic, copy) NSString <Optional> *putCount;     //90.00,
@property (nonatomic, copy) NSString <Optional> *boardtype;     //"911",
@property (nonatomic, copy) NSString <Optional> *theoryPower;     //800.00,
@property (nonatomic, copy) NSString <Optional> *actualPower;     //877.00,
@property (nonatomic, copy) NSString <Optional> *ctm;     //"CTM",
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;     //"silicon_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;
@property (nonatomic, copy) NSString <Optional> *sapinvoiceNumber;     //"单号",
@property (nonatomic, copy) NSString <Optional> *batteryEfficient;     //"40"

@end

NS_ASSUME_NONNULL_END
