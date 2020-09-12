//
//  AddressCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/17.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "AddressCell.h"
#import "UIButton+ShortCut.h"

@interface AddressCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIButton *btnEdit;
@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation AddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.labAddress];
    [self.baseView addSubview:self.labContact];
    [self.baseView addSubview:self.btnDefault];
    [self.baseView addSubview:self.lineView];
    [self.baseView addSubview:self.btnDelete];
    [self.baseView addSubview:self.btnEdit];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@105);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(10);
        make.top.equalTo(self.baseView).offset(14);
        make.right.lessThanOrEqualTo(self.baseView.mas_right).offset(-10);
    }];
    
    [self.labContact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(10);
        make.bottom.equalTo(self.lineView.mas_top).offset(-14);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-36);
        make.height.equalTo(@0.5);
    }];
    
    [self.btnDefault mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(10);
        make.centerY.equalTo(self.lineView.mas_bottom).offset(18);
        make.width.equalTo(@45);
        make.height.equalTo(@24);
    }];
    
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView).offset(-10);
        make.centerY.equalTo(self.lineView.mas_bottom).offset(18);
    }];
    
    [self.btnEdit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnDelete.mas_left).offset(-25);
        make.centerY.equalTo(self.lineView.mas_bottom).offset(18);
    }];
}

#pragma mark - public

- (void)laodDataWith:(AddressMo *)mo {
    if (_mo != mo) {
        _mo = mo;
    }
    self.labAddress.text = _mo.address;
    NSString *str = @"";
    if (_mo.provinceName) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", _mo.provinceName]];
    }
    if (_mo.cityName) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", _mo.cityName]];
    }
    if (_mo.areaName) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@", _mo.areaName]];
    }
    if (_mo.phoneOne) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@" %@", _mo.phoneOne]];
    }
    if (_mo.receiver) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@" %@", _mo.receiver]];
    }
    self.labContact.text = str;
    self.btnDefault.hidden = !_mo.defaults;
}

- (void)refreshView:(BOOL)cellSelected {
    self.baseView.backgroundColor = cellSelected ? COLOR_F3F9FD : COLOR_B4;
    self.baseView.layer.borderColor = cellSelected ? COLOR_C1.CGColor : COLOR_B4.CGColor;
    self.baseView.layer.borderWidth = 0.5;
}

- (void)btnDeleteClick:(UIButton *)sender {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(addressCellBtnDeleteClick:)]) {
        [_cellDelegate addressCellBtnDeleteClick:self];
    }
}

- (void)btnEditClick:(UIButton *)sender {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(addressCellBtnEditClick:)]) {
        [_cellDelegate addressCellBtnEditClick:self];
    }
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.layer.cornerRadius = 4;
        _baseView.clipsToBounds = YES;
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UILabel *)labAddress {
    if (!_labAddress) {
        _labAddress = [UILabel new];
        _labAddress.textColor = COLOR_B1;
        _labAddress.font = FONT_F16;
    }
    return _labAddress;
}

- (UILabel *)labContact {
    if (!_labContact) {
        _labContact = [UILabel new];
        _labContact.textColor = COLOR_B2;
        _labContact.font = FONT_F13;
    }
    return _labContact;
}

- (UIButton *)btnDefault {
    if (!_btnDefault) {
        _btnDefault = [[UIButton alloc] init];
        [_btnDefault setTitle:@"默认" forState:UIControlStateNormal];
        _btnDefault.layer.cornerRadius = 4;
        _btnDefault.titleLabel.font = FONT_F13;
        _btnDefault.clipsToBounds = YES;
        [_btnDefault setTitleColor:COLOR_C3 forState:UIControlStateNormal];
        _btnDefault.layer.borderColor = COLOR_C3.CGColor;
        _btnDefault.layer.borderWidth = 0.5;
        _btnDefault.clipsToBounds = YES;
    }
    return _btnDefault;
}

- (UIButton *)btnEdit {
    if (!_btnEdit) {
        _btnEdit = [[UIButton alloc] init];
        _btnEdit.titleLabel.font = FONT_F13;
        [_btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [_btnEdit setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btnEdit setImage:[UIImage imageNamed:@"编辑(2)"] forState:UIControlStateNormal];
        [_btnEdit imageLeftWithTitleFix:5];
        [_btnEdit addTarget:self action:@selector(btnEditClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnEdit;
}

- (UIButton *)btnDelete {
    if (!_btnDelete) {
        _btnDelete = [[UIButton alloc] init];
        _btnDelete.titleLabel.font = FONT_F13;
        [_btnDelete setTitle:@"删除" forState:UIControlStateNormal];
        [_btnDelete setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btnDelete setImage:[UIImage imageNamed:@"删除(1)"] forState:UIControlStateNormal];
        [_btnDelete imageLeftWithTitleFix:5];
        [_btnDelete addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDelete;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
