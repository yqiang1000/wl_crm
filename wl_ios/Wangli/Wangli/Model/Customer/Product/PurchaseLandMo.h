//
//  PurchaseLandMo.h
//  Wangli
//
//  Created by yeqiang on 2018/11/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseLandMo : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString <Optional> *purchaseLandNumber; //crm编号
@property (nonatomic, copy) NSString <Optional> *assignee; //受让人
@property (nonatomic, copy) NSString <Optional> *location; //宗地位置
@property (nonatomic, copy) NSString <Optional> *signedDateStr; //签订日期
@property (nonatomic, copy) NSString <Optional> *adminRegion; //行政区
@property (nonatomic, copy) NSString <Optional> *dealPrice; //成交价款（万元）
@property (nonatomic, copy) NSString <Optional> *elecSupervisorNo; //电子监管号
@property (nonatomic, copy) NSString <Optional> *endTimeStr; //约定竣工时间
@property (nonatomic, copy) NSString <Optional> *maxVolume; //最大容积率
@property (nonatomic, copy) NSString <Optional> *minVolume; //最小容积率
@property (nonatomic, copy) NSString <Optional> *parentCompany; //上级公司
@property (nonatomic, copy) NSString <Optional> *purpose; //土地用途
@property (nonatomic, copy) NSString <Optional> *startTimeStr; //约定动工时间
@property (nonatomic, copy) NSString <Optional> *supplyWay; //供应方式
@property (nonatomic, copy) NSString <Optional> *totalArea; //供地总面积(公顷)
@property (nonatomic, copy) NSString <Optional> *updateTimeStr; //更新时间
@property (nonatomic, copy) NSString <Optional> *linkUrl; //链接

@end

NS_ASSUME_NONNULL_END
