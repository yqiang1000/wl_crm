//
//  JYIMUtils.h
//  HangGuo
//
//  Created by yeqiang on 2020/2/7.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYDictItemMo.h"
#import "JYMessageDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYIMUtils : NSObject

@property (nonatomic, strong) NSArray *imHelperList;
@property (nonatomic, strong) NSArray *imStyleList;

+ (instancetype)standardJYIMUtils;

+ (NSArray *)getIM_Helper_List;

+ (NSArray *)getIM_Style_List;

// 获取小助手
+ (JYDictItemMo *)getIMHelperMoById:(NSString *)converId;

// 获取 Style
+ (JYDictItemMo *)getIMHelperStyleByStyle:(NSString *)style;

// 获取JYMessageDataModel对象
+ (JYMessageDataModel *)getJYMessageDataModel:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
