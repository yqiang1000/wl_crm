//
//  CustomMsgLayoutMo.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomMsgLayoutMo : YQBaseModel
//IMAMsg
+ (CGFloat)cellHeight:(CustomMsgMo *)cusMo msg:(id)msg;

@end

NS_ASSUME_NONNULL_END
