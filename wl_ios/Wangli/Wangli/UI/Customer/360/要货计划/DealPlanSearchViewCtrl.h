//
//  DealPlanSearchViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/6/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseSearchViewCtrl.h"
#import "DealPlanCollectionMo.h"

@interface DealPlanSearchViewCtrl : BaseSearchViewCtrl

@property (nonatomic, strong) DealPlanCollectionMo *model;
@property (nonatomic, assign) BOOL fromCollection;

@end
