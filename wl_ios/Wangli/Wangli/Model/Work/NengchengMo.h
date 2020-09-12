//
//  NengchengMo.h
//  Wangli
//
//  Created by yeqiang on 2019/5/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface NengchengMo : JSONModel

@property (nonatomic, assign) NSInteger actualSign;//   1,
@property (nonatomic, assign) CGFloat cumulativeShipments;//   912,
@property (nonatomic, assign) CGFloat actualShipment;//   20,
@property (nonatomic, assign) CGFloat completionRate;//   2.44,
@property (nonatomic, assign) CGFloat ompletionRate;//   757.72,
@property (nonatomic, assign) BOOL finish;//   true,
@property (nonatomic, assign) long long id;//   3,
@property (nonatomic, assign) NSInteger visitIntentional;//   1,
@property (nonatomic, assign) NSInteger expectVisit;//   3,
@property (nonatomic, assign) CGFloat developmentProject;//   123,
@property (nonatomic, assign) CGFloat salesTarget;//   123,
@property (nonatomic, assign) NSInteger finishVisit;//   1,
@property (nonatomic, assign) NSInteger followUpReportingProject;//   "1",
@property (nonatomic, assign) NSInteger signIntention;//   1,
@property (nonatomic, assign) NSInteger actualVisit;//   1,
@property (nonatomic, assign) NSInteger accumulateVisit;//   2,
@property (nonatomic, assign) NSInteger followUpUnfulfilledProject;//   "1",
@property (nonatomic, assign) CGFloat projectedShipment;//   1

@property (nonatomic, copy) NSString <Optional> *date;//   "2019-05-08",
@property (nonatomic, copy) NSString <Optional> *afterSaleUnprocessed;//   "a",
@property (nonatomic, copy) NSString <Optional> *cityNumber;//   "640100",
@property (nonatomic, copy) NSString <Optional> *activity;//   "b",
@property (nonatomic, strong) NSMutableArray <Optional> *ncUnfulfilledProjects;
@property (nonatomic, copy) NSString <Optional> *remark;//   "aa",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, strong) NSMutableArray <Optional> *ncVisitIntentions;
@property (nonatomic, strong) NSMutableArray <Optional> *ncSignIntentions;
@property (nonatomic, copy) NSString <Optional> *cityName;//   "银川市",
@property (nonatomic, copy) NSString <Optional> *areaName;//   "西夏区",
@property (nonatomic, copy) NSString <Optional> *provinceNumber;//   "640000",
@property (nonatomic, strong) NSMutableArray <Optional> *ncReportingProjects;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;//   "2019-05-08 18:36:56",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;//   "管理员",
@property (nonatomic, strong) NSMutableArray <Optional> *nengChengItems;
@property (nonatomic, copy) NSString <Optional> *areaNumber;//   "640105",
@property (nonatomic, copy) NSString <Optional> *createdDate;//   "2019-05-08 18:36:55",
@property (nonatomic, copy) NSString <Optional> *createdBy;//   "管理员",
@property (nonatomic, copy) NSString <Optional> *provinceName;//   "宁夏回族自治区",
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;
@property (nonatomic, copy) NSString <Optional> *province;
@property (nonatomic, copy) NSString <Optional> *developmentProvince;
@property (nonatomic, copy) NSString <Optional> *handleStatus;//编辑状态
@property (nonatomic, copy) NSString <Optional> *workPlanDate;//计划工作日期

@end


@interface NengChengItemMo : JSONModel

@property (nonatomic, strong) NSDictionary <Optional> *memberAttribute;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;//   "2019-05-08 18:36:56",
@property (nonatomic, copy) NSString <Optional> *engineerProcessingMatters;//   工程处理事项,
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;//   "管理员",
//@property (nonatomic, copy) NSString <Optional> *sort;//   10,
@property (nonatomic, copy) NSString <Optional> *content;//   null,
@property (nonatomic, copy) NSString <Optional> *createdDate;//   "2019-05-08 18:36:56",
@property (nonatomic, copy) NSString <Optional> *createdBy;//   "管理员",
@property (nonatomic, strong) NSDictionary <Optional> *member;

@property (nonatomic, assign) BOOL policyProcessAdvocacy;//   政策引导,
@property (nonatomic, assign) BOOL monopoly;//   专卖,
@property (nonatomic, assign) BOOL comparativeSales;//   null,
@property (nonatomic, assign) long long id;//   57,
@property (nonatomic, assign) BOOL visit;//   null,
@property (nonatomic, assign) BOOL complete;//   null,
@property (nonatomic, assign) BOOL train;//   null

@property (nonatomic, strong) NSMutableArray <Optional> *attachments;

@end

NS_ASSUME_NONNULL_END
