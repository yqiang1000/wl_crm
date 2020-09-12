//
//  MaterialListViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/6/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "MaterialMo.h"

@class MaterialListViewCtrl;
@protocol MaterialListViewCtrlDelegate <NSObject>
@optional
// 单选方法
- (void)materialListViewCtrl:(MaterialListViewCtrl *)listSelectViewCtrl selectMaterialMo:(MaterialMo *)materialMo indexPath:(NSIndexPath *)indexPath;

// 取消
- (void)materialListViewCtrlDismiss:(MaterialListViewCtrl *)materialListViewCtrl;

@end

@interface MaterialListViewCtrl : BaseViewCtrl

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *defaultNum;
@property (nonatomic, assign) BOOL fromSpe;
@property (nonatomic, weak) id <MaterialListViewCtrlDelegate> VcDelegate;

@end
