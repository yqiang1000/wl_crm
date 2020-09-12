//
//  BondInfoMo.h
//  Wangli
//
//  Created by yeqiang on 2018/11/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BondInfoMo : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString <Optional> *bondNum; //债券编号
@property (nonatomic, copy) NSString <Optional> *bondName; //债券名称
@property (nonatomic, copy) NSString <Optional> *bondTimeLimit; //债劵期限
@property (nonatomic, copy) NSString <Optional> *publishTimeStr; //债劵发行日
@property (nonatomic, copy) NSString <Optional> *bondTradeTimeStr; //上市交易日
@property (nonatomic, copy) NSString <Optional> *publishExpireTimeStr; //债劵到期日
@property (nonatomic, copy) NSString <Optional> *bondStopTimeStr; //债劵摘牌日
@property (nonatomic, copy) NSString <Optional> *planIssuedQuantity; //计划发行量(亿)
@property (nonatomic, copy) NSString <Optional> *realIssuedQuantity; //实际发行量(亿)
@property (nonatomic, copy) NSString <Optional> *bondType; //债券类型
@property (nonatomic, copy) NSString <Optional> *calInterestType; //计息方式
@property (nonatomic, copy) NSString <Optional> *creditRatingGov; //信用评级机构
@property (nonatomic, copy) NSString <Optional> *debtRating; //债项评级
@property (nonatomic, copy) NSString <Optional> *escrowAgent; //托管机构
@property (nonatomic, copy) NSString <Optional> *exeRightTimeStr; //行权日期
@property (nonatomic, copy) NSString <Optional> *exeRightType; //行权类型
@property (nonatomic, copy) NSString <Optional> *faceInterestRate; //票面利率(%)
@property (nonatomic, copy) NSString <Optional> *faceValue; //面值
@property (nonatomic, copy) NSString <Optional> *flowRange; //流通范围
@property (nonatomic, copy) NSString <Optional> *interestDiff; //利差(BP)
@property (nonatomic, assign) CGFloat issuedPrice; //发行价格(元)
@property (nonatomic, copy) NSString <Optional> *payInterestHZ; //付息频率
@property (nonatomic, copy) NSString <Optional> *refInterestRate; //参考利率
@property (nonatomic, copy) NSString <Optional> *deleted; //是否删除
@property (nonatomic, copy) NSString <Optional> *remark; //备注

@end

NS_ASSUME_NONNULL_END
