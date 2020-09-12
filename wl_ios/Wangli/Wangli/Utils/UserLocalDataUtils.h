//
//  UserLocalDataUtils.h
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserLocalDataUtils : NSObject

/** 保存信息 */
+ (void)saveRemark:(long long)msgId msgType:(NSString *)msgType;
/** 通过msgId获取信息 */
+ (BOOL)getRemarkByMsgId:(long long)msgId msgType:(NSString *)msgType;

@end

NS_ASSUME_NONNULL_END
