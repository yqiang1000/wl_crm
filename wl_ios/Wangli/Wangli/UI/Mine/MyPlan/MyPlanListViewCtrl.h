//
//  MyPlanListViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/7/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "DealPlanCollectionMo.h"
@interface MyPlanListViewCtrl : BaseViewCtrl

@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) DealPlanCollectionMo *model;

@end
