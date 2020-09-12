//
//  YQNewChatUtils.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewHelpeMessageCellData.h"


// 自定义消息类型
#define kTYPE_CUSTOM_LIST               @"TYPE_CUSTOM_LIST"
#define kTYPE_CUSTOM_TEXT               @"TYPE_CUSTOM_TEXT"
#define kTYPE_CUSTOM_CONTENTONLY        @"TYPE_CUSTOM_CONTENTONLY"

NS_ASSUME_NONNULL_BEGIN

@interface YQNewChatUtils : NSObject


// 获取自定义消息的名称
+ (NSString *)customNameFromHelperType:(NSString *)helperType;

// 获取自定义消息的头像
+ (NSString *)customIconFromHelperType:(NSString *)helperType;

// 获取自定义小助手消息对象
+ (CustomMsgMo *)getCustomMsgMoDataModel:(NSDictionary *)param;


// 拼接字符串
+ (NSMutableAttributedString *)pieceStringByArray:(NSArray <ContentTextMo *> *)arrSource;

// 标签
+ (NSString *)stringWithContents:(NSArray *)arrSource;
    

+ (NSAttributedString *)moreContent:(MoreInfoMo *)mo;

@end

NS_ASSUME_NONNULL_END
