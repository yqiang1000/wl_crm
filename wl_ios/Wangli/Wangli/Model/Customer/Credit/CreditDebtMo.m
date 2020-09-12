//
//  CreditDebtMo.m
//  Wangli
//
//  Created by yeqiang on 2018/8/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreditDebtMo.h"

@implementation CreditDebtMo

- (void)setCompanyList:(NSMutableArray<Optional> *)companyList {
    NSError *error = nil;
    _companyList = [CustomerMo arrayOfModelsFromDictionaries:companyList error:&error];
    NSLog(@"%@", error);
}

@end
