//
//  PersonalSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/22.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ContactMo.h"

NS_ASSUME_NONNULL_BEGIN
@class PersonalSelectViewCtrl;
@protocol PersonalSelectViewCtrlDelegate <NSObject>
@optional
- (void)personalSelectViewCtrl:(PersonalSelectViewCtrl *)personalSelectViewCtrl didSelect:(ContactMo *) model indexPath:(NSIndexPath *)indexPath;

- (void)personalSelectViewCtrlDismiss:(PersonalSelectViewCtrl *)personalSelectViewCtrl;
@end

@interface PersonalSelectViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <PersonalSelectViewCtrlDelegate> vcDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) long long memberId;
@property (nonatomic, assign) long long defaultId;

@end

NS_ASSUME_NONNULL_END
