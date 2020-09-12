//
//  RetailPageCell.m
//  Wangli
//
//  Created by yeqiang on 2019/4/22.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "RetailPageCell.h"

@implementation RetailPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.contentView addSubview:self.imgIcon];
    [self.contentView addSubview:self.lineView];
    
    UIView *topView = [self mutableKey:self.labName line:@" | " value:self.labTime];
    UIView *tlView = [self mutableKey:self.labKTL line:@" | " value:self.labTL];
    UIView *trView = [self mutableKey:self.labKTR line:@" | " value:self.labTR];
    UIView *blView = [self mutableKey:self.labKBL line:@" | " value:self.labBL];
    UIView *brView = [self mutableKey:self.labKBR line:@" | " value:self.labBR];
    
    [self.contentView addSubview:topView];
    [self.contentView addSubview:tlView];
    [self.contentView addSubview:trView];
    [self.contentView addSubview:blView];
    [self.contentView addSubview:brView];
    
    [self.contentView addSubview:self.progressView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@105.0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(35);
        make.left.right.equalTo(self.baseView);
        make.height.equalTo(@0.5);
    }];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.centerY.equalTo(self.baseView.mas_top).offset(17.5);
        make.height.equalTo(@16.0);
        make.width.equalTo(@13.0);
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgIcon.mas_right).offset(6);
        make.centerY.equalTo(self.imgIcon);
        make.right.lessThanOrEqualTo(self.baseView).offset(-15);
    }];
    
    [tlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
    }];
    
    [trView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(SCREEN_RATE*160);
        make.top.equalTo(tlView);
    }];
    
    [blView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(15);
        make.bottom.equalTo(self.baseView).offset(-15);
    }];
    
    [brView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(SCREEN_RATE*160);
        make.top.equalTo(blView);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@50.0);
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
}

- (UIView *)mutableKey:(UILabel *)key line:(NSString *)line value:(UILabel *)value {
    UIView *muView = [UIView new];
    UILabel *labLine = [[UILabel alloc] init];
    labLine.text = line;
    labLine.font = FONT_F13;
    labLine.textColor = COLOR_B3;
    [muView addSubview:key];
    [muView addSubview:labLine];
    [muView addSubview:value];
    
    [key mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(muView);
        make.left.equalTo(muView);
        make.top.equalTo(muView);
    }];
    
    [labLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(muView);
        make.left.equalTo(key.mas_right);
        make.top.equalTo(muView);
    }];
    
    [value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(muView);
        make.left.equalTo(labLine.mas_right);
        make.top.equalTo(muView);
        make.right.equalTo(muView);
    }];
    
    return muView;
}

- (void)rateProgress:(CGFloat)progress {
    if (progress < 0.0001) {
        self.progressView.progress = 0;
        [((UILabel *)self.progressView.centralView) setText:[NSString stringWithFormat:@"%2.0f%%", 0.0]];
    } else {
        self.progressView.progress = progress / 100.0;
        [((UILabel *)self.progressView.centralView) setText:[Utils getPriceFrom:progress]];
    }
}

#pragma mark - lazy

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.image = [UIImage imageNamed:@"work_plan_business_person"];
    }
    return _imgIcon;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = FONT_F13;
    lab.textColor = COLOR_B2;
    return lab;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [self getNewLabel];
        _labName.textColor = COLOR_B1;
    }
    return _labName;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [self getNewLabel];
        _labTime.textColor = COLOR_B1;
    }
    return _labTime;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}


- (UILabel *)labKTL {
    if (!_labKTL) _labKTL = [self getNewLabel];
    return _labKTL;
}

- (UILabel *)labKTR {
    if (!_labKTR) _labKTR = [self getNewLabel];
    return _labKTR;
}

- (UILabel *)labKBL {
    if (!_labKBL) _labKBL = [self getNewLabel];
    return _labKBL;
}

- (UILabel *)labKBR {
    if (!_labKBR) _labKBR = [self getNewLabel];
    return _labKBR;
}

- (UILabel *)labTL {
    if (!_labTL) {
        _labTL = [self getNewLabel];
        _labTL.textColor = COLOR_B1;
    }
    return _labTL;
}

- (UILabel *)labTR {
    if (!_labTR) {
        _labTR = [self getNewLabel];
        _labTR.textColor = COLOR_B1;
    }
    return _labTR;
}

- (UILabel *)labBL {
    if (!_labBL) {
        _labBL = [self getNewLabel];
        _labBL.textColor = COLOR_B1;
    }
    return _labBL;
}

- (UILabel *)labBR {
    if (!_labBR) {
        _labBR = [self getNewLabel];
        _labBR.textColor = COLOR_FF6A67;
    }
    return _labBR;
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
        };
    }
    return _progressView;
}

@end
