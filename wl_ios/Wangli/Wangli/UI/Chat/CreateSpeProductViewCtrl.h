//
//  CreateSpeProductViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/8/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ProductMo.h"

@interface CreateSpeProductViewCtrl : BaseViewCtrl

@property (nonatomic, assign) BOOL isOrder;
@property (nonatomic, strong) ProductMo *productMo;

@end
