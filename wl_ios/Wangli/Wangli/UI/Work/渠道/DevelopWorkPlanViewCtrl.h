//
//  DevelopWorkPlanViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/4/17.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ChannelDevelopmentMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DevelopWorkPlanViewCtrl : BaseViewCtrl

// 是否获取昨日数据，YES：获取，NO 不获取，默认 NO
@property (nonatomic, assign) BOOL yesterdayData;

@property (nonatomic, strong) ChannelDevelopmentMo *model;

@end

NS_ASSUME_NONNULL_END
