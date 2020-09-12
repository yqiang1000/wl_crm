//
//  ContactMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ContactMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) long long id;

@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *type;
@property (nonatomic, copy) NSString <Optional> *name;

@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *phone;
@property (nonatomic, copy) NSString <Optional> *phoneOne;
@property (nonatomic, copy) NSString <Optional> *phoneTwo;
@property (nonatomic, copy) NSString <Optional> *phoneThree;

@property (nonatomic, copy) NSString <Optional> *phoneFour;
@property (nonatomic, copy) NSString <Optional> *sex;
@property (nonatomic, copy) NSString <Optional> *birthday;
@property (nonatomic, copy) NSString <Optional> *email;
@property (nonatomic, copy) NSString <Optional> *address;

@property (nonatomic, copy) NSString <Optional> *provinceNumber;
@property (nonatomic, copy) NSString <Optional> *provinceName;
@property (nonatomic, copy) NSString <Optional> *cityNumber;
@property (nonatomic, copy) NSString <Optional> *cityName;
@property (nonatomic, copy) NSString <Optional> *areaNumber;

@property (nonatomic, copy) NSString <Optional> *areaName;
@property (nonatomic, strong) NSDictionary <Optional> *office;
@property (nonatomic, copy) NSString <Optional> *duty;
@property (nonatomic, copy) NSString <Optional> *headAddress;
@property (nonatomic, assign) BOOL important;

@property (nonatomic, copy) NSString <Optional> *actualControllers;
@property (nonatomic, strong) NSDictionary <Optional> *memberReadBean;
@property (nonatomic, copy) NSString <Optional> *avatralUrl;
@property (nonatomic, copy) NSString <Optional> *favorite;






//@property (nonatomic, copy) NSString <Optional> *id;
//@property (nonatomic, copy) NSString <Optional> *name;  //;  //"张三",
//@property (nonatomic, copy) NSString <Optional> *sex;  //"男",
//@property (nonatomic, copy) NSString <Optional> *birthday;  //"2019-01-31T11:37:10.455Z",
//@property (nonatomic, copy) NSString <Optional> *phone;  //12345678910,
@property (nonatomic, copy) NSString <Optional> *officeAddress;  //"浙江杭州东部软件园",
//@property (nonatomic, copy) NSString <Optional> *address;  //"杭州",
//@property (nonatomic, strong) NSDictionary <Optional> *office;  //null,
//@property (nonatomic, copy) NSString <Optional> *duty;  //"科长",
//@property (nonatomic, copy) NSString <Optional> *email;  //"123@qq.com",
//@property (nonatomic, copy) NSString <Optional> *favorite;  //"游泳",
@property (nonatomic, assign) BOOL incumbency;  //true,
//@property (nonatomic, strong) NSDictionary <Optional> *member;  //{



@end
