//
//  JYHelperMessageCellData.h
//  TUIKitDemo
//
//  Created by yeqiang on 2020/1/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "TUIMessageCellData.h"
#import "JYMessageDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYHelperMessageCellData : TUIMessageCellData

@property (nonatomic, strong) JYMessageDataModel *dataMo;

/* 是否已处理 */
@property (nonatomic, strong) NSNumber *isDealed;
/* 消息ID */
@property (nonatomic, copy) NSString *msgId;
/* 消息对方用户 */
@property (nonatomic, copy) NSString *fromId;

@end

NS_ASSUME_NONNULL_END
