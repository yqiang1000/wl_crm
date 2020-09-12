//
//  OperationIndexMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OperationIndexMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *office;
@property (nonatomic, assign) CGFloat reward;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) CGFloat demandPlan;
@property (nonatomic, assign) CGFloat demandActual;
@property (nonatomic, assign) CGFloat gatherPlan;
@property (nonatomic, assign) CGFloat gatherActual;
@property (nonatomic, copy) NSString <Optional> *demandPlanDesp;
@property (nonatomic, copy) NSString <Optional> *gatherPlnaDesp;
@property (nonatomic, copy) NSString <Optional> *url;

@end
