//
//  CreateProductionLicenseViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "RecruitmentMo.h"

typedef enum : NSUInteger {
//    kProduceType,               // 产品信息
//    kFactoryType,               // 工厂设备
//    kMaterialType,              // 生产动态
//    kCompetitiveType,           // 竞品信息
    kLicenseType        = 0,    // 生产许可
    kPruchaseType,              // 采购招标
    kPortInfoType,              // 进出口信息
    kTaxRatingType,             // 税务评级
    kSpotCheckType,             // 抽查检查
} ProduceViewCtrlType;

@interface CreateProductionLicenseViewCtrl : BaseViewCtrl

@property (nonatomic, strong) RecruitmentMo *mo;
@property (nonatomic, assign) ProduceViewCtrlType type;

@end
