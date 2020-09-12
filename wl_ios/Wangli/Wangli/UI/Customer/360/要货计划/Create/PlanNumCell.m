//
//  PlanNumCell.m
//  Wangli
//
//  Created by yeqiang on 2018/9/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PlanNumCell.h"

@interface PlanNumCell ()

{
    UIFont *_textFont;
}

@end

@implementation PlanNumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _textFont = IS_IPHONE5 ? FONT_F14 : FONT_F15;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labNumber];
    [self.contentView addSubview:self.labSpec];
    [self.contentView addSubview:self.labFactory];
    [self.contentView addSubview:self.labWeight];
    [self.contentView addSubview:self.labLevel];
    [self.contentView addSubview:self.labQuantity];
    [self.contentView addSubview:self.imgArrow];
    [self.contentView addSubview:self.lineView];
    
    [self.labNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.labSpec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.labNumber);
        make.width.equalTo(self.labNumber);
    }];
    
    [self.labFactory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labNumber);
        make.left.equalTo(self.labNumber.mas_right);
        make.width.equalTo(self.labNumber);
    }];
    
    [self.labWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labSpec);
        make.left.equalTo(self.labFactory);
        make.width.equalTo(self.labFactory);
    }];
    
    [self.labLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labNumber);
        make.left.equalTo(self.labFactory.mas_right);
        make.right.equalTo(self.imgArrow.mas_left).offset(-5);
        make.width.equalTo(self.labNumber);
    }];
    
    [self.labQuantity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labSpec);
        make.left.equalTo(self.labLevel);
        make.width.equalTo(self.labLevel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@8);
        make.height.equalTo(@13);
    }];
}

#pragma mark - public

- (void)loadDataWith:(MaterialMo *)mo {
    if (_mo != mo) {
        _mo = mo;
    }
    
    self.labNumber.text = _mo.batchNumber;
    self.labFactory.text = _mo.factoryName;
    self.labLevel.text = _mo.productLevelName;
    self.labSpec.text = [NSString stringWithFormat:@"规格:%@", _mo.spec];
    self.labWeight.text = [NSString stringWithFormat:@"件重:%@", _mo.weight];
    self.labQuantity.text = [NSString stringWithFormat:@"数量:%@", _mo.quantity];
}

#pragma mark - setter getter

- (UILabel *)labSpec {
    if (!_labSpec) {
        _labSpec = [[UILabel alloc] init];
        _labSpec.textColor = COLOR_B1;
        _labSpec.font = _textFont;
    }
    return _labSpec;
}

- (UILabel *)labLevel {
    if (!_labLevel) {
        _labLevel = [[UILabel alloc] init];
        _labLevel.textColor = COLOR_B2;
        _labLevel.font = _textFont;
    }
    return _labLevel;
}

- (UILabel *)labNumber {
    if (!_labNumber) {
        _labNumber = [[UILabel alloc] init];
        _labNumber.textColor = COLOR_B1;
        _labNumber.font = _textFont;
    }
    return _labNumber;
}

- (UILabel *)labQuantity {
    if (!_labQuantity) {
        _labQuantity = [[UILabel alloc] init];
        _labQuantity.textColor = COLOR_B2;
        _labQuantity.font = _textFont;
    }
    return _labQuantity;
}

- (UILabel *)labFactory {
    if (!_labFactory) {
        _labFactory = [[UILabel alloc] init];
        _labFactory.textColor = COLOR_B1;
        _labFactory.font = _textFont;
    }
    return _labFactory;
}

- (UILabel *)labWeight {
    if (!_labWeight) {
        _labWeight = [[UILabel alloc] init];
        _labWeight.textColor = COLOR_B1;
        _labWeight.font = _textFont;
    }
    return _labWeight;
}

- (UIImageView *)imgArrow {
    if (!_imgArrow) {
        _imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"client_arrow"]];
    }
    return _imgArrow;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
