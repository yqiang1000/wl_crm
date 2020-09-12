//
//  BusinessReceptionMo.h
//  Wangli
//
//  Created by yeqiang on 2019/3/11.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessReceptionMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *receptionStatusKey;    //;    //"not_started",
@property (nonatomic, copy) NSString <Optional> *meetingStandard;    //"广东地区特殊级别会议接待标准(国内)",
@property (nonatomic, strong) NSArray <Optional> *recepitorItems;
@property (nonatomic, copy) NSString <Optional> *endDate;    //"2019-03-04",
@property (nonatomic, copy) NSString <Optional> *receptionStatusValue;    //"未开始",
@property (nonatomic, copy) NSString <Optional> *mealStandard;    //"广东地区特殊级别用餐接待标准(国内)",
@property (nonatomic, copy) NSString <Optional> *hotelLevelKey;    //"five_star",
@property (nonatomic, copy) NSString <Optional> *planTicketFinalPlan;    //"",
@property (nonatomic, copy) NSString <Optional> *contactTel;    //"18667615607",
@property (nonatomic, copy) NSString <Optional> *receptionLevelDesp;    //"特殊",
@property (nonatomic, copy) NSString <Optional> *meetingFinalPlan;    //"",
@property (nonatomic, copy) NSString <Optional> *timeSlotCar;    //"",
@property (nonatomic, copy) NSString <Optional> *giftNum;    //null,
@property (nonatomic, copy) NSString <Optional> *planTicketStandard;    //"广东地区特殊级别票务接待标准(国内)",
@property (nonatomic, assign) long long id;    //58,
@property (nonatomic, copy) NSString <Optional> *mealFinalPlan;    //"",
@property (nonatomic, copy) NSString <Optional> *carOtherAppeal;    //"",
@property (nonatomic, copy) NSString <Optional> *receptionCountryTypeDesp;    //"国内",
@property (nonatomic, copy) NSString <Optional> *visitingReason;    //"答复",
@property (nonatomic, copy) NSString <Optional> *meetingOtherAppeal;    //"",
@property (nonatomic, copy) NSString <Optional> *predetermineMeetingRoom;    //"",
@property (nonatomic, copy) NSString <Optional> *contactName;    //"杨春花",
@property (nonatomic, copy) NSString <Optional> *sort;    //10,
@property (nonatomic, strong) NSArray <Optional> *visitorItems;
@property (nonatomic, copy) NSString <Optional> *mealOtherAppeal;    //"",
@property (nonatomic, copy) NSString <Optional> *giftStandard;    //"广东地区特殊级别礼品接待标准(国内)",
@property (nonatomic, copy) NSString <Optional> *giftOtherAppeal;    //"",
@property (nonatomic, copy) NSString <Optional> *approvalNodeDesp;    //null,
@property (nonatomic, copy) NSString <Optional> *applyRemark;    //"",
@property (nonatomic, copy) NSString <Optional> *mealArea;    //"",
@property (nonatomic, copy) NSString <Optional> *workShopOtherAppeal;    //"",
@property (nonatomic, copy) NSString <Optional> *receptionLevel;    //"SPECIAL",
@property (nonatomic, copy) NSString <Optional> *visitingObjects;    //"大师傅",
@property (nonatomic, copy) NSString <Optional> *hotelOtherAppeal;    //"",
@property (nonatomic, copy) NSString <Optional> *hotelLevelValue;    //"五星级",
@property (nonatomic, copy) NSString <Optional> *hotelStandard;    //"广东地区特殊级别酒店接待标准(国内)",
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;    //null,
@property (nonatomic, copy) NSString <Optional> *receptionCompanyDesp;    //"广东",
@property (nonatomic, copy) NSString <Optional> *title;    //"dfasdf ",
@property (nonatomic, strong) NSDictionary <Optional> *accountManager;
@property (nonatomic, copy) NSString <Optional> *meetingData;    //null,
@property (nonatomic, copy) NSString <Optional> *hotelFinalPlan;    //"",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *approvalStatusDesp;    //"审批完成",
@property (nonatomic, copy) NSString <Optional> *receptionCountryType;    //"DOMESTIC",
@property (nonatomic, copy) NSString <Optional> *workShopStandard;    //"广东地区特殊级别车间参观接待标准(国内)",
@property (nonatomic, copy) NSString <Optional> *explainMeeting;    //"",
@property (nonatomic, copy) NSString <Optional> *approvalStatus;    //"approvaledInCrm",
@property (nonatomic, copy) NSString <Optional> *meetingResource;    //"",
@property (nonatomic, copy) NSString <Optional> *carStandard;    //"广东地区特殊级别车辆接待标准(国内)",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    //"2019-03-04 20:12:24",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    //"丁宁",
@property (nonatomic, copy) NSString <Optional> *carFinalPlan;    //"",
@property (nonatomic, copy) NSString <Optional> *planTicketOtherAppeal;    //"",
@property (nonatomic, strong) NSDictionary <Optional> *createOperator;
@property (nonatomic, copy) NSString <Optional> *approvalNodeIdentifier;    //null,
@property (nonatomic, copy) NSString <Optional> *receptionObjects;    //"士大夫",
@property (nonatomic, copy) NSString <Optional> *receptionCompany;    //"GUANGDONG",
@property (nonatomic, copy) NSString <Optional> *beginDate;    //"2019-03-04",
@property (nonatomic, copy) NSString <Optional> *createdDate;    //"2019-03-04 19:42:30",
@property (nonatomic, copy) NSString <Optional> *workShopFinalPlan;    //"",
@property (nonatomic, copy) NSString <Optional> *createdBy;    //"潘梦洋",
@property (nonatomic, copy) NSString <Optional> *giftFinalPlan;    //""
@property (nonatomic, assign) BOOL needPlanTicket;    //true,
@property (nonatomic, assign) BOOL meetingNameplate;    //true,
@property (nonatomic, assign) BOOL needCar;    //true,
@property (nonatomic, assign) BOOL needHotel;    //true,
@property (nonatomic, assign) BOOL needMeetingRoom;    //true,
@property (nonatomic, assign) BOOL needMeal;    //true,
@property (nonatomic, assign) BOOL needGift;    //true,
@property (nonatomic, assign) BOOL needVisitWorkShop;    //true,


@end

NS_ASSUME_NONNULL_END
