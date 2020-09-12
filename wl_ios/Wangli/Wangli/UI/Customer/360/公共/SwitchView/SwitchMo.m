//
//  SwitchMo.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "SwitchMo.h"

@implementation SwitchMo

- (instancetype)init {
    self = [super init];
    if (self) {
        _button = [[UIButton alloc] init];
        _switchState = SwitchStateNormal;
    }
    return self;
}

@end
