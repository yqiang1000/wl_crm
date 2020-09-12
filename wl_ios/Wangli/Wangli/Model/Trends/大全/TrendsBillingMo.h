//
//  TrendsBillingMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/20.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsBillingMo : TrendsBaseMo

@property (nonatomic, copy) NSString <Optional> *createdBy; //; //"system",
@property (nonatomic, copy) NSString <Optional> *createdDate; //"2019-01-15 23:22:03",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; //"system",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; //"2019-01-15 23:22:03",
//@property (nonatomic, copy) NSString <Optional> *id; //28445,
@property (nonatomic, copy) NSString <Optional> *deleted; //false,
@property (nonatomic, copy) NSString <Optional> *sort; //10,
@property (nonatomic, copy) NSString <Optional> *fromClientType; //null,
@property (nonatomic, strong) NSArray <Optional> *optionGroup; //[],
@property (nonatomic, copy) NSString <Optional> *memberNumber; //"200264",
@property (nonatomic, strong) NSDictionary <Optional> *member; //null,
@property (nonatomic, copy) NSString <Optional> *memberName; //"隆基乐叶光伏科技有限公司",
@property (nonatomic, copy) NSString <Optional> *number; //"90023128",
@property (nonatomic, copy) NSString <Optional> *lineNumber; //"1970",
@property (nonatomic, copy) NSString <Optional> *fkdat; //"2018-08-10",
@property (nonatomic, copy) NSString <Optional> *vgbel; //"80034496",
@property (nonatomic, copy) NSString <Optional> *vgpos; //"1970",
@property (nonatomic, copy) NSString <Optional> *aubel; //"0030022579",
@property (nonatomic, copy) NSString <Optional> *aupos; //"001970",
@property (nonatomic, copy) NSString <Optional> *matnr; //"60000526",
@property (nonatomic, copy) NSString <Optional> *charg; //"X101174477",
@property (nonatomic, copy) NSString <Optional> *matkl; //"201",
@property (nonatomic, copy) NSString <Optional> *arktx; //"单晶PBPERC5主栅8分段10> A 21.4%~21.5% 5.23 WPC",
@property (nonatomic, copy) NSString <Optional> *pstyv; //"ZTAN",
@property (nonatomic, copy) NSString <Optional> *posar; //"",
@property (nonatomic, copy) NSString <Optional> *fkimg; //1440.00,
@property (nonatomic, copy) NSString <Optional> *vrkme; //"PC",
@property (nonatomic, copy) NSString <Optional> *kzwi5; //"8424.00",
@property (nonatomic, copy) NSString <Optional> *netwr; //7262.00,
@property (nonatomic, copy) NSString <Optional> *mwsbp; //1161.93,
@property (nonatomic, copy) NSString <Optional> *erdat; //"2018-08-10",
@property (nonatomic, copy) NSString <Optional> *erzet; //"14:40:24",
@property (nonatomic, copy) NSString <Optional> *erdatv; //null,
@property (nonatomic, copy) NSString <Optional> *abbreviation; //null,
@property (nonatomic, copy) NSString <Optional> *feedFkId; //3735,
@property (nonatomic, copy) NSString <Optional> *firstNotified; //true,
@property (nonatomic, copy) NSString <Optional> *logisticsNumber; //null,
@property (nonatomic, copy) NSString <Optional> *expressDate; //null,
@property (nonatomic, copy) NSString <Optional> *expressKey; //null,
@property (nonatomic, copy) NSString <Optional> *expressValue; //null,
@property (nonatomic, copy) NSString <Optional> *expressNumber; //null,
@property (nonatomic, copy) NSString <Optional> *addressee; //null,
@property (nonatomic, copy) NSString <Optional> *address; //null,
@property (nonatomic, copy) NSString <Optional> *goldenTaxNumber; //null,
@property (nonatomic, copy) NSString <Optional> *billingLogistics; //null
@property (nonatomic, copy) NSString <Optional> *materialDespForMobile;

@end

NS_ASSUME_NONNULL_END
