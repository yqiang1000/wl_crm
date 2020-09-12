//
//  WorthBeanMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorthBeanMo : JSONModel

@property (nonatomic, assign) BOOL type;
@property (nonatomic, assign) BOOL isText;
@property (nonatomic, assign) BOOL isTitle;
@property (nonatomic, copy) NSString <Optional> *leftContent;
@property (nonatomic, copy) NSString <Optional> *rightContent;
@property (nonatomic, copy) NSString <Optional> *score;

@end

NS_ASSUME_NONNULL_END
