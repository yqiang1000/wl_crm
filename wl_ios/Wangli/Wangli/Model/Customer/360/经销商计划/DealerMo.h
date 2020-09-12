//
//  DealerMo.h
//  Wangli
//
//  Created by yeqiang on 2019/4/28.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DealerMo : JSONModel

@property (nonatomic, assign) CGFloat november; //; // 11.0,
@property (nonatomic, assign) CGFloat octoberToNovember; // 999.0,
@property (nonatomic, assign) CGFloat april; // 4.0,
@property (nonatomic, assign) CGFloat totalForTheWholeYear; // 999.0,
@property (nonatomic, assign) CGFloat julyToSeptember; // 999.0,
@property (nonatomic, assign) CGFloat september; // 9.0,
@property (nonatomic, strong) NSDictionary <Optional> *province;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *december; // 12.0,
//0:零售 1 工程 2 部分
@property (nonatomic, assign) NSInteger dealerType; // 0,
@property (nonatomic, assign) long long id; // 91,
@property (nonatomic, strong) NSDictionary <Optional> *brand;
@property (nonatomic, copy) NSString <Optional> *getDealerPlanName; // "FFHD",
@property (nonatomic, copy) NSString <Optional> *brandName; // "华爵",
@property (nonatomic, assign) CGFloat may; // 5.0,
@property (nonatomic, assign) CGFloat august; // 8.0,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; // "2019-04-17 15:54:12",
@property (nonatomic, assign) CGFloat januaryToJune; // 999.0,
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; // "林武龙",
@property (nonatomic, assign) CGFloat february; // 2.0,
@property (nonatomic, assign) CGFloat july; // 7.0,
@property (nonatomic, copy) NSString <Optional> *dealerPlanCode; // "2000034",
@property (nonatomic, assign) CGFloat march; // 3.0,
@property (nonatomic, copy) NSString <Optional> *createdDate; // "2019-04-17 15:54:12",
@property (nonatomic, assign) CGFloat june; // 6.0,
@property (nonatomic, copy) NSString <Optional> *createdBy; // "林武龙",
@property (nonatomic, assign) CGFloat january; // 1.0,
@property (nonatomic, assign) CGFloat october; // 10.0

@end

NS_ASSUME_NONNULL_END
