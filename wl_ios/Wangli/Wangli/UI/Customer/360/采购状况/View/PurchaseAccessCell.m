//
//  PurchaseAccessCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchaseAccessCell.h"

@interface PurchaseAccessCell ()

@property (nonatomic, strong) UIView *baseView;
//@property (nonatomic, strong) UIButton *btnFile;
//@property (nonatomic, strong) UILabel *labType;
//@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation PurchaseAccessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.backgroundColor = COLOR_B0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.btnFile];
    [self.baseView addSubview:self.labTime];
    [self.baseView addSubview:self.labType];
    [self.baseView addSubview:self.lineView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView);
    }];
    
    [self.btnFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(4);
        make.left.equalTo(self.baseView).offset(15);
        make.right.lessThanOrEqualTo(self.baseView).offset(-15);
    }];
    
    [self.labType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnFile.mas_bottom).offset(4);
        make.left.equalTo(self.baseView).offset(15);
        make.right.lessThanOrEqualTo(self.baseView.mas_centerX).offset(-10);
        make.bottom.equalTo(self.baseView).offset(-15);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labType);
        make.left.greaterThanOrEqualTo(self.baseView.mas_centerX).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - lazy

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (UILabel *)labType{
    if (!_labType) {
        _labType = [UILabel new];
        _labType.textColor = COLOR_B2;
        _labType.font = FONT_F13;
    }
    return _labType;
}

- (UILabel *)labTime{
    if (!_labTime) {
        _labTime = [UILabel new];
        _labTime.textColor = COLOR_B2;
        _labTime.font = FONT_F13;
    }
    return _labTime;
}

- (UIButton *)btnFile {
    if (!_btnFile) {
        _btnFile = [[UIButton alloc] init];
        [_btnFile setTitleColor:COLOR_1D679D forState:UIControlStateNormal];
        _btnFile.titleLabel.font = FONT_F15;
        _btnFile.titleLabel.numberOfLines = 0;
    }
    return _btnFile;
}

@end
