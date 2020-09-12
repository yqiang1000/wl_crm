//
//  MuMenWorkPlanViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/9/9.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "JYWorkPlanViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface MuMenWorkPlanViewCtrl : BaseViewCtrl

@property (nonatomic, strong) JYWorkMo *model;

@property (nonatomic, assign) JYWorkType workType;

@end

NS_ASSUME_NONNULL_END
