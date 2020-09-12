//
//  BrandSelectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/5/31.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@class BrandSelectViewCtrl;
@protocol BrandSelectViewCtrlDelegate <NSObject>

@optional
- (void)brandSelectViewCtrl:(BrandSelectViewCtrl *)brandSelectViewCtrl didSelected:(NSMutableArray *)arrSelect;

@end

@interface BrandSelectViewCtrl : BaseViewCtrl

@property (nonatomic, weak) id <BrandSelectViewCtrlDelegate> vcDelegate;

@end

NS_ASSUME_NONNULL_END
