//
//  CountryMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/23.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountryMo : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString <Optional> *land1;
@property (nonatomic, copy) NSString <Optional> *landx;
@property (nonatomic, copy) NSString <Optional> *landx50;

@end

NS_ASSUME_NONNULL_END
