//
//  PurchaseCatalogMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseCatalogMo : JSONModel

@property (nonatomic, assign) long long id;        //;        // 5,
//@property (nonatomic, copy) NSString <Optional> *sort;        // 10,
@property (nonatomic, copy) NSString <Optional> *createdDate;        // 1547003405550,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;        // 1547003405550,
@property (nonatomic, copy) NSString <Optional> *createdBy;        // "1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;        // "1016078",
@property (nonatomic, copy) NSString <Optional> *productSpec;        // "Guide xinghao",
@property (nonatomic, copy) NSString <Optional> *monthQuantity;        // 90,
@property (nonatomic, copy) NSString <Optional> *productType;        // "Leixing.",
@property (nonatomic, strong) NSDictionary <Optional> *operator;        // {},
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *productName;        // "Champion mingcheng",
@property (nonatomic, copy) NSString <Optional> *seasonQuantity;        // 100,
@property (nonatomic, copy) NSString <Optional> *technologyDemand;        // "Joshua Yaqui",
@property (nonatomic, copy) NSString <Optional> *businessDemand;        // "Shang way yaoqiu",
@property (nonatomic, strong) NSArray <Optional> *attachmentList;        // [],
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;        // "battery_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;        // "电池厂"

@end

NS_ASSUME_NONNULL_END
