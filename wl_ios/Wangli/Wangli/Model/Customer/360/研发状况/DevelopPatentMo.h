//
//  DevelopPatentMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevelopPatentMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *createdDate;    //;    // 1546841131591,
@property (nonatomic, copy) NSString <Optional> *createdBy;    // "1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    // "1016078",
@property (nonatomic, copy) NSString <Optional> *name;    // "Hello",
@property (nonatomic, copy) NSString <Optional> *content;    // "Shia like neirong",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *applyDate;    // "2019-01-08",
@property (nonatomic, copy) NSString <Optional> *issuedDate;    // "2019-01-09",
@property (nonatomic, copy) NSString <Optional> *statusValue;    // "已颁发",
@property (nonatomic, copy) NSString <Optional> *statusKey;    // "isuessed",
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;    // "battery_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;    // "电池厂"

@end

NS_ASSUME_NONNULL_END
