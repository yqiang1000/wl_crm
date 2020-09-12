//
//  TheCustomerDefine.h
//  Wangli
//
//  Created by yeqiang on 2018/5/16.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerMo.h"
#import "MemberCenterMo.h"

#define TheCustomer [TheCustomerDefine shareInstance]

@interface TheCustomerDefine : NSObject

@property (nonatomic, strong) CustomerMo *customerMo;

@property (nonatomic, strong) MemberCenterMo *centerMo;

@property (nonatomic, strong) AuthorityBean *authorityBean;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *authoritys;

/**
 *  从哪里进入客户360，为后续横向刷新做判断 0:客户列表进，1:搜索列表进，2:收藏进
 */
@property (nonatomic, assign) NSInteger fromTab;

+ (TheCustomerDefine *)shareInstance;

// 更新当前全局客户
- (void)updateCustomer:(CustomerMo *)customer;
// 插入第二个客户
- (void)insertCustomer:(CustomerMo *)customer;
// 弹出当前客户
- (void)popCustomer;

- (void)releaseCustomers;


@end
