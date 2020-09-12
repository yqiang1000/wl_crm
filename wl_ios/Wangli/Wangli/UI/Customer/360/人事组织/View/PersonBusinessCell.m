//
//  PersonBusinessCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PersonBusinessCell.h"

@interface PersonBusinessCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labContact;
@property (nonatomic, strong) UILabel *labDate;

@end

@implementation PersonBusinessCell

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
    [self.contentView addSubview:self.labContact];
    [self.contentView addSubview:self.labDate];
    [self.contentView addSubview:self.lineView];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.labContact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.right.equalTo(self.labTitle);
    }];
    
    [self.labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContact.mas_bottom).offset(10);
        make.left.right.equalTo(self.labContact);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.labTitle);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - public

- (void)loadData:(LinkManBusinessMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = _model.title;
    self.labContact.text = _model.customerContact;
    self.labDate.text = [Utils changeDate:_model.createdDate formatterStr:nil];
    [self layoutIfNeeded];
}

#pragma mark - lazy

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UILabel *)labContact {
    if (!_labContact) {
        _labContact = [[UILabel alloc] init];
        _labContact.font = FONT_F13;
        _labContact.textColor = COLOR_B2;
    }
    return _labContact;
}

- (UILabel *)labDate {
    if (!_labDate) {
        _labDate = [[UILabel alloc] init];
        _labDate.font = FONT_F13;
        _labDate.textColor = COLOR_B2;
    }
    return _labDate;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

@end
