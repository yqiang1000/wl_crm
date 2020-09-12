//
//  MyTextFieldCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyTextFieldCell.h"

#pragma mark - MyTextFieldCell

@interface MyTextFieldCell () <UITextFieldDelegate>

@end

@implementation MyTextFieldCell

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
    [self.contentView addSubview:self.txtRight];
    [self.contentView addSubview:self.btnRight];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.imgArrow];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@8);
        make.height.equalTo(@13);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.height.equalTo(@22.5);
    }];
    
    [self.txtRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.btnRight.mas_left).offset(-10);
        make.left.equalTo(self.labLeft.mas_right).offset(10);
    }];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@70);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labLeft);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:textFieldDidBeginEditing:indexPath:)]) {
        [_cellDelegate cell:self textFieldDidBeginEditing:textField indexPath:_indexPath];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:textFieldShouldReturn:indexPath:)]) {
    //        [_cellDelegate cell:self textFieldShouldReturn:textField indexPath:_indexPath];
    //    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason  API_AVAILABLE(ios(10.0)){
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:textFieldDidEndEditing:indexPath:)]) {
        [_cellDelegate cell:self textFieldDidEndEditing:textField indexPath:_indexPath];
    }
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

- (void)setRightTextFont:(UIFont *)font {
    if (font) {
        self.txtRight.font = font;
    }
}

- (void)setRightTextColor:(UIColor *)color {
    if (color) {
        self.txtRight.textColor = color;
    }
}

- (void)setHidenContent:(BOOL)hidenContent {
    _hidenContent = hidenContent;
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@8);
        make.height.equalTo(@13);
        if (_hidenContent) make.height.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.height.equalTo(@22.5);
        if (_hidenContent) make.height.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.txtRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.btnRight.mas_left).offset(-10);
        make.left.equalTo(self.labLeft.mas_right).offset(10);
        if (_hidenContent) make.height.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@100);
        if (_hidenContent) make.height.lessThanOrEqualTo(self.contentView);
    }];
    [self layoutIfNeeded];
}

#pragma mark - event

- (void)btnRightClick:(UIButton *)sender {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:btnClick:indexPath:)]) {
        [_cellDelegate cell:self btnClick:sender indexPath:_indexPath];
    }
}

#pragma mark - setter and getter

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [[UILabel alloc] init];
        _labLeft.textColor = COLOR_B1;
        _labLeft.font = FONT_F16;
    }
    return _labLeft;
}

- (UITextField *)txtRight {
    if (!_txtRight) {
        _txtRight = [[UITextField alloc] init];
        _txtRight.textColor = COLOR_B1;
        _txtRight.font = FONT_F16;
        _txtRight.delegate = self;
    }
    return _txtRight;
}

- (UIImageView *)imgArrow {
    if (!_imgArrow) {
        _imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"client_arrow"]];
    }
    return _imgArrow;
}

- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [[UIButton alloc] init];
        [_btnRight addTarget:self action:@selector(btnRightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
