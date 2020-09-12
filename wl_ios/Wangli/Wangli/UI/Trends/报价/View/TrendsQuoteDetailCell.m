//
//  TrendsQuoteDetailCell.m
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsQuoteDetailCell.h"

@interface TrendsQuoteDetailCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *labCagegory;
@property (nonatomic, strong) UILabel *labGears;
@property (nonatomic, strong) UILabel *labPrice;
@property (nonatomic, strong) UILabel *labNum;
@property (nonatomic, strong) UILabel *labTotal;
@property (nonatomic, strong) UILabel *labUnit;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation TrendsQuoteDetailCell

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
    UIView *viewCategory = [self itemPartKey:@"产品分类" labValue:self.labCagegory];
    UIView *viewGears = [self itemPartKey:@"档位" labValue:self.labGears];
    UIView *viewUnit = [self itemPartKey:@"报价单位" labValue:self.labUnit];
    UIView *viewNum = [self itemPartKey:@"报价数量" labValue:self.labNum];
    UIView *viewPrice = [self itemPartKey:@"单价" labValue:self.labPrice];
    UIView *viewTotal = [self itemPartKey:@"小计" labValue:self.labTotal];
    
    [self.baseView addSubview:viewCategory];
    [self.baseView addSubview:viewGears];
    [self.baseView addSubview:viewUnit];
    [self.baseView addSubview:viewNum];
    [self.baseView addSubview:viewPrice];
    [self.baseView addSubview:viewTotal];
    [self.baseView addSubview:self.lineView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView);
    }];
    
    [viewCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView.mas_centerX).offset(-10);
    }];
    
    [viewGears mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewCategory);
        make.left.equalTo(self.baseView.mas_centerX).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [viewUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewCategory.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView.mas_centerX).offset(-10);
    }];
    
    [viewNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewUnit);
        make.left.equalTo(self.baseView.mas_centerX).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [viewPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewUnit.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView.mas_centerX).offset(-10);
        make.bottom.equalTo(self.baseView).offset(-15);
    }];
    
    [viewTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewPrice);
        make.left.equalTo(self.baseView.mas_centerX).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)itemPartKey:(NSString *)key labValue:(UILabel *)labValue {
    UIView *bottomView = [UIView new];
    UILabel *labKey = [self getNewLabel];
    labKey.text = key;
    [bottomView addSubview:labKey];
    [bottomView addSubview:labValue];
    [labKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(bottomView);
        make.bottom.equalTo(bottomView);
    }];
    [labValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(labKey.mas_right).offset(3);
        make.right.lessThanOrEqualTo(bottomView);
        make.bottom.equalTo(bottomView);
    }];
    return bottomView;
}

#pragma mark - public

- (void)loadDataWith:(TrendsQuoteDetailMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labCagegory.text = _model.materialType[@"name"];
    self.labGears.text = _model.gears;
    self.labPrice.text = _model.price;
    self.labNum.text = _model.quantity;
    self.labUnit.text = _model.unitValue;
    self.labTotal.text = _model.totalPrice;
    [self layoutIfNeeded];
}

#pragma mark - setter getter

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

- (UILabel *)labCagegory {
    if (!_labCagegory) _labCagegory = [self getNewLabel];
    return _labCagegory;
}

- (UILabel *)labGears {
    if (!_labGears) _labGears = [self getNewLabel];
    return _labGears;
}

- (UILabel *)labPrice {
    if (!_labPrice) _labPrice = [self getNewLabel];
    return _labPrice;
}

- (UILabel *)labNum {
    if (!_labNum) _labNum = [self getNewLabel];
    return _labNum;
}

- (UILabel *)labUnit {
    if (!_labUnit) _labUnit = [self getNewLabel];
    return _labUnit;
}

- (UILabel *)labTotal {
    if (!_labTotal) _labTotal = [self getNewLabel];
    return _labTotal;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    lab.numberOfLines = 1;
    return lab;
}

@end
