//
//  OrderMo.h
//  Wangli
//
//  Created by yeqiang on 2018/4/20.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OrderMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *type;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *orderMember;
@property (nonatomic, copy) NSString <Optional> *crmNumber;
@property (nonatomic, copy) NSString <Optional> *sapNumber;
@property (nonatomic, strong) NSDictionary <Optional> *office;
@property (nonatomic, copy) NSString <Optional> *orderRoleType;
@property (nonatomic, copy) NSString <Optional> *orderOperator;
@property (nonatomic, copy) NSString <Optional> *status;
@property (nonatomic, copy) NSString <Optional> *finalAmount;
@property (nonatomic, copy) NSString <Optional> *lowPriceReasonType;
@property (nonatomic, copy) NSString <Optional> *lowReason;
@property (nonatomic, copy) NSString <Optional> *requestDeliveryDate;
@property (nonatomic, copy) NSString <Optional> *internationalTradeTerm;
@property (nonatomic, copy) NSString <Optional> *currency;
@property (nonatomic, copy) NSString <Optional> *reason;
@property (nonatomic, strong) NSDictionary <Optional> *shippingAddress;
@property (nonatomic, copy) NSString <Optional> *statusDate;
@property (nonatomic, copy) NSString <Optional> *orgName;
@property (nonatomic, copy) NSString <Optional> *memberName;
@property (nonatomic, copy) NSString <Optional> *memberPhone;
@property (nonatomic, copy) NSString <Optional> *address;
@property (nonatomic, copy) NSString <Optional> *owedTotalAmount;
@property (nonatomic, copy) NSString <Optional> *dueTotalAmount;
@property (nonatomic, copy) NSString <Optional> *creditRiskTotalAmount;
@property (nonatomic, copy) NSString <Optional> *remark;
@property (nonatomic, copy) NSString <Optional> *adjusted;
@property (nonatomic, strong) NSArray <Optional> *orderItem;
@property (nonatomic, copy) NSString <Optional> *orderLogs;
@property (nonatomic, copy) NSString <Optional> *avatarUrl;
@property (nonatomic, copy) NSString <Optional> *salemanName;
@property (nonatomic, copy) NSString <Optional> *statusDesp;
@property (nonatomic, copy) NSString <Optional> *orderDate;
@property (nonatomic, copy) NSString <Optional> *abbreviation;
@property (nonatomic, copy) NSString <Optional> *waers;
@property (nonatomic, copy) NSString <Optional> *wearsSign; //单位
@property (nonatomic, strong) NSDictionary <Optional> *authBean;

@end
