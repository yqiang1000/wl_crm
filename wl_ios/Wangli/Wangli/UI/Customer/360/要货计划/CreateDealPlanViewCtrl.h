//
//  CreateDealPlanViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "DealPlanMo.h"
#import "MaterialMo.h"

typedef void(^CreateSuccess)(void);

@interface CreateDealPlanViewCtrl : BaseViewCtrl

@property (nonatomic, strong) DealPlanMo *mo;

@property (nonatomic, copy) CreateSuccess createSuccess;

@property (nonatomic, assign) BOOL fromChat;

@end
