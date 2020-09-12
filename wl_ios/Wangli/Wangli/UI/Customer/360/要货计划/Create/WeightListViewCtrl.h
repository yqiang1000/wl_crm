//
//  WeightListViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/9/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "MaterialMo.h"

@class WeightListViewCtrl;
@protocol WeightListViewCtrlDelegate <NSObject>
@optional
// 单选方法
- (void)weightListViewCtrl:(WeightListViewCtrl *)weightListViewCtrl selectedModel:(MaterialMo *)model indexPath:(NSIndexPath *)indexPath;

// 取消
- (void)weightListViewCtrlDismiss:(WeightListViewCtrl *)weightListViewCtrl;

@end

@interface WeightListViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <WeightListViewCtrlDelegate> VcDelegate;
@property (nonatomic, assign) NSInteger defaultId;

@end
