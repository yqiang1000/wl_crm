//
//  CustomMsgLayoutMo.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "CustomMsgLayoutMo.h"

#define FONT_TITLE FONT_F17
#define FONT_TIME FONT_F12
#define FONT_CONTENT FONT_F15

@implementation CustomMsgLayoutMo

+ (CGFloat)cellHeight:(CustomMsgMo *)cusMo msg:(id)msg {
    
//    if (cusMo.height != 0) {
//        return cusMo.height;
//    }
    
    CGFloat height = 300;
//    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-80, MAXFLOAT);
//    CGSize titleMaxSize = CGSizeMake(SCREEN_WIDTH-80-12, MAXFLOAT);
//
//    CGSize sizeTitle = [IMUtils getStringSize:cusMo.Title font:FONT_TITLE maxSize:msg.isDealed? maxSize:titleMaxSize];
//    CGSize sizeTime = [IMUtils getStringSize:cusMo.BusinessDate font:FONT_TIME maxSize:maxSize];
//
//    NSString *content = [IMUtils stringWithContents:cusMo.Contents];
//    NSArray *arr = [content componentsSeparatedByString:@"\n"];
//    CGFloat contentTxtHeight = 0;
//    CGFloat space = 0;//[cusMo.FormatType isEqualToString:kTYPE_CUSTOM_CONTENTONLY] ? 0 : 1.5;
//    contentTxtHeight = (arr.count - 1) * space;
//    for (int i = 0; i < arr.count; i++) {
//        CGSize sizeContent = [IMUtils getStringSize:arr[i] font:FONT_CONTENT maxSize:maxSize];
//        contentTxtHeight = space + sizeContent.height + contentTxtHeight;
//    }
//
//    if ([cusMo.FormatType isEqualToString:kTYPE_CUSTOM_LIST]) {
//
//        height = sizeTitle.height + sizeTime.height + contentTxtHeight + cusMo.Cells.count * 38 + 16 + 8 + 12 + 15 + 15 + 10;
//    } else if ([cusMo.FormatType isEqualToString:kTYPE_CUSTOM_TEXT]) {
//        MoreInfoMo *moreInfo = [[MoreInfoMo alloc] initWithDictionary:cusMo.MoreInfo error:nil];
//        CGSize sizeMore = [IMUtils getStringSize:moreInfo.content font:FONT_CONTENT maxSize:maxSize];
//        height = sizeTitle.height + sizeTime.height + contentTxtHeight + sizeMore.height + 30 + 16 + 8 + 12 + 15 + 15 + 10;
//    } else if ([cusMo.FormatType isEqualToString:kTYPE_CUSTOM_CONTENTONLY]) {
//        height = sizeTitle.height + sizeTime.height + contentTxtHeight + 30 + 16 + 8 + 12 + 15;
//    }
//    height = height+13;
//    cusMo.height = height;
    return height;
}

@end
