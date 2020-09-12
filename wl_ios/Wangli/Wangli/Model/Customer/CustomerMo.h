//
//  CustomerMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/2.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TagMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *desp;
@property (nonatomic, assign) BOOL isSelect;

@end

@interface AuthorityBean : JSONModel

@property (nonatomic, copy) NSString <Optional> *transactionType;

@property (nonatomic, assign) BOOL base; //基本资料
@property (nonatomic, assign) BOOL linkMan; //人事组织
@property (nonatomic, assign) BOOL financialRisk; //财务风险
@property (nonatomic, assign) BOOL procurementStatus; //采购状况
@property (nonatomic, assign) BOOL productionStatus; //生产及品质
@property (nonatomic, assign) BOOL salesStatus; //销售状况
@property (nonatomic, assign) BOOL developmentStatus; //研发状况
@property (nonatomic, assign) BOOL businessVisit; //商务拜访
@property (nonatomic, assign) BOOL businessFollow; //商务跟进
@property (nonatomic, assign) BOOL contractTracking; //合同跟踪
@property (nonatomic, assign) BOOL serviceComplaint; //服务投诉
@property (nonatomic, assign) BOOL costAnalysis; //费用分析
@property (nonatomic, assign) BOOL system;      //系统信息
@property (nonatomic, assign) BOOL topFlag; //权限



@end


@protocol TagMo;
@protocol AuthorityBean;

@interface CustomerMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) long long id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *cnumber;
@property (nonatomic, copy) NSString <Optional> *password;
@property (nonatomic, copy) NSString <Optional> *orgName;
@property (nonatomic, copy) NSString <Optional> *transactionType;
@property (nonatomic, strong) NSDictionary  <Optional> *office;
@property (nonatomic, strong) NSDictionary  <Optional> *salesman;
@property (nonatomic, copy) NSString <Optional> *riskLevel;
@property (nonatomic, copy) NSString <Optional> *superiorDealer;
@property (nonatomic, assign) NSInteger accountPeriod;
@property (nonatomic, copy) NSString <Optional> *credit;
@property (nonatomic, copy) NSString <Optional> *field;
@property (nonatomic, copy) NSString <Optional> *application;
@property (nonatomic, copy) NSString <Optional> *avatarUrl;
@property (nonatomic, copy) NSString <Optional> *sapNumber;
@property (nonatomic, copy) NSString <Optional> *abbreviation;
@property (nonatomic, copy) NSString <Optional> *status;
@property (nonatomic, copy) NSString <Optional> *simpleSpell;
@property (nonatomic, copy) NSString <Optional> *level;
@property (nonatomic, copy) NSString <Optional> *saleOrgNumber;
@property (nonatomic, copy) NSString <Optional> *saleOrgName;
@property (nonatomic, copy) NSString <Optional> *distributionChannelName;
@property (nonatomic, copy) NSString <Optional> *distributionChannelNumber;
@property (nonatomic, assign) NSInteger registeredCapital;
@property (nonatomic, copy) NSString <Optional> *taxNumber;
@property (nonatomic, copy) NSString <Optional> *accountBank;
@property (nonatomic, copy) NSString <Optional> *registeredAddress;
@property (nonatomic, copy) NSString <Optional> *legalName;
@property (nonatomic, copy) NSString <Optional> *businessScope;
@property (nonatomic, copy) NSString <Optional> *provinceName;
@property (nonatomic, copy) NSString <Optional> *provinceNumber;
@property (nonatomic, copy) NSString <Optional> *cityName;
@property (nonatomic, copy) NSString <Optional> *cityNumber;
@property (nonatomic, copy) NSString <Optional> *areaName;
@property (nonatomic, copy) NSString <Optional> *areaNumber;
@property (nonatomic, copy) NSString <Optional> *companyAddress;
@property (nonatomic, copy) NSString <Optional> *companyPhone;
@property (nonatomic, copy) NSString <Optional> *registrationDate;
@property (nonatomic, copy) NSString <Optional> *creditCode;
@property (nonatomic, copy) NSString <Optional> *businessStatus;
@property (nonatomic, copy) NSString <Optional> *companyType;
@property (nonatomic, copy) NSString <Optional> *operatingPeriodFrom;
@property (nonatomic, copy) NSString <Optional> *operatingPeriodTo;
@property (nonatomic, copy) NSString <Optional> *website;
@property (nonatomic, copy) NSString <Optional> *productGroupNumber;
@property (nonatomic, copy) NSString <Optional> *productGroupName;
@property (nonatomic, copy) NSString <Optional> *saleRegionNumber;
@property (nonatomic, copy) NSString <Optional> *saleRegionName;
@property (nonatomic, copy) NSString <Optional> *paymentTermNumber;
@property (nonatomic, copy) NSString <Optional> *paymentTermName;
@property (nonatomic, copy) NSString <Optional> *creditRiskTotalAmount;
@property (nonatomic, copy) NSString <Optional> *accountsReceivable;
@property (nonatomic, copy) NSString <Optional> *specialDebt;
@property (nonatomic, copy) NSString <Optional> *creditModifyDate;
@property (nonatomic, assign) CGFloat owedTotalAmount;
@property (nonatomic, assign) CGFloat dueTotalAmount;
@property (nonatomic, assign) NSInteger maxDueDays;
@property (nonatomic, copy) NSString <Optional> *cartItems;
@property (nonatomic, strong) NSArray <Optional> *orders;
@property (nonatomic, copy) NSString <Optional> *orderLogs;
@property (nonatomic, strong) NSArray <TagMo *> <Optional> *labels;
@property (nonatomic, strong) NSArray <Optional> *operators;
@property (nonatomic, copy) NSString <Optional> *dunningFailures;
@property (nonatomic, copy) NSString <Optional> *monthlyCreditCounts;
@property (nonatomic, copy) NSString <Optional> *productRequests;
@property (nonatomic, copy) NSString <Optional> *products;
@property (nonatomic, copy) NSString <Optional> *lastTransactionDays;

