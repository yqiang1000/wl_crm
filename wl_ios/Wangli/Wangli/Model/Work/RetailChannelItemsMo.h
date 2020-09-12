//
//  RetailChannelItemsMo.h
//  Wangli
//
//  Created by yeqiang on 2019/4/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CustomerMo.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol CustomerMo;
@interface RetailChannelItemsMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-19 10:21:07",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "管理员",
@property (nonatomic, copy) NSString <Optional> *sort;  // 10,
@property (nonatomic, copy) NSString <Optional> *content;  // null,
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-19 10:21:07",
@property (nonatomic, copy) NSString <Optional> *createdBy;  // "管理员",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, assign) long long id;  // 45,
@property (nonatomic, assign) BOOL visit;
@property (nonatomic, assign) BOOL monopoly;  // null,
@property (nonatomic, assign) BOOL policyProcessAdvocacy;  // null,
@property (nonatomic, assign) BOOL comparativeSales;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic, assign) BOOL train;
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@end

NS_ASSUME_NONNULL_END
