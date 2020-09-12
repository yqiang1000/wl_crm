//
//  CreateMarketViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/9.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "RiskFollowMo.h"

typedef void(^CreateUpdateSuccess)(RiskFollowMo *riskFollowMo);

@interface CreateMarketViewCtrl : BaseViewCtrl

@property (nonatomic, strong) RiskFollowMo *mo;

@property (nonatomic, copy) CreateUpdateSuccess createUpdateSuccess;

@property (nonatomic, assign) BOOL fromChat;

@end
