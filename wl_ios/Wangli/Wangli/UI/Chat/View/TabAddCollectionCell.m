//
//  TabAddCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2019/8/28.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "TabAddCollectionCell.h"

@implementation TabAddCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = COLOR_B4;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.labText];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.centerX.equalTo(self.contentView);
        make.height.width.equalTo(@((IS_iPhoneX || IS_IPHONE6_PLUS) ? 48 : 40));
    }];
    
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(10);
        make.centerX.equalTo(self.imgView);
        make.left.greaterThanOrEqualTo(self.contentView).offset(10);
    }];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)labText {
    if (!_labText) {
        _labText = [UILabel new];
        _labText.font = FONT_F13;
        _labText.textColor = COLOR_B2;
        _labText.numberOfLines = 0;
        _labText.textAlignment = NSTextAlignmentCenter;
    }
    return _labText;
}

@end
