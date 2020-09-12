//
//  QiniuFileMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface QiniuFileMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) long long id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, strong) NSArray <Optional> *optionGroup;
@property (nonatomic, copy) NSString <Optional> *fkType;
@property (nonatomic, copy) NSString <Optional> *fkId;
@property (nonatomic, copy) NSString <Optional> *qiniuKey;
@property (nonatomic, copy) NSString <Optional> *fileName;
@property (nonatomic, copy) NSString <Optional> *fileType;
@property (nonatomic, assign) long long sizeOfByte;
@property (nonatomic, copy) NSString <Optional> *fileSize;
@property (nonatomic, copy) NSString <Optional> *url;
@property (nonatomic, copy) NSString <Optional> *thumbnail;
@property (nonatomic, copy) NSString <Optional> *key;
@property (nonatomic, copy) NSString <Optional> *fkTypeValue;
@property (nonatomic, assign) long long extData;

@property (nonatomic, strong) NSData <Optional> *myData;

@property (nonatomic, copy) NSString <Optional> *yyyymm;

@end
