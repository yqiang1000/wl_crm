//
//  MyPlanCompletionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/5/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyPlanCompletionCell.h"

@implementation MyPlanCompletionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labDay];
    [self.contentView addSubview:self.labYear];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labMsg];
    [self.contentView addSubview:self.labTotalSend];
    [self.contentView addSubview:self.labRealSend];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.lineView];
    
    [self.labDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.centerX.equalTo(self.labYear);
    }];
    
    [self.labYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-12);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.labYear.mas_right).offset(35);
    }];
    
    [self.labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(5);
        make.left.equalTo(self.labYear.mas_right).offset(35);
    }];
    
    [self.labTotalSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labMsg.mas_bottom).offset(10);
        make.left.equalTo(self.labMsg);
    }];
    
    [self.labRealSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTotalSend);
        make.left.equalTo(self.labTotalSend.mas_right).offset(13);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(@50);
        make.right.equalTo(self.contentView).offset(-17);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.width.equalTo(@0.5);
    }];
}

#pragma mark - public

- (void)loadDataWith:(id)model {
    self.labDay.text = @"12";
    self.labYear.text = @"2018";
    self.labTitle.text = @"凤翔纺织";
    self.labMsg.text = @"CG03/D1355";
    self.labTotalSend.text = @"10000KG";
    self.labRealSend.text = @"3000KG";
    self.progressView.progress = 0.3;
    CGSize size = [Utils getStringSize:self.labRealSend.text font:self.labRealSend.font];
    
//    [self.labRealSend mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(size.width+4));
//    }];
    [self layoutIfNeeded];
//    if (_model != model) {
//        _model = model;
//    }
//    self.labDay.text = _model.dayStr;
//    self.labYear.text = _model.yearStr;
//    self.labTitle.text = _model.title;
//    self.labFrom.text = _model.from;
//    self.labTotalSend.text = _model.totalSend;
//    self.labRealSend.text = _model.realSend;
//    self.progressView.progress = [_model.present floatValue];
//    CGSize size = [Utils getStringSize:self.labRealSend.text font:self.labRealSend.font];
//
//    [self.labRealSend mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(size.width+4));
//    }];
//    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UILabel *)labDay {
    if (!_labDay) {
        _labDay = [[UILabel alloc] init];
        _labDay.font = FONT_F30;
        _labDay.textColor = COLOR_B1;
    }
    return _labDay;
}

- (UILabel *)labYear {
    if (!_labYear) {
        _labYear = [[UILabel alloc] init];
        _labYear.font = FONT_F12;
        _labYear.textColor = COLOR_B3;
    }
    return _labYear;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F17;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UILabel *)labMsg {
    if (!_labMsg) {
        _labMsg = [[UILabel alloc] init];
        _labMsg.font = FONT_F13;
        _labMsg.textColor = COLOR_B2;
    }
    return _labMsg;
}

- (UILabel *)labTotalSend {
    if (!_labTotalSend) {
        _labTotalSend = [[UILabel alloc] init];
        _labTotalSend.font = FONT_F14;
        _labTotalSend.textColor = COLOR_C1;
    }
    return _labTotalSend;
}

- (UILabel *)labRealSend {
    if (!_labRealSend) {
        _labRealSend = [[UILabel alloc] init];
        _labRealSend.font = FONT_F14;
        _labRealSend.textColor = COLOR_C2;
    }
    return _labRealSend;
}

- (UAProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UAProgressView alloc] init];
        _progressView.tintColor = COLOR_C1;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.textColor = COLOR_B1;
        label.font = FONT_F13;
        label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
        _progressView.centralView = label;
        _progressView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
            [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
        };
    }
    return _progressView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}
@end
