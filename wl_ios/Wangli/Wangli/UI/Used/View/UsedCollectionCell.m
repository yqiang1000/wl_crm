//
//  UsedCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "UsedCollectionCell.h"

#pragma mark - UsedCollectionCell

@interface UsedCollectionCell ()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIView *baseView;

@end

@implementation UsedCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_B4;
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
        make.centerY.equalTo(self.baseView).offset(-10);
        make.height.width.equalTo(@22.0);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.centerY.equalTo(self.imgIcon.mas_bottom).offset(17);
        make.left.equalTo(self.contentView).offset(5);
    }];

    UIView *lineView = [Utils getLineView];
    [self.baseView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.baseView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - public

- (void)loadDataWith:(UsedMo *)model {
    _mo = model;
    if (_mo) {
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:[Utils imgUrlWithKey:_mo.iosIconUrl]] placeholderImage:[UIImage imageNamed:@"default_icon"]];
        self.labTitle.text = _mo.name;
    } else {
        self.imgIcon.image = nil;
        self.labTitle.text = @"";
    }
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
//        _imgIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgIcon;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B2;
        _labTitle.numberOfLines = 0;
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}

@end


#pragma mark - UsedHeaderView

@implementation UsedHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backgroundColor = COLOR_B4;
    [self addSubview:self.labText];
    [self addSubview:self.imgView];
    [self addSubview:self.lineView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@3.0);
        make.height.equalTo(@15.0);
    }];
    
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.imgView.mas_right).offset(7);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - setter getter

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UIView *)imgView {
    if (!_imgView) {
        _imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 15)];
        _imgView.backgroundColor = COLOR_C1;
        _imgView.layer.mask = [Utils drawContentFrame:_imgView.bounds corners:UIRectCornerAllCorners cornerRadius:1.5];
    }
    return _imgView;
}

- (UILabel *)labText {
    if (!_labText) {
        _labText = [[UILabel alloc] init];
        _labText.font = FONT_F14;
        _labText.textColor = COLOR_B1;
    }
    return _labText;
}

@end


#pragma mark - UsedFooterView

@implementation UsedFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backgroundColor = COLOR_B0;
}

@end
