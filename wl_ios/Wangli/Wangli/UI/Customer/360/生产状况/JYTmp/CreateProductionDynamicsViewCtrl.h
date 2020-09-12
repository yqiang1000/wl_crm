//
//  CreateProductionDynamicsViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "PerformanceMo.h"

@interface CreateProductionDynamicsViewCtrl : BaseViewCtrl

@property (nonatomic, strong) PerformanceMo *mo;
/**
 *  是否使用保存的数据新建，默认NO
 */
@property (nonatomic, assign) BOOL enableSave;

@end
