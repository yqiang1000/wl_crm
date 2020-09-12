//
//  MyDefaultCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyDefaultCell.h"

#pragma mark - MyDefaultCell

@interface MyDefaultCell ()

@end

@implementation MyDefaultCell


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
    self.contentView.backgroundColor = COLOR_B4;
    [self.contentView addSubview:self.labLeft];
    [self.contentView addSubview:self.btnSwitch];
    [self.contentView addSubview:self.lineView];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.btnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - event

- (void)btnSwitchClick:(UISwitch *)sender {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(defaultCellSwitchTouch:btnSwitch:)]) {
        [_cellDelegate defaultCellSwitchTouch:self btnSwitch:self.btnSwitch];
        return;
    }
    self.btnSwitch.on = !self.btnSwitch.isOn;
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(defaultCell:isDefault:)]) {
        [_cellDelegate defaultCell:self isDefault:self.btnSwitch.on];
    }
    [self.btnSwitch setOn:self.btnSwitch.isOn animated:YES];
}

// 自适应用
- (void)setLeftText:(NSString *)text {
    self.labLeft.text = text;
    
    CGSize size = [Utils getStringSize:self.labLeft.text font:self.labLeft.font];
    
    [self.labLeft mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width + 3));
    }];
    
    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [[UILabel alloc] init];
        _labLeft.textColor = COLOR_B1;
        _labLeft.font = FONT_F16;
        [_labLeft sizeToFit];
    }
    return _labLeft;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
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
