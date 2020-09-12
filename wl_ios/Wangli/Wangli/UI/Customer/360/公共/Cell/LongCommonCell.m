//
//  LongCommonCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "LongCommonCell.h"

#pragma mark - LongCommonCell

@interface LongCommonCell ()

@end

@implementation LongCommonCell

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
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.labRight];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@45);
    }];
    
    [self.labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.labLeft.mas_bottom).offset(10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labLeft);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - public

- (void)setLongRightText:(NSString *)rightText {
    self.labRight.text = rightText;
    if (self.labRight.text.length == 0) {
        [self.labLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.height.equalTo(@45);
            make.bottom.equalTo(self.contentView);
        }];
        self.labRight.hidden = YES;
        [self.labRight mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.width.equalTo(@0);
        }];
    } else {
        self.labRight.hidden = NO;
        [self.labLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.height.equalTo(@45);
        }];
        
        [self.labRight mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.labLeft.mas_bottom).offset(5);
        }];
    }
    [self layoutIfNeeded];
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
        _labRight.numberOfLines = 0;
    }
    return _labRight;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
