//
//  PerformanceMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "QiniuFileMo.h"

@protocol QiniuFileMo;

@interface PerformanceMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *customerId;
@property (nonatomic, strong) NSDictionary <Optional> *factory;
@property (nonatomic, strong) NSDictionary <Optional> *equipment;
@property (nonatomic, copy) NSString <Optional> *year;
@property (nonatomic, copy) NSString <Optional> *month;
@property (nonatomic, copy) NSString <Optional> *bootedQuantity; //开机数
@property (nonatomic, copy) NSString <Optional> *bootedRatio; //开机率
@property (nonatomic, copy) NSString <Optional> *bootRatioEstimate; //开机率估算
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *type; //设备类型
@property (nonatomic, copy) NSString <Optional> *typeValue;
@property (nonatomic, strong) NSArray <Optional> *attachments;

@property (nonatomic, copy) NSString <Optional> *spandexNumber;//氨纶批号
@property (nonatomic, copy) NSString <Optional> *spandexBackoffSpeed;//氨纶退绕速度
@property (nonatomic, copy) NSString <Optional> *spandexBackoffTension;//氨纶退绕张力
@property (nonatomic, copy) NSString <Optional> *drawRation;//牵伸比
@property (nonatomic, copy) NSString <Optional> *productUsingCondition;//产品使用情况
@property (nonatomic, copy) NSString <Optional> *airPressure;//气压

@property (nonatomic, copy) NSString <Optional> *recordDate;//记录时间
@property (nonatomic, copy) NSString <Optional> *name;//产品名称
@property (nonatomic, copy) NSString <Optional> *productionDate;//氨纶生产日期
@property (nonatomic, copy) NSString <Optional> *usedQuantityExpected;//氨纶月用量
@property (nonatomic, copy) NSString <Optional> *stockQuantity;//氨纶库存
@property (nonatomic, copy) NSString <Optional> *stockDays; // 客户成品库存
@property (nonatomic, copy) NSString <Optional> *remark;//备注
@property (nonatomic, copy) NSString <Optional> *size;  // 设备尺寸规格

@end
