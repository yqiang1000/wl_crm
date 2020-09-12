//
//  PermissionCell.m
//  Wangli
//
//  Created by yeqiang on 2019/3/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "PermissionCell.h"
#import "UIButton+WebCache.h"

@implementation PermissionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.btnIcon];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labMsg];
    [self.contentView addSubview:self.imgArrow];
    UIView *lineView = [Utils getLineView];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.btnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(@20.0);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnIcon);
        make.left.equalTo(self.btnIcon.mas_right).offset(10);
    }];
    
    [self.labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnIcon);
        make.left.equalTo(self.labTitle.mas_right).offset(10);
    }];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@10.0);
    }];
}

- (void)loadDataWith:(Node *)node {
    if (_node != node) {
        _node = node;
    }
    self.labTitle.text = _node.name;
    self.labMsg.text = _node.msg;
    
    // 操作员
    if (_node.isEnd) {
        [self.btnIcon sd_setImageWithURL:[NSURL URLWithString:_node.url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:_node.imgName]];
    } else {
        // 部门
        self.btnIcon.hidden = NO;
        [self.btnIcon sd_setImageWithURL:[NSURL URLWithString:_node.url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:_node.imgName]];
    }
    
    [self.btnIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25*_node.depth+15));
    }];
    
    self.imgArrow.hidden = !_node.isSelect;
    [self layoutIfNeeded];
}

#pragma mark - event

- (void)btnIconClick:(UIButton *)sender {
    if (_permissionDelegate && [_permissionDelegate respondsToSelector:@selector(permissionCell:didSelected:indexPath:)]) {
        [_permissionDelegate permissionCell:self didSelected:self.btnIcon.selected indexPath:self.indexPath];
    }
}

#pragma mark - setter getter

- (UIButton *)btnIcon {
    if (!_btnIcon) {
        _btnIcon = [[UIButton alloc] init];
        _btnIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_btnIcon addTarget:self action:@selector(btnIconClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnIcon;
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

- (UIImageView *)imgArrow {
    if (!_imgArrow) {
        _imgArrow = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"元素单选"]];
    }
    return _imgArrow;
}

@end
