//
//  SearchDetailFooter.m
//  ABCInstitution
//
//  Created by yeqiang on 2017/8/9.
//  Copyright © 2017年 北京暄暄科技有限公司. All rights reserved.
//

#import "SearchDetailFooter.h"

@implementation SearchDetailFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UILabel *lab = [[UILabel alloc] init];
    lab.text = GET_LANGUAGE_KEY(@"upToTheEnd");
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    [self addSubview:lab];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = COLOR_LINE;
    [self addSubview:line1];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = COLOR_LINE;
    [self addSubview:line2];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(lab.mas_left).offset(-7.5);
        make.height.equalTo(@0.5);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab);
        make.right.equalTo(self).offset(-15);
        make.left.equalTo(lab.mas_right).offset(7.5);
        make.height.equalTo(@0.5);
    }];
}

@end
