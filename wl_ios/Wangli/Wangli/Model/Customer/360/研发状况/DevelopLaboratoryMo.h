//
//  DevelopLaboratoryMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevelopLaboratoryMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, copy) NSString <Optional> *createdBy;    // "1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    // "1016078",
@property (nonatomic, copy) NSString <Optional> *name;    // "实验室名字",
@property (nonatomic, copy) NSString <Optional> *typeKey;    // "enterprise",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *typeValue;    // "企业级",
@property (nonatomic, copy) NSString <Optional> *area;    // "浙江杭州",
@property (nonatomic, copy) NSString <Optional> *researchCount;    // 40,
@property (nonatomic, copy) NSString <Optional> *labBoss;    // "yeqiang",
@property (nonatomic, copy) NSString <Optional> *outputResult;    // "产出结果",
@property (nonatomic, copy) NSString <Optional> *yearPutCost;    // 900.00,
@property (nonatomic, copy) NSString <Optional> *lidTestBox;    // "LID",
@property (nonatomic, copy) NSString <Optional> *hotSpotBox;    // "热板效应",
@property (nonatomic, copy) NSString <Optional> *otherInfo;    // "其他信息",
@property (nonatomic, copy) NSString <Optional> *electronMicroscope;    // "扫描？",
@property (nonatomic, copy) NSString <Optional> *mechanicalMeter;    // "再喝",
@property (nonatomic, copy) NSString <Optional> *environmentTestBox;    // "坏境",
@property (nonatomic, copy) NSString <Optional> *ultravioletBox;    // "紫外线",
@property (nonatomic, copy) NSString <Optional> *solarIrradianceMeter;    // "太阳辐射",
@property (nonatomic, copy) NSString <Optional> *solarSimulator;    // "稳态模拟器",
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;    // "battery_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;    // "电池厂"

@end

NS_ASSUME_NONNULL_END
