
//
//  DefaultInputCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "DefaultInputCell.h"

#pragma mark - DefaultInputCell

@interface DefaultInputCell () <UITextFieldDelegate>

@end

@implementation DefaultInputCell

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
    [self.contentView addSubview:self.lineView];
    
    [self.txtRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.labLeft.mas_right).offset(10);
    }];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@70.0);
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
    [self.txtRight resignFirstResponder];
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

//#pragma mark - event
//
//- (void)btnRightClick:(UIButton *)sender {
//    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:btnClick:indexPath:)]) {
//        [_cellDelegate cell:self btnClick:sender indexPath:_indexPath];
//    }
//}

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
        _txtRight.returnKeyType = UIReturnKeyDone;
        _txtRight.textAlignment = NSTextAlignmentRight;
    }
    return _txtRight;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
