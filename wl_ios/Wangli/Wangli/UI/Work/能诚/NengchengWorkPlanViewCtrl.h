//
//  NengchengWorkPlanViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/5/9.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "NengchengMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NengchengWorkPlanViewCtrl : BaseViewCtrl

@property (nonatomic, strong) NengchengMo *model;

@end

NS_ASSUME_NONNULL_END

//nengCheng:
//private Operator operator;
//private Date date;
//private Long salesTarget;//当月销售目标
//private Long cumulativeShipments;//当月累计发货量
//private Long projectedShipment;//当日预计发货量
//private Long actualShipment;//当日实际发货量
//private BigDecimal ompletionRate;//月目标完成率
//private String provinceName;//省份
//private String provinceNumber;
//private String cityName;//城市
//private String cityNumber;
//private String areaName;//区域
//private String areaNumber;
//private Long expectVisit;//预计走访客户
//private Long actualVisit;//实际走访客户
//private String remark;//其他
//private String afterSaleUnprocessed;//售后未处理事项
//private String activity;//活动
//private Boolean finish;//是否完成：true：完成。false：未完成
//private List<Attachment> attachments;
//private Set<NengChengItem> nengChengItems;//明细
//private Long developmentProject;//当月开发目标
//private Long accumulateVisit;//当月累计拜访
//private Long visitIntentional;//当日拜访意向客户
//private Long finishVisit;//当日完成拜访
//private BigDecimal completionRate;//月目标完成率
//private Long signIntention;//当日签署意向客户
//private Long actualSign;//当日实际签署
//private Set<NcVisitIntention> ncVisitIntentions;//拜访意向客户明细
//private Set<NcSignIntention> ncSignIntentions;//签署意向客户明细
//private String followUpReportingProject;//报备工程跟进
//private String followUpUnfulfilledProject;//超期未履行工程跟进
//private Set<NcReportingProject> ncReportingProjects;//报备工程跟进
//private Set<NcUnfulfilledProject> ncUnfulfilledProjects;//未履行工程
//nengChengItem:
//private NengCheng nengCheng;
//private Member member;
//private Dict memberAttribute;//客户属性
//private Boolean visit;//是否走访
//private Boolean monopoly;//是否专卖
//private Boolean complete;//基本款上样是否齐全
//private Boolean comparativeSales;//对比销售
//private Boolean policyProcessAdvocacy;//政策流程宣导
//private Boolean train;//培训
//private String content;//内容
//private List<Attachment> attachments;
//private String engineerProcessingMatters;//工程处理事项
//ncVisitIntention:
//private NengCheng nengCheng;
//private String member;
//private Boolean visit;//是否拜访
//private String managementBrand;//现经营品牌
//private Integer annualSalesVolume;//年销量
//private String cooperationIntention;//合作意向
//NcSignIntention
//private NengCheng nengCheng;
//private String member;
//private Boolean sign;//是否签署
//NcReportingProject:
//private NengCheng nengCheng;
//private String engineering;//工程
//private Boolean followUp;//是否跟进
//private String followUpResults;//跟进结果
//NcUnfulfilledProject:
//private NengCheng nengCheng;
//private String engineering;//工程
//private String reasonsNoPerformance;//未履行原因
//private Boolean effective;//合同是否有效
//private Date estimatedOrderTime;//预计下单时间

//    CommonRowMo *rowMo = nil;
//    for (int i = 0; i < self.arrData.count; i++) {
//        CommonRowMo *tmpRowMo = self.arrData[i];
//        if ([tmpRowMo.key isEqualToString:@"salesTarget"]) {
//            rowMo = tmpRowMo;
//            break;
//        }
//    }
