//
//  LinkManOfficeMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/3.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LinkManOfficeMo;

@interface LinkManOfficeMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, assign) NSInteger totalCount;         // 当前人数
@property (nonatomic, assign) long long memberId;           // 关联客户Id
@property (nonatomic, assign) long long id;                 // 当前Id
@property (nonatomic, assign) NSInteger parentOfficeId;     // 父节点id
@property (nonatomic, assign) NSInteger depth;              // 层次
@property (nonatomic, assign) BOOL expand;                  // 是否展开

@end

NS_ASSUME_NONNULL_END
