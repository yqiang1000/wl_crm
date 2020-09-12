//
//  MyCommonCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "MyCommonCell.h"

#pragma mark - MyCommonCell

@interface MyCommonCell ()

@end

@implementation MyCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_B4;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labLeft];
    [self.contentView addSubview:self.imgArrow];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.labRight];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@8);
        make.height.equalTo(@13);
    }];
    
    [self.labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.imgArrow.mas_left).offset(-10);
        make.left.greaterThanOrEqualTo(self.labLeft.mas_right).offset(10);
    }];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@100);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labLeft);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - public

- (void)setLeftText:(NSString *)text {
    self.labLeft.text = text;
    
    CGSize size = [Utils getStringSize:self.labLeft.text font:self.labLeft.font];
    
    [self.labLeft mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width + 3));
    }];
    
    [self layoutIfNeeded];
}

- (void)setHidenContent:(BOOL)hidenContent {
    _hidenContent = hidenContent;
    
    [self.imgArrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@8);
        make.height.equalTo(@13);
        if (_hidenContent) make.height.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.labRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.imgArrow.mas_left).offset(-10);
        make.left.greaterThanOrEqualTo(self.labLeft.mas_right).offset(10);
        if (_hidenContent) make.height.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.labLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@100);
        if (_hidenContent) make.height.lessThanOrEqualTo(self.contentView);
    }];
    [self layoutIfNeeded];
}

- (void)setRightTextFont:(UIFont *)font {
    if (font) {
        self.labRight.font = font;
    }
}

- (void)setRightTextColor:(UIColor *)color {
    if (color) {
        self.labRight.textColor = color;
    }
}

#pragma mark - setter and getter

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [[UILabel alloc] init];
        _labLeft.textColor = COLOR_B2;
        _labLeft.font = FONT_F16;
    }
    return _labLeft;
}

- (UILabel *)labRight {
    if (!_labRight) {
        _labRight = [[UILabel alloc] init];
        _labRight.textColor = COLOR_B1;
        _labRight.font = FONT_F16;
    }
    return _labRight;
}

- (UIImageView *)imgArrow {
    if (!_imgArrow) {
        _imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"client_arrow"]];
    }
    return _imgArrow;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
