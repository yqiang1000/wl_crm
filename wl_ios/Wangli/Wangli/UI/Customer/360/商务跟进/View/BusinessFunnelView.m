//
//  BusinessFunnelView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BusinessFunnelView.h"

@interface BusinessFunnelView ()

@property (nonatomic, strong) UIView *titleView;

@end

@implementation BusinessFunnelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.backgroundColor = COLOR_B0;
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.funnelView];
    [self addSubview:self.titleView];
    
    [self.funnelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.funnelView);
        make.height.equalTo(@45.0);
    }];
}

#pragma mark - lazy

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        UILabel *labText = [UILabel new];
        labText.text = @"销售漏斗";
        labText.font = FONT_F14;
        labText.textColor = COLOR_B1;
        [_titleView addSubview:labText];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView).offset(10);
            make.height.equalTo(@15);
            make.width.equalTo(@3);
        }];
        
        [labText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(_titleView).offset(-10);
        }];
    }
    return _titleView;
}

- (DrawBusinessFunnelView *)funnelView {
    if (!_funnelView) {
        _funnelView = [[DrawBusinessFunnelView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)-30, CGRectGetHeight(self.frame)-10)];
        _funnelView.backgroundColor = COLOR_B4;
        _funnelView.layer.mask = [Utils drawContentFrame:_funnelView.bounds corners:UIRectCornerAllCorners cornerRadius:5];
    }
    return _funnelView;
}

@end

