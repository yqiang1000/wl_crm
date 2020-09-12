//
//  RowMaterialMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "QiniuFileMo.h"

@protocol QiniuFileMo;

@interface RowMaterialMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, strong) NSDictionary <Optional> *type;
@property (nonatomic, copy) NSString <Optional> *typeValue;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *annualPurchaseVolume;
@property (nonatomic, copy) NSString <Optional> *monthlyUsage;
@property (nonatomic, copy) NSString <Optional> *purchaseVolumeNextMonth;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSArray <QiniuFileMo *> <QiniuFileMo, Optional> *attachments;

@end
