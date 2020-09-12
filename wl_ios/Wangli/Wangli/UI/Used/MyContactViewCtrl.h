//
//  MyContactViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

typedef enum ContactType {
    ContactMyPart       = 0,
    ContactCompany,
    ContactMyFollow,
    ContactImport,
    ContactCustomer
} ContactType;

@interface MyContactViewCtrl : BaseViewCtrl

@property (nonatomic, assign) ContactType type;

@end
