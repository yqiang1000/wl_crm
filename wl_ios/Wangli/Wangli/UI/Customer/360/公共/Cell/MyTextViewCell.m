//
//  MyTextViewCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyTextViewCell.h"

#pragma mark - MyTextViewCell

@interface MyTextViewCell () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *labPlaceholder;

@end

@implementation MyTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    self.contentView.backgroundColor = COLOR_B4;
    [self.contentView addSubview:self.labLeft];
    [self.contentView addSubview:self.txtView];
    [self.contentView addSubview:self.lineView];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labLeft.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:textViewDidBeginEditing:indexPath:)]) {
        [_cellDelegate cell:self textViewDidBeginEditing:self.txtView indexPath:self.indexPath];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:textViewDidEndEditing:indexPath:)]) {
        [textView resignFirstResponder];
        [_cellDelegate cell:self textViewDidEndEditing:self.txtView indexPath:self.indexPath];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text] == YES && textView.returnKeyType == UIReturnKeyDone) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - public

- (void)setLeftText:(NSString *)text {
    self.labLeft.text = text;
    
//    CGSize size = [Utils getStringSize:self.labLeft.text font:self.labLeft.font];
//
//    [self.labLeft mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(size.width + 3));
//    }];
//
//    [self layoutIfNeeded];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (!_labPlaceholder) {
        self.labPlaceholder.text = _placeholder;
        [self.txtView addSubview:self.labPlaceholder];
        [self.txtView setValue:self.labPlaceholder forKey:@"_placeholderLabel"];
    }
}

#pragma mark - event

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

- (UITextView *)txtView {
    if (!_txtView) {
        _txtView = [[UITextView alloc] init];
        _txtView.textColor = COLOR_B1;
        _txtView.font = FONT_F16;
        _txtView.delegate = self;
        _txtView.returnKeyType = UIReturnKeyDefault;
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
