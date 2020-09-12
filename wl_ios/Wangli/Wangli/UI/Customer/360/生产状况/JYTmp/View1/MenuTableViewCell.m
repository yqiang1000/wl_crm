//
//  MenuTableViewCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/19.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.labTitle];
    UIView *white = [UIView new];
    white.backgroundColor = COLOR_B4;
    [self.contentView addSubview:white];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.equalTo(@3);
    }];
    
    [white mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.lineView.hidden = !selected;
//    self.labTitle.textColor = selected ? COLOR_1893D5 : COLOR_B2;
//    self.contentView.backgroundColor = selected ? COLOR_B4 : COLOR_B0;
}

- (void)loadDataWith:(BOOL)cellSelect {
    self.lineView.hidden = !cellSelect;
    self.labTitle.textColor = cellSelect ? COLOR_1893D5 : COLOR_B2;
    self.contentView.backgroundColor = cellSelect ? COLOR_B4 : COLOR_B0;
}

#pragma mark - setter getter

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F13;
    }
    return _labTitle;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_1893D5;
    }
    return _lineView;
}

@end
