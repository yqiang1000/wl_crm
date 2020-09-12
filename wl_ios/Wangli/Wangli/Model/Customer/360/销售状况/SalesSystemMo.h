//
//  SalesSystemMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/9.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SalesSystemMo : JSONModel

@property (nonatomic, assign) long long id;
//@property (nonatomic, copy) NSString <Optional> *sort;    //  10,
@property (nonatomic, copy) NSString <Optional> *createdDate;    //  "2019-01-09 15:15:19",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    //  "2019-01-09 15:15:19",
@property (nonatomic, copy) NSString <Optional> *createdBy;    //  "杨建树",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    //  "杨建树",
@property (nonatomic, copy) NSString <Optional> *content;    //  "Neirong",
@property (nonatomic, copy) NSString <Optional> *fileName;    //  "Wenjian Miami",
@property (nonatomic, strong) NSArray <Optional> *attachmentList;    //  [],
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;    //  "battery_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;    //  "电池厂",
@property (nonatomic, copy) NSString <Optional> *summary;    //  "Zhaiyao.",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *infoDate;    //  "2019-01-11",
@property (nonatomic, copy) NSString <Optional> *fileTypeValue;    //  "研发",
@property (nonatomic, copy) NSString <Optional> *fileTypeKey;    //  "research"

@end

NS_ASSUME_NONNULL_END
