//
//  RiskTotalCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/17.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "RiskTotalCell.h"

@interface RiskTotalCell ()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIView *baseView;

@end

@implementation RiskTotalCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.imgIcon];
    [self.baseView addSubview:self.labTitle];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(16);
        make.height.width.equalTo(@43);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.imgIcon.mas_bottom).offset(10);
    }];
}

#pragma mark - public

- (void)loadDataWith:(RiskListMo *)model {
    if (_model != model) {
        _model = model;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld", _model.fieldValue, _model.count]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_B1 range:NSMakeRange(_model.fieldValue.length, attrStr.length - _model.fieldValue.length)];
    self.labTitle.attributedText = attrStr;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl]];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 4;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
        _imgIcon.layer.mask = [Utils drawContentFrame:_imgIcon.bounds corners:UIRectCornerAllCorners cornerRadius:21.5];
        _imgIcon.clipsToBounds = YES;
        _imgIcon.backgroundColor = COLOR_B4;
    }
    return _imgIcon;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B2;
    }
    return _labTitle;
}


@end
