//
//  JYVoiceMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/29.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYVoiceMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *fileName;

@property (nonatomic, assign) NSInteger secondCount;;

@property (nonatomic, assign) CGFloat fileSize;

@end

NS_ASSUME_NONNULL_END
