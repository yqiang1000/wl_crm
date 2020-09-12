//
//  TravelMo.h
//  Wangli
//
//  Created by yeqiang on 2019/4/28.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TravelMo : JSONModel

@property (nonatomic, assign) long long id;

@property (nonatomic, copy) NSString <Optional> *noRealNameRemark; //; //"哦哦",
@property (nonatomic, copy) NSString <Optional> *kcTransport; //"78",
@property (nonatomic, copy) NSString <Optional> *stayReimbursementStandard; //"20",
@property (nonatomic, copy) NSString <Optional> *hgfTransport; //"高铁",
@property (nonatomic, copy) NSString <Optional> *cityTrafficInvoiceAmount; //"25",
@property (nonatomic, copy) NSString <Optional> *endDate; //"2019-04-25",
@property (nonatomic, copy) NSString <Optional> *mealBusinessTrip; //"a",
@property (nonatomic, copy) NSString <Optional> *commit; //null,
@property (nonatomic, copy) NSString <Optional> *cityTrafficReimbursementAmount; //"250",
@property (nonatomic, copy) NSString <Optional> *remark; //"g",
@property (nonatomic, copy) NSString <Optional> *travelStatusDesp; //"提交OA成功",
@property (nonatomic, copy) NSString <Optional> *title; //"差旅报销-管理员-2019-04-24",
@property (nonatomic, strong) NSDictionary <Optional> *cohabitOperator;
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *cityTrafficReimbursementStandard; //"250",
@property (nonatomic, copy) NSString <Optional> *requestId; //null,
@property (nonatomic, copy) NSString <Optional> *hotel; //"h",
@property (nonatomic, copy) NSString <Optional> *plannedBusinessTrip; //"上海",
@property (nonatomic, copy) NSString <Optional> *stayInvoiceAmount; //"100",
@property (nonatomic, copy) NSString <Optional> *otherExpenses; //"d",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; //"2019-04-29 11:28:34",
@property (nonatomic, copy) NSString <Optional> *stayReimbursementAmount; //"20",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; //"管理员",
@property (nonatomic, copy) NSString <Optional> *placeDeparture; //"杭州",
@property (nonatomic, copy) NSString <Optional> *createdDate; //"2019-04-29 11:28:34",
@property (nonatomic, copy) NSString <Optional> *travelStatus; //"SUCCESS",
@property (nonatomic, copy) NSString <Optional> *noRealNameTransport; //"78",
@property (nonatomic, copy) NSString <Optional> *createdBy; //"管理员",
@property (nonatomic, copy) NSString <Optional> *travelDate; //"2019-04-24",
@property (nonatomic, copy) NSString <Optional> *placeArrival; //"上海",
@property (nonatomic, copy) NSString <Optional> *reimbursementCity; //"杭州",
@property (nonatomic, copy) NSString <Optional> *mealAllowance; //"啊"

@end

NS_ASSUME_NONNULL_END
