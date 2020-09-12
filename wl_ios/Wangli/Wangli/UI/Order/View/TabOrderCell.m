
//
//  TabOrderCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/20.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TabOrderCell.h"

@interface TabOrderCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UILabel *labCompany;
@property (nonatomic, strong) UILabel *labAddress;
@property (nonatomic, strong) UILabel *labLevel;
@property (nonatomic, strong) UILabel *labState;
@property (nonatomic, strong) UILabel *labPerson;
@property (nonatomic, strong) UILabel *labPrice;

@property (nonatomic, strong) UIImageView *imgTmp1;
@property (nonatomic, strong) UIImageView *imgTmp2;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation TabOrderCell

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
    [self.baseView addSubview:self.imgHeader];
    [self.baseView addSubview:self.labTime];
    [self.baseView addSubview:self.labState];
    [self.baseView addSubview:self.imgTmp1];
    [self.baseView addSubview:self.labCompany];
    [self.baseView addSubview:self.labAddress];
    [self.baseView addSubview:self.imgTmp2];
    [self.baseView addSubview:self.labLevel];
    [self.baseView addSubview:self.labPerson];
    [self.baseView addSubview:self.labPrice];
    [self.baseView addSubview:self.lineView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@133);
    }];
    
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(20);
        make.left.equalTo(self.baseView).offset(10);
        make.width.height.equalTo(@50);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(26);
        make.left.equalTo(self.imgHeader.mas_right).offset(8);
    }];
    
    [self.imgTmp1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTime.mas_bottom).offset(12);
        make.left.equalTo(self.labTime);
        make.height.width.equalTo(@13);
    }];
    
    [self.imgTmp2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgTmp1.mas_bottom).offset(8);
        make.left.equalTo(self.imgTmp1);
        make.height.width.equalTo(@13);
    }];
    
    [self.labCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgTmp1);
        make.left.equalTo(self.imgTmp1.mas_right).offset(10);
    }];
    
    [self.labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgTmp1);
        make.left.equalTo(self.labCompany.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.labLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgTmp2);
        make.left.equalTo(self.imgTmp2.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.baseView).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-33);
        make.height.equalTo(@0.5);
    }];
    
    [self.labPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baseView.mas_bottom).offset(-16.5);
        make.left.equalTo(self.imgTmp1);
    }];
    
    [self.labPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labPerson);
        make.right.equalTo(self.baseView).offset(-10);
    }];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(9);
        make.right.equalTo(self.baseView);
        make.width.equalTo(@65);
        make.height.equalTo(@28);
    }];
}

#pragma mark - public

- (void)loadDataWith:(OrderMo *)model {
    if (_model != model) {
        _model = model;
    }
    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:_model.avatarUrl] placeholderImage:[UIImage imageNamed:(@"client_directsales")]];
    self.labTime.text = _model.orderDate;
    self.labCompany.text = _model.abbreviation;
    self.labAddress.text = _model.address;
    
    NSDictionary *dic = [_model.orderItem firstObject];
    NSString *levelStr = [[NSString alloc] init];
    NSString *spec = STRING(dic[@"spec"]);
    NSString *batchNumber = STRING(dic[@"batchNumber"]);
    NSString *gradeName = STRING(dic[@"gradeName"]);
    if (spec.length > 0) {
        levelStr = [levelStr stringByAppendingString:spec];
        levelStr = [levelStr stringByAppendingString:@"/"];
    }
    if (batchNumber.length > 0) {
        levelStr = [levelStr stringByAppendingString:batchNumber];
        levelStr = [levelStr stringByAppendingString:@"/"];
    }
    if (gradeName.length > 0) {
        levelStr = [levelStr stringByAppendingString:gradeName];
    }
    self.labLevel.text = levelStr.length == 0 ? @"无":levelStr;
    self.labPerson.text = [NSString stringWithFormat:@"业务员:%@", _model.salemanName.length == 0 ? @"无":_model.salemanName];
    self.labPrice.text = [NSString stringWithFormat:@"%@%@",_model.wearsSign.length==0?@"¥":_model.wearsSign,[Utils getPriceFrom:[_model.finalAmount floatValue]]];
    self.labPrice.hidden = ![_model.authBean[@"price"] boolValue];
    self.labState.text = _model.statusDesp;
    CGSize size = [Utils getStringSize:self.labState.text font:self.labState.font];
    [self.labState mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width+10));
    }];
}

#pragma mark - setter and getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 133)];
        _baseView.layer.mask = [Utils drawContentFrame:_baseView.bounds corners:UIRectCornerAllCorners cornerRadius:5];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imgHeader.layer.mask = [Utils drawContentFrame:_imgHeader.bounds corners:UIRectCornerAllCorners cornerRadius:25];
        _imgHeader.backgroundColor = [UIColor redColor];
    }
    return _imgHeader;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.textColor = COLOR_B2;
        _labTime.font = FONT_F13;
    }
    return _labTime;
}

- (UIImageView *)imgTmp1 {
    if (!_imgTmp1) {
        _imgTmp1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_origin"]];
    }
    return _imgTmp1;
}

- (UIImageView *)imgTmp2 {
    if (!_imgTmp2) {
        _imgTmp2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_produat_news"]];
    }
    return _imgTmp2;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UILabel *)labCompany {
    if (!_labCompany) {
        _labCompany = [[UILabel alloc] init];
        _labCompany.textColor = COLOR_B1;
        _labCompany.font = FONT_F16;
    }
    return _labCompany;
}

- (UILabel *)labAddress {
    if (!_labAddress) {
        _labAddress = [[UILabel alloc] init];
        _labAddress.textColor = COLOR_B2;
        _labAddress.font = FONT_F13;
    }
    return _labAddress;
}

- (UILabel *)labLevel {
    if (!_labLevel) {
        _labLevel = [[UILabel alloc] init];
        _labLevel.textColor = COLOR_B3;
        _labLevel.font = FONT_F13;
    }
    return _labLevel;
}

- (UILabel *)labPerson {
    if (!_labPerson) {
        _labPerson = [[UILabel alloc] init];
        _labPerson.textColor = COLOR_B3;
        _labPerson.font = FONT_F13;
    }
    return _labPerson;
}

- (UILabel *)labPrice {
    if (!_labPrice) {
        _labPrice = [[UILabel alloc] init];
        _labPrice.textColor = COLOR_EC675D;
        _labPrice.font = FONT_F15;
    }
    return _labPrice;
}

- (UILabel *)labState {
    if (!_labState) {
        _labState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 28)];
        _labState.layer.mask = [Utils drawContentFrame:_labState.bounds corners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadius:14];
        _labState.textColor = COLOR_B4;
        _labState.backgroundColor = COLOR_C3;
        _labState.font = FONT_F13;
        _labState.textAlignment = NSTextAlignmentCenter;
    }
    return _labState;
}

@end
