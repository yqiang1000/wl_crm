//
//  TrendsShipCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsShipCell.h"

@interface TrendsShipCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation TrendsShipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.lineView];
    [self.contentView addSubview:self.imgIcon];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labMonth];
    [self.contentView addSubview:self.labYear];
    [self.contentView addSubview:self.labProduct];
    [self.contentView addSubview:self.labCode];
    [self.contentView addSubview:self.labNum];
    [self.contentView addSubview:self.labState];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(34);
        make.bottom.equalTo(self.baseView).offset(-72);
        make.left.equalTo(self.baseView);
        make.right.equalTo(self.baseView);
        make.height.equalTo(@0.5);
    }];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.height.width.equalTo(@15.0);
        make.centerY.equalTo(self.baseView.mas_top).offset(17);
    }];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView).offset(-15);
        make.centerY.equalTo(self.imgIcon);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgIcon.mas_right).offset(8);
        make.centerY.equalTo(self.imgIcon);
        make.right.lessThanOrEqualTo(self.labState.mas_left).offset(-10);
    }];
    
    [self.labMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.centerX.equalTo(self.labYear);
    }];
    
    [self.labYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView).offset(-14);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [self.labCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView).offset(-16);
        make.left.equalTo(self.baseView).offset(IS_IPHONE5?80:100);
    }];
    
    [self.labProduct mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(17);
        make.left.equalTo(self.labCode);
        make.right.lessThanOrEqualTo(self.labNum.mas_left).offset(-5);
    }];
    
    [self.labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(30);
        make.right.equalTo(self.baseView).offset(-15);
    }];
}

#pragma mark - public

- (void)loadDataWith:(TrendsShipMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = [NSString stringWithFormat:@"%@-%@", _model.member[@"crmNumber"], _model.member[@"abbreviation"]];
    NSString *year = [_model.erdat substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [_model.erdat substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [_model.erdat substringWithRange:NSMakeRange(8, 2)];
    self.labYear.text = [NSString stringWithFormat:@"%@/%@", year, month];
    self.labMonth.text = day;
    self.labProduct.text = _model.materialDespForMobile.length==0?@"暂无信息":_model.materialDespForMobile;
    self.labCode.text = [NSString stringWithFormat:@"NO.%@/%@ | %@", _model.number,_model.lineNumber, _model.charg];
    self.labState.text = _model.statusValue;
    self.labNum.text = [NSString stringWithFormat:@"%@ %@", _model.quantity, _model.unit];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.image = [UIImage imageNamed:@"dynamic_contract_company"];
    }
    return _imgIcon;
}

- (UILabel *)labMonth {
    if (!_labMonth) {
        _labMonth = [[UILabel alloc] init];
        _labMonth.font = FONT_F30;
        _labMonth.textColor = COLOR_B1;
    }
    return _labMonth;
}

- (UILabel *)labYear {
    if (!_labYear) {
        _labYear = [[UILabel alloc] init];
        _labYear.font = FONT_F12;
        _labYear.textColor = COLOR_B3;
    }
    return _labYear;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UILabel *)labState {
    if (!_labState) {
        _labState = [[UILabel alloc] init];
        _labState.font = FONT_F13;
        _labState.textColor = COLOR_B1;
    }
    return _labState;
}

- (UILabel *)labNum {
    if (!_labNum) {
        _labNum = [[UILabel alloc] init];
        _labNum.font = FONT_F17;
        _labNum.textColor = COLOR_FF6967;
    }
    return _labNum;
}

- (UILabel *)labProduct {
    if (!_labProduct) {
        _labProduct = [[UILabel alloc] init];
        _labProduct.font = FONT_F16;
        _labProduct.textColor = COLOR_B1;
    }
    return _labProduct;
}

- (UILabel *)labCode {
    if (!_labCode) {
        _labCode = [[UILabel alloc] init];
        _labCode.font = FONT_F12;
        _labCode.textColor = COLOR_B3;
    }
    return _labCode;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
