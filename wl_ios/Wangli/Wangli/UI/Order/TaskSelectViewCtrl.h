//
//  TaskSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/8/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "TaskMo.h"

@class TaskSelectViewCtrl;
@protocol TaskSelectViewCtrlDelegate <NSObject>
@optional
// 单选方法
- (void)taskSelectViewCtrl:(TaskSelectViewCtrl *)taskSelectViewCtrl selectedModel:(TaskMo *)model indexPath:(NSIndexPath *)indexPath;

// 取消
- (void)taskSelectViewCtrlDismiss:(TaskSelectViewCtrl *)taskSelectViewCtrl;

@end

@interface TaskSelectViewCtrl : BaseViewCtrl

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <TaskSelectViewCtrlDelegate> VcDelegate;
@property (nonatomic, assign) NSInteger defaultId;

@end
