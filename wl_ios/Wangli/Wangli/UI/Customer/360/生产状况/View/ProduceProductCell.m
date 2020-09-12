//
//  ProduceProductCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ProduceProductCell.h"

@interface ProduceProductCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *point;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labSpec;
@property (nonatomic, strong) UILabel *labCost;
@property (nonatomic, strong) UILabel *labMarket;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *btnTechnology;
@property (nonatomic, strong) UIButton *btnBom;

@end

@implementation ProduceProductCell

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
    [self.baseView addSubview:self.point];
    [self.baseView addSubview:self.labTitle];
    UIView *viewSpec = [self itemPartKey:@"规格:" labValue:self.labSpec];
    UIView *viewCost = [self itemPartKey:@"产品成本:" labValue:self.labCost];
    UIView *viewMarket = [self itemPartKey:@"市场价:" labValue:self.labMarket];
    UIView *viewBom = [self itemPartKey:@"BOM/工艺:" labValue:self.btnBom];
    UIView *viewTechnology = [self itemPartKey:@"技术/检验标准:" labValue:self.btnTechnology];
    [self.baseView addSubview:viewSpec];
    [self.baseView addSubview:viewCost];
    [self.baseView addSubview:viewMarket];
    [self.baseView addSubview:viewBom];
    [self.baseView addSubview:viewTechnology];
    [self.baseView addSubview:self.lineView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView);
    }];
    
    [self.point mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(20);
        make.left.equalTo(self.baseView).offset(15);
        make.width.height.equalTo(@5.0);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(25);
    }];
    
    [viewSpec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
//        make.right.equalTo(self.baseView.mas_centerX).offset(-10);
    }];
    
    [viewCost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewSpec);
        make.left.equalTo(self.baseView).offset((SCREEN_WIDTH-50)/3.0+15);
//        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [viewMarket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewSpec);
        make.left.equalTo(self.baseView).offset((SCREEN_WIDTH-50)/3.0*2+15);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [viewBom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewSpec.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.bottom.equalTo(self.baseView).offset(-20);
    }];
    
    [viewTechnology mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewBom);
        make.left.equalTo(self.baseView.mas_centerX).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
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

- (void)loadData:(ProduceProductMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = _model.process;
    self.labSpec.text = _model.process;
    self.labCost.text = _model.cost;
    self.labMarket.text = _model.productPrice;
    
    NSInteger x = arc4random() % 2;
    self.point.hidden = x == 0 ? YES : NO;
    [self.labTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(x == 0 ? 15 : 25);
    }];
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

- (UIView *)point {
    if (!_point) {
        _point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _point.layer.mask = [Utils drawContentFrame:_point.bounds corners:UIRectCornerAllCorners cornerRadius:2.5];
        _point.backgroundColor = COLOR_C2;
    }
    return _point;
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

- (UILabel *)labCost {
    if (!_labCost) _labCost = [self getNewLabel];
    return _labCost;
}

- (UILabel *)labSpec {
    if (!_labSpec) _labSpec = [self getNewLabel];
    return _labSpec;
}

- (UILabel *)labMarket {
    if (!_labMarket) _labMarket = [self getNewLabel];
    return _labMarket;
}

- (UIButton *)btnTechnology {
    if (!_btnTechnology) {
        _btnTechnology = [[UIButton alloc] init];
        [_btnTechnology setTitle:@"下载" forState:UIControlStateNormal];
        [_btnTechnology setTitleColor:COLOR_336699 forState:UIControlStateNormal];
        _btnTechnology.titleLabel.font = FONT_F13;
    }
    return _btnTechnology;
}

- (UIButton *)btnBom {
    if (!_btnBom) {
        _btnBom = [[UIButton alloc] init];
        [_btnBom setTitle:@"下载" forState:UIControlStateNormal];
        [_btnBom setTitleColor:COLOR_336699 forState:UIControlStateNormal];
        _btnBom.titleLabel.font = FONT_F13;
    }
    return _btnBom;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    lab.numberOfLines = 0;
    return lab;
}

@end
