//
//  ContactSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/8/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ContactMo.h"

@class ContactSelectViewCtrl;
@protocol ContactSelectViewCtrlDelegate <NSObject>
@optional
// 单选方法
- (void)contactSelectViewCtrl:(ContactSelectViewCtrl *)contactSelectViewCtrl selectedModel:(ContactMo *)model indexPath:(NSIndexPath *)indexPath;

// 取消
- (void)contactSelectViewCtrlDismiss:(ContactSelectViewCtrl *)contactSelectViewCtrl;

@end

@interface ContactSelectViewCtrl : BaseViewCtrl

@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <ContactSelectViewCtrlDelegate> VcDelegate;
@property (nonatomic, assign) NSInteger defaultId;

@end
