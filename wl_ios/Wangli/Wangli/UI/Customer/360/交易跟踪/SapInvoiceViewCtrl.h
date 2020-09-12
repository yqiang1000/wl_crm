//
//  SapInvoiceViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/6/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "CusInfoMo.h"

typedef enum : NSUInteger {
    kContractType = 0,      // 商务合同（占位）
    kOrderType,             // 订单（占位）
    kSapInvoiceType,        // 发货
    kBillingType,           // 发票
    kReceiptType,           // 电汇
    kForeignType,           // 外贸（占位）
    kMonthyStatement,       // 对账单
} SapInvoiceViewCtrlType;

@interface SapInvoiceViewCtrl : BaseViewCtrl

@property (nonatomic, strong) CusInfoMo *mo;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, assign) SapInvoiceViewCtrlType type;

@end
