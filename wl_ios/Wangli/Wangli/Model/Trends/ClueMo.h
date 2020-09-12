//
//  ClueMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClueMo : TrendsBaseMo

//@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *sort;    // 10,
@property (nonatomic, copy) NSString <Optional> *createdDate;    // "2019-01-19 15:31:53",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    // "2019-01-19 15:31:53",
@property (nonatomic, copy) NSString <Optional> *createdBy;    // "陈刚(a)",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    // "陈刚(a)",
@property (nonatomic, copy) NSString <Optional> *content;    // "内容让你容你日荣",
@property (nonatomic, strong) NSDictionary <Optional> *principal;    // {},
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *title;    // "线索标题1",
@property (nonatomic, copy) NSString <Optional> *statusKey;    // "in_verification",
@property (nonatomic, copy) NSString <Optional> *abbreviation;    // "",
@property (nonatomic, copy) NSString <Optional> *statusValue;    // "验证中",
@property (nonatomic, strong) NSArray <Optional> *attachments;    // [],
@property (nonatomic, strong) NSArray <Optional> *materialTypes;
@property (nonatomic, copy) NSString <Optional> *principalName;    // "",
@property (nonatomic, copy) NSString <Optional> *statusDesp;    // "销售管理部经理审批",
@property (nonatomic, copy) NSString <Optional> *submitDate;    // "2019-01-19",
@property (nonatomic, copy) NSString <Optional> *submitterName;    // "陈刚(a)",
@property (nonatomic, strong) NSDictionary <Optional> *submitter;
@property (nonatomic, copy) NSString <Optional> *approvalNodeIdentifier;    // "SALES_MANAGER",
@property (nonatomic, strong) NSDictionary <Optional> *intelligenceItem;    // {},
@property (nonatomic, copy) NSString <Optional> *importantValue;    // "非常重要",
@property (nonatomic, copy) NSString <Optional> *approvalStatusDesp;    // "审批中",
@property (nonatomic, copy) NSString <Optional> *approvalStatus;    // "approvalInCrm",
@property (nonatomic, copy) NSString <Optional> *importantKey;    // "very_important",
@property (nonatomic, copy) NSString <Optional> *resourceValue;    // "老客户介绍",
@property (nonatomic, copy) NSString <Optional> *resourceKey;    // "customer_introduce",
@property (nonatomic, copy) NSString <Optional> *closeDesp;    // "",
@property (nonatomic, copy) NSString <Optional> *clueNumber;    // "AXXS20190119002",
@property (nonatomic, copy) NSString <Optional> *coupleBack;    // "",
@property (nonatomic, strong) NSDictionary <Optional> *oldMember;
@property (nonatomic, strong) NSDictionary <Optional> *marketActivity;    // {},
@property (nonatomic, copy) NSString <Optional> *memberContactor;    // "联系人1111",
@property (nonatomic, copy) NSString <Optional> *memberContactorPhone;    // "123",
@property (nonatomic, copy) NSString <Optional> *marketActivityTitle;    // "",
@property (nonatomic, copy) NSString <Optional> *intelligenceContent;    // "",
@property (nonatomic, strong) NSDictionary <Optional> *oldMemberAbbreviation;    // {}

@end

NS_ASSUME_NONNULL_END
