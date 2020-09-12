//
//  NewHelpeMessageCellData.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "TUIMessageCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewHelpeMessageCellData : TUIMessageCellData

@property (nonatomic, strong) CustomMsgMo *dataMo;

/* 是否已处理 */
@property (nonatomic, strong) NSNumber *isDealed;
/* 消息ID */
@property (nonatomic, copy) NSString *msgId;
/* 消息对方用户 */
@property (nonatomic, copy) NSString *fromId;

@end

NS_ASSUME_NONNULL_END
