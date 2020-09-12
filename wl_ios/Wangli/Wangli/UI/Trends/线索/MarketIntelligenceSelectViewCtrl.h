//
//  MarketIntelligenceSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "MarketIntelligenceMo.h"

NS_ASSUME_NONNULL_BEGIN

@class MarketIntelligenceSelectViewCtrl;
@protocol MarketIntelligenceSelectViewCtrlDelegate <NSObject>
@optional
- (void)marketIntelligenceSelectViewCtrl:(MarketIntelligenceSelectViewCtrl *)marketIntelligenceSelectViewCtrl didSelect:(MarketIntelligenceMo *) model indexPath:(NSIndexPath *)indexPath;

- (void)marketIntelligenceSelectViewCtrlDismiss:(MarketIntelligenceSelectViewCtrl *)marketIntelligenceSelectViewCtrl;
@end

@interface MarketIntelligenceSelectViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <MarketIntelligenceSelectViewCtrlDelegate> vcDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) long long defaultId;

@end

NS_ASSUME_NONNULL_END

