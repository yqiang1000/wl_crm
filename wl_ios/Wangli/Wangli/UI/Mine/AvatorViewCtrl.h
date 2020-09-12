//
//  AvatorViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/6/28.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

typedef NS_ENUM(NSInteger, AvatorType) {
    AvatorTypeDefault     = 0,      //个人
    AvatorTypeMember,               //客户
};

@interface AvatorViewCtrl : BaseViewCtrl

@property (nonatomic, assign) AvatorType type;

@end
