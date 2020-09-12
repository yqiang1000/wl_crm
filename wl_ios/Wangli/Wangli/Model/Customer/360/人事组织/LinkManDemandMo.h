//
//  LinkManDemandMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinkManDemandMo : JSONModel

@property (nonatomic, assign) long long id;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, strong) NSDictionary <Optional> *member; 
@property (nonatomic, copy) NSString <Optional> *grade;
@property (nonatomic, strong) NSDictionary <Optional> *linkMan;
@property (nonatomic, assign) BOOL needFeedBack;
@property (nonatomic, copy) NSString <Optional> *closingDate;
@property (nonatomic, copy) NSString <Optional> *reply;
@property (nonatomic, copy) NSString <Optional> *desp;

@end

NS_ASSUME_NONNULL_END
