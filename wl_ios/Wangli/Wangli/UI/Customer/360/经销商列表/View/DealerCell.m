//
//  DealerCell.m
//  Wangli
//
//  Created by yeqiang on 2019/3/20.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "DealerCell.h"

@interface DealerCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labType;
@property (nonatomic, strong) UILabel *labMsg;
@property (nonatomic, strong) UILabel *labAmount;
@property (nonatomic, strong) UILabel *labTotal;

@end


@implementation DealerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_B0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.imgIcon];
    [self.baseView addSubview:self.labName];
    [self.baseView addSubview:self.labType];
    [self.baseView addSubview:self.labMsg];
    [self.baseView addSubview:self.labAmount];
    [self.baseView addSubview:self.labTotal];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@69.0);
    }];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(13);
        make.height.equalTo(@15.0);
        make.width.equalTo(@14.0);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgIcon);
        make.left.equalTo(self.imgIcon.mas_right).offset(5);
    }];
    
    [self.labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labName);
        make.top.equalTo(self.imgIcon.mas_bottom).offset(12);
    }];
    
    [self.labType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labName);
        make.left.equalTo(self.labName.mas_right).offset(10);
        make.height.equalTo(@18.0);
        make.width.equalTo(@36.0);
    }];
    
    [self.labAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgIcon);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.labTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labAmount.mas_bottom).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
}

- (void)loadData:(DealerMo *)model {
    if (_model != model) _model = model;
    self.labName.text = _model.member[@"orgName"];
    self.labType.text = [self typeString:_model.dealerType];
    NSString *msg = @"";
    NSString *provinceName = _model.province[@"provinceName"];
    if (provinceName.length > 0) msg = [msg stringByAppendingString:provinceName];
    if (_model.brandName.length > 0) {
        if (msg.length > 0) msg = [msg stringByAppendingString:@" | "];
        msg = [msg stringByAppendingString:_model.brandName];
    }
    
    if (_model.dealerPlanCode.length > 0) {
        if (msg.length > 0) msg = [msg stringByAppendingString:@" | "];
        msg = [msg stringByAppendingString:_model.dealerPlanCode];
    }
    self.labMsg.text = msg;
    self.labAmount.text = [Utils getPriceFrom:_model.totalForTheWholeYear];
    
//    CGSize size = [Utils getStringSize:self.labType.text font:self.labType.font];
//    [self.labType mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(size.width+20));
//    }];
//
//    [self layoutIfNeeded];
}
//0:零售 1 工程 2 部分
- (NSString *)typeString:(NSInteger)type {
    if (type == 0) {
        return @"零售";
    } else if (type == 1) {
        return @"工程";
    } else if (type == 2) {
        return @"部分";
    }
    return @"";
}

#pragma mark - lazy

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-30, 90)];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 5;
        _baseView.layer.shadowColor = [[UIColor alloc] initWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:0.6].CGColor;
        _baseView.layer.shadowOffset = CGSizeMake(0, 4);
        _baseView.layer.shadowOpacity = 0.5;
        _baseView.layer.shadowRadius = 5;
    }
    return _baseView;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.image = [UIImage imageNamed:@"daeler"];
    }
    return _imgIcon;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [UILabel new];
        _labName.font = FONT_F16;
        _labName.textColor = COLOR_B2;
    }
    return _labName;
}

- (UILabel *)labType {
    if (!_labType) {
        _labType = [UILabel new];
        _labType.backgroundColor = COLOR_F2F3F5;
        _labType.textColor = COLOR_B2;
        _labType.font = FONT_F12;
        _labType.layer.cornerRadius = 3.0;
        _labType.clipsToBounds = YES;
        _labType.textAlignment = NSTextAlignmentCenter;
    }
    return _labType;
}

- (UILabel *)labMsg {
    if (!_labMsg) {
        _labMsg = [UILabel new];
        _labMsg.font = FONT_F12;
        _labMsg.textColor = COLOR_B3;
    }
    return _labMsg;
}

- (UILabel *)labAmount {
    if (!_labAmount) {
        _labAmount = [UILabel new];
        _labAmount.textColor = COLOR_FF6A67;
        _labAmount.font = FONT_F18;
    }
    return _labAmount;
}

- (UILabel *)labTotal {
    if (!_labTotal) {
        _labTotal = [UILabel new];
        _labTotal.textColor = COLOR_B3;
        _labTotal.font = FONT_F12;
        _labTotal.text = @"全年合计";
    }
    return _labTotal;
}

@end
