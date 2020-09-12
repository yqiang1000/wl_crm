//
//  ProduceProductMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "QiniuFileMo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QiniuFileMo;
@interface ProduceProductMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *operator;

@property (nonatomic, copy) NSString <Optional> *grossProfit;   //": 1.00,
@property (nonatomic, copy) NSString <Optional> *supplier;       //核心共饮上",
@property (nonatomic, copy) NSString <Optional> *process;       //工艺",
@property (nonatomic, copy) NSString <Optional> *productPatent;       //专利",
@property (nonatomic, copy) NSString <Optional> *capacityInfo;       //产能情况",
@property (nonatomic, copy) NSString <Optional> *equipment;       //设备",
@property (nonatomic, copy) NSString <Optional> *stockInfo;       //100",
@property (nonatomic, copy) NSString <Optional> *complaintInfo;       //可素啊",
@property (nonatomic, copy) NSString <Optional> *productPrice;      //": 90.00,
@property (nonatomic, copy) NSString <Optional> *orderInfo;       //在手",
@property (nonatomic, copy) NSString <Optional> *inOutInfo;       //出口情",
@property (nonatomic, copy) NSString <Optional> *returnInfo;       //退换货",
@property (nonatomic, copy) NSString <Optional> *revenue;       //": 100.00,
@property (nonatomic, copy) NSString <Optional> *cost;          //": 90.00,
@property (nonatomic, copy) NSString <Optional> *technicalDefect;       //有缺陷",
@property (nonatomic, copy) NSString <Optional> *demandStandard;       //要求",
@property (nonatomic, copy) NSString <Optional> *poorProductInfo;       //有狭翅",
@property (nonatomic, copy) NSString <Optional> *singleGrossProfit;     //": 40.00,
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;       //battery_factory"
//@property (nonatomic, strong) NSMutableArray <QiniuFileMo *> <QiniuFileMo, Optional> *attachmentList;

@end

NS_ASSUME_NONNULL_END
