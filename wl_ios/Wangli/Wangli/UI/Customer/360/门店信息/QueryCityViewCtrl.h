//
//  QueryCityViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/9/9.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface QueryCityViewCtrl : BaseViewCtrl

/** typeId: 0 省份搜索； 1 市搜索；2 地区搜索*/
@property (nonatomic, assign) NSInteger typeId;
/** searchId 需要搜索的id */
@property (nonatomic, copy) NSString *searchId;

@end

NS_ASSUME_NONNULL_END
