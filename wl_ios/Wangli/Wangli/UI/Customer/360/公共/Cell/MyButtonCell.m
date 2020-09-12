//
//  MyButtonCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyButtonCell.h"

#pragma mark - MyButtonCell

@interface MyButtonCell ()

@end

@implementation MyButtonCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    self.contentView.backgroundColor = COLOR_B0;
    [self.contentView addSubview:self.btnSave];
    [self.btnSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(50);
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@44.0);
        make.bottom.equalTo(self.contentView);
    }];
}


#pragma mark - public

#pragma mark - event

- (void)btnSaveClick:(UIButton *)sender {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:btnClick:)]) {
        [_cellDelegate cell:self btnClick:sender];
    }
}

#pragma mark - setter and getter

- (UIButton *)btnSave {
    if (!_btnSave) {
        _btnSave = [[UIButton alloc] init];
        _btnSave.titleLabel.font = FONT_F18;
        [_btnSave setBackgroundColor:COLOR_C1];
        [_btnSave setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        //        [_btnSave setTitle: forState:UIControlStateNormal];
        [_btnSave addTarget:self action:@selector(btnSaveClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnSave.layer.cornerRadius = 4;
        _btnSave.clipsToBounds = YES;
    }
    return _btnSave;
}

@end
