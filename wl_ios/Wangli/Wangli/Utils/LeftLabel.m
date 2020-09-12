//
//  LeftLabel.m
//  Wangli
//
//  Created by yeqiang on 2018/5/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "LeftLabel.h"

@implementation LeftLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = FONT_F13;
        self.backgroundColor = COLOR_B4;
        self.textColor = COLOR_B2;
    }
    return self;
}

- (void)setLeftLength:(NSInteger)leftLength totalLength:(NSInteger)totalLength {
    NSString *leftStr = [NSString stringWithFormat:@"%ld", leftLength];
    NSString *totalStr = [NSString stringWithFormat:@"%ld", totalLength];
    self.text = [NSString stringWithFormat:@"%@/%@", leftStr, totalStr];
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", leftStr, totalStr]];
//    NSRange range1 = NSMakeRange(0, leftStr.length);
//    NSRange range2 = NSMakeRange(leftStr.length, attribtStr.length - leftStr.length);
//
//    if (leftLength < 0) {
//        [attribtStr addAttribute:NSForegroundColorAttributeName value:COLOR_C1 range:range1];
//    } else {
//        [attribtStr addAttribute:NSForegroundColorAttributeName value:COLOR_C2 range:range1];
//    }
//    [attribtStr addAttribute:NSForegroundColorAttributeName value:COLOR_B3 range:range2];
//    self.attributedText = attribtStr;
}

@end
