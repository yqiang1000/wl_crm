//
//  SystemInfoMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SystemInfoMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *sapNumber;
@property (nonatomic, copy) NSString <Optional> *createOperator;
@property (nonatomic, copy) NSString <Optional> *createDate;
@property (nonatomic, copy) NSString <Optional> *lastModify;
@property (nonatomic, copy) NSString <Optional> *assistNumber;
@property (nonatomic, strong) NSArray <Optional> *operators;
@property (nonatomic, copy) NSString <Optional> *modifyDate;
@property (nonatomic, strong) NSArray <Optional> *memberAssistSet;

@end
