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
    JYWorkTypeJinMuMen,
    JYWorkTypeLvMuMen,
    JYWorkTypeZhiNengSuo,
    JYWorkTypeTongMuMen,
    JYWorkTypeMuMen,
} JYWorkType;

@interface JYWorkPlanViewCtrl : BaseViewCtrl

@property (nonatomic, strong) JYWorkMo *model;

@property (nonatomic, assign) JYWorkType workType;

@end

NS_ASSUME_NONNULL_END
