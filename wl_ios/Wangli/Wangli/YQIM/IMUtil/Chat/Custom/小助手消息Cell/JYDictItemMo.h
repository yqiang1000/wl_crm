//
//  JYDictItemMo.h
//  HangGuo
//
//  Created by yeqiang on 2020/2/7.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYDictItemMo : YQBaseModel

@property (nonatomic, copy) NSString *ID;  //2000172,
@property (nonatomic, assign) BOOL enabled;  //true,
@property (nonatomic, copy) NSString *code;  //"hgcrm_order_helper",
@property (nonatomic, copy) NSString *dictId;  //2000039,
@property (nonatomic, copy) NSString *dictName;  //"消息分类",
@property (nonatomic, copy) NSString *dictCode;  //"tim_helper",
@property (nonatomic, copy) NSString *engValue;  //null,
@property (nonatomic, copy) NSString *value;  //"订单小助手",
@property (nonatomic, copy) NSString *value2;  //"http://img.jiuyisoft.com/news_orderassistant.png",
@property (nonatomic, assign) NSInteger showSort;  //10,
@property (nonatomic, copy) NSString *describe;  //null

@end

NS_ASSUME_NONNULL_END
