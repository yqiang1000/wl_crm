//
//  HelpPersonMo.h
//  Wangli
//
//  Created by yeqiang on 2019/3/13.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelpPersonMo : JSONModel


@property (nonatomic, copy) NSString <Optional> *sdd;

@property (nonatomic, copy) NSString <Optional> *assistRole;    //;    //"AR",
@property (nonatomic, copy) NSString <Optional> *assistReason;    //"666",
@property (nonatomic, copy) NSString <Optional> *createdDate;    //"2019-03-13 11:51:40",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    //"2019-03-13 11:51:40",
@property (nonatomic, copy) NSString <Optional> *createdBy;    //"管理员",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    //"管理员",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, assign) long long id;    //1052,
//@property (nonatomic, copy) NSString <Optional> *sort;    //10,
@property (nonatomic, strong) NSDictionary <Optional> *operator;   

@end

NS_ASSUME_NONNULL_END
