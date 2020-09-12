//
//  BusinessVisitViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessVisitViewCtrl : BaseViewCtrl

@property (nonatomic, assign) BOOL fromMy;

- (void)refreshView;

@end

NS_ASSUME_NONNULL_END
