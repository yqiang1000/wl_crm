//
//  OrderProductCell.m
//  Wangli
//
//  Created by yeqiang on 2018/5/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "OrderProductCell.h"

@implementation OrderProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labNumber];
    [self.contentView addSubview:self.labSpePrice];
    [self.contentView addSubview:self.labLevel];
    [self.contentView addSubview:self.labOldPrice];
    [self.contentView addSubview:self.imgArrow];
    [self.contentView addSubview:self.lineView];
    
    [self.labNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.labSpePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.labLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labNumber);
        make.left.equalTo(self.contentView).offset(200);
    }];
    
    [self.labOldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labNumber);
        make.left.equalTo(self.contentView).offset(100);
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

- (void)loadDataWith:(ProductMo *)mo order:(BOOL)order {
    if (_mo != mo) {
        _mo = mo;
    }
    
    self.labNumber.text = _mo.batch;
    if (order) {
        self.labSpePrice.text = [NSString stringWithFormat:@"数量：%@KG", _mo.priceApply];
    } else {
        self.labSpePrice.text = [NSString stringWithFormat:@"特价：%@元/KG", _mo.priceApply];
    }
    
    self.labLevel.text = _mo.level;
}

#pragma mark - setter getter

- (UILabel *)labSpePrice {
    if (!_labSpePrice) {
        _labSpePrice = [[UILabel alloc] init];
        _labSpePrice.textColor = COLOR_B1;
        _labSpePrice.font = FONT_F16;
    }
    return _labSpePrice;
}

- (UILabel *)labLevel {
    if (!_labLevel) {
        _labLevel = [[UILabel alloc] init];
        _labLevel.textColor = COLOR_B2;
        _labLevel.font = FONT_F16;
    }
    return _labLevel;
}

- (UILabel *)labNumber {
    if (!_labNumber) {
        _labNumber = [[UILabel alloc] init];
        _labNumber.textColor = COLOR_B1;
        _labNumber.font = FONT_F16;
    }
    return _labNumber;
}

- (UILabel *)labOldPrice {
    if (!_labOldPrice) {
        _labOldPrice = [[UILabel alloc] init];
        _labOldPrice.textColor = COLOR_B2;
        _labOldPrice.font = FONT_F16;
        _labOldPrice.hidden = YES;
    }
    return _labOldPrice;
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
