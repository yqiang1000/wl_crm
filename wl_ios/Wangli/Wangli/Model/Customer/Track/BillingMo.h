//
//  BillingMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

// 发票
@interface BillingMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *number;
@property (nonatomic, copy) NSString <Optional> *goldenTaxNumber;
@property (nonatomic, copy) NSString <Optional> *billDate;
@property (nonatomic, copy) NSString <Optional> *amount;
@property (nonatomic, copy) NSString <Optional> *status;
@property (nonatomic, copy) NSString <Optional> *customerSinger;
@property (nonatomic, copy) NSString <Optional> *signDate;
@property (nonatomic, copy) NSString <Optional> *expressCompanyName;
@property (nonatomic, copy) NSString <Optional> *expressNumber;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSArray <Optional> *salesBillingItems;
@property (nonatomic, copy) NSString <Optional> *salesBillingTracking;
@property (nonatomic, copy) NSString <Optional> *statusDesp;
@property (nonatomic, copy) NSString <Optional> *price;

@end
