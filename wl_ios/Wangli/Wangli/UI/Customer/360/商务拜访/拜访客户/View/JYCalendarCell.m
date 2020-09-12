//
//  JYCalendarCell.m
//  Wangli
//
//  Created by yeqiang on 2019/1/26.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "JYCalendarCell.h"

@interface JYCalendarCell ()
{
    CGFloat _cellWidth;
}

@end

@implementation JYCalendarCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cellWidth = SCREEN_WIDTH/7.0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.labTost];
//    [self.labTost mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(2);
////        make.left.equalTo(self.contentView).offset(10);
//        make.centerX.equalTo(self.contentView);
//        make.height.equalTo(@15.0);
//        make.width.equalTo(@25.0);
//    }];
}

- (UILabel *)labTost {
    if (!_labTost) {
        _labTost = [[UILabel alloc] initWithFrame:CGRectMake(_cellWidth-25, 2, 25, 15)];
        _labTost.layer.mask = [Utils drawContentFrame:_labTost.bounds corners:UIRectCornerAllCorners cornerRadius:7.5];
        _labTost.textAlignment = NSTextAlignmentCenter;
        _labTost.textColor = COLOR_B1;
        _labTost.backgroundColor = COLOR_B0;;
//        _labTost.text = @"拜访";
        _labTost.font = FONT_F10;
//        _labTost.layer.cornerRadius = 7.5;
//        _labTost.layer.borderColor = COLOR_LINE.CGColor;
//        _labTost.layer.borderWidth = 1;
//        _labTost.clipsToBounds = YES;
    }
    return _labTost;
}

@end


