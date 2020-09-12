//
//  CustDeptMo.h
//  Wangli
//
//  Created by yeqiang on 2018/9/19.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CustDeptMo : JSONModel

@property (nonatomic, assign) CGFloat zeroToAccount;
@property (nonatomic, assign) CGFloat accountToNinety;
@property (nonatomic, assign) CGFloat moreThanNinety;
@property (nonatomic, assign) CGFloat owedTotalAmount;
@property (nonatomic, assign) CGFloat quantity; // 预计收款
@property (nonatomic, assign) CGFloat receivedAmount;//截止收款
@property (nonatomic, assign) CGFloat planTotalAmount;//计划总额

@end
