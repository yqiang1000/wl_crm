//
//  DicMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DicMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *key;
@property (nonatomic, copy) NSString <Optional> *value;

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *desp;
@property (nonatomic, copy) NSString <Optional> *modifiable;
@property (nonatomic, assign) BOOL builtIn;
@property (nonatomic, copy) NSString <Optional> *remark;
@property (nonatomic, copy) NSString <Optional> *orders;
@property (nonatomic, assign) BOOL cached;
@property (nonatomic, copy) NSString <Optional> *type;

// 扩展属性
@property (nonatomic, copy) NSString <Optional> *extendValue1;
@property (nonatomic, copy) NSString <Optional> *extendValue2;

@end
