//
//  JYTextMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/2.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYTextMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *orgText;
@property (nonatomic, copy) NSString <Optional> *urlText;
@property (nonatomic, copy) NSString <Optional> *showText;
@property (nonatomic, assign) NSRange range;

@end

NS_ASSUME_NONNULL_END
