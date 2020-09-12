//
//  CountrySelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/23.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "CountryMo.h"

NS_ASSUME_NONNULL_BEGIN

@class CountrySelectViewCtrl;
@protocol CountrySelectViewCtrlDelegate <NSObject>
@optional
- (void)countrySelectViewCtrl:(CountrySelectViewCtrl *)countrySelectViewCtrl didSelect:(CountryMo *) model indexPath:(NSIndexPath *)indexPath;

- (void)countrySelectViewCtrlDismiss:(CountrySelectViewCtrl *)countrySelectViewCtrl;
@end

@interface CountrySelectViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <CountrySelectViewCtrlDelegate> vcDelegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) long long defaultId;

@end

NS_ASSUME_NONNULL_END
