//
//  TrendsQuoteMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsQuoteDetailMo : JSONModel
// 报价明细
@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *createdDate; //"2019-01-21 11:51:44",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; //"2019-01-21 11:51:44",
@property (nonatomic, copy) NSString <Optional> *createdBy; //"潘梦洋",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; //"潘梦洋",
@property (nonatomic, strong) NSDictionary <Optional> *materialType;
@property (nonatomic, strong) NSDictionary <Optional> *quotedPrice;
@property (nonatomic, copy) NSString <Optional> *gears;
@property (nonatomic, copy) NSString <Optional> *unitValue;
@property (nonatomic, copy) NSString <Optional> *quantity;
@property (nonatomic, copy) NSString <Optional> *unitKey;
@property (nonatomic, copy) NSString <Optional> *price;
@property (nonatomic, copy) NSString <Optional> *totalPrice;
@property (nonatomic, copy) NSString <Optional> *remark;
@property (nonatomic, copy) NSString <Optional> *currencyValue;

@end

@interface TrendsQuoteMo : TrendsBaseMo

// 报价
@property (nonatomic, strong) NSMutableArray <Optional> *attachments; //null,
@property (nonatomic, copy) NSString <Optional> *endDate; //"2019-02-21",
@property (nonatomic, copy) NSString <Optional> *statusValue; //null,
@property (nonatomic, copy) NSString <Optional> *discount; //0.60,
@property (nonatomic, copy) NSString <Optional> *remark; //"999",
@property (nonatomic, copy) NSString <Optional> *profitForecast; //"成本2000，利润6000",
@property (nonatomic, strong) NSDictionary <Optional> *operator; //null,
@property (nonatomic, copy) NSString <Optional> *conditionKey; //"Z023",
@property (nonatomic, strong) NSDictionary <Optional> *businessChance; //,
@property (nonatomic, copy) NSString <Optional> *memberContractor; //"777",
@property (nonatomic, copy) NSString <Optional> *statusKey; //null,
@property (nonatomic, strong) NSDictionary <Optional> *member; //,
@property (nonatomic, copy) NSString <Optional> *approvalStatusDesp; //"利润预测",
//@property (nonatomic, copy) NSString <Optional> *id; //146,
@property (nonatomic, strong) NSArray <Optional> *quotedPriceItem;
@property (nonatomic, copy) NSString <Optional> *approvalStatus; //"审批中",
@property (nonatomic, copy) NSString <Optional> *payWayKey; //"C",
@property (nonatomic, copy) NSString <Optional> *amount; //60.00,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; //"2019-01-21 00:33:26",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; //"滕细权",
@property (nonatomic, copy) NSString <Optional> *contract; //null,
@property (nonatomic, strong) NSDictionary <Optional> *createOperator;
@property (nonatomic, copy) NSString <Optional> *quotedPriceNumber; //; //"AXBJ20190121005",
@property (nonatomic, copy) NSString <Optional> *approvalNodeIdentifier; //"ACCOUNTANT",
//@property (nonatomic, copy) NSString <Optional> *sort; //10,
@property (nonatomic, copy) NSString <Optional> *payWayValue; //"支票",
@property (nonatomic, copy) NSString <Optional> *statusDesp; //"利润预测",
@property (nonatomic, copy) NSString <Optional> *beginDate; //"2019-01-21",
@property (nonatomic, copy) NSString <Optional> *createdDate; //"2019-01-21 11:51:44",
@property (nonatomic, copy) NSString <Optional> *createdBy; //"潘梦洋",
@property (nonatomic, copy) NSString <Optional> *currencyValue; //"人民币",
@property (nonatomic, copy) NSString <Optional> *currencyKey; //"RMB",
@property (nonatomic, copy) NSString <Optional> *conditionValue; //"发货后30天付款"

@end

NS_ASSUME_NONNULL_END
