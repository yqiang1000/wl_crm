//
//  MarketWorkPlanViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/4/17.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "MarketEngineeringMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarketWorkPlanViewCtrl : BaseViewCtrl

// 是否获取昨日数据，YES：获取，NO 不获取，默认 NO
@property (nonatomic, assign) BOOL yesterdayData;

@property (nonatomic, strong) MarketEngineeringMo *model;

@end

NS_ASSUME_NONNULL_END
//private Date date;
//private Integer salesTarget;//销售目标
//private Integer projectedShipment;//预计发货量
//private Integer actualShipment;//实际发货量
//private BigDecimal ompletionRate;//目标完成率
//private Integer expectVisit;//预计走访客户
//private Integer actualVisit;//实际走访客户
//private String remark;//其他
//private String followUpReportingProject;//报备工程跟进
//private String followUpUnfulfilledProject;//超期未履行工程跟进
//private Set<MarketEngineeringItem> marketEngineeringItems;
//private Set<ReportingProject> reportingProjects;//报备工程跟进
//private Set<UnfulfilledProject> unfulfilledProjects;//超期未履行工程
