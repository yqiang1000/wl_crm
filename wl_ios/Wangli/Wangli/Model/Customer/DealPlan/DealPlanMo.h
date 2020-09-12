//
//  DealPlanMo.h
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MaterialMo.h"

@protocol MaterialMo;

@interface DealPlanMo : JSONModel

@property (nonatomic, copy) NSString<Optional> *createdBy;
@property (nonatomic, copy) NSString<Optional> *createdDate;
@property (nonatomic, copy) NSString<Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString<Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString<Optional> *fromClientType;
@property (nonatomic, copy) NSString<Optional> *number;
@property (nonatomic, strong) NSDictionary<Optional> *member;

@property (nonatomic, strong) NSDictionary <Optional> *material;
@property (nonatomic, copy) NSString<Optional> *year;
@property (nonatomic, copy) NSString<Optional> *month;
@property (nonatomic, strong) NSDictionary <Optional> *office;
@property (nonatomic, strong) NSDictionary<Optional> *salesMan;

@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *statusValue;
@property (nonatomic, assign) CGFloat quantity;
@property (nonatomic, assign) CGFloat adjustedQuantity;
@property (nonatomic, copy) NSString<Optional> *unit;
@property (nonatomic, copy) NSString<Optional> *weight;

@property (nonatomic, copy) NSString<Optional> *actualShip;
@property (nonatomic, assign) CGFloat issuedQuantity;
@property (nonatomic, strong) NSDictionary <Optional> *undoneReasonType;
@property (nonatomic, copy) NSString<Optional> *reasonDesp;
@property (nonatomic, copy) NSString<Optional> *undoneRemark;

@property (nonatomic, assign) CGFloat showQuantity;

@property (nonatomic, copy) NSString<Optional> *batchNumber;
@property (nonatomic, copy) NSString<Optional> *productLevel;
@property (nonatomic, copy) NSString<Optional> *productLevelName;
@property (nonatomic, copy) NSString<Optional> *productPlace;
@property (nonatomic, copy) NSString<Optional> *factoryNumber;//工厂号
@property (nonatomic, copy) NSString<Optional> *factory;//工厂
@property (nonatomic, copy) NSString<Optional> *spec;   //规格
//private ProcessStatus status;//状态
//private BigDecimal quantity;//数量
//private BigDecimal adjustedQuantity;//调整数量
//private String unit;//单位
//private BigDecimal weight;//重量
//private String actualShip;//实际完成比（按照 0.00%保存）
//private BigDecimal issuedQuantity;//已发数量
//private Dict undoneReasonType;//未完成原因类型
//private String undoneRemark;//未完成备注

//    ONAPPLICATION("申请中"),
//    APPROVALED("已审批"),
//    RETURNED("已退回");

@end
