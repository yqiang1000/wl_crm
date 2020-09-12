//
//  CostTypeAllCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CostTypeAllCell.h"

@interface  CostTypeAllCell ()

@end

@implementation CostTypeAllCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_B4;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labMsg];
    [self.contentView addSubview:self.labPerson];
    [self.contentView addSubview:self.labDate];
    [self.contentView addSubview:self.labState];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.labState.mas_left).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@0.5);
    }];
    
    [self.labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.equalTo(self.labTitle);
    }];
    
    [self.labPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labMsg.mas_bottom).offset(8);
        make.left.equalTo(self.labTitle);
    }];
    
    [self.labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labPerson);
        make.left.equalTo(self.labPerson.mas_right).offset(30);
    }];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(15);
    }];
}

#pragma mark - public

- (void)loadData:(CoastAllMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = @"费用报销流程2018-11-01";
    self.labMsg.text = @"报销金额：￥320";
    self.labPerson.text = @"报销人：周晓峰";
    self.labDate.text = @"报销日期：2018-11-01";
    self.labState.text = @"OA审批中";
}

#pragma mark - setter getter

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UILabel *)labState {
    if (!_labState) {
        _labState = [[UILabel alloc] init];
        _labState.font = FONT_F13;
        _labState.textColor = COLOR_C3;
    }
    return _labState;
}

- (UILabel *)labMsg {
    if (!_labMsg) _labMsg = [self getNewLabel];
    return _labMsg;
}

- (UILabel *)labPerson {
    if (!_labPerson) _labPerson = [self getNewLabel];
    return _labPerson;
}

- (UILabel *)labDate {
    if (!_labDate) _labDate = [self getNewLabel];
    return _labDate;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    lab.numberOfLines = 0;
    return lab;
}


@end
