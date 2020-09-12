//
//  ProduceFactoryMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProduceFactoryMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) long long id;
@property (nonatomic, strong) NSArray <Optional> *optionGroup;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *factoryName;   //;   //共仓",
@property (nonatomic, copy) NSString <Optional> *workshop;   //车间",
@property (nonatomic, copy) NSString <Optional> *equipmentTypeKey;   //battery_factory",
@property (nonatomic, copy) NSString <Optional> *equipmentTypeValue;    //": null,
@property (nonatomic, copy) NSString <Optional> *vendor;   //厂商",
@property (nonatomic, copy) NSString <Optional> *equipmentModel;   //knug",
@property (nonatomic, copy) NSString <Optional> *count;         //": 80,
@property (nonatomic, copy) NSString <Optional> *parameters;   //可口可乐了了了",
@property (nonatomic, strong) NSDictionary <Optional> *operator;

@end

NS_ASSUME_NONNULL_END
