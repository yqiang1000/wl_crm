//
//  SignInMo.h
//  Wangli
//
//  Created by yeqiang on 2019/3/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignInMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;    //;    //"1023443",
@property (nonatomic, copy) NSString <Optional> *createdDate;    //"2019-02-14 15:48:09",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    //"1023443",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    //"2019-02-14 15:48:09",
@property (nonatomic, assign) long long id;    //27,
//@property (nonatomic, copy) NSString <Optional> *deleted;    //false,
//@property (nonatomic, copy) NSString <Optional> *sort;    //10,
//@property (nonatomic, copy) NSString <Optional> *fromClientType;    //null,
@property (nonatomic, strong) NSArray <Optional> *optionGroup;    //[],
@property (nonatomic, copy) NSString <Optional> *searchContent;    //null,
@property (nonatomic, copy) NSString <Optional> *signInDate;    //"2019-02-14",
@property (nonatomic, copy) NSString <Optional> *longitude;    //"0",
@property (nonatomic, copy) NSString <Optional> *latitude;    //"0",
@property (nonatomic, copy) NSString <Optional> *address;    //"未识别你的位置，请重试",
@property (nonatomic, copy) NSString <Optional> *remark;    //"",
@property (nonatomic, copy) NSString <Optional> *hardwareInfo;    //null,
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;    //[],
@property (nonatomic, strong) NSDictionary <Optional> *operatorVo;
@property (nonatomic, copy) NSString <Optional> *provinceName;

@property (nonatomic, assign) BOOL hasImgUrl;
@property (nonatomic, strong) NSMutableArray <Optional> *arrImgs;  
@property (nonatomic, strong) NSMutableArray <Optional> *arrUrls;

@property (nonatomic, strong) NSDictionary <Optional> *signType;

@end

NS_ASSUME_NONNULL_END
