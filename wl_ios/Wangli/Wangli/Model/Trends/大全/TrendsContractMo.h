//
//  TrendsContractMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/14.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsContractMo : TrendsBaseMo

@property (nonatomic, copy) NSString <Optional> *fkId;
@property (nonatomic, copy) NSString <Optional> *memberName;
@property (nonatomic, copy) NSString <Optional> *createDate;
@property (nonatomic, copy) NSString <Optional> *crmNumber;
@property (nonatomic, copy) NSString <Optional> *sapNumber;
@property (nonatomic, copy) NSString <Optional> *unit;
@property (nonatomic, copy) NSString <Optional> *materialDesp;
@property (nonatomic, copy) NSString <Optional> *actualQuantity;
@property (nonatomic, copy) NSString <Optional> *quantity;
@property (nonatomic, copy) NSString <Optional> *rate;

@end

NS_ASSUME_NONNULL_END
