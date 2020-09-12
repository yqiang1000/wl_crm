//
//  SearchTopView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/11.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "SearchTopView.h"

@interface SearchTopView () <UITextFieldDelegate>

@end


@implementation SearchTopView

- (instancetype)initWithAudio:(BOOL)hasAudio {
    self = [super init];
    if (self) {
        _hasAudio = hasAudio;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.btnSearch];
    [self.btnSearch addSubview:self.imgLeft];
    if (_hasAudio) {
        [self.btnSearch addSubview:self.btnRight];
    }
    [self.btnSearch addSubview:self.searchTxtField];
    
    [self.btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.imgLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_btnSearch);
        make.left.equalTo(_btnSearch).offset(8);
        make.width.height.equalTo(@13);
    }];
    
    if (_hasAudio) {
        [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btnSearch);
            make.right.equalTo(self.btnSearch.mas_right).offset(0);
            make.height.equalTo(@20);
            make.width.equalTo(@36);
        }];
    }
    
    [_searchTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_btnSearch);
        make.left.equalTo(_imgLeft.mas_right).offset(5);
        make.right.equalTo(_hasAudio?_btnRight.mas_left:_btnSearch.mas_right).offset(-8);
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(searchTopView:textFieldDidBeginEditing:)]) {
        [_delegate searchTopView:self textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(searchTopView:textFieldShouldReturn:)]) {
        [_delegate searchTopView:self textFieldShouldReturn:textField];
    }
    return YES;
}

#pragma mark - event

- (void)btnVoiceClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(searchTopViewVoiceClick:)]) {
        [_delegate searchTopViewVoiceClick:self];
    }
}

#pragma mark - setter getter

- (UIButton *)btnSearch {
    if (!_btnSearch) {
        _btnSearch = [[UIButton alloc] init];
        _btnSearch.backgroundColor = COLOR_B4;
        _btnSearch.layer.cornerRadius = 5;
        _btnSearch.clipsToBounds = YES;
    }
    return _btnSearch;
}

- (UITextField *)searchTxtField {
    if (!_searchTxtField) {
        _searchTxtField = [[UITextField alloc] init];
        _searchTxtField.font = FONT_F13;
        _searchTxtField.textColor = COLOR_B1;
        _searchTxtField.returnKeyType = UIReturnKeySearch;
        _searchTxtField.delegate = self;
    }
    return _searchTxtField;
}

- (UIImageView *)imgLeft {
    if (!_imgLeft) {
        _imgLeft = [[UIImageView alloc] init];
        _imgLeft.image = [UIImage imageNamed:@"news_search"];
        _imgLeft.contentMode = UIViewContentModeCenter;
    }
    return _imgLeft;
}

- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [[UIButton alloc] init];
        [_btnRight setImage:[UIImage imageNamed:@"news_voice"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(btnVoiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end
