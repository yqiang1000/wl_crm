//
//  RecordUtils.m
//  Wangli
//
//  Created by yeqiang on 2018/12/27.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordUtils.h"

@implementation RecordUtils

+ (RecordUtils *)shareInstance {
    static RecordUtils *utils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utils = [[RecordUtils alloc] init];
    });
    return utils;
}

- (CGFloat)getHeightByCount:(NSInteger)count {
    if (count > 0) {
        NSInteger x = count / 5;
        NSInteger y = count % 5;
        x = x + (y == 0 ? 0 : 1);
        CGFloat height = x * (_record_width + 10);
        return height;
    } else {
        return 0;
    }
}

- (void)setRecord_width:(CGFloat)record_width {
    if (record_width < 0.1) {
        _record_width = ((SCREEN_WIDTH-70)/5.0);
    } else {
        _record_width = record_width;
    }
}

@end
