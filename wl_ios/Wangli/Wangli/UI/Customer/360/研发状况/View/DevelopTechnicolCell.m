//
//  DevelopTechnicolCell.m
//  Wangli
//
//  Created by yeqiang on 2019/1/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "DevelopTechnicolCell.h"

@interface DevelopTechnicolCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation DevelopTechnicolCell

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
    [self.baseView addSubview:self.labContent];
    [self.baseView addSubview:self.labTime];
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
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContent.mas_bottom).offset(10);
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

#pragma mark - public

- (void)loadData:(DevelopTechnicalMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = _model.productType;
    self.labTime.text = [NSString stringWithFormat:@"上传日期：%@", _model.planDate];
    self.labContent.text = _model.content;
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

- (UILabel *)labContent {
    if (!_labContent) _labContent = [self getNewLabel];
    return _labContent;
}

- (UILabel *)labTime {
    if (!_labTime) _labTime = [self getNewLabel];
    return _labTime;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    lab.numberOfLines = 0;
    return lab;
}

@end
