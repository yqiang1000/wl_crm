//
//  ServiceConsultationReplyCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ServiceConsultationReplyCell.h"

@interface ServiceConsultationReplyCell ()

@property (nonatomic, strong) UIButton *btnName;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UILabel *labReply;
@property (nonatomic, strong) UILabel *labTime;

@end

@implementation ServiceConsultationReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.btnName];
    [self.contentView addSubview:self.labReply];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.labContent];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@0.5);
    }];
    
    [self.btnName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.labReply);
    }];
    
    [self.labReply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.btnName.mas_right).offset(4);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.labReply);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labReply.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - public

- (void)loadDataName:(NSString *)name reply:(NSString *)reply time:(NSString *)time content:(NSString *)content {
    //    if (_model != model) {
    //        _model = model;
    //    }
    [self.btnName setTitle:STRING(name) forState:UIControlStateNormal];
    self.labReply.text = STRING(reply);
    self.labTime.text = STRING(time);
    self.labContent.text = STRING(content);
}

#pragma mark - setter getter

- (UIButton *)btnName {
    if (!_btnName) {
        _btnName = [[UIButton alloc] init];
        [_btnName setTitleColor:COLOR_336699 forState:UIControlStateNormal];
        _btnName.titleLabel.font = FONT_F13;
    }
    return _btnName;
}

- (UILabel *)labReply {
    if (!_labReply) {
        _labReply = [[UILabel alloc] init];
        _labReply.font = FONT_F13;
        _labReply.textColor = COLOR_B2;
    }
    return _labReply;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = FONT_F12;
        _labTime.textColor = COLOR_B3;
    }
    return _labTime;
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [[UILabel alloc] init];
        _labContent.font = FONT_F13;
        _labContent.textColor = COLOR_B1;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
