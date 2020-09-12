//
//  CreateBusinessCompetiorCell.m
//  Wangli
//
//  Created by yeqiang on 2019/1/16.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CreateBusinessCompetiorCell.h"

@interface CreateBusinessCompetiorCell ()

@property (nonatomic, strong) UIView *baseView;

@end

@implementation CreateBusinessCompetiorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_B4;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.contentView addSubview:self.labMember];
    [self.contentView addSubview:self.labName];
    [self.contentView addSubview:self.labRemark];
    [self.contentView addSubview:self.lineView];
    
    UILabel *memberNote = [self leftLabel];
    memberNote.text = @"友商名称";
    [self.contentView addSubview:memberNote];
    UILabel *nameNote = [self leftLabel];
    nameNote.text = @"友商负责人";
    [self.contentView addSubview:nameNote];
    UILabel *remarkNote = [self leftLabel];
    remarkNote.text = @"备注";
    [self.contentView addSubview:remarkNote];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [memberNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [nameNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(memberNote.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [remarkNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameNote.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [self.labMember mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.bottom.equalTo(memberNote);
        make.left.equalTo(memberNote.mas_right).offset(8);
        make.right.lessThanOrEqualTo(self.baseView).offset(-15);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.bottom.equalTo(nameNote);
        make.left.equalTo(nameNote.mas_right).offset(8);
        make.right.lessThanOrEqualTo(self.baseView).offset(-15);
    }];
    
    [self.labRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.bottom.equalTo(remarkNote);
        make.left.equalTo(remarkNote.mas_right).offset(8);
        make.right.lessThanOrEqualTo(self.baseView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.bottom.equalTo(self.baseView);
        make.height.equalTo(@0.5);
    }];
}

- (void)loadDataWith:(TrendsCompetitorMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labName.text =  [NSString stringWithFormat:@"%@ / %@", _model.principalName, _model.principalTel];
    self.labMember.text = _model.member.abbreviation;
    self.labRemark.text = _model.content.length==0?@"暂无":_model.content;
    [self layoutIfNeeded];
}

#pragma mark - lazy

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UILabel *)labMember {
    if (!_labMember) _labMember = [self rightLabel];
    return _labMember;
}

- (UILabel *)labName {
    if (!_labName) _labName = [self rightLabel];
    return _labName;
}

- (UILabel *)labRemark {
    if (!_labRemark) _labRemark = [self rightLabel];
    return _labRemark;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (UILabel *)leftLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B1;
    lab.font = FONT_F12;
    return lab;
}

- (UILabel *)rightLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B2;
    lab.font = FONT_F12;
    return lab;
}

@end
