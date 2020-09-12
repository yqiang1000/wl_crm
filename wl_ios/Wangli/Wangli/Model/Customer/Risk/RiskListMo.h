//
//  RiskListMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RiskListMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *field;         // id
@property (nonatomic, copy) NSString <Optional> *fieldValue;    // 标题
@property (nonatomic, assign) NSInteger count;                  // 数量
@property (nonatomic, copy) NSString <Optional> *iconUrl;       // 图片
@property (nonatomic, copy) NSString <Optional> *fieldTitle;

@end
