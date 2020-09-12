//
//  RiskFollowMo.h
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DicMo.h"
#import "QiniuFileMo.h"

@protocol QiniuFileMo;
@protocol DicMo;

@interface RiskFollowMo : JSONModel

@property (nonatomic, copy) NSString<Optional> *iconUrl;
@property (nonatomic, assign) BOOL hasImgUrl;

@property (nonatomic, copy) NSString<Optional> *createdBy;
@property (nonatomic, copy) NSString<Optional> *createdDate;
@property (nonatomic, copy) NSString<Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString<Optional> *lastModifiedDate;
@property (nonatomic, assign) long long id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, strong) NSDictionary <Optional> *type;
@property (nonatomic, copy) NSString<Optional> *typeValue;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *riskManageComments;
@property (nonatomic, copy) NSString<Optional> *riskManageHandleDate;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString<Optional> *operator;
@property (nonatomic, strong) NSArray <QiniuFileMo *> <QiniuFileMo, Optional> *attachmentList;
@property (nonatomic, strong) NSArray <QiniuFileMo *> <QiniuFileMo, Optional> *attachments;

@property (nonatomic, strong) NSMutableArray <Optional> *arrImgs;

@property (nonatomic, strong) NSMutableArray <Optional> *arrUrls;

@property (nonatomic, strong) NSArray <Optional> *departmentVoList;
@property (nonatomic, copy) NSString <Optional> *childCategoryId;
@property (nonatomic, copy) NSString <Optional> *operatorName;
@property (nonatomic, copy) NSString <Optional> *url;

@end
