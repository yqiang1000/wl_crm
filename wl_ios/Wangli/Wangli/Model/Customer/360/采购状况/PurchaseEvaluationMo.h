//
//  PurchaseEvaluationMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/9.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseEvaluationMo : JSONModel


@property (nonatomic, assign) long long id;
//@property (nonatomic, copy) NSString <Optional> *sort;    // 10,
@property (nonatomic, copy) NSString <Optional> *createdDate;    // 1547003436740,

@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  //"2019-01-09 11:11:08",
@property (nonatomic, copy) NSString <Optional> *createdBy;    // "杨建树",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    // "杨建树",
@property (nonatomic, copy) NSString <Optional> *name;    // "Lao. He wenjian Ming",
@property (nonatomic, copy) NSString <Optional> *content;    // "Neirong kaohe",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;    //"battery_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;    // "电池厂",
@property (nonatomic, strong) NSArray <Optional> *attachmentList;    // [],
@property (nonatomic, copy) NSString <Optional> *summary;    // "Zhaiyao.",
@property (nonatomic, copy) NSString <Optional> *typeValue;    // "生产",
@property (nonatomic, copy) NSString <Optional> *typeKey;    // "product",
@property (nonatomic, copy) NSString <Optional> *infoDate;    // "2019-01-05"

@end

NS_ASSUME_NONNULL_END
