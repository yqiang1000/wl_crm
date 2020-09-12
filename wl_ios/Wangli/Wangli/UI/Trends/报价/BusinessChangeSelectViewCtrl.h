//
//  BusinessChangeSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "TrendsBusinessMo.h"

NS_ASSUME_NONNULL_BEGIN

@class BusinessChangeSelectViewCtrl;
@protocol BusinessChangeSelectViewCtrlDelegate <NSObject>
@optional
- (void)businessChangeSelectViewCtrl:(BusinessChangeSelectViewCtrl *)businessChangeSelectViewCtrl didSelect:(TrendsBusinessMo *) model indexPath:(NSIndexPath *)indexPath;

- (void)businessChangeSelectViewCtrlDismiss:(BusinessChangeSelectViewCtrl *)businessChangeSelectViewCtrl;
@end

@interface BusinessChangeSelectViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <BusinessChangeSelectViewCtrlDelegate> vcDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) long long defaultId;

@end

NS_ASSUME_NONNULL_END
