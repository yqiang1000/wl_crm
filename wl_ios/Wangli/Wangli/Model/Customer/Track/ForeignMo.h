//
//  ForeignMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

// 外贸
@interface ForeignMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *number;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *status;
@property (nonatomic, copy) NSString <Optional> *phoneFax;
@property (nonatomic, copy) NSString <Optional> *transportType;
@property (nonatomic, copy) NSString <Optional> *shippingPort;
@property (nonatomic, copy) NSString <Optional> *targetPort;
@property (nonatomic, copy) NSString <Optional> *country;
@property (nonatomic, copy) NSString <Optional> *shippingAgent;
@property (nonatomic, copy) NSString <Optional> *packages;
@property (nonatomic, copy) NSString <Optional> *freight;
@property (nonatomic, copy) NSString <Optional> *containerType;
@property (nonatomic, copy) NSString <Optional> *invoiceDate;
@property (nonatomic, copy) NSString <Optional> *bookingDate;
@property (nonatomic, copy) NSString <Optional> *loadingCabinetDate;
@property (nonatomic, copy) NSString <Optional> *customsDate;
@property (nonatomic, copy) NSString <Optional> *shipmentDate;
@property (nonatomic, copy) NSString <Optional> *receiveLadingBillDate;
@property (nonatomic, copy) NSString <Optional> *receivePaymentDate;
@property (nonatomic, copy) NSString <Optional> *deliveryNoteDate;
@property (nonatomic, copy) NSString <Optional> *pickUpDate;
@property (nonatomic, copy) NSString <Optional> *memberName;
@property (nonatomic, copy) NSString <Optional> *address;
@property (nonatomic, strong) NSArray <Optional> *salesContracts;
@property (nonatomic, strong) NSArray <Optional> *foreignInvoiceDetails;
@property (nonatomic, copy) NSString <Optional> *changeDate;


//private String number;// 跟踪单号
//private Member member;// 客户号
//private ForeignInvoiceTrackingStatus status;// 状态 发货/订舱/装柜/报关/出运/接收提单/收款/交货单（客户接受）/提货
//private String phoneFax;// 电话传真
//private String transportType;// 运输方式
//private String shippingPort;// 装运港口
//private String targetPort;// 目的港口
//private String country;// 国别
//private String shippingAgent;// 货运代理
//private String packages;// 包装
//private BigDecimal freight;// 运费
//private String containerType;// 货柜箱型
//private LocalDate invoiceDate;// 发货日期
//private LocalDate bookingDate;// 订舱日期
//private LocalDate loadingCabinetDate;// 装柜日期
//private LocalDate customsDate;// 报关日期
//private LocalDate shipmentDate;// 出运日期
//private LocalDate receiveLadingBillDate;// 接收提单日期
//private LocalDate receivePaymentDate;// 收货款日期
//private LocalDate deliveryNoteDate;// 交货单（客户接受）日期
//private LocalDate pickUpDate;// 提货日期
//private LocalDate ChangeDate;//当前状态日期


@end
