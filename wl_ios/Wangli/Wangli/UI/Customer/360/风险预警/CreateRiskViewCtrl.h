//
//  CreateRiskViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/4.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "RiskFollowMo.h"

typedef void(^CreateUpdateSuccess)(RiskFollowMo *riskFollowMo);

@interface CreateRiskViewCtrl : BaseViewCtrl

@property (nonatomic, strong) RiskFollowMo *mo;

@property (nonatomic, copy) CreateUpdateSuccess createUpdateSuccess;

@property (nonatomic, assign) BOOL fromChat;

@end
