//
//  TrendsSampleMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsSampleMo : TrendsBaseMo

@property (nonatomic, copy) NSString <Optional> *sendTimesKey;  //;  //"first",
@property (nonatomic, strong) NSArray <Optional> *sampleApplications;
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *applicateDate;  //"2019-01-21",
@property (nonatomic, copy) NSString <Optional> *appReason;  //"申请",
@property (nonatomic, copy) NSString <Optional> *provideDate;  //null,
@property (nonatomic, copy) NSString <Optional> *producerValue;  //"浙江",
@property (nonatomic, copy) NSString <Optional> *experimentalReport;  //null,
//@property (nonatomic, copy) NSString <Optional> *id;  //99,
@property (nonatomic, copy) NSString <Optional> *reliabilityRemark;  //"可靠性",
@property (nonatomic, copy) NSString <Optional> *massProductionResultAttachments;  //null,
@property (nonatomic, copy) NSString <Optional> *massProduction;  //true,
@property (nonatomic, strong) NSArray <Optional> *reliabilityTests;
@property (nonatomic, copy) NSString <Optional> *addresseePhone;  //"12345678910",
@property (nonatomic, copy) NSString <Optional> *expectProvideDate;  //"2019-01-21",
@property (nonatomic, copy) NSString <Optional> *massProductionCount;  //0.00,
@property (nonatomic, copy) NSString <Optional> *sampleNum;  //"AXYPSQ20190121006",
@property (nonatomic, copy) NSString <Optional> *sort;  //10,
@property (nonatomic, copy) NSString <Optional> *massProductionResultRemark;  //"",
@property (nonatomic, copy) NSString <Optional> *salesAreaKey;  //"domestic",
@property (nonatomic, copy) NSString <Optional> *massProductionDate;  //null,
@property (nonatomic, copy) NSString <Optional> *producerKey;  //"ZHEJIANG",
@property (nonatomic, copy) NSString <Optional> *sampleTypeValue;  //"主动送样",
@property (nonatomic, copy) NSString <Optional> *massProductionResultKey;  //null,
@property (nonatomic, copy) NSString <Optional> *status;  //"REVIEW",
@property (nonatomic, copy) NSString <Optional> *monthFreeNum;  //2944.00,
@property (nonatomic, copy) NSString <Optional> *remark;  //null,
@property (nonatomic, copy) NSString <Optional> *title;  //"送样测试",
@property (nonatomic, copy) NSString <Optional> *totalCount;  //500.00,
@property (nonatomic, strong) NSArray <Optional> *attachmentList;  //null,
@property (nonatomic, strong) NSDictionary <Optional> *businessChance;  //null,
@property (nonatomic, copy) NSString <Optional> *requestId;  //"",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *approvalStatusDesp;  //"品质部审批",
@property (nonatomic, strong) NSDictionary <Optional> *productOperator;  //null,
@property (nonatomic, strong) NSArray <Optional> *sampleItems;
@property (nonatomic, copy) NSString <Optional> *appRemark;  //"用途",
@property (nonatomic, copy) NSString <Optional> *reservedSample;  //null,
@property (nonatomic, copy) NSString <Optional> *free;  //false,
@property (nonatomic, copy) NSString <Optional> *historySampleResult;  //null,
@property (nonatomic, copy) NSString <Optional> *nodeIdentifier;  //"pinzhibushenpi_yexz",
@property (nonatomic, copy) NSString <Optional> *historySampleFailedReason;  //null,
@property (nonatomic, copy) NSString <Optional> *address;  //"测试",
@property (nonatomic, copy) NSString <Optional> *salesAreaValue;  //"国内",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  //"2019-01-21 19:15:30",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  //"滕细权",
@property (nonatomic, copy) NSString <Optional> *logisticsPreparation;  //null,
@property (nonatomic, copy) NSString <Optional> *statusDesp;  //"审核中",
@property (nonatomic, copy) NSString <Optional> *createdDate;  //"2019-01-21 19:15:30",
@property (nonatomic, copy) NSString <Optional> *reservedSampleCount;  //0.00,
@property (nonatomic, copy) NSString <Optional> *createdBy;  //"滕细权",
@property (nonatomic, copy) NSString <Optional> *sendTimesValue;  //"首次",
@property (nonatomic, copy) NSString <Optional> *massProductionResultValue;  //null,
@property (nonatomic, copy) NSString <Optional> *recipient;  //"王二",
@property (nonatomic, copy) NSString <Optional> *inspectionReport;  //null,
@property (nonatomic, copy) NSString <Optional> *sampleTypeKey;  //"initiative_send_sample",
@property (nonatomic, copy) NSString <Optional> *contractNum;  //""

@end


@interface SampleItemMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *effectiveness; //; //"21.6",
@property (nonatomic, copy) NSString <Optional> *amount; //2000.00,
@property (nonatomic, copy) NSString <Optional> *efficiencyConvert; //null,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; //"2019-01-25 14:25:17",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; //"费婷",
@property (nonatomic, copy) NSString <Optional> *remark; //"",
@property (nonatomic, copy) NSString <Optional> *sort; //10,
@property (nonatomic, strong) NSDictionary <Optional> *sample;
@property (nonatomic, copy) NSString <Optional> *productName; //"单面PERC",
@property (nonatomic, copy) NSString <Optional> *efficiencyConvertManual; //"5.8",
@property (nonatomic, copy) NSString <Optional> *unitKey; //"PC",
@property (nonatomic, copy) NSString <Optional> *createdDate; //"2019-01-25 14:25:17",
@property (nonatomic, copy) NSString <Optional> *createdBy; //"费婷",
@property (nonatomic, copy) NSString <Optional> *materialNum; //"",
@property (nonatomic, assign) long long id; //135,
@property (nonatomic, copy) NSString <Optional> *unitValue; //"PC"

@end

NS_ASSUME_NONNULL_END

