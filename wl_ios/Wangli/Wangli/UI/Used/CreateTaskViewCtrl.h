//
//  CreateTaskViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "TaskMo.h"

typedef NS_ENUM(NSInteger, PickerUtilType) {
    PickerUtilTypeDefault   = 0,    // 正常
    PickerUtilTypeNow,              // 开始时间不能早于当前时间
    PickerUtilTypeBegin,            // 结束时间不能早于开始时间
};

@interface CreateTaskViewCtrl : BaseViewCtrl

@property (nonatomic, strong) TaskMo *mo;

@end
