//
//  TrendFeedItemMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrendFeedItemMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString <Optional> *text;
@property (nonatomic, copy) NSString <Optional> *key;

@end

NS_ASSUME_NONNULL_END
