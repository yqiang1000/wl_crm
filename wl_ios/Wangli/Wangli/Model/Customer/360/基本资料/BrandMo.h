//
//  BrandMo.h
//  Wangli
//
//  Created by yeqiang on 2019/5/31.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrandMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;  // "guanliyuan",
@property (nonatomic, copy) NSString <Optional> *createdDate;  // "2019-04-09 14:08:12",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  // "guanliyuan",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  // "2019-04-09 14:08:17",
@property (nonatomic, assign) NSInteger id;  // 4,
@property (nonatomic, assign) BOOL deleted;  // null,
@property (nonatomic, copy) NSString <Optional> *fromClientType;  // null,
@property (nonatomic, strong) NSArray <Optional> *optionGroup;  // [],
@property (nonatomic, copy) NSString <Optional> *searchContent;  // null,
@property (nonatomic, copy) NSString <Optional> *brandName;  // "能诚",
@property (nonatomic, copy) NSString <Optional> *brandDesc;  // "能诚"

@end

NS_ASSUME_NONNULL_END
