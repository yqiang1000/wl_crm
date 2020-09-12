//
//  AreaMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AreaMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *areaName;

@end

@protocol AreaMo;

@interface CityMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *cityName;
@property (nonatomic, strong) NSMutableArray <AreaMo *> <Optional> *arealist;

@end

@protocol CityMo;

@interface ProvinceMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *provinceName;
@property (nonatomic, strong) NSArray <CityMo *> <Optional> *citylist;

// 选择省份page用
@property (nonatomic, copy) NSString <Optional> *provinceId;

@end
