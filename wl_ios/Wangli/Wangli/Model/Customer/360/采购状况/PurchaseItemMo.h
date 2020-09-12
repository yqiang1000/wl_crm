//
//  PurchaseItemMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseItemMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *field;         // id
@property (nonatomic, assign) BOOL fieldTitle;
@property (nonatomic, copy) NSString <Optional> *fieldValue;    // 标题
@property (nonatomic, assign) NSInteger count;                  // 数量
@property (nonatomic, copy) NSString <Optional> *iconUrl;       // 图片
@property (nonatomic, assign) NSInteger newCount;               // 暂时没用到

@end

NS_ASSUME_NONNULL_END
