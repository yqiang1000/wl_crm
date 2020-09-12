//
//  LocalRemarkHelp.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalRemarkHelp : NSObject

/** 保存信息 */
+ (void)saveMsgId:(NSString *)msgId toConvType:(NSString *)toConvType remark:(BOOL)remark fromDefault:(BOOL)fromDefault;

/** 通过msgId获取信息 */
+ (BOOL)getRemarkByMsgId:(NSString *)msgId fromConvType:(NSString *)fromConvType fromDefault:(BOOL)fromDefault;


@end

NS_ASSUME_NONNULL_END
