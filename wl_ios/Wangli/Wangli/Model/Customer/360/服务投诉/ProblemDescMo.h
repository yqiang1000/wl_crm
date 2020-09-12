//
//  ProblemDescMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProblemDescMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *consulationType;
@property (nonatomic, copy) NSString <Optional> *detailType;
@property (nonatomic, copy) NSString <Optional> *count;
@property (nonatomic, copy) NSString <Optional> *desc;

@end

NS_ASSUME_NONNULL_END
