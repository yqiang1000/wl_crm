//
//  TrendsContractCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsContractCell.h"

@interface TrendsContractCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation TrendsContractCell

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
    [self.contentView addSubview:self.imgIcon];
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labMonth];
    [self.contentView addSubview:self.labYear];
    [self.contentView addSubview:self.labTotalSend];
    [self.contentView addSubview:self.labRealSend];
    [self.contentView addSubview:self.labTotalNote];
    [self.contentView addSubview:self.labRealNote];
//    [self.contentView addSubview:self.imgArrow];
    [self.contentView addSubview:self.progressView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(38);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.greaterThanOrEqualTo(@15.0);
        make.top.equalTo(self.baseView).offset(10);
    }];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.height.width.equalTo(@15.0);
        make.centerY.equalTo(self.labTitle);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.bottom.equalTo(self.baseView).offset(-72);
        make.left.equalTo(self.baseView);
        make.right.equalTo(self.baseView);
        make.height.equalTo(@0.5);
    }];
    
    [self.labMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.centerX.equalTo(self.labYear);
    }];
    
    [self.labYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView).offset(-14);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [self.labRealNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.baseView).offset(IS_IPHONE5?80:100);
    }];
    
    [self.labTotalNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.labRealNote);
        make.left.equalTo(self.labRealNote.mas_right).offset(IS_IPHONE5?30:49);
    }];
    
    [self.labTotalSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(17);
        make.centerX.equalTo(self.labTotalNote);
    }];
    
    [self.labRealSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTotalSend);
        make.centerX.equalTo(self.labRealNote);
    }];
    
//    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.baseView).offset(-15);
//        make.centerY.equalTo(self.baseView);
//    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.imgArrow);
        make.height.width.equalTo(@50.0);
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
}

#pragma mark - public

- (void)loadDataWith:(TrendsContractMo *)model {
    if (_model != model) {
        _model = model;
    }
    NSString *year = [_model.createDate substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [_model.createDate substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [_model.createDate substringWithRange:NSMakeRange(8, 2)];
    self.labYear.text = [NSString stringWithFormat:@"%@/%@", year, month];
    self.labMonth.text = day;
    if ([_model.materialDesp isEqualToString:@"无物料"] || _model.materialDesp.length == 0) {
        self.labTitle.text = [NSString stringWithFormat:@"%@ | %@", _model.memberName, _model.crmNumber];
        self.labTotalSend.text = @"0";
        self.labRealSend.text = @"0";
    } else {
        self.labTitle.text = [NSString stringWithFormat:@"%@ | %@ | %@", _model.memberName, _model.materialDesp, _model.crmNumber];
        self.labTotalSend.text = _model.quantity;
        self.labRealSend.text = _model.actualQuantity;
    }
    self.labTotalNote.text = [NSString stringWithFormat:@"合同量(%@)", _model.unit.length==0?@"MW":_model.unit];
    self.labRealNote.text = [NSString stringWithFormat:@"实发(%@)", _model.unit.length==0?@"MW":_model.unit];
    CGFloat progress = [_model.rate floatValue] / 100.0;
    self.progressView.progress = progress;
    [((UILabel *)self.progressView.centralView) setText:[NSString stringWithFormat:@"%2.0f%%",  progress * 100]];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.image = [UIImage imageNamed:@"dynamic_contract_company"];
    }
    return _imgIcon;
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
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B1;
        _labTitle.numberOfLines = 0;
    }
    return _labTitle;
}

- (UILabel *)labTotalNote {
    if (!_labTotalNote) {
        _labTotalNote = [[UILabel alloc] init];
        _labTotalNote.font = FONT_F12;
        _labTotalNote.textColor = COLOR_B3;
        _labTotalNote.text = @"计划(MW)";
    }
    return _labTotalNote;
}

- (UILabel *)labRealNote {
    if (!_labRealNote) {
        _labRealNote = [[UILabel alloc] init];
        _labRealNote.font = FONT_F12;
        _labRealNote.textColor = COLOR_B3;
        _labRealNote.text = @"实发(MW)";
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
        _labRealSend.textColor = COLOR_FF6A67;
    }
    return _labRealSend;
}

//- (UIImageView *)imgArrow {
//    if (!_imgArrow) {
//        _imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
//    }
//    return _imgArrow;
//}

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
