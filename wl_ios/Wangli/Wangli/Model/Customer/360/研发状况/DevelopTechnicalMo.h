//
//  DevelopTechnicalMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevelopTechnicalMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    // 1546841969029,
@property (nonatomic, copy) NSString <Optional> *createdBy;    // "1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    // "1016078",
@property (nonatomic, copy) NSString <Optional> *content;    // "Guihuanrirong",
@property (nonatomic, copy) NSString <Optional> *productType;    // "Chamomile icing",
@property (nonatomic, copy) NSString <Optional> *typeKey;    // "reduction_plan",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *typeValue;    // "降本规划",
@property (nonatomic, copy) NSString <Optional> *planDate;    // "2019-01-11",
@property (nonatomic, strong) NSArray <Optional> *technicalMeansSet;    // [],
@property (nonatomic, copy) NSString <Optional> *endDate;    // "2019-01-12",
@property (nonatomic, copy) NSString <Optional> *statusValue;    // "未达成",
@property (nonatomic, copy) NSString <Optional> *statusKey;    // "unreach",
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;    // "component_factory",
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;    // "组件厂"

@end

NS_ASSUME_NONNULL_END
