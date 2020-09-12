//
//  TrendsBaseMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrendsBaseMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *content;
@property (nonatomic, copy) NSString <Optional> *person;
@property (nonatomic, copy) NSString <Optional> *date;
@property (nonatomic, copy) NSString <Optional> *state;
@property (nonatomic, assign) BOOL read;
@property (nonatomic, assign) long long  id;

@end

NS_ASSUME_NONNULL_END
