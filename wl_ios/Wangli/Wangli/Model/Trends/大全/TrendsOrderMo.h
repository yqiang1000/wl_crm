//
//  TrendsOrderMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/14.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsOrderMo : TrendsBaseMo

@property (nonatomic, copy) NSString <Optional> *createdBy; //; // "system",
@property (nonatomic, copy) NSString <Optional> *createdDate; // "2019-01-11 10:10:46",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; // "system",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; // "2019-01-11 16:38:35",
//@property (nonatomic, copy) NSString <Optional> *id; // 8247,
//@property (nonatomic, copy) NSString <Optional> *deleted; // false,
//@property (nonatomic, copy) NSString <Optional> *sort; // 10,
//@property (nonatomic, copy) NSString <Optional> *fromClientType; // null,
@property (nonatomic, strong) NSArray <Optional> *optionGroup; // [],
@property (nonatomic, copy) NSString <Optional> *memberNumber; // "200021",
@property (nonatomic, copy) NSString <Optional> *number; // "30023797",
@property (nonatomic, copy) NSString <Optional> *statusKey; // "pending_delivery",
@property (nonatomic, copy) NSString <Optional> *statusValue; // "待发货",
@property (nonatomic, copy) NSString <Optional> *kunwe; // "200021",
@property (nonatomic, copy) NSString <Optional> *auart; // "ZSF",
@property (nonatomic, copy) NSString <Optional> *bstkd; // "40003583",
@property (nonatomic, copy) NSString <Optional> *bstdk; // "2018-09-11",
@property (nonatomic, copy) NSString <Optional> *contractNumber; // "40003583",
@property (nonatomic, copy) NSString <Optional> *cmgst; // "A",
@property (nonatomic, copy) NSString <Optional> *spstg; // "",
@property (nonatomic, copy) NSString <Optional> *netwr; // "725850.34",
@property (nonatomic, copy) NSString <Optional> *erdat; // "2018-09-11",
@property (nonatomic, copy) NSString <Optional> *erzet; // "1900-01-01 21:30:24.0000000",
@property (nonatomic, copy) NSString <Optional> *vdatu; // "2018-09-11",
@property (nonatomic, copy) NSString <Optional> *saleOrganizationKey; // "1200",
@property (nonatomic, copy) NSString <Optional> *saleOrganizationValue; // "广东爱旭内贸销售",
@property (nonatomic, copy) NSString <Optional> *distributionChannelKey; // "50",
@property (nonatomic, copy) NSString <Optional> *distributionChannelValue; // null,
@property (nonatomic, copy) NSString <Optional> *spart; // "00",
@property (nonatomic, copy) NSString <Optional> *augru; // "",
@property (nonatomic, copy) NSString <Optional> *payConditionKey; // "Z005",
@property (nonatomic, copy) NSString <Optional> *payConditionValue; // "款到发货",
@property (nonatomic, copy) NSString <Optional> *tradingTermsKey; // "CY5",
@property (nonatomic, copy) NSString <Optional> *tradingTermsValue; // "运费-盛达",
@property (nonatomic, copy) NSString <Optional> *payWayKey; // "A",
@property (nonatomic, copy) NSString <Optional> *payWayValue; // "6个月银行承兑汇票",
@property (nonatomic, copy) NSString <Optional> *currencyKey; // "CNY",
@property (nonatomic, copy) NSString <Optional> *currencyValue; // "中国人民币",
@property (nonatomic, copy) NSString <Optional> *knumv; // "0000055088",
@property (nonatomic, copy) NSString <Optional> *contract; // null,
@property (nonatomic, strong) NSDictionary <Optional> *member; // null,
@property (nonatomic, copy) NSString <Optional> *memberName; // "佛山市南海中天五金机电有限公司",
@property (nonatomic, copy) NSString <Optional> *abbrevation; // "南海中天",
@property (nonatomic, copy) NSString <Optional> *deliveryMember; // null,
@property (nonatomic, copy) NSString <Optional> *deliveryMemberName; // null,
@property (nonatomic, copy) NSString <Optional> *coId; // null,
@property (nonatomic, copy) NSString <Optional> *firstNotified; // true,
@property (nonatomic, copy) NSString <Optional> *totalAmount; // null,
@property (nonatomic, copy) NSString <Optional> *totalQuantity; // null,
@property (nonatomic, copy) NSString <Optional> *cmgstValue; // null,
@property (nonatomic, copy) NSString <Optional> *orderItems; // null,
@property (nonatomic, copy) NSString <Optional> *invoices; // null,
@property (nonatomic, copy) NSString <Optional> *waerk; // "CNY"


@property (nonatomic, copy) NSString <Optional> *fromClientType; //null,
@property (nonatomic, copy) NSString <Optional> *fkId; //8247,
//@property (nonatomic, copy) NSString <Optional> *memberName; //"南海中天200021",
@property (nonatomic, copy) NSString <Optional> *createDate; //"2018-09-11",
//@property (nonatomic, copy) NSString <Optional> *number; //"30023797",
@property (nonatomic, copy) NSString <Optional> *status; //"待发货",
@property (nonatomic, copy) NSString <Optional> *materialDesp; //"",
@property (nonatomic, copy) NSString <Optional> *quantity; //0.000000,
//@property (nonatomic, copy) NSString <Optional> *auart; //"ZSF",
@property (nonatomic, copy) NSString <Optional> *unit; //"W"

@end

NS_ASSUME_NONNULL_END
