//
//  ContractMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

// 销售合同
@interface ContractMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *type;
@property (nonatomic, strong) NSDictionary <Optional> *status;
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *number;
@property (nonatomic, copy) NSString <Optional> *infoDate;
@property (nonatomic, copy) NSString <Optional> *startDate;
@property (nonatomic, copy) NSString <Optional> *endDate;
@property (nonatomic, copy) NSString <Optional> *overdueNotifyDays;
@property (nonatomic, copy) NSString <Optional> *amount;
@property (nonatomic, copy) NSString <Optional> *demandDeliveryDate;
@property (nonatomic, copy) NSString <Optional> *shipAddressId;
@property (nonatomic, copy) NSString <Optional> *shipContact;
@property (nonatomic, copy) NSString <Optional> *shipPhone;
@property (nonatomic, copy) NSString <Optional> *shipProvince;
@property (nonatomic, copy) NSString <Optional> *shipCity;
@property (nonatomic, copy) NSString <Optional> *shipAddr;
@property (nonatomic, copy) NSString <Optional> *invoicingTitle;
@property (nonatomic, copy) NSString <Optional> *invoicingTaxNumber;
@property (nonatomic, copy) NSString <Optional> *ticketCollectorName;
@property (nonatomic, copy) NSString <Optional> *ticketCollectorPhone;
@property (nonatomic, copy) NSString <Optional> *specialClause;
@property (nonatomic, copy) NSString <Optional> *remark;
@property (nonatomic, copy) NSString <Optional> *paymementCondition;
@property (nonatomic, copy) NSString <Optional> *shipType;
@property (nonatomic, copy) NSString <Optional> *internationalTradeClause;
@property (nonatomic, copy) NSString <Optional> *foreignInvoiceTrackings;
@property (nonatomic, copy) NSString <Optional> *currency;
@property (nonatomic, copy) NSString <Optional> *payWay;
@property (nonatomic, copy) NSString <Optional> *tradeWay;
@property (nonatomic, strong) NSArray <Optional> *attachments;
@property (nonatomic, strong) NSArray <Optional> *salesContractMaterials;
@property (nonatomic, strong) NSArray <Optional> *salesContractInvoices;

@end
