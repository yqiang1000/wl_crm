//
//  JYUserMo.h
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GroupMo.h"

@protocol Roles;
@interface Roles : JSONModel

@property (nonatomic, copy) NSString<Optional> *createdBy;
@property (nonatomic, copy) NSString<Optional> *createdDate;
@property (nonatomic, copy) NSString<Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString<Optional> *lastModifiedDate;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *desp;
@property (nonatomic, copy) NSString<Optional> *operators;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) BOOL builtIn;

@end

@protocol GroupMo;
@interface JYUserMo : JSONModel

@property (nonatomic, copy) NSString<Optional> *oaCode;

@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *avatarUrl;
@property (nonatomic, copy) NSString<Optional> *nickName;
@property (nonatomic, copy) NSString<Optional> *remark;

@property (nonatomic, copy) NSString<Optional> *mobile;
@property (nonatomic, copy) NSString<Optional> *password;

@property (nonatomic, copy) NSString<Optional> *orgStr;
@property (nonatomic, copy) NSString<Optional> *partStr;
@property (nonatomic, copy) NSString<Optional> *jobStr;

@property (nonatomic, copy) NSString<Optional> *userSig;

// operator
@property (nonatomic, copy) NSString<Optional> *createdBy;
@property (nonatomic, copy) NSString<Optional> *createdDate;
@property (nonatomic, copy) NSString<Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString<Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger activated;

@property (nonatomic, copy) NSString<Optional> *fromClientType;
@property (nonatomic, copy) NSString<Optional> *username;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *telOne;
@property (nonatomic, copy) NSString<Optional> *telTwo;
@property (nonatomic, copy) NSString<Optional> *telThree;
@property (nonatomic, copy) NSString<Optional> *address;
@property (nonatomic, copy) NSString<Optional> *email;
@property (nonatomic, copy) NSString<Optional> *sex;
@property (nonatomic, copy) NSString<Optional> *birthday;
@property (nonatomic, strong) NSDictionary <Optional> *superiorOperator;
@property (nonatomic, strong) NSDictionary <Optional> *position;
@property (nonatomic, copy) NSString<Optional> *lastLoginDate;
@property (nonatomic, copy) NSString<Optional> *previousLoginDate;
@property (nonatomic, copy) NSString<Optional> *timIdentifier;
@property (nonatomic, copy) NSString<Optional> *id_token;
@property (nonatomic, copy) NSString<Optional> *dunningFailures;
@property (nonatomic, strong) NSArray<Optional> *members;
@property (nonatomic, strong) NSArray <Roles *> <Optional> *roles;

@property (nonatomic, copy) NSString<Optional> *tim_signature;
@property (nonatomic, copy) NSString<Optional> *shortWaybills;
@property (nonatomic, copy) NSString<Optional> *officeOrderApprovalConfigs;
@property (nonatomic, copy) NSString<Optional> *departmentName;

@property (nonatomic, copy) NSString<Optional> *title;

@property (nonatomic, strong) NSDictionary <Optional> *department;//部门节点
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, assign) NSInteger depth;
@property (nonatomic, assign) BOOL expand;

@end
