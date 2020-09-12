//
//  PersonnelCreateViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ContactMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonnelCreateViewCtrl : BaseViewCtrl

@property (nonatomic, strong) ContactMo *mo;
@property (nonatomic, assign) BOOL from360;

@end

NS_ASSUME_NONNULL_END
