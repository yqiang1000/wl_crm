//
//  NewComplaintCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "NewComplaintCell.h"

@interface NewComplaintCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imgArrow;

@end

@implementation NewComplaintCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_B4;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    [self.contentView addSubview:self.baseView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.labInvoice];
    [self.contentView addSubview:self.labReceipt];
    [self.contentView addSubview:self.labNotInvoice];
    [self.contentView addSubview:self.labNotReceipt];
    
    [self.contentView addSubview:self.imgArrow];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView);
        make.left.equalTo(self.baseView).offset(0);
        make.right.equalTo(self.baseView).offset(0);
        make.height.equalTo(@0.5);
    }];
    
    [self.labInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [self.labReceipt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView).offset(-15);
//        make.top.equalTo(self.labInvoice.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [self.labNotInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labInvoice);
        make.left.equalTo(self.baseView).offset(IS_IPHONE5? 130 : 150);
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

- (void)loadDataWith:(ProblemDescMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labInvoice.attributedText = [self mutableKey:@"客诉类型" line:@" | " value:STRING(_model.consulationType)];
    self.labReceipt.attributedText = [self mutableKey:@"具体类型" line:@" | " value:STRING(_model.detailType)];
    self.labNotInvoice.attributedText = [self mutableKey:@"投诉数量" line:@" | " value:STRING(_model.count)];
    self.labNotReceipt.attributedText = [self mutableKey:@"描述" line:@" | " value:STRING(_model.desc)];
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
