//
//  ConsulationMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConsulationMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *content;
@property (nonatomic, copy) NSString <Optional> *person;
@property (nonatomic, copy) NSString <Optional> *date;
@property (nonatomic, strong) NSMutableArray <Optional> *attachments;

@end

NS_ASSUME_NONNULL_END
