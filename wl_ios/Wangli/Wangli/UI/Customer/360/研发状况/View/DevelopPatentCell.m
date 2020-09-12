//
//  DevelopPatentCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "DevelopPatentCell.h"

@interface DevelopPatentCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labType;
@property (nonatomic, strong) UILabel *labState;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation DevelopPatentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.backgroundColor = COLOR_B0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.labTitle];
    UIView *viewType = [self itemPartKey:@"专利类型:" labValue:self.labType];
    UIView *viewState = [self itemPartKey:@"专利状态:" labValue:self.labState];
    UIView *viewTime = [self itemPartKey:@"申请日期:" labValue:self.labTime];
    [self.baseView addSubview:viewType];
    [self.baseView addSubview:viewState];
    [self.baseView addSubview:viewTime];
    [self.baseView addSubview:self.lineView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [viewType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [viewState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewType);
        make.left.equalTo(self.baseView.mas_centerX).offset(15);
    }];
    
    [viewTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewType.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.bottom.equalTo(self.baseView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)itemPartKey:(NSString *)key labValue:(id)labValue {
    UIView *bottomView = [UIView new];
    UILabel *labKey = [self getNewLabel];
    labKey.text = key;
    [bottomView addSubview:labKey];
    [bottomView addSubview:labValue];
    [labKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(bottomView);
        make.bottom.lessThanOrEqualTo(bottomView);
    }];
    [labValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labKey);
        make.left.equalTo(labKey.mas_right).offset(3);
        make.right.lessThanOrEqualTo(bottomView);
    }];
    return bottomView;
}

#pragma mark - public

- (void)loadData:(DevelopPatentMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = _model.name;
    self.labTime.text = _model.applyDate;
    self.labType.text = _model.businessTypeValue;
    self.labState.text = _model.statusValue;
    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.textColor = COLOR_B1;
        _labTitle.font = FONT_F15;
    }
    return _labTitle;
}

- (UILabel *)labType {
    if (!_labType) _labType = [self getNewLabel];
    return _labType;
}

- (UILabel *)labTime {
    if (!_labTime) _labTime = [self getNewLabel];
    return _labTime;
}

- (UILabel *)labState {
    if (!_labState) _labState = [self getNewLabel];
    return _labState;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    lab.numberOfLines = 0;
    return lab;
}

@end
