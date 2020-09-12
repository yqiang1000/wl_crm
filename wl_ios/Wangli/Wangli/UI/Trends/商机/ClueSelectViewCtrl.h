//
//  ClueSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ClueMo.h"

NS_ASSUME_NONNULL_BEGIN

@class ClueSelectViewCtrl;
@protocol ClueSelectViewCtrlDelegate <NSObject>
@optional
- (void)clueSelectViewCtrl:(ClueSelectViewCtrl *)clueSelectViewCtrl didSelect:(ClueMo *)model indexPath:(NSIndexPath *)indexPath;

- (void)clueSelectViewCtrlDismiss:(ClueSelectViewCtrl *)clueSelectViewCtrl;
@end

@interface ClueSelectViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <ClueSelectViewCtrlDelegate> vcDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) long long defaultId;

@end

NS_ASSUME_NONNULL_END
