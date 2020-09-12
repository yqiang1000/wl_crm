//
//  ProduceCapacityMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProduceCapacityMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;     //1016078",
@property (nonatomic, copy) NSString <Optional> *createdDate;     //2019-01-06",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;     //1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;     //2019-01-06",
@property (nonatomic, assign) long long id;     //5,
@property (nonatomic, strong) NSArray <Optional> *optionGroup;       //": [],
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;     //battery_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;     //": null,
@property (nonatomic, strong) NSDictionary <Optional> *member;      //": null,
@property (nonatomic, copy) NSString <Optional> *productType;     //类型",
@property (nonatomic, copy) NSString <Optional> *factoryName;     //工厂",
@property (nonatomic, copy) NSString <Optional> *workshop;     //车间",
@property (nonatomic, copy) NSString <Optional> *theoryYield;   //": 100.00,
@property (nonatomic, copy) NSString <Optional> *actualYield;       //": 40.00,
@property (nonatomic, copy) NSString <Optional> *infoDate;     //2019-01-06",
@property (nonatomic, copy) NSString <Optional> *remark;     //备注",
@property (nonatomic, strong) NSMutableArray <Optional> *attachmentList;    //": null,
@property (nonatomic, strong) NSDictionary <Optional> *operator;    //": null

@end

NS_ASSUME_NONNULL_END
