//
//  ProductInfoMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "QiniuFileMo.h"

@protocol QiniuFileMo;

@interface ProductInfoMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *category;
@property (nonatomic, copy) NSString <Optional> *categoryValue;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, strong) NSDictionary <Optional> *ingredient;
@property (nonatomic, copy) NSString <Optional> *ingredientValue;
@property (nonatomic, strong) NSDictionary <Optional> *yarn;
@property (nonatomic, copy) NSString <Optional> *yarnValue;
@property (nonatomic, strong) NSDictionary <Optional> *weight;
@property (nonatomic, copy) NSString <Optional> *weightValue;
@property (nonatomic, strong) NSDictionary <Optional> *dyeingTechnology;
@property (nonatomic, copy) NSString <Optional> *dyeingTechnologyValue;
@property (nonatomic, strong) NSDictionary <Optional> *qualityStandard;
@property (nonatomic, copy) NSString <Optional> *qualityStandardValue;
@property (nonatomic, strong) NSDictionary <Optional> *popularElement;
@property (nonatomic, copy) NSString <Optional> *popularElementValue;
@property (nonatomic, strong) NSDictionary <Optional> *applicableSession;
@property (nonatomic, copy) NSString <Optional> *applicableSessionValue;
@property (nonatomic, strong) NSDictionary <Optional> *printStyle;
@property (nonatomic, copy) NSString <Optional> *printStyleValue;
@property (nonatomic, strong) NSDictionary <Optional> *color;
@property (nonatomic, copy) NSString <Optional> *colorValue;
@property (nonatomic, strong) NSDictionary <Optional> *marketExpectation;
@property (nonatomic, copy) NSString <Optional> *marketExpectationValue;
@property (nonatomic, copy) NSString <Optional> *customerGroup;
@property (nonatomic, copy) NSString <Optional> *marketReferencePrice;
@property (nonatomic, strong) NSArray <QiniuFileMo *> <QiniuFileMo, Optional> *attachments;

@property (nonatomic, copy) NSString <Optional> *finishedDoor;
@property (nonatomic, strong) NSDictionary <Optional> *factory;

@end
