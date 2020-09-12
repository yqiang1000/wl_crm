//
//  ProduceQualityMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProduceQualityMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *createdBy;     //;     //"1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;     //"1016078",
@property (nonatomic, copy) NSString <Optional> *content;     //"内容",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *infoDate;     //"2019-01-06",
@property (nonatomic, copy) NSString <Optional> *summary;     //"摘要",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;     //"battery_factory"
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;

@end

NS_ASSUME_NONNULL_END
