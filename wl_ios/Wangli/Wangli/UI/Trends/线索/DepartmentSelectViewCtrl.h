//
//  DepartmentSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/16.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "DepartmentMo.h"

NS_ASSUME_NONNULL_BEGIN
@class DepartmentSelectViewCtrl;
@protocol DepartmentSelectViewCtrlDelegate <NSObject>
@optional
- (void)departmentSelectViewCtrl:(DepartmentSelectViewCtrl *)departmentSelectViewCtrl didSelect:(DepartmentMo *) model indexPath:(NSIndexPath *)indexPath;

- (void)departmentSelectViewCtrlDismiss:(DepartmentSelectViewCtrl *)departmentSelectViewCtrl;
@end

@interface DepartmentSelectViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <DepartmentSelectViewCtrlDelegate> vcDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) long long defaultId;

@end

NS_ASSUME_NONNULL_END
