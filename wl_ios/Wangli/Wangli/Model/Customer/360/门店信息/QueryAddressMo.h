//
//  QueryAddressMo.h
//  Wangli
//
//  Created by yeqiang on 2019/9/9.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface QueryAddressMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *cityName;//  "郑州市",
@property (nonatomic, copy) NSString <Optional> *cityId;// "410100",
@property (nonatomic, assign) NSInteger id;// 152,
@property (nonatomic, copy) NSString <Optional> *provinceId;// "410000"

@property (nonatomic, copy) NSString <Optional> *areaId;// "410201",
@property (nonatomic, copy) NSString <Optional> *areaName;// "市辖区",
//@property (nonatomic, copy) NSString <Optional> *cityId;// "410200",
//@property (nonatomic, copy) NSString <Optional> *id;// 1518

@end

NS_ASSUME_NONNULL_END
