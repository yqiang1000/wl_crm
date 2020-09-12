//
//  CreatePersonnelDemandViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/3.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ContactMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreatePersonnelDemandViewCtrl : BaseViewCtrl

// 是否从tab进入
@property (nonatomic, assign) BOOL fromTab;
@property (nonatomic, strong) ContactMo *contactMo;

@end

NS_ASSUME_NONNULL_END
