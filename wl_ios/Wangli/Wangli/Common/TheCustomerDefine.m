//
//  TheCustomerDefine.m
//  Wangli
//
//  Created by yeqiang on 2018/5/16.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TheCustomerDefine.h"

static TheCustomerDefine *instance;
static NSMutableArray *_arrCustomers;


@implementation TheCustomerDefine

+ (TheCustomerDefine *)shareInstance {
    static TheCustomerDefine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TheCustomerDefine alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _arrCustomers = [NSMutableArray new];
    }
    return self;
}

- (void)setCustomerMo:(CustomerMo *)customerMo {
    if (customerMo) [_arrCustomers addObject:customerMo];
}

// 更新当前全局客户
- (void)updateCustomer:(CustomerMo *)customer {
    if (customer && _arrCustomers.count > 0) {
        [_arrCustomers replaceObjectAtIndex:_arrCustomers.count-1 withObject:customer];
    }
}

// 插入第二个客户
- (void)insertCustomer:(CustomerMo *)customer {
    if (customer) [_arrCustomers addObject:customer];
}

// 弹出当前客户
- (void)popCustomer {
    if (_arrCustomers.count > 0) {
        [_arrCustomers removeLastObject];
    }
    if (_arrCustomers.count > 0) {
        CustomerMo *lastMo = _arrCustomers.lastObject;
        self.authorityBean = [[AuthorityBean alloc] initWithDictionary:lastMo.authorityBean error:nil];
    }
}

- (void)releaseCustomers {
    [_arrCustomers removeAllObjects];
}

// 获取最近的一个客户对象
- (CustomerMo *)customerMo {
    if (_arrCustomers.count > 0) {
        CustomerMo *lastMo = _arrCustomers.lastObject;
//        self.authorityBean = [[AuthorityBean alloc] initWithDictionary:lastMo.authorityBean error:nil];
        return lastMo;
    }
    return nil;
}

- (void)setAuthorityBean:(AuthorityBean *)authorityBean {
    
    if (!_authorityBean) {
        _authorityBean = [[AuthorityBean alloc] init];
    }
    _authorityBean = authorityBean;
    
//    if (_authorityBean != nil) {
//        [self.authoritys replaceObjectAtIndex:0 withObject:@(_authorityBean.base)];
//        [self.authoritys replaceObjectAtIndex:1 withObject:@(_authorityBean.linkMan)];
//        [self.authoritys replaceObjectAtIndex:2 withObject:@(_authorityBean.financialRisk)];
//        [self.authoritys replaceObjectAtIndex:3 withObject:@(_authorityBean.procurementStatus)];
//        [self.authoritys replaceObjectAtIndex:4 withObject:@(_authorityBean.productionStatus)];
//
//        [self.authoritys replaceObjectAtIndex:5 withObject:@(_authorityBean.salesStatus)];
//        [self.authoritys replaceObjectAtIndex:6 withObject:@(_authorityBean.developmentStatus)];
//        [self.authoritys replaceObjectAtIndex:7 withObject:@(_authorityBean.businessVisit)];
//        [self.authoritys replaceObjectAtIndex:8 withObject:@(_authorityBean.businessFollow)];
//        [self.authoritys replaceObjectAtIndex:9 withObject:@(_authorityBean.contractTracking)];
////        [self.authoritys replaceObjectAtIndex:10 withObject:@(_authorityBean.serviceComplaint)];
////        [self.authoritys replaceObjectAtIndex:11 withObject:@(_authorityBean.costAnalysis)];
//        [self.authoritys replaceObjectAtIndex:12 withObject:@(_authorityBean.system)];
//    }
}

- (NSMutableArray *)authoritys {
    if (!_authoritys) {
        _authoritys = [NSMutableArray new];
        for (int i = 0; i < 13; i++) {
            [_authoritys addObject:@(1)];
        }
    }
    return _authoritys;
}


@end
