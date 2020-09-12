//
//  AddressMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AddressMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *abbreviation;
@property (nonatomic, copy) NSString <Optional> *phoneOne;
@property (nonatomic, copy) NSString <Optional> *provinceNumber;
@property (nonatomic, copy) NSString <Optional> *provinceName;
@property (nonatomic, copy) NSString <Optional> *cityNumber;
@property (nonatomic, copy) NSString <Optional> *cityName;
@property (nonatomic, copy) NSString <Optional> *areaNumber;
@property (nonatomic, copy) NSString <Optional> *areaName;
@property (nonatomic, copy) NSString <Optional> *address;
@property (nonatomic, copy) NSString <Optional> *receiver;
@property (nonatomic, assign) BOOL defaults;


@end
