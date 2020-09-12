//
//  OrderSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/8/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "OrderMo.h"

@class OrderSelectViewCtrl;
@protocol OrderSelectViewCtrlDelegate <NSObject>
@optional
// 单选方法
- (void)orderSelectViewCtrl:(OrderSelectViewCtrl *)orderSelectViewCtrl selectedModel:(OrderMo *)model indexPath:(NSIndexPath *)indexPath;

// 取消
- (void)orderSelectViewCtrlDismiss:(OrderSelectViewCtrl *)orderSelectViewCtrl;

@end

@interface OrderSelectViewCtrl : BaseViewCtrl

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, weak) id <OrderSelectViewCtrlDelegate> VcDelegate;
@property (nonatomic, assign) NSInteger defaultId;

@end
