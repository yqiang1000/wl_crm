//
//  ReceiptMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

// 电汇
@interface ReceiptMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *number;//收款单号
@property (nonatomic, copy) NSString <Optional> *companyCode;//公司代码
@property (nonatomic, copy) NSString <Optional> *companyName;//公司名称
@property (nonatomic, copy) NSString <Optional> *receiptDate;//收款日期
@property (nonatomic, copy) NSString <Optional> *department;//部门
@property (nonatomic, copy) NSString <Optional> *memberSapNumber;//客户编号
@property (nonatomic, copy) NSString <Optional> *memberName;//客户名称
@property (nonatomic, copy) NSString <Optional> *operatorSapNumber;//业务员编号
@property (nonatomic, copy) NSString <Optional> *operatorName;//业务员名称
@property (nonatomic, copy) NSString <Optional> *receiptAmount;//收款金额
@property (nonatomic, copy) NSString <Optional> *remark;//摘要
@property (nonatomic, strong) NSDictionary <Optional> *member;//客户

@property (nonatomic, copy) NSString <Optional> *paidDate;//打款日期
@property (nonatomic, copy) NSString <Optional> *claimedDate;//认领日期
@property (nonatomic, copy) NSString <Optional> *arrivedDate;//到账日期
@property (nonatomic, copy) NSString <Optional> *bookedDate;//入账日期

@property (nonatomic, copy) NSString <Optional> *ztype; // 状态
@property (nonatomic, copy) NSString <Optional> *gttyp;
@property (nonatomic, copy) NSString <Optional> *ztext; // 类型
@end
