//
//  JYWorkPlanViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/8/27.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "JYWorkMo.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JYWorkTypeJinMuMen,         // 金木门
    JYWorkTypeLvMuMen,          // 铝木门
    JYWorkTypeZhiNengSuo,       // 智能锁
    JYWorkTypeTongMuMen,        // 铜木门
    JYWorkTypeMuMen,            // 木门
} JYWorkType;

@interface JYWorkPlanViewCtrl : BaseViewCtrl

// 是否获取昨日数据，YES：获取，NO 不获取，默认 NO
@property (nonatomic, assign) BOOL yesterdayData;

@property (nonatomic, strong) JYWorkMo *model;

@property (nonatomic, assign) JYWorkType workType;

@end

NS_ASSUME_NONNULL_END
