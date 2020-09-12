//
//  ProduceStandardMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/5.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "QiniuFileMo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QiniuFileMo;

@interface ProduceStandardMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *content;
@property (nonatomic, strong) NSMutableArray <QiniuFileMo *> <QiniuFileMo, Optional> *attachmentList;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;
@property (nonatomic, copy) NSString <Optional> *summary;
@property (nonatomic, copy) NSString <Optional> *infoDate;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *operator;

@end

NS_ASSUME_NONNULL_END
