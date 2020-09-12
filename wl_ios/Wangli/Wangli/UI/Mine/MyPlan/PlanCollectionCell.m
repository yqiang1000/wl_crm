
//
//  PlanCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/7/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PlanCollectionCell.h"

@interface PlanCollectionCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation PlanCollectionCell

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
    
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.lineView];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labMonth];
    [self.contentView addSubview:self.labYear];
    [self.contentView addSubview:self.labTotalSend];
    [self.contentView addSubview:self.labRealSend];
    [self.contentView addSubview:self.labTotalNote];
    [self.contentView addSubview:self.labRealNote];
    [self.contentView addSubview:self.imgArrow];
    [self.contentView addSubview:self.progressView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.right.left.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(33);
        make.right.left.equalTo(self.baseView);
        make.height.equalTo(@0.5);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.centerY.equalTo(self.baseView.mas_top).offset(16);
    }];
    
    [self.labMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(14);
        make.centerX.equalTo(self.labYear);
    }];
    
    [self.labYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-14);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.labTotalNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-17);
        make.left.equalTo(self.baseView).offset(IS_IPHONE5?70:90);
    }];
    
    [self.labRealNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.labTotalNote);
        make.left.equalTo(self.labTotalNote.mas_right).offset(IS_IPHONE5?30:49);
    }];
    
    [self.labTotalSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(17);
        make.left.equalTo(self.labTotalNote);
    }];
    
    [self.labRealSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTotalSend);
        make.left.equalTo(self.labRealNote);
    }];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView).offset(-15);
        make.centerY.equalTo(self.baseView.mas_bottom).offset(-36.5);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgArrow);
        make.height.width.equalTo(@50);
        make.right.equalTo(self.imgArrow.mas_left).offset(-10);
    }];
}

#pragma mark - public

- (void)loadDataWith:(DealPlanCollectionMo *)model orgName:(NSString *)orgName {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = orgName;
    self.labMonth.text = _model.month;
    self.labYear.text = _model.year;
    self.labTotalSend.text = [Utils getKGToTon:_model.totalPlanQuantity];
    self.labRealSend.text = [Utils getKGToTon:_model.actualQuantity];
    if (_model.actualShipNumber - 0 < 0.0001) {
        self.progressView.progress = 0;
        [((UILabel *)self.progressView.centralView) setText:[NSString stringWithFormat:@"%2.0f%%", 0.0]];
    } else {
        self.progressView.progress = _model.actualShipNumber;
        [((UILabel *)self.progressView.centralView) setText:[NSString stringWithFormat:@"%2.0f%%", _model.actualShipNumber * 100]];
    }
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UILabel *)labMonth {
    if (!_labMonth) {
        _labMonth = [[UILabel alloc] init];
        _labMonth.font = FONT_F30;
        _labMonth.textColor = COLOR_B1;
    }
    return _labMonth;
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
        _labTitle.font = FONT_F14;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UILabel *)labTotalNote {
    if (!_labTotalNote) {
        _labTotalNote = [[UILabel alloc] init];
        _labTotalNote.font = FONT_F12;
        _labTotalNote.textColor = COLOR_B3;
        _labTotalNote.text = @"计划(吨)";
    }
    return _labTotalNote;
}

- (UILabel *)labRealNote {
    if (!_labRealNote) {
        _labRealNote = [[UILabel alloc] init];
        _labRealNote.font = FONT_F12;
        _labRealNote.textColor = COLOR_B3;
        _labRealNote.text = @"实发(吨)";
    }
    return _labRealNote;
}

- (UILabel *)labTotalSend {
    if (!_labTotalSend) {
        _labTotalSend = [[UILabel alloc] init];
        _labTotalSend.font = FONT_F17;
        _labTotalSend.textColor = COLOR_B1;
    }
    return _labTotalSend;
}

- (UILabel *)labRealSend {
    if (!_labRealSend) {
        _labRealSend = [[UILabel alloc] init];
        _labRealSend.font = FONT_F17;
        _labRealSend.textColor = COLOR_ED746C;
    }
    return _labRealSend;
}

- (UIImageView *)imgArrow {
    if (!_imgArrow) {
        _imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    }
    return _imgArrow;
}

- (UAProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UAProgressView alloc] init];
        _progressView.tintColor = COLOR_C1;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.textColor = COLOR_B1;
        label.font = FONT_F13;
        label.text = @"0%";
        label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
        _progressView.centralView = label;
        _progressView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
            //            [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
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
