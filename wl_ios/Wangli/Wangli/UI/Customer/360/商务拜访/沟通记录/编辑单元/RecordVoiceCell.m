//
//  RecordVoiceCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordVoiceCell.h"
#import "UIButton+ShortCut.h"

@interface RecordVoiceCell ()

@property (nonatomic, strong) UIImageView *imgVoice;

@end

@implementation RecordVoiceCell
//m_voice
//15 20

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = COLOR_F2F3F5;
        [self setUI];
    }
    return self;
}


- (void)setUI {
    [self.contentView addSubview:self.imgVoice];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.btnDelete];
    
    [self.imgVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-(DEVICE_VALUE(10)));
//        make.top.equalTo(self.contentView).offset(DEVICE_VALUE(15));
        make.height.equalTo(@(DEVICE_VALUE(20.0)));
        make.width.equalTo(@(DEVICE_VALUE(15.0)));
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(DEVICE_VALUE(10));
    }];
    
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(-2);
        make.width.height.equalTo(@15.0);
    }];
}

#pragma mark - public

- (void)btnDeleteClick:(UIButton *)sender {
    if (_recordVoiceCellDelegate && [_recordVoiceCellDelegate respondsToSelector:@selector(recordVoiceCell:deleteIndexPath:)]) {
        [_recordVoiceCellDelegate recordVoiceCell:self deleteIndexPath:self.indexPath];
    }
}

- (void)loadData:(QiniuFileMo *)model {
    _model = model;
    self.labTime.text = [Utils getTimeByCount:_model.extData];
    self.btnDelete.hidden = self.unDelete;
}

#pragma mark - setter getter

- (UIImageView *)imgVoice {
    if (!_imgVoice) {
        _imgVoice = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m_voice"]];
    }
    return _imgVoice;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = FONT_F9;
        _labTime.textColor = COLOR_1893D5;
        _labTime.textAlignment = NSTextAlignmentCenter;
    }
    return _labTime;
}

- (UIButton *)btnDelete {
    if (!_btnDelete) {
        _btnDelete = [[UIButton alloc] init];
        [_btnDelete setImage:[UIImage imageNamed:@"upload_close"] forState:UIControlStateNormal];
        [_btnDelete addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDelete;
}

@end
