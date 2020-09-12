//
//  BaseNaviView.m
//  Wangli
//
//  Created by yeqiang on 2018/3/22.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseNaviView.h"

@implementation BaseNaviView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44+STATUS_BAR_HEIGHT);
    //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    //        imageView.image = [UIImage imageNamed:@"导航背景"];
    //        [self addSubview:imageView];
    //
    //        [imageView makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.right.top.equalTo(self);
    //            make.height.equalTo(64);
    //        }];
    self.backgroundColor = COLOR_C1;
    [self addSubview:self.labTitle];
    
    [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(STATUS_BAR_HEIGHT);
        make.height.equalTo(@44);
        make.width.equalTo(@200);
    }];
    
    [self addSubview:self.btnBack];
    [_btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(STATUS_BAR_HEIGHT);
        make.bottom.equalTo(self);
        make.width.equalTo(@100);
    }];
    
    [self addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    //右按钮
    [self addSubview:self.rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnBack);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}


- (void)dealloc {
    
}

#pragma mark - setter getter

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150, 20, 300, 44)];
        _labTitle.textColor = COLOR_B4;
        _labTitle.font = FONT_F18;
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.backgroundColor = [UIColor clearColor];
    }
    return _labTitle;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
        [_btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_btnBack setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        _btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btnBack.titleLabel.font = SYSTEM_FONT(15);
        _btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _btnBack.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return _btnBack;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        _rightBtn.titleLabel.font = SYSTEM_FONT(15);
        [_rightBtn setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        [_rightBtn setTitleColor:COLOR_B3 forState:UIControlStateDisabled];
    }
    return _rightBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_LINE;
    }
    return _lineView;
}

@end
