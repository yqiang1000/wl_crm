//
//  HuajueWorkPlanViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/5/9.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "HuajueMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HuajueWorkPlanViewCtrl : BaseViewCtrl

// 是否获取昨日数据，YES：获取，NO 不获取，默认 NO
@property (nonatomic, assign) BOOL yesterdayData;
@property (nonatomic, strong) HuajueMo *model;

@end

NS_ASSUME_NONNULL_END
