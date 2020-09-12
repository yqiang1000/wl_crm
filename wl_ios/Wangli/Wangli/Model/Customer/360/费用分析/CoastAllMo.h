//
//  CoastAllMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoastAllMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *msg;
@property (nonatomic, copy) NSString <Optional> *person;
@property (nonatomic, copy) NSString <Optional> *date;
@property (nonatomic, copy) NSString <Optional> *state;

@end

NS_ASSUME_NONNULL_END
