//
//  ContactDetailViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/6/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ContactMo.h"
#import "JYUserMo.h"

@interface ContactDetailViewCtrl : BaseViewCtrl

@property (nonatomic, strong) ContactMo *mo;

@property (nonatomic, strong) JYUserMo *userMo;

@end
