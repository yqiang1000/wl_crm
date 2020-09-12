//
//  CompetitionMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "QiniuFileMo.h"

@protocol QiniuFileMo;

@interface CompetitionMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *companyType;
@property (nonatomic, copy) NSString <Optional> *companyTypeValue;
@property (nonatomic, strong) NSDictionary <Optional> *industryRank;
@property (nonatomic, copy) NSString <Optional> *industryRankValue; //行业地位
@property (nonatomic, copy) NSString <Optional> *companyName; //竞企名称
@property (nonatomic, strong) NSDictionary <Optional> *brand;  //品牌
@property (nonatomic, copy) NSString <Optional> *brandValue;
@property (nonatomic, strong) NSDictionary <Optional> *brandPosition;//品牌定位
@property (nonatomic, copy) NSString <Optional> *brandPositionValue;
@property (nonatomic, copy) NSString <Optional> *salesVolume; // 吨/月
@property (nonatomic, copy) NSString <Optional> *features; //功能特色
@property (nonatomic, copy) NSString <Optional> *marketStrategy;
@property (nonatomic, copy) NSString <Optional> *serviceMode;
@property (nonatomic, copy) NSString <Optional> *background;
@property (nonatomic, strong) NSArray <QiniuFileMo *> <QiniuFileMo, Optional> *attachments;

@property (nonatomic, copy) NSString <Optional> *spandexNumber;//氨纶批号
@property (nonatomic, copy) NSString <Optional> *spandexBackoffSpeed;//氨纶退绕速度
@property (nonatomic, copy) NSString <Optional> *spandexBackoffTension;//氨纶退绕张力
@property (nonatomic, copy) NSString <Optional> *drawRation;//牵伸比
@property (nonatomic, copy) NSString <Optional> *productUsingCondition;//产品使用情况
@property (nonatomic, copy) NSString <Optional> *airPressure;//气压
@property (nonatomic, copy) NSString <Optional> *recordDate;// 记录时间
@property (nonatomic, copy) NSString <Optional> *name; // 产品名称
@property (nonatomic, copy) NSString <Optional> *priceVolume; //价格元/吨
@property (nonatomic, copy) NSString <Optional> *payMethod;//付款方式
@property (nonatomic, copy) NSString <Optional> *accountPeriod;//账期
@property (nonatomic, copy) NSString <Optional> *stockQuantity;//客户处库存
@property (nonatomic, strong) NSDictionary <Optional> *distributionChannel;//营销策略
@property (nonatomic, copy) NSString <Optional> *distributionChannelValue;
@property (nonatomic, copy) NSString <Optional> *remark; //备注

@end
