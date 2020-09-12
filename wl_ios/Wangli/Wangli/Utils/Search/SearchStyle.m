//
//  SearchStyle.m
//  Wangli
//
//  Created by yeqiang on 2018/5/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "SearchStyle.h"

@implementation SearchStyle

- (instancetype)init {
    self = [super init];
    if (self) {
        _isHidenHot = YES;
    }
    return self;
}

+ (NSString *)placeholdString:(SearchType)type {
    switch (type) {
        case SearchCustomer:
        {
            return @"客户名称/首字母/联系人名称/电话";
        }
            break;
        case SearchContact:
        {
            return @"请输入姓名/首字母/手机号";
        }
            break;
        case SearchDealPlan:
        {
            return @"请输入批号";
        }
            break;
        case SearchPayPlan:
        {
            return @"请输入客户/批号";
        }
            break;
        case SearchOrder:
        {
            return @"搜索订单客户名/订单编号/产品关键字等";
        }
            break;
        case SearchTask:
        {
            return @"请输入任务关键字等";
        }
            break;
        case SearchCollectionDeal:
        {
            return @"请输入批号/客户";
        }
            break;
        default:
            return @"";
            break;
    }
}

- (void)setType:(SearchType)type {
    _type = type;
    switch (_type) {
        case SearchCustomer:
        {
            self.cacheKey = @"history_search_List";
            self.placeholdStr = @"客户名称/首字母/联系人名称/电话";
        }
            break;
        case SearchContact:
        {
            self.cacheKey = @"contact_search_list";
            self.placeholdStr = @"请输入姓名/首字母/手机号";
        }
            break;
        case SearchDealPlan:
        {
            self.cacheKey = @"dealPlan_search_list";
            self.placeholdStr = @"请输入批号";
        }
            break;
        case SearchPayPlan:
        {
            self.cacheKey = @"payPlan_search_list";
            self.placeholdStr = @"请输入批号/客户";
        }
            break;
        case SearchOrder:
        {
            self.cacheKey = @"order_search_list";
            self.placeholdStr = @"搜索订单客户名/产品关键字等";
        }
            break;
        case SearchTask:
        {
            self.cacheKey = @"task_search_list";
            self.placeholdStr = @"请输入任务关键字等";
        }
            break;
        case SearchCollectionDeal:
        {
            self.cacheKey = @"dealPlan_search_list";
            self.placeholdStr = @"请输入批号/客户";
        }
            break;
        default:
            break;
    }
}

@end
