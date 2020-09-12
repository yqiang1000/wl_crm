
//
//  AreaMo.m
//  Wangli
//
//  Created by yeqiang on 2018/5/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "AreaMo.h"

@implementation AreaMo

@end

@implementation CityMo

- (void)setArealist:(NSMutableArray <AreaMo *><Optional> *)arealist {
    _arealist = (NSMutableArray <AreaMo *><Optional> *)[AreaMo arrayOfModelsFromDictionaries:arealist error:nil];
}

@end

@implementation ProvinceMo

- (void)setCitylist:(NSArray<CityMo *><Optional> *)citylist {
    _citylist = (NSMutableArray <CityMo *><Optional> *)[CityMo arrayOfModelsFromDictionaries:citylist error:nil];
}

@end
