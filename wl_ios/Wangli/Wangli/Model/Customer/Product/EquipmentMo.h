//
//  EquipmentMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "QiniuFileMo.h"

@protocol QiniuFileMo;
@interface EquipmentMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *factory;
@property (nonatomic, strong) NSDictionary <Optional> *field;
@property (nonatomic, copy) NSString <Optional> *fieldValue;
@property (nonatomic, strong) NSDictionary <Optional> *type;
@property (nonatomic, copy) NSString <Optional> *typeValue;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *quantity;
@property (nonatomic, copy) NSString <Optional> *remark;
@property (nonatomic, copy) NSString <Optional> *brands;
@property (nonatomic, copy) NSString <Optional> *size;
@property (nonatomic, copy) NSString <Optional> *purchaseYears;
@property (nonatomic, strong) NSArray <QiniuFileMo *> <QiniuFileMo, Optional> *attachments;

@property (nonatomic, copy) NSString <Optional> *compositionContent; //成分含量
@property (nonatomic, copy) NSString <Optional> *gauze; //纱支
@property (nonatomic, copy) NSString <Optional> *gramWeight; // 克重
@property (nonatomic, copy) NSString <Optional> *dyeing; //染整工艺
@property (nonatomic, strong) NSDictionary <Optional> *productType;//产品类型
@property (nonatomic, copy) NSString <Optional> *recordDate;
@property (nonatomic, copy) NSString <Optional> *guideMethod;

@end
