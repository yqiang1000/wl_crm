//
//  MarketProjectMo.h
//  Wangli
//
//  Created by yeqiang on 2021/1/12.
//  Copyright © 2021 yeqiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketProjectMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;  //"guanliyuan",
@property (nonatomic, copy) NSString <Optional> *createdDate;  //"2021-01-04 15:27:25",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;  //"guanliyuan",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;  //"2021-01-04 15:27:25",
@property (nonatomic, assign) long long id;  //20,
@property (nonatomic, assign) BOOL deleted;  //null,
@property (nonatomic, copy) NSString <Optional> *sort;  //10,
@property (nonatomic, copy) NSString <Optional> *fromClientType;  //null,
@property (nonatomic, strong) NSArray *optionGroup;
@property (nonatomic, copy) NSString <Optional> *searchContent;  //null,
@property (nonatomic, copy) NSString <Optional> *projectUser;  //"填报人",
@property (nonatomic, copy) NSString <Optional> *projectUserPhone;  //null,
@property (nonatomic, copy) NSString <Optional> *projectUserId;  //null,
@property (nonatomic, copy) NSString <Optional> *project;  //"项目二",
@property (nonatomic, copy) NSDictionary <Optional> *manager;  //null,
@property (nonatomic, copy) NSString <Optional> *projectBrand;  //"品牌",
@property (nonatomic, copy) NSString <Optional> *status;  //null,
@property (nonatomic, copy) NSString <Optional> *contactName;  //null,
@property (nonatomic, copy) NSString <Optional> *contactPhone;  //null,
@property (nonatomic, copy) NSString <Optional> *address;  //null,
@property (nonatomic, copy) NSString <Optional> *tenderDate;  //null,
@property (nonatomic, copy) NSString <Optional> *productNum;  //null,
@property (nonatomic, copy) NSString <Optional> *otherBrand;  //null,
@property (nonatomic, copy) NSString <Optional> *remark;  //null,
@property (nonatomic, copy) NSString <Optional> *created;  //null,
@property (nonatomic, copy) NSString <Optional> *modified;  //null,
@property (nonatomic, copy) NSString <Optional> *creator;  //null,
@property (nonatomic, copy) NSString <Optional> *modifier;  //null,
@property (nonatomic, copy) NSString <Optional> *cateJson;  //null,
@property (nonatomic, copy) NSString <Optional> *isModified;  //null,
@property (nonatomic, copy) NSString <Optional> *enable;  //null,
@property (nonatomic, copy) NSString <Optional> *tender;  //

@end

NS_ASSUME_NONNULL_END
