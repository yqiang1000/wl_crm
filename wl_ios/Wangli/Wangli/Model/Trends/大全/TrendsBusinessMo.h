//
//  TrendsBusinessMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/13.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsBusinessMo : TrendsBaseMo

//@property (nonatomic, assign) long long id; //161,
//@property (nonatomic, copy) NSString <Optional> *sort; //10,
@property (nonatomic, copy) NSString <Optional> *createdDate; //"2019-01-13 15:08:34",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; //"2019-01-13 15:08:34",
@property (nonatomic, copy) NSString <Optional> *createdBy; //"费婷",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; //"费婷",
@property (nonatomic, copy) NSString <Optional> *content; //"老客户拜访了解",
@property (nonatomic, strong) NSDictionary <Optional> *principal; //{},
@property (nonatomic, copy) NSString <Optional> *transactionDate; //"2019-01-31",
@property (nonatomic, copy) NSString <Optional> *importantValue; //"一般",
@property (nonatomic, copy) NSString <Optional> *approvalStatusValue; //"审批中",
@property (nonatomic, strong) NSDictionary <Optional> *regularCustomer;
@property (nonatomic, copy) NSString <Optional> *regularCustomerName; //"赛维LDK",
@property (nonatomic, strong) NSArray <Optional> *attachmentList; //[],
@property (nonatomic, copy) NSString <Optional> *typeValue; //"新商机",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *typeKey; //"new_business_chance",
@property (nonatomic, copy) NSString <Optional> *title; //"LDK新商机发现",
@property (nonatomic, copy) NSString <Optional> *statusKey; //"under_review",
@property (nonatomic, copy) NSString <Optional> *customerTel; //18766778866.00,
@property (nonatomic, copy) NSString <Optional> *customerJob; //"采购主管",
@property (nonatomic, strong) NSDictionary <Optional> *clue; //{},
@property (nonatomic, copy) NSString <Optional> *clueTitle; //"",
@property (nonatomic, strong) NSDictionary <Optional> *activity; //{},
@property (nonatomic, copy) NSString <Optional> *activityTitle; //"",
@property (nonatomic, copy) NSString <Optional> *resourceValue; //"老客户介绍",
@property (nonatomic, copy) NSString <Optional> *importantKey; //"general",
@property (nonatomic, copy) NSString <Optional> *resourceKey; //"customer_introduce",
@property (nonatomic, copy) NSString <Optional> *feedback; //"",
@property (nonatomic, copy) NSString <Optional> *closeDesp; //"",
@property (nonatomic, strong) NSArray <Optional> *quotedPrice; //[],
@property (nonatomic, strong) NSArray <Optional> *productBigCategorySet;
@property (nonatomic, strong) NSArray <Optional> *competitorBehaviorset; //[],
@property (nonatomic, copy) NSString <Optional> *businessNumber; //"AXSJ20190113003",
@property (nonatomic, strong) NSArray <Optional> *friendDealerSet; //[],
@property (nonatomic, strong) NSArray <Optional> *businessJournalSet; //[],
@property (nonatomic, copy) NSString <Optional> *approvalStatusKey; //"approvalInCrm",
@property (nonatomic, copy) NSString <Optional> *customerContact; //"王德峰",
@property (nonatomic, copy) NSString <Optional> *abbreviation; //"赛维LDK",
@property (nonatomic, strong) NSDictionary <Optional> *contract; //{},
@property (nonatomic, copy) NSString <Optional> *operatorName; //"费婷",
@property (nonatomic, copy) NSString <Optional> *statusValue; //"审核中",
@property (nonatomic, copy) NSString <Optional> *principalName; //"",
@property (nonatomic, copy) NSString <Optional> *submitDate; //"2019-01-13 15:08",
@property (nonatomic, copy) NSString <Optional> *amount; //19000000.00
@property (nonatomic, strong) NSMutableArray <Optional> *materialTypes;
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;

@end

NS_ASSUME_NONNULL_END
