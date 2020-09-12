//
//  TrendsReceiptMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/20.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsReceiptMo : TrendsBaseMo

@property (nonatomic, copy) NSString <Optional> *companyValue;  //;  // "广东爱旭",
@property (nonatomic, strong) NSArray <Optional> *optionGroup;
@property (nonatomic, copy) NSString <Optional> *memberName;  // "江西晶科",
@property (nonatomic, copy) NSString <Optional> *remark;  // "21",
@property (nonatomic, copy) NSString <Optional> *type;  // "CASH_DEPOSIT",
@property (nonatomic, copy) NSString <Optional> *typeDesp;  // "保证金",
@property (nonatomic, copy) NSString <Optional> *number;  // "AXSK20190116007",
@property (nonatomic, strong) NSDictionary <Optional> *member;  //crmNumber
//@property (nonatomic, copy) NSString <Optional> *id;  // 19,
@property (nonatomic, copy) NSString <Optional> *companyKey;  // "gd_aikosolar",
@property (nonatomic, copy) NSString <Optional> *meId;  // 2326,
@property (nonatomic, copy) NSString <Optional> *amount;  // 21.000,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-01-16 09:51:27",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "曹康",
@property (nonatomic, copy) NSString <Optional> *receiptDate;  // "2019-01-17",
@property (nonatomic, copy) NSString <Optional> *sort;  // 10,
@property (nonatomic, copy) NSString <Optional> *statusDesp;  // "未过账",
@property (nonatomic, copy) NSString <Optional> *receiptTypeValue;  // "电汇",
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-01-16 09:51:27",
@property (nonatomic, copy) NSString <Optional> *memberNumber;  // "200011",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "曹康",
@property (nonatomic, copy) NSString <Optional> *currencyValue;  // "中国人民币 元",
@property (nonatomic, copy) NSString <Optional> *receiptTypeKey;  // "wire_transfer",
@property (nonatomic, copy) NSString <Optional> *currencyKey;  // "RMB",
@property (nonatomic, copy) NSString <Optional> *status;  // "NOT_ACCOUNT"

@end

NS_ASSUME_NONNULL_END
