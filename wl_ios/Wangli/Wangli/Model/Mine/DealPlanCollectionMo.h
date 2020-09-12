//
//  DealPlanCollectionMo.h
//  Wangli
//
//  Created by yeqiang on 2018/7/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DealPlanCollectionMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *type;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *memberId;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *batchNumber;
@property (nonatomic, copy) NSString <Optional> *year;
@property (nonatomic, copy) NSString <Optional> *month;
@property (nonatomic, assign) CGFloat totalPlanQuantity;
@property (nonatomic, assign) CGFloat actualQuantity;
@property (nonatomic, assign) CGFloat actualShipNumber;
@property (nonatomic, copy) NSString <Optional> *actualShipString;
@property (nonatomic, copy) NSString <Optional> *searchValue;

@end
