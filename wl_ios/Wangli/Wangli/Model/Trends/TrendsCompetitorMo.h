//
//  TrendsCompetitorMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CustomerMo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CustomerMo;
@interface TrendsCompetitorMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, strong) CustomerMo <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *abbreviation;
@property (nonatomic, copy) NSString <Optional> *principalName;
@property (nonatomic, copy) NSString <Optional> *principalJob;
@property (nonatomic, copy) NSString <Optional> *principalTel;
@property (nonatomic, copy) NSString <Optional> *content;
@property (nonatomic, copy) NSString <Optional> *principalDepartment;

@end

NS_ASSUME_NONNULL_END
