//
//  MemberSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/7/9.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "CustomerMo.h"

@class MemberSelectViewCtrl;
@protocol MemberSelectViewCtrlDelegate <NSObject>
@optional
// 单选方法
- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath;

// 取消
- (void)memberSelectViewCtrlDismiss:(MemberSelectViewCtrl *)memberSelectViewCtrl;

@end

@interface MemberSelectViewCtrl : BaseViewCtrl

@property (nonatomic, assign) BOOL needRules;   //是否需要rule (已弃用)
@property (nonatomic, assign) BOOL sendIM;      //IM发送客户
@property (nonatomic, assign) BOOL knkli;       //knkli不允许为空

@property (nonatomic, assign) BOOL isWangli;      //爱旭新加的

@property (nonatomic, copy) NSString *moduleNumber; // 客户搜索特殊字段

@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <MemberSelectViewCtrlDelegate> VcDelegate;
@property (nonatomic, assign) long long defaultId;

@property (nonatomic, strong) NSMutableArray *customRules;

@end
