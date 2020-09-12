//
//  ProduceComponentMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProduceComponentMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *createdDate;      //1546769065029,
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;      //;      //1546769065029,
@property (nonatomic, copy) NSString <Optional> *createdBy;      //"1016078",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;      //"1016078",
@property (nonatomic, copy) NSString <Optional> *condition;      //"测试条件",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *projectKey;      //"dh1000",
@property (nonatomic, copy) NSString <Optional> *projectValue;
@property (nonatomic, copy) NSString <Optional> *standard;      //"判定标准",
@property (nonatomic, copy) NSString <Optional> *remark;      //"说明",
@property (nonatomic, strong) NSDictionary <Optional> *operator;      //
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;      //"battery_factory"

@end

NS_ASSUME_NONNULL_END
