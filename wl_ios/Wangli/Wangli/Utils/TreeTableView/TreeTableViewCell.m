//
//  TreeTableViewCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/21.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TreeTableViewCell.h"

@implementation TreeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgIcon];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labMsg];
    [self.contentView addSubview:self.labIcon];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(@20);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.labIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.imgIcon);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgIcon);
        make.left.equalTo(self.imgIcon.mas_right).offset(10);
    }];

    [self.labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgIcon);
        make.left.equalTo(self.labTitle.mas_right).offset(10);
    }];
}

- (void)loadDataWith:(Node *)node {
    if (_node != node) {
        _node = node;
    }
    self.labTitle.text = _node.name;
    self.labMsg.text = _node.msg;
    NSString *name = _node.name;
    if (_node.name.length > 2) {
        name = [name substringWithRange:NSMakeRange(1, 2)];
    }
    self.labIcon.text = name;
    // 操作员
    if (_node.isEnd) {
        __weak typeof(self) weakself = self;
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:_node.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            weakself.labIcon.hidden = image ? YES : NO;
            weakself.imgIcon.hidden = image ? NO : YES;
        }];
    } else {
        // 部门
        self.labIcon.hidden = YES;
        self.imgIcon.hidden = NO;
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:_node.url] placeholderImage:[UIImage imageNamed:_node.imgName]];
    }
    
    [self.imgIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25*_node.depth+15));
        make.height.width.equalTo(_node.isEnd ? @35 : @13);
    }];
    self.imgIcon.layer.cornerRadius = _node.isEnd ? 17.5 : 0;
    self.imgIcon.clipsToBounds = YES;
    self.labIcon.layer.cornerRadius = _node.isEnd ? 17.5 : 0;
    self.labIcon.clipsToBounds = YES;
    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgIcon;
}

- (UILabel *)labIcon {
    if (!_labIcon) {
        _labIcon = [[UILabel alloc] init];
        _labIcon.font = FONT_F15;
        _labIcon.textColor = COLOR_B4;
        _labIcon.backgroundColor = COLOR_C1;
        _labIcon.textAlignment = NSTextAlignmentCenter;
    }
    return _labIcon;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UILabel *)labMsg {
    if (!_labMsg) {
        _labMsg = [[UILabel alloc] init];
        _labMsg.font = FONT_F12;
        _labMsg.textColor = COLOR_B2;
    }
    return _labMsg;
}


@end