@property (nonatomic, assign) NSInteger salesmanId;
@property (nonatomic, copy) NSString <Optional> *salesmanName;
@property (nonatomic, assign) NSInteger officeId;
@property (nonatomic, copy) NSString <Optional> *officeName;
@property (nonatomic, assign) BOOL memberRelease;
@property (nonatomic, assign) BOOL transfer;
@property (nonatomic, assign) BOOL claim;
@property (nonatomic, copy) NSString <Optional> *headUrl;
@property (nonatomic, assign) NSInteger lastTransactionDayCount;
@property (nonatomic, copy) NSString <Optional> *completeness;
@property (nonatomic, assign) BOOL badDebt;

@property (nonatomic, copy) NSString <Optional> *knkli;


@property (nonatomic, copy) NSString <Optional> *crmNumber;
@property (nonatomic, copy) NSString <Optional> *statusKey;
@property (nonatomic, copy) NSString <Optional> *statusValue;
@property (nonatomic, copy) NSString <Optional> *cooperationType;
@property (nonatomic, copy) NSString <Optional> *memberLevelKey;
@property (nonatomic, copy) NSString <Optional> *memberLevelValue;
@property (nonatomic, copy) NSString <Optional> *straightShow;
@property (nonatomic, copy) NSString <Optional> *arName;
@property (nonatomic, copy) NSString <Optional> *frName;
@property (nonatomic, copy) NSString <Optional> *srName;


// center接口返回的数据

@property (nonatomic, assign) long long memberId;  // 2537,
//@property (nonatomic, copy) NSString <Optional> *orgName;  // "新建客户消息测试",
//@property (nonatomic, copy) NSString <Optional> *crmNumber;  // "A20190112001",
//@property (nonatomic, copy) NSString <Optional> *statusValue;  // "潜在",
//@property (nonatomic, copy) NSString <Optional> *labels;  // [],
@property (nonatomic, copy) NSString <Optional> *creditLevelValue;  // "AAA",
//@property (nonatomic, copy) NSString <Optional> *avatarUrl;  // null,
@property (nonatomic, copy) NSString <Optional> *linkManCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *warningCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *procurementStatusCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *productStatusCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *salesStatusCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *researchStatusCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *businessVisitCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *businessChanceCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *contractCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *serviceComplaintCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *costAnalysisCount;  // 0,
@property (nonatomic, copy) NSString <Optional> *contractSumMonth;  // 200,
@property (nonatomic, copy) NSString <Optional> *orderSumMounth;  // 200,
@property (nonatomic, copy) NSString <Optional> *billingSumMonth;  // 300,
@property (nonatomic, copy) NSString <Optional> *receivedSumMonth;  // 400,
@property (nonatomic, copy) NSString <Optional> *contractShip;  // 0,
@property (nonatomic, copy) NSString <Optional> *orderShip;  // 0,
@property (nonatomic, copy) NSString <Optional> *billingShip;  // 0,
@property (nonatomic, copy) NSString <Optional> *receivedShip;  // 0,
@property (nonatomic, copy) NSString <Optional> *title;  // "1月1日-1月30日",
@property (nonatomic, copy) NSString <Optional> *favorite;  // -1,
@property (nonatomic, copy) NSString <Optional> *stormeManageCount;//门店数量
@property (nonatomic, copy) NSString <Optional> *dealerPlanCount;//经销商计划数量
@property (nonatomic, strong) NSArray <Optional> *intelligenceItemBeans;  // [],
@property (nonatomic, strong) NSDictionary <Optional> *authorityBean;  // null

@property (nonatomic, strong) NSString <Optional> *stras;//街道

@property (nonatomic, strong) NSString <Optional> *cooperationTypeKey;

@property (nonatomic, assign) long long arId;
@property (nonatomic, assign) long long frId;
@property (nonatomic, assign) long long srId;


@property (nonatomic, assign) NSInteger linkManTotalCount;


@property (nonatomic, assign) long long operatorId;
@property (nonatomic, copy) NSString <Optional> *operatorName;
@property (nonatomic, copy) NSString <Optional> *creditLevelKey;
@property (nonatomic, copy) NSString <Optional> *brand;

@end
