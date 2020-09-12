//
//  SquareGridCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "SquareGridCollectionCell.h"
#import "UIButton+ShortCut.h"

#pragma mark - SquareGridCollectionCell

@interface SquareGridCollectionCell ()

@property (nonatomic, strong) UILabel *labText;
@property (nonatomic, strong) UIImageView *imgIcon;

@end

@implementation SquareGridCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = COLOR_C1;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgIcon];
    [self.contentView addSubview:self.labText];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(15);
        make.height.width.equalTo(@26.0);
    }];
    
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgIcon);
        make.top.equalTo(self.imgIcon.mas_bottom).offset(10);
    }];

}

- (void)loadData:(SquareMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.imgIcon.image = [UIImage imageNamed:STRING(_model.image)];
    self.labText.text = STRING(_model.title);
}

#pragma mark - lazy

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
    }
    return _imgIcon;
}

- (UILabel *)labText {
    if (!_labText) {
        _labText = [UILabel new];
        _labText.textAlignment = NSTextAlignmentCenter;
        _labText.textColor = COLOR_B4;
        _labText.font = FONT_F14;
    }
    return _labText;
}

@end

#pragma mark - SquareMo

@implementation SquareMo

@end
