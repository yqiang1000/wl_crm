//
//  SalesPriceCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "SalesPriceCell.h"

@interface SalesPriceCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labMarket;
@property (nonatomic, strong) UILabel *labCustomerPrice;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SalesPriceCell

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
    [self.baseView addSubview:self.labTitle];
    UIView *viewMarket = [self itemPartKey:@"市场价:¥" labValue:self.labMarket];
    UIView *viewCustomer = [self itemPartKey:@"战略客户报价:￥" labValue:self.labCustomerPrice];
    UIView *viewTime = [self itemPartKey:@"报价日期:" labValue:self.labTime];
    [self.baseView addSubview:viewMarket];
    [self.baseView addSubview:viewCustomer];
    [self.baseView addSubview:viewTime];
    [self.baseView addSubview:self.lineView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [viewMarket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [viewCustomer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewMarket);
        make.left.equalTo(self.baseView.mas_centerX).offset(15);
    }];
    
    [viewTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewMarket.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.bottom.equalTo(self.baseView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)itemPartKey:(NSString *)key labValue:(id)labValue {
    UIView *bottomView = [UIView new];
    UILabel *labKey = [self getNewLabel];
    labKey.text = key;
    [bottomView addSubview:labKey];
    [bottomView addSubview:labValue];
    [labKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(bottomView);
        make.bottom.lessThanOrEqualTo(bottomView);
    }];
    [labValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labKey);
        make.left.equalTo(labKey.mas_right).offset(3);
        make.right.lessThanOrEqualTo(bottomView);
    }];
    return bottomView;
}

#pragma mark - public

- (void)loadData:(SalesPriceMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = _model.productName;
    self.labTime.text = _model.startDate;
    self.labCustomerPrice.text = _model.priceMaintenance;
    self.labMarket.text = _model.unitPrice;
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

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.textColor = COLOR_B1;
        _labTitle.font = FONT_F15;
    }
    return _labTitle;
}

- (UILabel *)labCustomerPrice {
    if (!_labCustomerPrice) _labCustomerPrice = [self getNewLabel];
    return _labCustomerPrice;
}

- (UILabel *)labTime {
    if (!_labTime) _labTime = [self getNewLabel];
    return _labTime;
}

- (UILabel *)labMarket {
    if (!_labMarket) _labMarket = [self getNewLabel];
    return _labMarket;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    lab.numberOfLines = 0;
    return lab;
}

@end
