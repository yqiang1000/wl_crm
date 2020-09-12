//
//  CreateAddressViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/4/16.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "AddressMo.h"

typedef void(^AddSuccessBlock)(AddressMo *mo);

@interface CreateAddressViewCtrl : BaseViewCtrl

@property (nonatomic, copy) AddSuccessBlock addSuccessBlock;

@property (nonatomic, strong) AddressMo *mo;

@end
