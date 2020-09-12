//
//  CreditDebtMo.h
//  Wangli
//
//  Created by yeqiang on 2018/8/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CompanyCodeMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *amount;
@property (nonatomic, copy) NSString <Optional> *companyCode;

@end


@protocol CompanyCodeMo;

@interface CreditDebtMo : JSONModel

@property (nonatomic, strong) NSDictionary <Optional> *companyCode;
@property (nonatomic, strong) NSMutableArray <Optional> *companyList;

@end
