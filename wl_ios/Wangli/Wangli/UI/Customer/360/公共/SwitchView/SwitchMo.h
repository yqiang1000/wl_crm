//
//  SwitchMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SwitchStateNormal,          // 正常双灰
    SwitchStateSelectFirst,     // 第一次选中
    SwitchStateSelectSecond,    // 第二次选中
} SwitchState;

@interface SwitchMo : NSObject

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) SwitchState switchState;

@end

NS_ASSUME_NONNULL_END
