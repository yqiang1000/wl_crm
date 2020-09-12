//
//  ProductMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ProductMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *itemId;
@property (nonatomic, copy) NSString <Optional> *specifications;
@property (nonatomic, copy) NSString <Optional> *batch;
@property (nonatomic, copy) NSString <Optional> *number;
@property (nonatomic, copy) NSString <Optional> *price;

@property (nonatomic, copy) NSString <Optional> *sapNum;
@property (nonatomic, copy) NSString <Optional> *priceApply;
@property (nonatomic, copy) NSString <Optional> *level;
@property (nonatomic, copy) NSString <Optional> *levelValue;
@property (nonatomic, copy) NSString <Optional> *useWay;
@property (nonatomic, copy) NSString <Optional> *totalMoney;

@end
