//
//  LinkManBusinessMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinkManBusinessMo : JSONModel

@property (nonatomic, assign) long long id;        //;        // 69,
//@property (nonatomic, copy) NSString <Optional> *sort;        // 1,
@property (nonatomic, copy) NSString <Optional> *createdDate;        // 1545739143684,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;        // 1545739149498,
@property (nonatomic, copy) NSString <Optional> *createdBy;        // "17721180295",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;        // "17721180295",
@property (nonatomic, copy) NSString <Optional> *content;        // "测试商机",
@property (nonatomic, copy) NSString <Optional> *typeValue;        // "",
@property (nonatomic, copy) NSString <Optional> *typeKey;        // "",
@property (nonatomic, copy) NSString <Optional> *statusValue;        // "",
@property (nonatomic, copy) NSString <Optional> *statusKey;        // "",
@property (nonatomic, copy) NSString <Optional> *importantKey;        // "general",
@property (nonatomic, copy) NSString <Optional> *amount;        // 123456,
@property (nonatomic, copy) NSString <Optional> *abbreviation;        // "测试",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *title;        // "测试商机",
@property (nonatomic, copy) NSString <Optional> *operatorName;        // "唐旺",
@property (nonatomic, strong) NSArray <Optional> *competitorBehaviorset;        // [],
@property (nonatomic, strong) NSArray <Optional> *friendDealerSet;        // [],
@property (nonatomic, strong) NSArray <Optional> *businessJournalSet;        // [],
@property (nonatomic, copy) NSString <Optional> *importantValue;        // "一般",
@property (nonatomic, copy) NSString <Optional> *businessNumber;        // "AXSJ20181225001",
@property (nonatomic, copy) NSString <Optional> *customerContact;        // "赵",
@property (nonatomic, copy) NSString <Optional> *transactionDate;        // "2018-12-28",
@property (nonatomic, strong) NSDictionary <Optional> *clue;
@property (nonatomic, copy) NSString <Optional> *clueTitle;        // "测试关联情报",
@property (nonatomic, copy) NSString <Optional> *submitDate;        // "2018-12-25 19:58",
@property (nonatomic, copy) NSString <Optional> *resourceValue;        // "老客户介绍",
@property (nonatomic, copy) NSString <Optional> *resourceKey;        // "customer_introduce",
@property (nonatomic, strong) NSArray <Optional> *quotedPrice;        // ,
@property (nonatomic, assign) NSInteger favorited;        // -8,
@property (nonatomic, assign) NSInteger viewed;        // -8,
@property (nonatomic, assign) NSInteger viewedCount;        // 0,
@property (nonatomic, assign) NSInteger liked;        // -8,
@property (nonatomic, assign) NSInteger likedCount;        // 0
    
@end

NS_ASSUME_NONNULL_END
