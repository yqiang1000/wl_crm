//
//  VisitProcessCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "VisitProcessCell.h"

@implementation VisitProcessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labStep];
    [self.contentView addSubview:self.lineBottom];
    [self.contentView addSubview:self.lineTop];
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.labTitle];
    [self.baseView addSubview:self.labContent];
    [self.baseView addSubview:self.btnAddress];
    [self.baseView addSubview:self.btnCreate];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(50);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.labStep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(12);
        make.right.equalTo(self.baseView.mas_left).offset(-10);
        make.height.width.equalTo(@25.0);
    }];
    
    [self.lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.labStep.mas_top).offset(-5);
        make.centerX.equalTo(self.labStep);
        make.width.equalTo(@1.0);
    }];
    
    [self.lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labStep.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.labStep);
        make.width.equalTo(@1.0);
    }];
    
    [self.btnCreate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView);
        make.right.equalTo(self.baseView);
        make.width.height.equalTo(@45.0);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(17);
        make.left.equalTo(self.baseView).offset(16);
        make.right.lessThanOrEqualTo(self.btnCreate.mas_left);
    }];
    
    [self.btnAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.equalTo(self.labTitle);
        make.width.equalTo(@8.0);
        make.height.equalTo(@12.0);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.equalTo(self.btnAddress.mas_left);
        make.right.lessThanOrEqualTo(self.btnCreate).offset(-15);
        make.bottom.equalTo(self.baseView).offset(-17);
    }];
}

#pragma mark - public

- (void)loadData:(VisitProcessCellType)type content:(NSString *)content {
    _type = type;
    self.labStep.text = [NSString stringWithFormat:@"%ld", (NSInteger)_type + 1];
    if (type == VisitProcessCellOne) {
        self.labTitle.text = @"签到";
        self.btnAddress.hidden = NO;
        self.labContent.text = content.length == 0 ? @"暂无签到信息" : content;
        self.lineTop.hidden = YES;
        self.lineBottom.hidden = NO;
        [self.btnCreate setImage:[UIImage imageNamed:@"sign_in_business"] forState:UIControlStateNormal];
    } else if (type == VisitProcessCellTwo) {
        self.labTitle.text = @"沟通记录";
        self.btnAddress.hidden = YES;
        self.labContent.text = content.length == 0 ? @"暂无沟通记录" : content;
        self.lineTop.hidden = NO;
        self.lineBottom.hidden = NO;
        [self.btnCreate setImage:[UIImage imageNamed:content.length==0?@"add_business":@"编辑"] forState:UIControlStateNormal];
    } else if (type == VisitProcessCellThree) {
        self.labTitle.text = @"拜访报告";
        self.btnAddress.hidden = YES;
        self.labContent.text = content.length == 0 ? @"暂无报告" : content;
        self.lineTop.hidden = NO;
        self.lineBottom.hidden = YES;
        [self.btnCreate setImage:[UIImage imageNamed:content.length==0?@"add_business":@"编辑"] forState:UIControlStateNormal];
    }
    
    [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(_type == VisitProcessCellOne ? 20 : 0);
    }];
    
    [self.labContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnAddress.mas_left).offset(_type == VisitProcessCellOne ? 15 : 0);
    }];
    [self layoutIfNeeded];
}

#pragma mark - event

- (void)btnCreateClick:(UIButton *)sender {
    if (_visitProcessCellDelegate && [_visitProcessCellDelegate respondsToSelector:@selector(visitProcessCell:btnActionIndexPath:)]) {
        [_visitProcessCellDelegate visitProcessCell:self btnActionIndexPath:self.indexPath];
    }
}

#pragma mark - lazy

- (UILabel *)labStep {
    if (!_labStep) {
        _labStep = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _labStep.layer.mask = [Utils drawContentFrame:_labStep.bounds corners:UIRectCornerAllCorners cornerRadius:12.5];
        _labStep.font = FONT_F14;
        _labStep.textColor = COLOR_B4;
        _labStep.backgroundColor = COLOR_C1;
        _labStep.textAlignment = NSTextAlignmentCenter;
    }
    return _labStep;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_000000;
    }
    return _labTitle;
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [[UILabel alloc] init];
        _labContent.font = FONT_F13;
        _labContent.textColor = COLOR_B2;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

- (UIView *)lineTop {
    if (!_lineTop) {
        _lineTop = [UIView new];
        _lineTop.backgroundColor = COLOR_C1;
    }
    return _lineTop;
}

- (UIView *)lineBottom {
    if (!_lineBottom) {
        _lineBottom = [UIView new];
        _lineBottom.backgroundColor = COLOR_C1;
    }
    return _lineBottom;
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.shadowColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:0.35].CGColor;
        _baseView.layer.shadowOffset = CGSizeMake(0,2);
        _baseView.layer.shadowOpacity = 1;
        _baseView.layer.shadowRadius = 8;
        _baseView.layer.borderWidth = 0.5;
        _baseView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:0.5].CGColor;
        _baseView.layer.cornerRadius = 5;
    }
    return _baseView;
}

- (UIButton *)btnCreate {
    if (!_btnCreate) {
        _btnCreate = [[UIButton alloc] init];
        [_btnCreate addTarget:self action:@selector(btnCreateClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCreate;
}

- (UIButton *)btnAddress {
    if (!_btnAddress) {
        _btnAddress = [[UIButton alloc] init];
        [_btnAddress setImage:[UIImage imageNamed:@"location_business"] forState:UIControlStateNormal];
    }
    return _btnAddress;
}

@end
