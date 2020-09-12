//
//  CreateProductViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ProductMo.h"

typedef void(^CreateSuccess)(ProductMo *model);

@interface CreateProductViewCtrl : BaseViewCtrl

@property (nonatomic, strong) ProductMo *mo;
@property (nonatomic, copy) CreateSuccess success;

@end
