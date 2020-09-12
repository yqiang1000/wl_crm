//
//  JYHelperMessageCellData.m
//  TUIKitDemo
//
//  Created by yeqiang on 2020/1/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "JYHelperMessageCellData.h"

@implementation JYHelperMessageCellData

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define FONT_TITLE          Font_Regular(17)
#define FONT_TIME           Font_Regular(12)
#define FONT_CONTENT        Font_Regular(15)

- (CGSize)contentSize
{
    CGFloat height = [self cellHeight:self.dataMo];
    CGSize size = CGSizeMake(SCREEN_WIDTH, height);
    return size;
}

- (CGFloat)cellHeight:(JYMessageDataModel *)cusMo {

    CGFloat height = 0;
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-80, MAXFLOAT);
    CGSize titleMaxSize = CGSizeMake(SCREEN_WIDTH-80-12, MAXFLOAT);
    // 标题
    CGSize sizeTitle = [Utils getStringSize:cusMo.title font:FONT_TITLE maxSize:self.isDealed? maxSize:titleMaxSize];
    // 时间
    CGSize sizeTime = [Utils getStringSize:cusMo.businessDate font:FONT_TIME maxSize:maxSize];
    // 内容，字符串为空也会有元素
    NSString *content = cusMo.abstracts;
    NSArray *arr = [content componentsSeparatedByString:@"\n"];
    CGFloat contentTxtHeight = 0;
    CGFloat space = 8;
    contentTxtHeight = (arr.count - 1) * space;
    if (content.length > 0) {
        for (int i = 0; i < arr.count; i++) {
            CGSize sizeContent = [Utils getStringSize:arr[i] font:FONT_CONTENT maxSize:maxSize];
            contentTxtHeight = space + sizeContent.height + contentTxtHeight;
        }
    }
    // tips
    CGSize sizeTips = [Utils getStringSize:cusMo.tips font:FONT_CONTENT maxSize:maxSize];
    height = sizeTitle.height + sizeTime.height + contentTxtHeight + cusMo.table.count*38 + sizeTips.height + 65;
    
//    NSLog(@"height=%lf, sizeTitle=%lf, sizeTime=%lf, contentTxtHeight=%lf, sizeTips=%lf", height, sizeTitle.height, sizeTime.height, contentTxtHeight, sizeTips.height);
    
    return height;
}

- (CGFloat)heightOfWidth:(CGFloat)width {
    return [self contentSize].height;
}

// height=179.600000, sizeTitle=23.800000, sizeTime=16.800000, contentTxtHeight=65.000000, sizeTips=21.000000
// height=114.600000, sizeTitle=23.800000, sizeTime=16.800000, contentTxtHeight=0.000000, sizeTips=21.000000
@end
