//
//  ChangeOwnerViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/6/9.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "CustomerMo.h"

typedef enum : NSUInteger {
    OwnerChangeType = 0,        // 转移
    OwnerReleaseType,           // 释放
    OwnerClaimType,             // 认领
} OwnerType;

@interface ChangeOwnerViewCtrl : BaseViewCtrl

@property (nonatomic, strong) CustomerMo *mo;
@property (nonatomic, assign) OwnerType ownerType;

@end
