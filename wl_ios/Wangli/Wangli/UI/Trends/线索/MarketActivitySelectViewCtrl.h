//
//  MarketActivitySelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "MarketActivityMo.h"

NS_ASSUME_NONNULL_BEGIN
@class MarketActivitySelectViewCtrl;
@protocol MarketActivitySelectViewCtrlDelegate <NSObject>
@optional
- (void)marketActivitySelectViewCtrl:(MarketActivitySelectViewCtrl *)marketActivitySelectViewCtrl didSelect:(MarketActivityMo *) model indexPath:(NSIndexPath *)indexPath;

- (void)marketActivitySelectViewCtrlDismiss:(MarketActivitySelectViewCtrl *)marketActivitySelectViewCtrl;
@end

@interface MarketActivitySelectViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <MarketActivitySelectViewCtrlDelegate> vcDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) long long defaultId;

@end

NS_ASSUME_NONNULL_END
