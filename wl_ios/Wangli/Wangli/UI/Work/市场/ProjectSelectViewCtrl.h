//
//  ProjectSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2021/1/12.
//  Copyright © 2021 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "MarketProjectMo.h"

NS_ASSUME_NONNULL_BEGIN

@class ProjectSelectViewCtrl;
@protocol ProjectSelectViewCtrlDelegate <NSObject>
@optional
// 单选方法
- (void)projectSelectViewCtrl:(ProjectSelectViewCtrl *)projectSelectViewCtrl selectedModel:(MarketProjectMo *)model indexPath:(NSIndexPath *)indexPath;

// 取消
- (void)projectSelectViewCtrlDismiss:(ProjectSelectViewCtrl *)projectSelectViewCtrl;

@end

@interface ProjectSelectViewCtrl : BaseViewCtrl


@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <ProjectSelectViewCtrlDelegate> VcDelegate;
@property (nonatomic, assign) long long defaultId;

@property (nonatomic, strong) NSMutableArray *customRules;

@end


NS_ASSUME_NONNULL_END
