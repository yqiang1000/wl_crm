//
//  PersonCardCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PersonCardCell.h"

@interface PersonCardCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation PersonCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = COLOR_B4;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.lineView];
    [self.baseView addSubview:self.imgHeader];
    [self.baseView addSubview:self.labName];
    [self.baseView addSubview:self.labPart];
    [self.baseView addSubview:self.labTel];
    [self.baseView addSubview:self.labEmail];
    [self.baseView addSubview:self.labHobby];
    
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.font = FONT_F13;
    lab1.textColor = COLOR_B2;
    lab1.text = @"手机号码";
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.font = FONT_F13;
    lab2.textColor = COLOR_B2;
    lab2.text = @"电子邮件";
    UILabel *lab3 = [[UILabel alloc] init];
    lab3.font = FONT_F13;
    lab3.textColor = COLOR_B2;
    lab3.text = @"个人爱好";
    [self.baseView addSubview:lab1];
    [self.baseView addSubview:lab2];
    [self.baseView addSubview:lab3];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(42);
        make.center.equalTo(self.contentView);
    }];
    
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(25);
        make.height.width.equalTo(@(50));
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgHeader.mas_centerY).offset(-5);
        make.left.equalTo(self.imgHeader.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.baseView).offset(-25);
    }];
    
    [self.labPart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgHeader.mas_centerY).offset(5);
        make.left.equalTo(self.imgHeader.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.baseView).offset(-25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgHeader.mas_bottom).offset(15);
        make.left.equalTo(self.baseView).offset(25);
        make.right.equalTo(self.baseView).offset(-25);
        make.height.equalTo(@1);
    }];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.equalTo(self.lineView);
    }];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(12);
        make.left.equalTo(self.lineView);
    }];
    
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab2.mas_bottom).offset(12);
        make.left.equalTo(self.lineView);
        make.bottom.equalTo(self.baseView).offset(-15);
    }];
    
    [self.labTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab1);
        make.left.equalTo(lab1.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.baseView).offset(-25);
    }];
    
    [self.labEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab2);
        make.left.equalTo(lab2.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.baseView).offset(-25);
    }];
    
    [self.labHobby mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab3);
        make.left.equalTo(lab3.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.baseView).offset(-25);
    }];
}

#pragma mark - public

- (void)loadData:(ContactMo *)model {
    if (_model != model) {
        _model = model;
    }
    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:[URLConfig domainUrl:[NSString stringWithFormat:@"%@%@", FILE_ORG_READ, _model.avatralUrl]]] placeholderImage:[UIImage imageNamed:@"avatar_def"]];
    self.labName.text = _model.name.length==0?@"暂无":_model.name;
    self.labPart.text = _model.duty.length==0?@"暂无":_model.duty;
    self.labTel.text = _model.phone.length==0?@"暂无":_model.phone;
    self.labEmail.text = _model.email.length==0?@"暂无":_model.email;
    self.labHobby.text = _model.favorite.length==0?@"暂无":_model.favorite;
}

#pragma mark - lazy

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 5;
        _baseView.layer.shadowColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:0.35].CGColor;
        _baseView.layer.shadowOffset = CGSizeMake(0,7);
        _baseView.layer.shadowOpacity = 1;
        _baseView.layer.shadowRadius = 12;
        _baseView.layer.borderWidth = 0.5;
        _baseView.layer.borderColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:0.5].CGColor;
    
    }
    return _baseView;
}

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] init];
    }
    return _imgHeader;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [[UILabel alloc] init];
        _labName.font = FONT_F17;
        _labName.textColor = COLOR_B1;
    }
    return _labName;
}

- (UILabel *)labPart {
    if (!_labPart) {
        _labPart = [[UILabel alloc] init];
        _labPart.font = FONT_F13;
        _labPart.textColor = COLOR_B2;
    }
    return _labPart;
}

- (UILabel *)labTel {
    if (!_labTel) {
        _labTel = [[UILabel alloc] init];
        _labTel.font = FONT_F13;
        _labTel.textColor = COLOR_B1;
    }
    return _labTel;
}

- (UILabel *)labEmail {
    if (!_labEmail) {
        _labEmail = [[UILabel alloc] init];
        _labEmail.font = FONT_F13;
        _labEmail.textColor = COLOR_B1;
    }
    return _labEmail;
}

- (UILabel *)labHobby {
    if (!_labHobby) {
        _labHobby = [[UILabel alloc] init];
        _labHobby.font = FONT_F13;
        _labHobby.textColor = COLOR_B1;
    }
    return _labHobby;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
