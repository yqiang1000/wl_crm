//
//  CreatePayPlanViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "PayPlanMo.h"

typedef void(^CreateSuccess)(void);

@interface CreatePayPlanViewCtrl : BaseViewCtrl

@property (nonatomic, strong) PayPlanMo *mo;
@property (nonatomic, copy) CreateSuccess createSuccess;
@property (nonatomic, assign) BOOL fromChat;

@end


