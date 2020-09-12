//
//  PurchaseAccessMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseAccessMo : JSONModel

@property (nonatomic, assign) long long id;
//@property (nonatomic, copy) NSString <Optional> *sort;        // 10,
@property (nonatomic, copy) NSString <Optional> *createdDate;        // 1547003436740,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, copy) NSString <Optional> *createdBy;        // "1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;        // "1016078",
@property (nonatomic, copy) NSString <Optional> *name;        // "Hahahha wenjian Ming",
@property (nonatomic, copy) NSString <Optional> *content;        // "Neirong a Cheshire",
@property (nonatomic, copy) NSString <Optional> *infoDate;        // "2019-01-12",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *typeKey;        // "research",
@property (nonatomic, copy) NSString <Optional> *typeValue;        // "研发",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *summary;        // "Zhaiyao",
@property (nonatomic, strong) NSMutableArray <Optional> *attachmentList;        // [],
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;        // "硅料厂"

@end

NS_ASSUME_NONNULL_END
