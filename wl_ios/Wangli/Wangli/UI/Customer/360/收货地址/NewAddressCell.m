//
//  NewAddressCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/16.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "NewAddressCell.h"

#pragma mark - NewAddressCell

@interface NewAddressCell () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, assign) AddressCellType type;
@property (nonatomic, strong) UILabel *labPlaceholder;

@end

@implementation NewAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(AddressCellType)type {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _type = type;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    if (_type == AddressCellSave) {
        self.contentView.backgroundColor = COLOR_B0;
        [self.contentView addSubview:self.btnSave];
        [self.btnSave mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(50);
            make.centerX.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.height.equalTo(@44);
        }];
    } else {
        
        self.contentView.backgroundColor = COLOR_B4;
        [self.contentView addSubview:self.labLeft];
        [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
        if (_type == AddressCellNormal) {
            [self.contentView addSubview:self.txtField];
            [self.txtField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.labLeft.mas_right).offset(20);
                make.right.equalTo(self.txtField.mas_left).offset(-20);
            }];
            
            [self.txtField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.labLeft.mas_right).offset(20);
                make.right.equalTo(self.contentView).offset(-15);
            }];
        } else if (_type == AddressCellSelect) {
            
            [self.contentView addSubview:self.txtField];
            [self.contentView addSubview:self.btnArrow];
            
            [self.btnArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView).offset(-15);
                make.width.height.equalTo(@20);//8, 13
            }];
            
            [self.txtField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.labLeft.mas_right).offset(20);
                make.right.equalTo(self.btnArrow.mas_left).offset(-15);
            }];
        } else if (_type == AddressCellAddress) {
            
            [self.labLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(10);
                make.left.equalTo(self.contentView).offset(15);
            }];
            
            [self.contentView addSubview:self.txtView];
            [self.txtView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.labLeft).offset(-4);
                make.left.equalTo(self.labLeft.mas_right).offset(20);
                make.right.equalTo(self.contentView).offset(-15);
                make.bottom.equalTo(self.contentView).offset(-10);
                make.height.equalTo(self.labLeft).multipliedBy(2);
            }];
        } else if (_type == AddressCellDefault) {
            
            [self.contentView addSubview:self.btnSwitch];
            [self.btnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView).offset(-15);
            }];
        }
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(newAddressCell:textFieldDidBeginEditing:textViewDidBeginEditing:indexPath:)]) {
        [_delegate newAddressCell:self textFieldDidBeginEditing:self.txtField textViewDidBeginEditing:nil indexPath:self.indexPath];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(newAddressCell:textFieldShouldReturn:textViewDidEndEditing:indexPath:)]) {
        [_delegate newAddressCell:self textFieldShouldReturn:self.txtField textViewDidEndEditing:nil indexPath:self.indexPath];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(newAddressCell:textFieldShouldReturn:textViewDidEndEditing:indexPath:)]) {
        [_delegate newAddressCell:self textFieldShouldReturn:self.txtField textViewDidEndEditing:nil indexPath:self.indexPath];
    }
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(newAddressCell:textFieldDidBeginEditing:textViewDidBeginEditing:indexPath:)]) {
        [_delegate newAddressCell:self textFieldDidBeginEditing:nil textViewDidBeginEditing:self.txtView indexPath:self.indexPath];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(newAddressCell:textFieldShouldReturn:textViewDidEndEditing:indexPath:)]) {
        [_delegate newAddressCell:self textFieldShouldReturn:nil textViewDidEndEditing:self.txtView indexPath:self.indexPath];
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

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    if (_type == AddressCellAddress) {
        if (!_labPlaceholder) {
            self.labPlaceholder.text = _placeholder;
            [self.txtView addSubview:self.labPlaceholder];
            [self.txtView setValue:self.labPlaceholder forKey:@"_placeholderLabel"];
        }
    } else {
        self.txtField.placeholder = placeholder;
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    self.txtField.text = text;
}

#pragma mark - event

- (void)btnArrowClick:(UIButton *)sender {
    [self.txtField becomeFirstResponder];
}

- (void)btnSaveClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(newAddressCellSaveClick:)]) {
        [_delegate newAddressCellSaveClick:self];
    }
}

- (void)btnSwitchClick:(UISwitch *)sender {
    self.btnSwitch.on = !self.btnSwitch.isOn;
    if (_delegate && [_delegate respondsToSelector:@selector(newAddressCell:isDefault:)]) {
        [_delegate newAddressCell:self isDefault:self.btnSwitch.on];
    }
    [self.btnSwitch setOn:self.btnSwitch.isOn animated:YES];
}

#pragma mark - setter and getter

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [[UILabel alloc] init];
        _labLeft.textColor = COLOR_B1;
        _labLeft.font = FONT_F16;
        [_labLeft sizeToFit];
    }
    return _labLeft;
}

- (UITextField *)txtField {
    if (!_txtField) {
        _txtField = [[UITextField alloc] init];
        _txtField.textColor = COLOR_B1;
        _txtField.font = FONT_F16;
        _txtField.delegate = self;
    }
    return _txtField;
}

- (UITextView *)txtView {
    if (!_txtView) {
        _txtView = [[UITextView alloc] init];
        _txtView.textColor = COLOR_B1;
        _txtView.font = FONT_F16;
        _txtView.delegate = self;
    }
    return _txtView;
}

- (UILabel *)labPlaceholder {
    if (!_labPlaceholder) {
        _labPlaceholder = [UILabel new];
        _labPlaceholder.numberOfLines = 0;
        _labPlaceholder.textColor = COLOR_B3;
        _labPlaceholder.font = FONT_F16;
        [_labPlaceholder sizeToFit];
    }
    return _labPlaceholder;
}

- (UIButton *)btnArrow {
    if (!_btnArrow) {
        _btnArrow = [[UIButton alloc] init];
        [_btnArrow setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [_btnArrow setImage:[UIImage imageNamed:@"client_arrow"] forState:UIControlStateNormal];
        [_btnArrow addTarget:self action:@selector(btnArrowClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnArrow;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UIButton *)btnSave {
    if (!_btnSave) {
        _btnSave = [[UIButton alloc] init];
        _btnSave.titleLabel.font = FONT_F18;
        [_btnSave setBackgroundColor:COLOR_C1];
        [_btnSave setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        [_btnSave setTitle:@"保存地址" forState:UIControlStateNormal];
        [_btnSave addTarget:self action:@selector(btnSaveClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnSave.layer.cornerRadius = 4;
        _btnSave.clipsToBounds = YES;
    }
    return _btnSave;
}

- (UISwitch *)btnSwitch {
    if (!_btnSwitch) {
        _btnSwitch = [[UISwitch alloc] init];
        _btnSwitch.onTintColor = COLOR_C1;
        [_btnSwitch addTarget:self action:@selector(btnSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _btnSwitch;
}

@end
