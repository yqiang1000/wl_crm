//
//  MemberCenterMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "RiskFollowMo.h"
#import "ContenBeansMo.h"
#import "IntelligenceItemBeanMo.h"

//@interface ContenBeansMo : JSONModel
//
//@property (nonatomic, copy) NSString <Optional> *date;
//@property (nonatomic, assign) NSInteger totalAmount;
//@property (nonatomic, assign) NSInteger dueAmount;
//
//@end

@protocol RiskFollowMo;
//@protocol ContentBeansMo;
@protocol IntelligenceItemBeanMo;

@interface MemberCenterMo : JSONModel

//@property (nonatomic, assign) NSInteger contactCount;
//@property (nonatomic, assign) NSInteger addressCount;
//@property (nonatomic, assign) NSInteger marketCount;
//@property (nonatomic, assign) NSInteger tradeCount;
@property (nonatomic, strong) NSArray <RiskFollowMo *> <RiskFollowMo, Optional> *riskWarnings;

//@property (nonatomic, assign) CGFloat totalPlanQuantity;
//@property (nonatomic, assign) CGFloat totalDeliveryQuantity;
//@property (nonatomic, assign) CGFloat quantityActualShip;
//@property (nonatomic, assign) CGFloat paymentAmount;
//@property (nonatomic, assign) CGFloat totalAmountInvoiced;
//@property (nonatomic, assign) CGFloat amountActualShip;

@property (nonatomic, strong) NSArray <Optional>*contenBeans;
@property (nonatomic, assign) CGFloat riskShip;

@property (nonatomic, copy) NSString <Optional> *creditLevelValue;//信用等级
@property (nonatomic, assign) NSInteger linkManCount;//联系人数量
@property (nonatomic, assign) NSInteger warningCount;//财务风险数量
@property (nonatomic, assign) NSInteger procurementStatusCount;//采购状况数量
@property (nonatomic, assign) NSInteger productStatusCount;//生产状况数量
@property (nonatomic, assign) NSInteger salesStatusCount;//销售状况数量
@property (nonatomic, assign) NSInteger researchStatusCount;//研发状况数量
@property (nonatomic, assign) NSInteger businessVisitCount;//商务拜访数量
@property (nonatomic, assign) NSInteger businessChanceCount;//商机跟进数量
@property (nonatomic, assign) NSInteger contractCount;//合同跟踪数量
@property (nonatomic, assign) NSInteger serviceComplaintCount;//服务投诉数量
@property (nonatomic, assign) NSInteger costAnalysisCount;//费用分析数量
@property (nonatomic, assign) NSInteger stormeManageCount;//门店数量
@property (nonatomic, assign) NSInteger dealerPlanCount;//经销商计划数量

@property (nonatomic, assign) CGFloat contractSumMonth;//本月合同总量
@property (nonatomic, assign) CGFloat orderSumMounth;//本月订单总量
@property (nonatomic, assign) CGFloat billingSumMonth;//本月开票数量
@property (nonatomic, assign) CGFloat receivedSumMonth;//本月回款数量

@property (nonatomic, assign) CGFloat contractShip;//本月合同完成率
@property (nonatomic, assign) CGFloat orderShip;//本月订单完成率
@property (nonatomic, assign) CGFloat billingShip;//本月开票完成率
@property (nonatomic, assign) CGFloat receivedShip;//本月合同完成率
@property (nonatomic, copy) NSString <Optional> *title;//标题
@property (nonatomic, assign) long long favorite;//收藏的id
@property (nonatomic, strong) NSArray <IntelligenceItemBeanMo *> <IntelligenceItemBeanMo, Optional> *intelligenceItemBeans;//企业动态

@end
