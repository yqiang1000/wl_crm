//
//  TestViewController.h
//  Wangli
//
//  Created by yeqiang on 2018/11/30.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CommonCreateBlock)(id param, id attachement);
typedef void(^CommonUpdateBlock)(id param, id attachement);

@interface TestViewController : BaseViewCtrl

@property (nonatomic, copy) CommonCreateBlock createBlock;
@property (nonatomic, copy) CommonUpdateBlock updateBlock;

@end

NS_ASSUME_NONNULL_END
