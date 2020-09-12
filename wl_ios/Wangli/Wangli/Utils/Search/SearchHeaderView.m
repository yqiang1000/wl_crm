//
//  SearchHeaderView.m
//  ABCInstitution
//
//  Created by yeqiang on 2017/8/9.
//  Copyright © 2017年 北京暄暄科技有限公司. All rights reserved.
//

#import "SearchHeaderView.h"

#pragma mark - SearchHeaderView

@interface SearchHeaderView ()

@end

@implementation SearchHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_B4;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.labTitle];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_blue"]];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTitle);
        make.left.equalTo(self.mas_left).offset(16);
        make.width.equalTo(@2);
        make.height.equalTo(@13);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerY.equalTo(self);
        make.left.equalTo(line.mas_right).offset(5);
    }];
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = COLOR_B2;
        _labTitle.font = FONT_F13;
    }
    return _labTitle;
}

@end

#pragma mark - SearchFooterView

@interface SearchFooterView ()

@end

@implementation SearchFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.btnMore];
    
    UIView *lineView = [Utils getLineView];
    [self addSubview:lineView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@38);
    }];
    
    [self.btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.baseView);
        make.height.equalTo(@35);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIButton *)btnMore {
    if (!_btnMore) {
        _btnMore = [[UIButton alloc] init];
        [_btnMore setTitle:GET_LANGUAGE_KEY(@"lookupMore") forState:UIControlStateNormal];
        [_btnMore setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        _btnMore.titleLabel.font = FONT_F16;
        _btnMore.backgroundColor = COLOR_B4;
        [_btnMore setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [_btnMore setTitleEdgeInsets:UIEdgeInsetsMake(0, -6-8, 0, 6+8)];
        [_btnMore setImageEdgeInsets:UIEdgeInsetsMake(0, 66, 0, 0)];
    }
    return _btnMore;
}


@end

