
//
//  DealPlanCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "DealPlanCell.h"

@interface DealPlanCell ()

@property (nonatomic, strong) UIView *baseView;

@end

@implementation DealPlanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setUI {
    
    [self.contentView addSubview:self.baseView];
    
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labFrom];
    [self.contentView addSubview:self.labState];
    [self.contentView addSubview:self.lineView];
    
    [self.contentView addSubview:self.labMonth];
    [self.contentView addSubview:self.labYear];
    
    [self.contentView addSubview:self.labLevel];
    [self.contentView addSubview:self.labWeight];
    [self.contentView addSubview:self.labTotalSend];
    [self.contentView addSubview:self.labRealSend];
    
    [self.contentView addSubview:self.progressView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.right.left.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(32);
        make.right.left.equalTo(self.baseView);
        make.height.equalTo(@0.5);
    }];
    
    [self.labMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(13);
        make.centerX.equalTo(self.labYear);
    }];
    
    [self.labYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-12);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.labLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.equalTo(self.baseView).offset(72);
    }];
    
    [self.labWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labLevel.mas_bottom).offset(10);
        make.left.equalTo(self.labLevel);
    }];
    
    [self.labTotalSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labLevel);
        make.left.equalTo(self.baseView).offset(IS_IPHONE5? 150 : 178);
    }];
    
    [self.labRealSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labWeight);
        make.left.equalTo(self.labTotalSend);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baseView.mas_bottom).offset(-34);
        make.height.width.equalTo(@50);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.centerY.equalTo(self.baseView.mas_top).offset(16);
    }];
    
    [self.labFrom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.greaterThanOrEqualTo(self.labTotalSend);
        make.left.greaterThanOrEqualTo(self.labTitle.mas_right).offset(5);
        make.centerY.equalTo(self.labTitle);
    }];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressView);
        make.centerY.equalTo(self.labTitle);
    }];
}

#pragma mark - public

- (void)loadDataWith:(DealPlanMo *)model orgName:(NSString *)orgName {
    if (_model != model) {
        _model = model;
    }
    self.labMonth.text = _model.month;
    self.labYear.text = _model.year;
    self.labTitle.text = STRING(_model.batchNumber);
    self.labFrom.text = orgName;
    self.labState.text = _model.statusValue;
    
    self.labLevel.attributedText = [self mutableKey:@"等级" line:@" | " value:_model.productLevelName];
    self.labWeight.attributedText = [self mutableKey:@"件重" line:@" | " value:[NSString stringWithFormat:@"%@", _model.weight]];
    self.labTotalSend.attributedText = [self mutableKey:@"计划" line:@" | " value:[NSString stringWithFormat:@"%@KG", [Utils getPriceFrom:_model.showQuantity]]];
    self.labRealSend.attributedText = [self mutableKey:@"实发" line:@" | " value:[NSString stringWithFormat:@"%@KG", [Utils getPriceFrom:_model.issuedQuantity]]];
    
    if (_model.adjustedQuantity < 0.0001) {
        self.progressView.progress = 0;
        [((UILabel *)self.progressView.centralView) setText:[NSString stringWithFormat:@"%2.0f%%", 0.0]];
    } else {
        self.progressView.progress = _model.issuedQuantity / _model.adjustedQuantity;
        [((UILabel *)self.progressView.centralView) setText:[NSString stringWithFormat:@"%2.0f%%", _model.issuedQuantity * 1.0 / _model.adjustedQuantity * 100]];
    }
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
        _labTitle.font = FONT_F17;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UILabel *)labFrom {
    if (!_labFrom) {
        _labFrom = [[UILabel alloc] init];
        _labFrom.font = FONT_F13;
        _labFrom.textColor = COLOR_B2;
    }
    return _labFrom;
}

- (UILabel *)labState {
    if (!_labState) {
        _labState = [[UILabel alloc] init];
        _labState.font = FONT_F13;
        _labState.textColor = COLOR_1893D5;
    }
    return _labState;
}

- (UILabel *)labLevel {
    if (!_labLevel) {
        _labLevel = [[UILabel alloc] init];
        _labLevel.font = FONT_F13;
    }
    return _labLevel;
}

- (UILabel *)labWeight {
    if (!_labWeight) {
        _labWeight = [[UILabel alloc] init];
        _labWeight.font = FONT_F13;
    }
    return _labWeight;
}

- (UILabel *)labTotalSend {
    if (!_labTotalSend) {
        _labTotalSend = [[UILabel alloc] init];
        _labTotalSend.font = FONT_F13;
    }
    return _labTotalSend;
}

- (UILabel *)labRealSend {
    if (!_labRealSend) {
        _labRealSend = [[UILabel alloc] init];
        _labRealSend.font = FONT_F13;
    }
    return _labRealSend;
}

- (UAProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UAProgressView alloc] init];
        _progressView.tintColor = COLOR_C1;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.textColor = COLOR_B1;
        label.font = FONT_F13;
        label.text = @"0%";
        label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
        _progressView.centralView = label;
        _progressView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
//            [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
        };
    }
    return _progressView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}
@end
