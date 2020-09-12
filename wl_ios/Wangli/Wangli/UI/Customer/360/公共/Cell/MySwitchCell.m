//
//  MySwitchCell.m
//  Wangli
//
//  Created by yeqiang on 2019/4/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "MySwitchCell.h"

@interface MySwitchCell ()

@end

@implementation MySwitchCell

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
    [self.contentView addSubview:self.btnRight];
    [self.contentView addSubview:self.lineView];
    
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
//        make.width.height.equalTo(@22.5);
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

#pragma mark - public

- (void)setLeftText:(NSString *)text {
    self.labLeft.text = text;
    
    CGSize size = [Utils getStringSize:self.labLeft.text font:self.labLeft.font];
    
    [self.labLeft mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width + 3));
    }];
    
    [self layoutIfNeeded];
}

#pragma mark - event

- (void)valueChanged:(UISwitch *)sender {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:btnClick:isOn:indexPath:)]) {
        [_cellDelegate cell:self btnClick:sender isOn:sender.isOn indexPath:_indexPath];
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

- (UISwitch *)btnRight {
    if (!_btnRight) {
        _btnRight = [[UISwitch alloc] init];
        [_btnRight addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
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
