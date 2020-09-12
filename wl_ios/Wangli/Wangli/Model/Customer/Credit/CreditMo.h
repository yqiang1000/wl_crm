//
//  CreditMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CreditMo : JSONModel

@property (nonatomic, copy) NSString<Optional> *field;      //": "资产总额",
@property (nonatomic, copy) NSString<Optional> *fieldTitle;      //": "负债率：0.00%",
@property (nonatomic, copy) NSString<Optional> *fieldValue;      //": 0,
@property (nonatomic, copy) NSString<Optional> *unit;      //": "万",
@property (nonatomic, copy) NSString<Optional> *iconUrl;      //": ""

@end
