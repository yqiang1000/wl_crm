//
//  RetailItemCell.m
//  Wangli
//
//  Created by yeqiang on 2019/4/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "RetailItemCell.h"

@implementation RetailItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labTitle];
    UIView *lineView = [Utils getLineView];
    [self.contentView addSubview:lineView];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

@end
