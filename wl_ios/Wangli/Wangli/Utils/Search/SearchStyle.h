//
//  SearchStyle.h
//  Wangli
//
//  Created by yeqiang on 2018/5/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum SearchType {
    SearchCustomer = 0,     // 客户
    SearchContact,          // 联系人
    SearchDealPlan,         // 要货计划
    SearchPayPlan,          // 收款计划
    SearchOrder,            // 订单
    SearchTask,             // 协作任务
    SearchCollectionDeal,   // 收藏的要货计划
}SearchType;

@interface SearchStyle : NSObject

/** 缓存关键字 */
@property (nonatomic, copy) NSString *cacheKey;

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholdStr;

/** 是否显示热门 */
@property (nonatomic, assign) BOOL isHidenHot;

/** 类型 */
@property (nonatomic, assign) SearchType type;

/** 占位文字 */
+ (NSString *)placeholdString:(SearchType)type;

@end
