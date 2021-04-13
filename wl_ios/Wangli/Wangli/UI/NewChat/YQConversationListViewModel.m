//
//  YQConversationListViewModel.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQConversationListViewModel.h"
#import <TIMMessage.h>
#import <TIMMessage+DataProvider.h>
#import "JYIMUtils.h"
#import "TIMMessage+DataProvider.h"

@implementation YQConversationListViewModel

- (NSString *)getLastDisplayString:(TIMConversation *)conv
{
    NSString *str = @"";
    TIMMessageDraft *draft = [conv getDraft];
    if(draft){
        for (int i = 0; i < draft.elemCount; ++i) {
            TIMElem *elem = [draft getElem:i];
            if([elem isKindOfClass:[TIMTextElem class]]){
                TIMTextElem *text = (TIMTextElem *)elem;
                str = [NSString stringWithFormat:@"[草稿]%@", text.text];
                break;
            }
            else{
                continue;
            }
        }
        return str;
    }

    TIMMessage *msg = [conv getLastMsg];
    str = [msg getDisplayString];
    if ([str isEqualToString:@"[自定义消息]"]) {
        // 自定义消息如果是小助手的话，修改标题
        TIMElem *elem = [msg getElem:0];
        if ([elem isKindOfClass:[TIMCustomElem class]]) {
            TIMCustomElem *custom = (TIMCustomElem *)elem;
            NSDictionary *param = [TCUtil jsonData2Dictionary:[custom data]];
            CustomMsgMo *dataMo = [YQNewChatUtils getCustomMsgMoDataModel:param];
            if (dataMo && dataMo.Title.length > 0) {
                str = dataMo.Title;
            }
        }
    }

    TUIConversationCellData *cellData = [self cellDataOf:conv.getReceiver];
    if ([conv.getReceiver containsString:@"_helper"]) {
        JYDictItemMo *dicMo = [JYIMUtils getIMHelperMoById:conv.getReceiver];
        cellData.avatarUrl = dicMo.value2;
        cellData.title = dicMo.value;
    }
    return str;
}

- (TUIConversationCellData *)cellDataOf:(NSString *)convId
{
    for (TUIConversationCellData *data in self.dataList) {
        if ([data.convId isEqualToString:convId]) {
            return data;
        }
    }
    return nil;
}


@end
