//
//  MarketIntelligenceMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketIntelligenceMo : JSONModel


@property (nonatomic, assign) long long id;    //;    // 124,
//@property (nonatomic, copy) NSString <Optional> *sort;    // 10,
@property (nonatomic, copy) NSString <Optional> *createdDate;    // "2019-01-15 10:18:28",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    // "2019-01-15 10:18:29",
@property (nonatomic, copy) NSString <Optional> *createdBy;    // "潘梦洋",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    // "潘梦洋",
@property (nonatomic, strong) NSArray <Optional> *optionGroup;
@property (nonatomic, copy) NSString <Optional> *content;    // "内容",
@property (nonatomic, strong) NSDictionary <Optional> *principal;    // {},
@property (nonatomic, copy) NSString <Optional> *principalName;    // "",
@property (nonatomic, copy) NSString <Optional> *submitDate;    // "2019-01-14",
@property (nonatomic, copy) NSString <Optional> *statusDesp;    // "销售管理部经理审批",
@property (nonatomic, copy) NSString <Optional> *submitterName;    // "潘梦洋",
@property (nonatomic, strong) NSDictionary <Optional> *submitter;
@property (nonatomic, strong) NSArray <Optional> *attachments;    // [],
@property (nonatomic, copy) NSString <Optional> *approvalNodeIdentifier;    // "SALES_MANAGER",
@property (nonatomic, strong) NSArray <Optional> *productBigCategories;
@property (nonatomic, strong) NSDictionary <Optional> *intelligenceItem;    // {},
@property (nonatomic, copy) NSString <Optional> *approvalStatusDesp;    // "审批中",
@property (nonatomic, copy) NSString <Optional> *approvalStatus;    // "approvalInCrm",
@property (nonatomic, copy) NSString <Optional> *importantValue;    // "一般",
@property (nonatomic, copy) NSString <Optional> *abbreviation;    // "",
@property (nonatomic, copy) NSString <Optional> *statusValue;    // "验证中",
@property (nonatomic, copy) NSString <Optional> *statusKey;    // "in_verification",
@property (nonatomic, copy) NSString <Optional> *title;    // "测试",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *coupleBack;    // "",
@property (nonatomic, copy) NSString <Optional> *clueNumber;    // "AXXS20190115001",
@property (nonatomic, strong) NSDictionary <Optional> *oldMember;    // {},
@property (nonatomic, strong) NSDictionary <Optional> *oldMemberAbbreviation;    // {},
@property (nonatomic, copy) NSString <Optional> *intelligenceContent;    // "",
@property (nonatomic, copy) NSString <Optional> *memberContactor;    // "王大锤",
@property (nonatomic, copy) NSString <Optional> *memberContactorPhone;    // "12345678910",
@property (nonatomic, copy) NSString <Optional> *marketActivityTitle;    // "",
@property (nonatomic, copy) NSString <Optional> *closeDesp;    // "",
@property (nonatomic, copy) NSString <Optional> *resourceValue;    // "网站留言",
@property (nonatomic, copy) NSString <Optional> *importantKey;    // "general",
@property (nonatomic, copy) NSString <Optional> *resourceKey;    // "web_message",
@property (nonatomic, strong) NSDictionary <Optional> *marketActivity;    // {}

@end

NS_ASSUME_NONNULL_END
