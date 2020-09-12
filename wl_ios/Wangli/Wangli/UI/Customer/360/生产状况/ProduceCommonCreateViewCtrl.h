//
//  ProduceCommonCreateViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CommonAutoViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *K_PRODUCT_STANDARD = @"product-standard";// 标准 2637
static NSString *K_PRODUCT_PRODUCT = @"product-info";//  产品信息 2638
static NSString *K_PRODUCT_FACTORY = @"factory-equipment";//  工厂设备 2639
static NSString *K_PRODUCT_CAPACITY = @"capacity-info";//  产能信息 2640
static NSString *K_PRODUCT_QUALITY = @"quality-standard";//  品质标准 2641
static NSString *K_PRODUCT_IQC = @"iqc-material";//  IQC来料 2642
static NSString *K_PRODUCT_PUTINTO = @"put-into-product";//  投产状况 2643
static NSString *K_PRODUCT_CTM = @"ctm-report";//  CTM报告 2644
static NSString *K_PRODUCT_COMPONENT = @"component-reliability";// 组件

@interface ProduceCommonCreateViewCtrl : CommonAutoViewCtrl

@end

NS_ASSUME_NONNULL_END
