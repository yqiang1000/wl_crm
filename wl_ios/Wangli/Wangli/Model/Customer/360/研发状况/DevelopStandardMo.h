//
//  DevelopStandardMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevelopStandardMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, strong) NSArray <Optional> *optionGroup;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;       //;       //"battery_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;       //"电池厂",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *typeKey;       //"research",
@property (nonatomic, copy) NSString <Optional> *typeValue;       //"研发",
@property (nonatomic, copy) NSString <Optional> *summary;       //"Zhaoyao",
@property (nonatomic, copy) NSString <Optional> *content;       //"Neirong content",
@property (nonatomic, copy) NSString <Optional> *infoDate;       //"2019-01-08",
@property (nonatomic, strong) NSArray <Optional> *attachmentList;       //[],
@property (nonatomic, strong) NSDictionary <Optional> *operator;

@end

NS_ASSUME_NONNULL_END
