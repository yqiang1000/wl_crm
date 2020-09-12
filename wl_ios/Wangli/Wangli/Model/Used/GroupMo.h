//
//  GroupMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GroupMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, copy) NSString <Optional> *desp;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *admin;
@property (nonatomic, copy) NSString <Optional> *marketTreands;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *operators;
@property (nonatomic, strong) NSDictionary <Optional> *parent;
@property (nonatomic, strong) NSString <Optional> *totalCount;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger parentId;//父节点id
@property (nonatomic, assign) NSInteger depth;//层次
@property (nonatomic, assign) BOOL expand;

@end
