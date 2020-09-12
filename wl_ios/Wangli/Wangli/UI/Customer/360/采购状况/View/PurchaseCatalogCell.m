//
//  PurchaseCatalogCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchaseCatalogCell.h"

@interface PurchaseCatalogCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labType;
@property (nonatomic, strong) UILabel *labSpec;
//@property (nonatomic, strong) UILabel *labMonth;
//@property (nonatomic, strong) UILabel *labSeason;
@property (nonatomic, strong) UILabel *labTechnology;
@property (nonatomic, strong) UILabel *labBusiness;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UIButton *btnDownload;

@end

@implementation PurchaseCatalogCell

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
    [self.baseView addSubview:self.labTitle];
    UIView *viewType = [self itemPartKey:@"产品类型:" labValue:self.labType];
    UIView *viewSpec = [self itemPartKey:@"规格/型号:" labValue:self.labSpec];
//    UIView *viewMonth = [self itemPartKey:@"月采购量:" labValue:self.labMonth];
//    UIView *viewSeason = [self itemPartKey:@"季采购量:" labValue:self.labSeason];
    UIView *viewTechnology = [self itemPartKey:@"技术要求:" labValue:self.labTechnology];
    UIView *viewBusiness = [self itemPartKey:@"商务要求:" labValue:self.labBusiness];
    
    [self.baseView addSubview:viewType];
    [self.baseView addSubview:viewSpec];
//    [self.baseView addSubview:viewMonth];
//    [self.baseView addSubview:viewSeason];
    [self.baseView addSubview:viewTechnology];
    [self.baseView addSubview:viewBusiness];
//    [self.baseView addSubview:self.btnDownload];
    [self.baseView addSubview:self.lineView];
    
//    UILabel *labRemark = [self getNewLabel];
//    labRemark.text = @"附件:";
//    [self.baseView addSubview:labRemark];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(15);
    }];
    
    [viewType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(13);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView.mas_centerX).offset(-10);
    }];
    
    [viewSpec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewType);
        make.left.equalTo(self.baseView.mas_centerX).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
//    [viewMonth mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.greaterThanOrEqualTo(viewType.mas_bottom).offset(10);
//        make.top.greaterThanOrEqualTo(viewSpec.mas_bottom).offset(10);
//        make.left.equalTo(self.baseView).offset(15);
//        make.right.equalTo(self.baseView.mas_centerX).offset(-10);
//    }];
//
//    [viewSeason mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(viewMonth);
//        make.left.equalTo(self.baseView.mas_centerX).offset(10);
//        make.right.equalTo(self.baseView).offset(-15);
//    }];
    
    [viewTechnology mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(viewType.mas_bottom).offset(10);
        make.top.greaterThanOrEqualTo(viewSpec.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView.mas_centerX).offset(-10);
    }];
    
    [viewBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTechnology);
        make.left.equalTo(self.baseView.mas_centerX).offset(10);
        make.right.equalTo(self.baseView).offset(-15);
        make.bottom.equalTo(self.baseView).offset(-15);
    }];
    
//    [labRemark mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.greaterThanOrEqualTo(viewTechnology.mas_bottom).offset(10);
//        make.top.greaterThanOrEqualTo(viewBusiness.mas_bottom).offset(10);
//        make.left.equalTo(self.baseView).offset(15);
//        make.bottom.equalTo(self.baseView).offset(-15);
//    }];
    
//    [self.btnDownload mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(labRemark);
//        make.left.equalTo(labRemark.mas_right).offset(3);
//    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)itemPartKey:(NSString *)key labValue:(UILabel *)labValue {
    UIView *bottomView = [UIView new];
    UILabel *labKey = [self getNewLabel];
    labKey.text = key;
    [bottomView addSubview:labKey];
    [bottomView addSubview:labValue];
    
    CGSize size = [Utils getStringSize:labKey.text font:labKey.font];
    [labKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(bottomView);
        make.width.equalTo(@(size.width+3));
        make.bottom.lessThanOrEqualTo(bottomView);
    }];
    [labValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.equalTo(labKey.mas_right).offset(3);
        make.right.lessThanOrEqualTo(bottomView);
        make.bottom.equalTo(bottomView);
    }];
    return bottomView;
}

#pragma mark - public

- (void)loadData:(PurchaseCatalogMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = _model.productName;
    self.labType.text = _model.productType;
    self.labSpec.text = _model.productSpec;
//    self.labMonth.text = _model.monthQuantity;
//    self.labSeason.text = _model.seasonQuantity;
    self.labTechnology.text = _model.technologyDemand;
    self.labBusiness.text = _model.businessDemand;
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

- (UILabel *)labType {
    if (!_labType) _labType = [self getNewLabel];
    return _labType;
}

- (UILabel *)labSpec {
    if (!_labSpec) _labSpec = [self getNewLabel];
    return _labSpec;
}

//- (UILabel *)labMonth {
//    if (!_labMonth) _labMonth = [self getNewLabel];
//    return _labMonth;
//}
//
//- (UILabel *)labSeason {
//    if (!_labSeason) _labSeason = [self getNewLabel];
//    return _labSeason;
//}

- (UILabel *)labTechnology {
    if (!_labTechnology) _labTechnology = [self getNewLabel];
    return _labTechnology;
}

- (UILabel *)labBusiness {
    if (!_labBusiness) _labBusiness = [self getNewLabel];
    return _labBusiness;
}

//- (UIButton *)btnDownload {
//    if (!_btnDownload) {
//        _btnDownload = [[UIButton alloc] init];
//        [_btnDownload setTitle:@"下载" forState:UIControlStateNormal];
//        [_btnDownload setTitleColor:COLOR_336699 forState:UIControlStateNormal];
//        _btnDownload.titleLabel.font = FONT_F13;
//    }
//    return _btnDownload;
//}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.textColor = COLOR_B2;
    lab.font = FONT_F13;
    lab.numberOfLines = 0;
    lab.lineBreakMode = NSLineBreakByCharWrapping;
    return lab;
}

@end
