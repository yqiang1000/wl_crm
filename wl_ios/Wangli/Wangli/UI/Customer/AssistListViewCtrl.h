//
//  AssistListViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/7/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "JYUserMo.h"

@class AssistListViewCtrl;
@protocol AssistListViewCtrlDelegate <NSObject>
@optional
// 单选方法
- (void)assistListViewCtrl:(AssistListViewCtrl *)assistListViewCtrl selectedModel:(JYUserMo *)model indexPath:(NSIndexPath *)indexPath;

// 取消
- (void)assistListViewCtrlDismiss:(AssistListViewCtrl *)assistListViewCtrl;

@end

@interface AssistListViewCtrl : BaseViewCtrl

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <AssistListViewCtrlDelegate> VcDelegate;
@property (nonatomic, assign) NSInteger defaultId;

@end
