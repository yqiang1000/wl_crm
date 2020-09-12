//
//  SummaryMo.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SummaryMo : YQBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *businessDate;
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
