//
//  OfflinePushInfoMo.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OfflinePushInfoMo : YQBaseModel

@property (nonatomic, assign) NSInteger PushFlag;
@property (nonatomic, copy) NSString *Desc;
@property (nonatomic, copy) NSString *Ext;
@property (nonatomic, strong) NSDictionary *AndroidInfo;
@property (nonatomic, strong) NSDictionary *ApnsInfo;

@end

NS_ASSUME_NONNULL_END
