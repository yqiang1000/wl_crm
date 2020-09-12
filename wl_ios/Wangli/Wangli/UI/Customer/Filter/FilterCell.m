//
//  FilterCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "FilterCell.h"
#import "UIButton+ShortCut.h"

#pragma mark - 排序cell

@interface ScortCell ()

@end

@implementation ScortCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.labTxt];
    [self.contentView addSubview:self.imgArraw];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.labTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.imgArraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.labTxt);
    }];
}

#pragma mark - setter getter

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UILabel *)labTxt {
    if (!_labTxt) {
        _labTxt = [[UILabel alloc] init];
        _labTxt.font = FONT_F14;
        _labTxt.textColor = COLOR_B3;
    }
    return _labTxt;
}

- (UIImageView *)imgArraw {
    if (!_imgArraw) {
        _imgArraw = [[UIImageView alloc] init];
        _imgArraw.image = [UIImage imageNamed:@"client_selected"];
        _imgArraw.hidden = YES;
    }
    return _imgArraw;
}

@end

#pragma mark - 筛选cell

@interface FilterCell ()

@end

@implementation FilterCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 4;
        self.contentView.layer.borderWidth = 1;
        self.contentView.clipsToBounds = YES;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.labName];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.greaterThanOrEqualTo(self.contentView);
        make.center.equalTo(self.contentView);
    }];
}

#pragma mark - public

- (void)setCellIsSelected:(BOOL)cellIsSelected {
    self.contentView.layer.borderColor = cellIsSelected ? COLOR_0089D1.CGColor : COLOR_B0.CGColor;
    self.contentView.backgroundColor = cellIsSelected ? COLOR_B4 : COLOR_B0;
    self.labName.textColor = cellIsSelected ? COLOR_0089D1 : COLOR_B1;
}

#pragma mark - setter getter

- (UILabel *)labName {
    if (!_labName) {
        _labName = [[UILabel alloc] init];
        _labName.font = FONT_F12;
        _labName.textColor = COLOR_B1;
        _labName.textAlignment = NSTextAlignmentLeft;
        
    }
    return _labName;
}

@end

#pragma mark - 筛选sectionHeader

@interface FilterHeaderView ()

@property (nonatomic, strong) UIButton *btnTop;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *labRight;

@end


@implementation FilterHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        _hidenLine = YES;
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _hidenLine = YES;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.labTitle];
    [self addSubview:self.labRight];
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    [self addSubview:self.btnArrow];
    [self addSubview:self.btnTop];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(0);
    }];
    
    [self.btnArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(0);
        make.width.equalTo(@38);
        make.height.equalTo(@13);
    }];
    
    [self.labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.btnArrow.mas_left).offset(0);
        make.left.greaterThanOrEqualTo(self.labTitle.mas_right).offset(10);
        make.top.equalTo(self);
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self.btnTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

- (void)leftText:(NSString *)text {
    self.labTitle.text = text;
    CGSize size = [Utils getStringSize:self.labTitle.text font:self.labTitle.font];
    
    [self.labTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width + 3));
    }];
    
    [self layoutIfNeeded];
}

- (void)rightText:(NSString *)text {
    self.labRight.text = text;
    if ([text isEqualToString:@"请选择"]) {
        self.labRight.textColor = COLOR_B1;
    } else {
        self.labRight.textColor = COLOR_C1;
    }
}

- (void)btnClick:(UIButton *)sender {
    if (_headerDelegate && [_headerDelegate respondsToSelector:@selector(filterHeaderViewSelected:indexPath:)]) {
        [_headerDelegate filterHeaderViewSelected:self indexPath:_indexPath];
    }
}

- (void)setHidenLine:(BOOL)hidenLine {
    _hidenLine = hidenLine;
    self.bottomLine.hidden = _hidenLine;
    self.topLine.hidden = YES;
    self.btnArrow.hidden = _hidenLine;
    self.btnTop.hidden = _hidenLine;
    
    if (_hidenLine) {
        [self.labTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(0);
        }];
    } else {
        [self.labTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(0);
        }];
    }
    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B2;
    }
    return _labTitle;
}

- (UIButton *)btnTop {
    if (!_btnTop) {
        _btnTop = [[UIButton alloc] init];
        [_btnTop addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnTop;
}
//- (UIButton *)btnRight {
//    if (!_btnRight) {
//        _btnRight = [[UIButton alloc] init];
//        [_btnRight addSubview:self.labRight];
//        [_labRight mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.top.equalTo(_btnRight);
//        }];
//        [_btnRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btnRight;
//}

- (UIButton *)btnArrow {
    if (!_btnArrow) {
        _btnArrow = [[UIButton alloc] init];
        [_btnArrow setImage:[UIImage imageNamed:@"client_arrow"] forState:UIControlStateNormal];
        [_btnArrow addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnArrow;
}

- (UILabel *)labRight {
    if (!_labRight) {
        _labRight = [UILabel new];
        _labRight.textColor = COLOR_B1;
        _labRight.font = FONT_F13;
        _labRight.textAlignment = NSTextAlignmentRight;
    }
    return _labRight;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [Utils getLineView];
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [Utils getLineView];
    }
    return _bottomLine;
}


@end

