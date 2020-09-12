//
//  StoreCell.m
//  Wangli
//
//  Created by yeqiang on 2019/3/20.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "StoreCell.h"

@interface StoreCell ()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labStore;
@property (nonatomic, strong) UILabel *labNumber;
@property (nonatomic, strong) UILabel *labType;
@property (nonatomic, strong) UILabel *labName;

@end

@implementation StoreCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgIcon];
    [self.contentView addSubview:self.labStore];
    [self.contentView addSubview:self.labNumber];
    [self.contentView addSubview:self.labType];
    [self.contentView addSubview:self.labName];
    [self.contentView addSubview:self.lineView];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@15.0);
    }];
    
    [self.labStore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(35);
    }];
    
    [self.labNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labStore);
        make.left.equalTo(self.labStore.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.labType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labStore.mas_bottom).offset(9);
        make.left.equalTo(self.labStore);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labType.mas_bottom).offset(7);
        make.left.equalTo(self.labStore);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}


- (void)loadData:(StoreMo *)model {
    if (_model != model) _model = model;
    
    
    NSString *storeStr = @"";
    NSString *provinceName = _model.province[@"provinceName"];
    NSString *cityName = _model.city[@"cityName"];
    NSString *areaName = _model.area[@"areaName"];
    if (provinceName.length > 0) storeStr = [storeStr stringByAppendingString:provinceName];
    if (cityName.length > 0) {
        if (storeStr.length > 0) storeStr = [storeStr stringByAppendingString:@"/"];
        storeStr = [storeStr stringByAppendingString:cityName];
    }
    if (areaName.length > 0) {
        if (storeStr.length > 0) storeStr = [storeStr stringByAppendingString:@"/"];
        storeStr = [storeStr stringByAppendingString:areaName];
        storeStr = [storeStr stringByAppendingString:@"专卖店"];
    }
    self.labStore.text = storeStr.length == 0?@"暂无专卖店":storeStr;
    if (_model.deleted) {
        self.labNumber.text = [NSString stringWithFormat:@"%@ [已删除]", _model.storeName];
    } else {
        self.labNumber.text = [NSString stringWithFormat:@"%@ [正常]", _model.storeName];
    }
    
    NSString *orgName = _model.customer[@"orgName"];
    if (orgName.length > 0) {
        self.labType.text = [NSString stringWithFormat:@"%@ | %@", orgName, [_model.createdDate substringToIndex:10]];
    } else {
        self.labType.text = [_model.createdDate substringToIndex:10];
    }
    NSString *nameStr = @"";
    if (_model.createByName.length > 0) nameStr = [nameStr stringByAppendingString:_model.createByName];
    if (_model.contactNumber.length > 0) {
        if (nameStr.length > 0) nameStr = [nameStr stringByAppendingString:@" | "];
        nameStr = [nameStr stringByAppendingString:_model.contactNumber];
    }
    self.labName.text = nameStr.length == 0? @"暂无联系人":nameStr;
}

#pragma mark - lazy

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.image = [UIImage imageNamed:@"shop_information_icon"];
    }
    return _imgIcon;
}

- (UILabel *)labStore {
    if (!_labStore) {
        _labStore = [UILabel new];
        _labStore.textColor = COLOR_000000;
        _labStore.font = FONT_F15;
    }
    return _labStore;
}

- (UILabel *)labNumber {
    if (!_labNumber) {
        _labNumber = [UILabel new];
        _labNumber.textColor = COLOR_B2;
        _labNumber.font = FONT_F12;
    }
    return _labNumber;
}

- (UILabel *)labType {
    if (!_labType) {
        _labType = [UILabel new];
        _labType.textColor = COLOR_B1;
        _labType.font = FONT_F13;
    }
    return _labType;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [UILabel new];
        _labName.textColor = COLOR_B1;
        _labName.font = FONT_F13;
    }
    return _labName;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

@end
