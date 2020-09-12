//
//  JYWorkPlanItemCell.m
//  Wangli
//
//  Created by yeqiang on 2019/8/28.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "JYWorkPlanItemCell.h"

@implementation JYWorkPlanItemCell

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
