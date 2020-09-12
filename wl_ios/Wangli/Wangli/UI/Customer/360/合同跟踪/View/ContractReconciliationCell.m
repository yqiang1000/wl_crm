//
//  ContractReconciliationCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ContractReconciliationCell.h"

@interface ContractReconciliationCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imgArrow;

@end

@implementation ContractReconciliationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_B4;
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    
    [self.contentView addSubview:self.baseView];
    
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.lineView];
    
    [self.contentView addSubview:self.labMonth];
    [self.contentView addSubview:self.labYear];
    
    [self.contentView addSubview:self.labInvoice];
    [self.contentView addSubview:self.labReceipt];
    [self.contentView addSubview:self.labNotInvoice];
    [self.contentView addSubview:self.labNotReceipt];
    
    [self.contentView addSubview:self.imgArrow];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(28);
        make.bottom.right.left.equalTo(self.contentView);
        make.height.equalTo(@68.0);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.bottom.equalTo(self.baseView.mas_top).offset(-1);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@0.5);
    }];
    
    [self.labMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(10);
        make.centerX.equalTo(self.labYear);
    }];
    
    [self.labYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView).offset(-12);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [self.labInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(14);
        make.left.equalTo(self.baseView).offset(57);
    }];
    
    [self.labReceipt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labInvoice.mas_bottom).offset(10);
        make.left.equalTo(self.labInvoice);
    }];
    
    [self.labNotInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labInvoice);
        make.left.equalTo(self.baseView).offset(IS_IPHONE5? 150 : 178);
    }];
    
    [self.labNotReceipt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labReceipt);
        make.left.equalTo(self.labNotInvoice);
    }];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView).offset(-15);
        make.centerY.equalTo(self.baseView);
    }];
}

#pragma mark - public

- (void)loadDataWith:(NSString *)model {
//    if (_model != model) {
//        _model = model;
//    }
    self.labMonth.text = @"11";
    self.labYear.text = @"2018";
    self.labTitle.text = @"20089-晶科 | 广东爱旭";
    self.labInvoice.attributedText = [self mutableKey:@"已开票" line:@" | " value:@"1200"];
    self.labReceipt.attributedText = [self mutableKey:@"已收票" line:@" | " value:@"2342"];
    self.labNotInvoice.attributedText = [self mutableKey:@"已发货未开票" line:@" | " value:@"56000"];
    self.labNotReceipt.attributedText = [self mutableKey:@"已发货未收票" line:@" | " value:@"27000"];
}

- (NSMutableAttributedString *)mutableKey:(NSString *)key line:(NSString *)line value:(NSString *)value {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", key, line, value]];
    [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_B2 range:NSMakeRange(0, key.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_B3 range:NSMakeRange(key.length, line.length)];
    if ([key isEqualToString:@"实发"]) {
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_ED746C range:NSMakeRange(attStr.length-value.length, value.length)];
    } else {
        [attStr addAttribute:NSForegroundColorAttributeName value:COLOR_B1 range:NSMakeRange(attStr.length-value.length, value.length)];
    }
    return attStr;
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
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

- (UILabel *)labInvoice {
    if (!_labInvoice) {
        _labInvoice = [[UILabel alloc] init];
        _labInvoice.font = FONT_F13;
    }
    return _labInvoice;
}

- (UILabel *)labReceipt {
    if (!_labReceipt) {
        _labReceipt = [[UILabel alloc] init];
        _labReceipt.font = FONT_F13;
    }
    return _labReceipt;
}

- (UILabel *)labNotInvoice {
    if (!_labNotInvoice) {
        _labNotInvoice = [[UILabel alloc] init];
        _labNotInvoice.font = FONT_F13;
    }
    return _labNotInvoice;
}

- (UILabel *)labNotReceipt {
    if (!_labNotReceipt) {
        _labNotReceipt = [[UILabel alloc] init];
        _labNotReceipt.font = FONT_F13;
    }
    return _labNotReceipt;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UIImageView *)imgArrow {
    if (!_imgArrow) {
        _imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    }
    return _imgArrow;
}

@end
