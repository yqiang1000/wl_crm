//
//  SapInvoiceMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

// 发货
@interface SapInvoiceMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *orderNumber;
@property (nonatomic, copy) NSString <Optional> *lineNumber;
@property (nonatomic, copy) NSString <Optional> *quantity;
@property (nonatomic, copy) NSString <Optional> *amount;
@property (nonatomic, copy) NSString <Optional> *deliveryDate;
@property (nonatomic, copy) NSString <Optional> *denier;
@property (nonatomic, copy) NSString <Optional> *zzszs;
@property (nonatomic, copy) NSString <Optional> *zksks;
@property (nonatomic, copy) NSString <Optional> *number;
@property (nonatomic, copy) NSString <Optional> *invoiceNumber;
@property (nonatomic, copy) NSString <Optional> *invoiceLineNumber;
@property (nonatomic, copy) NSString <Optional> *materialNumber;
@property (nonatomic, copy) NSString <Optional> *materialBatchNumber;
@property (nonatomic, copy) NSString <Optional> *materialSpec;
@property (nonatomic, copy) NSString <Optional> *orderSapNumber;
@property (nonatomic, copy) NSString <Optional> *orderLineNumber;
@property (nonatomic, copy) NSString <Optional> *shippedQuantity;
@property (nonatomic, copy) NSString <Optional> *status;
@property (nonatomic, copy) NSString <Optional> *licensePlateNumber;
@property (nonatomic, copy) NSString <Optional> *driverName;
@property (nonatomic, copy) NSString <Optional> *driverPhone;
@property (nonatomic, copy) NSString <Optional> *memberName;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSArray <Optional> *foreignInvoiceDetails;


@end
