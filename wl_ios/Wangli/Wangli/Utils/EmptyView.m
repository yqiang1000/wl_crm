
//
//  EmptyView.m
//  Wangli
//
//  Created by yeqiang on 2018/6/19.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.imgView];
    [self.baseView addSubview:self.labText];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView);
        make.centerX.equalTo(self.baseView);
    }];
    
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(30);
        make.centerX.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView);
    }];
}

#pragma mark - lazy

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
    }
    return _baseView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无数据"]];
    }
    return _imgView;
}

- (UILabel *)labText {
    if (!_labText) {
        _labText = [[UILabel alloc] init];
        _labText.textColor = COLOR_B3;
        _labText.font = FONT_F14;
        _labText.text = @"暂无相关数据";
    }
    return _labText;
}
@end
