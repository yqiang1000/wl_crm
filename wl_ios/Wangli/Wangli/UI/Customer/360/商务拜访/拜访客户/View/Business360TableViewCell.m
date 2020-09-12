//
//  Business360TableViewCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "Business360TableViewCell.h"

@interface Business360TableViewCell ()

@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UILabel *labMsg;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UILabel *labState;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation Business360TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labMsg];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.labState];
    [self.contentView addSubview:self.pointView];
    [self.contentView addSubview:self.lineView];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@50.0);
        make.height.equalTo(@24.0);
    }];
    
    [self.labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.labState.mas_left).offset(-15);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.labMsg).offset(10);
        make.right.lessThanOrEqualTo(self.labState.mas_left).offset(-15);
    }];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTime);
        make.left.equalTo(self.labMsg).offset(1);
        make.width.height.equalTo(@4.0);
    }];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTime);
        make.left.equalTo(self.labMsg).offset(1);
        make.width.height.equalTo(@4.0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.labMsg);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - public

- (void)loadData:(BusinessVisitActivityMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labMsg.text = _model.purpose;
    
    NSString *beginStr = @"暂无时间";
    NSString *endStr = @"暂无时间";
    if (_model.beginDate.length == @"2019-01-01 16:07:00".length) {
        beginStr = [_model.beginDate substringWithRange:NSMakeRange(_model.beginDate.length-8, 8)];
    }
    if (_model.endDate.length == @"2019-01-01 16:07:00".length) {
        endStr = [_model.endDate substringWithRange:NSMakeRange(_model.endDate.length-8, 8)];
    }
    self.labTime.text = [NSString stringWithFormat:@"%@-%@", beginStr, endStr];

    //  已完成
    if ([_model.status isEqualToString:@"end"]) {
        self.pointView.backgroundColor = COLOR_A4A4A4;
        self.labMsg.textColor = COLOR_B2;
        self.labTime.textColor = COLOR_B3;
        self.labState.textColor = COLOR_B2;
        self.labState.backgroundColor = COLOR_F2F3F5;
        self.labState.text = @"已完成"; // _model.statusValue;
    }
    // 未完成
    else {
        self.pointView.backgroundColor = COLOR_1995D6;
        self.labMsg.textColor = COLOR_B1;
        self.labTime.textColor = COLOR_B2;
        self.labState.textColor = COLOR_EC675D;
        self.labState.backgroundColor = COLOR_B0;
        self.labState.text = @"未完成"; //_model.statusValue;
    }
}

- (void)loadReceptionData:(BusinessReceptionMo *)receptionModel {
    if (_receptionModel != receptionModel) {
        _receptionModel = receptionModel;
    }
    self.labMsg.text = _receptionModel.title;
    
    NSString *beginStr = @"暂无时间";
    NSString *endStr = @"暂无时间";
    if (_receptionModel.beginDate.length == @"2019-01-01 16:07:00".length) {
        beginStr = [_receptionModel.beginDate substringWithRange:NSMakeRange(_receptionModel.beginDate.length-8, 8)];
    }
    if (_receptionModel.endDate.length == @"2019-01-01 16:07:00".length) {
        endStr = [_receptionModel.endDate substringWithRange:NSMakeRange(_receptionModel.endDate.length-8, 8)];
    }
    self.labTime.text = [NSString stringWithFormat:@"%@-%@", beginStr, endStr];
    
    //  已完成
    if ([_receptionModel.receptionStatusKey isEqualToString:@"have_completed"]) {
        self.pointView.backgroundColor = COLOR_A4A4A4;
        self.labMsg.textColor = COLOR_B2;
        self.labTime.textColor = COLOR_B3;
        self.labState.textColor = COLOR_B2;
        self.labState.backgroundColor = COLOR_F2F3F5;
        self.labState.text = @"已完成"; // _receptionModel.receptionStatusValue;
    }
    // 已取消
    else if ([_receptionModel.receptionStatusKey isEqualToString:@"have_canceled"]) {
        self.pointView.backgroundColor = COLOR_1995D6;
        self.labMsg.textColor = COLOR_B1;
        self.labTime.textColor = COLOR_B2;
        self.labState.textColor = COLOR_EC675D;
        self.labState.backgroundColor = COLOR_B0;
        self.labState.text = @"已取消"; //_receptionModel.receptionStatusValue;
    }
    // 未完成
    else {
        self.pointView.backgroundColor = COLOR_1995D6;
        self.labMsg.textColor = COLOR_B1;
        self.labTime.textColor = COLOR_B2;
        self.labState.textColor = COLOR_EC675D;
        self.labState.backgroundColor = COLOR_B0;
        self.labState.text = @"未完成"; //_receptionModel.receptionStatusValue;
    }
}

#pragma mark - lazy

- (UILabel *)labMsg {
    if (!_labMsg) {
        _labMsg = [[UILabel alloc] init];
        _labMsg.font = FONT_F14;
        _labMsg.textColor = COLOR_B2;
    }
    return _labMsg;
}

- (UILabel *)labState {
    if (!_labState) {
        _labState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
        _labState.layer.mask = [Utils drawContentFrame:_labState.bounds corners:UIRectCornerAllCorners cornerRadius:3];
        _labState.font = FONT_F12;
        _labState.textColor = COLOR_B3;
        _labState.textAlignment = NSTextAlignmentCenter;
    }
    return _labState;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.font = FONT_F13;
        _labTime.textColor = COLOR_B3;
    }
    return _labTime;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        _pointView.layer.mask = [Utils drawContentFrame:_pointView.bounds corners:UIRectCornerAllCorners cornerRadius:2];
    }
    return _pointView;
}

@end
