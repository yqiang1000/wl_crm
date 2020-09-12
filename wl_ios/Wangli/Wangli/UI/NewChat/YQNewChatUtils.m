
//
//  YQNewChatUtils.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQNewChatUtils.h"

#define kORDER @"ORDER" //订单
#define kREVEICE @"RECEIVE" //催款
#define kPLAN @"PLAN" //计划
#define kMARKET @"MARKET" //营销
#define kPERFORMANCE @"PERFORMANCE" //绩效
#define kAFTER_SALE @"AFTER_SALE" //售后
#define kNOTICE @"NOTICE" //公告
#define kTASK @"TASK" //任务

#define kORDER_TITLE @"订单小助手" //订单
#define kREVEICE_TITLE @"催款小助手" //催款
#define kPLAN_TITLE @"计划小助手" //计划
#define kMARKET_TITLE @"营销小助手" //营销
#define kPERFORMANCE_TITLE @"绩效小助手" //绩效
#define kAFTER_SALE_TITLE @"售后小助手" //售后
#define kNOTICE_TITLE @"公告小助手" //公告
#define kTASK_TITLE @"任务小助手" //任务

@implementation YQNewChatUtils


+ (NSString *)customNameFromHelperType:(NSString *)helperType {
    NSString *name = nil;
    if([helperType isEqualToString:kORDER]) {
        name = kORDER_TITLE;
    }else if([helperType isEqualToString:kREVEICE]) {
        name = kREVEICE_TITLE;
    }else if([helperType isEqualToString:kPLAN]) {
        name = kPLAN_TITLE;
    }else if([helperType isEqualToString:kMARKET]){
        name = kMARKET_TITLE;
    }else if([helperType isEqualToString:kPERFORMANCE]){
        name = kPERFORMANCE_TITLE;
    }else if([helperType isEqualToString:kAFTER_SALE]){
        name = kAFTER_SALE_TITLE;
    }else if([helperType isEqualToString:kNOTICE]){
        name = kNOTICE_TITLE;
    }else if([helperType isEqualToString:kTASK]){
        name = kTASK_TITLE;
    } else {
        name = @"暂无名称";
    }
    return name;
}

+ (NSString *)customIconFromHelperType:(NSString *)helperType {
    NSString *imgIcon = nil;
    if([helperType isEqualToString:kORDER]) {
        imgIcon = @"news_orderassistant";
    }else if([helperType isEqualToString:kREVEICE]) {
        imgIcon = @"news_dunningassistant";
    }else if([helperType isEqualToString:kPLAN]) {
        imgIcon = @"news_planassistant";
    }else if([helperType isEqualToString:kMARKET]){
        imgIcon = @"news_marketingassistant";
    }else if([helperType isEqualToString:kPERFORMANCE]){
        imgIcon = @"news_performanceassistant";
    }else if([helperType isEqualToString:kAFTER_SALE]){
        imgIcon = @"news_aftersales";
    }else if([helperType isEqualToString:kNOTICE]){
        imgIcon = @"news_announcementassistant";
    }else if([helperType isEqualToString:kTASK]){
        imgIcon = @"news_taskassistant";
    } else {
        imgIcon = @"client_default_avatar";
    }
    return imgIcon;
}


+ (CustomMsgMo *)getCustomMsgMoDataModel:(NSDictionary *)param {
    CustomMsgMo *mo = [CustomMsgMo yy_modelWithDictionary:param];
    return mo;
}

+ (NSAttributedString *)moreContent:(MoreInfoMo *)mo {
    if (mo == nil) {
        return nil;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (mo.color.length == 7) {
        UIColor *color = COLOR_HEX([mo.color substringFromIndex:1]);
        attributes[NSForegroundColorAttributeName] = color;
    }
    NSAttributedString *tmpStr = [[NSAttributedString alloc] initWithString:mo.content attributes:attributes];
    return tmpStr;
}

+ (NSMutableAttributedString *)pieceStringByArray:(NSArray <ContentTextMo *> *)arrSource {
    // 标签拼接
    NSMutableAttributedString *finStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *tmpStr = [[NSAttributedString alloc] init];
    
    for (int i = 0; i < arrSource.count; i++) {
        ContentTextMo *mo = arrSource[i];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        if (mo.color.length == 7) {
            UIColor *color = COLOR_HEX([mo.color substringFromIndex:1]);
            attributes[NSForegroundColorAttributeName] = color;
        }
        tmpStr = [[NSAttributedString alloc] initWithString:mo.content attributes:attributes];
        [finStr appendAttributedString:tmpStr];
    }
    return finStr;
}

+ (NSString *)stringWithContents:(NSArray *)arrSource {
    // 标签拼接
    NSString *tagStr = [[NSString alloc] init];
    
    for (int i = 0; i < arrSource.count; i++) {
        if ([arrSource[i] isKindOfClass:[ContentTextMo class]]) {
            ContentTextMo *txtMo = arrSource[i];
            tagStr = [tagStr stringByAppendingString:txtMo.content];
        } else {
            tagStr = [tagStr stringByAppendingString:arrSource[i]];
        }
    }
    return tagStr;
}

@end
