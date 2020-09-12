//
//  TravelTableViewCell.m
//  Wangli
//
//  Created by yeqiang on 2019/3/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TravelTableViewCell.h"

@interface TravelTableViewCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imgArr;
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) UILabel *labAddress;
@property (nonatomic, strong) UILabel *labStatus;
@property (nonatomic, strong) UILabel *labFrom;

@end

@implementation TravelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_B0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.imgArr];
    [self.baseView addSubview:self.labDate];
    [self.baseView addSubview:self.labAddress];
    [self.baseView addSubview:self.labStatus];
    [self.baseView addSubview:self.labFrom];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@90.0);
    }];
    
    [self.imgArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(13);
        make.height.equalTo(@13.0);
        make.width.equalTo(@15.0);
    }];
    
    [self.labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgArr);
        make.left.equalTo(self.imgArr.mas_right).offset(7);
    }];
    
    [self.labStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgArr);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@24.0);
    }];
    
    [self.labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labDate.mas_bottom).offset(9);
        make.left.equalTo(self.labDate);
    }];
    
    [self.labFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labAddress.mas_bottom).offset(7);
        make.left.equalTo(self.labDate);
    }];
}

- (void)loadData:(TravelMo *)model {
    if (_model != model) _model = model;
    self.labDate.text = [NSString stringWithFormat:@"%@ %@", _model.travelDate, _model.placeArrival];
    self.labAddress.text = _model.title;
    self.labStatus.text = _model.travelStatusDesp;
    self.labFrom.text = [NSString stringWithFormat:@"出发地:%@ | 到达地:%@", _model.placeDeparture, _model.placeArrival];
    
    CGSize size = [Utils getStringSize:self.labStatus.text font:self.labStatus.font];
    [self.labStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width+20));
    }];
    
    [self layoutIfNeeded];
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

- (UIImageView *)imgArr {
    if (!_imgArr) {
        _imgArr = [[UIImageView alloc] init];
        _imgArr.image = [UIImage imageNamed:@"business_travel_icon"];
    }
    return _imgArr;
}

- (UILabel *)labDate {
    if (!_labDate) {
        _labDate = [UILabel new];
        _labDate.font = FONT_F15;
        _labDate.textColor = COLOR_B2;
    }
    return _labDate;
}

- (UILabel *)labAddress {
    if (!_labAddress) {
        _labAddress = [UILabel new];
        _labAddress.textColor = COLOR_000000;
        _labAddress.font = FONT_F16;
    }
    return _labAddress;
}

- (UILabel *)labStatus {
    if (!_labStatus) {
        _labStatus = [UILabel new];
        _labStatus.font = FONT_F12;
        _labStatus.textColor = COLOR_B2;
        _labStatus.backgroundColor = COLOR_F2F3F5;
        _labStatus.textAlignment = NSTextAlignmentCenter;
        _labStatus.layer.cornerRadius = 3.0;
        _labStatus.clipsToBounds = YES;
    }
    return _labStatus;
}

- (UILabel *)labFrom {
    if (!_labFrom) {
        _labFrom = [UILabel new];
        _labFrom.textColor = COLOR_B2;
        _labFrom.font = FONT_F13;
    }
    return _labFrom;
}

@end
