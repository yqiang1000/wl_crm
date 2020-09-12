//
//  YQIMPublicDefine.h
//  HangGuo
//
//  Created by yeqiang on 2020/2/5.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CustomMsgMo.h"

NS_ASSUME_NONNULL_BEGIN

#if DEBUG
#define sdkBusiId           14140
#else
#define sdkBusiId           14083
#endif

static const int SDKAPPID = 1400197006;

#define BUGLY_APP_ID        @"f4edc97d28"


#define Key_UserInfo_Appid  @"Key_UserInfo_Appid"
#define Key_UserInfo_User   @"Key_UserInfo_User"
#define Key_UserInfo_Pwd    @"Key_UserInfo_Pwd"
#define Key_UserInfo_Sig    @"Key_UserInfo_Sig"


@interface YQIMPublicDefine : NSObject

@end

NS_ASSUME_NONNULL_END
