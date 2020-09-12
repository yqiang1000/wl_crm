//
//  LockScreenViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/4/27.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"

typedef enum LockState {
    LockStateOld = 0,   //输入旧密码
    LockStateFirst,     //第一次输入新密码
    LockStateSecond,    //第二次确认新密码
    LockStateSuccess,   //修改成功
}LockState;

typedef enum SourceType {
    SourceOpen = 0,     //开启密码
    SourceClose,        //关闭密码
    SourceChange,       //修改密码
    SourceTouchOpen,    //开启指纹
    SourceTouchClose,   //关闭指纹
}SourceType;

@interface LockScreenViewCtrl : BaseViewCtrl

@property (nonatomic, assign) LockState lockState;
@property (nonatomic, assign) SourceType sourceType;

@end
