//
//  UsedMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UsedMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *iosIconUrl;
@property (nonatomic, copy) NSString <Optional> *androidIconUrl;
@property (nonatomic, copy) NSString <Optional> *url;
@property (nonatomic, copy) NSString <Optional> *flag;
@property (nonatomic, copy) NSString <Optional> *category;

@end

@protocol UsedMo;

@interface TabUsedMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *category;
@property (nonatomic, strong) NSMutableArray <Optional> *items;

@end
