//
//  CreateIntelligenceViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "BusinessVisitActivityMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateIntelligenceViewCtrl : BaseViewCtrl

@property (nonatomic, strong) BusinessVisitActivityMo *model;
@property (nonatomic, assign) BOOL fromTab;
@property (nonatomic, assign) long long communId;

@end

// 部门
//"visibleRangeList": [{
//    "visibleType": "DEPARTMENT",
//    "departmentId": 168
//}, {
//    "visibleType": "DEPARTMENT",
//    "departmentId": 164
//}, {
//    "visibleType": "DEPARTMENT",
//    "departmentId": 169
//}, {
//    "visibleType": "DEPARTMENT",
//    "departmentId": 170
//}]

// 公开
//"visibleRangeList": [{
//    "visibleType": "PUBLIC"
//}]

// 指定
//"visibleRangeList": [{
//    "visibleType": "SOMEONE",
//    "operatorId": 218
//}, {
//    "visibleType": "SOMEONE",
//    "operatorId": 489
//}]

// 客户干系人
//"visibleRangeList": [{
//    "visibleType": "FRSRAR",
//    "operatorId": 369,
//    "frSrAr": "AR"
//}]

NS_ASSUME_NONNULL_END
