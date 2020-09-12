//
//  PurchaseSupplierCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchaseSupplierCell.h"
#import "UIButton+ShortCut.h"

@interface PurchaseSupplierCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIImageView *imgComplany;
@property (nonatomic, strong) UIImageView *imgBusiness;

@end

@implementation PurchaseSupplierCell

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
    [self.baseView addSubview:self.imgHeader];
    [self.baseView addSubview:self.labName];
    [self.baseView addSubview:self.imgComplany];
    [self.baseView addSubview:self.imgBusiness];
    [self.baseView addSubview:self.labComplany];
    [self.baseView addSubview:self.labBusiness];
    [self.baseView addSubview:self.labSort];
    [self.baseView addSubview:self.labSortType];
    [self.baseView addSubview:self.bottomView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@150);
    }];
    
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(20);
        make.left.equalTo(self.baseView).offset(28);
        make.height.width.equalTo(@50);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgHeader);
        make.left.equalTo(self.imgHeader.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.baseView).offset(-5);
        make.height.greaterThanOrEqualTo(@17.0);
    }];
    
    [self.imgComplany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labName);
        make.top.equalTo(self.labName.mas_bottom).offset(8);
        make.height.width.equalTo(@14.0);
    }];
    
    [self.labComplany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgComplany);
        make.left.equalTo(self.imgComplany.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.baseView).offset(-80);
    }];
    
    [self.imgBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labName);
        //        make.top.equalTo(self.imgComplany.mas_bottom).offset(5);
        make.height.width.equalTo(@14);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-12);
    }];
    
    [self.labBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgBusiness);
        make.left.equalTo(self.imgBusiness.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.labSort mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(20);
        make.right.equalTo(self.baseView).offset(-20);
    }];
    
    [self.labSortType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labSort.mas_bottom).offset(8);
        make.right.equalTo(self.baseView).offset(-20);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.baseView);
        make.height.equalTo(@56);
    }];
}

#pragma mark - public

- (void)loadData:(JSONModel *)mo {
    if (_mo != mo) {
        _mo = mo;
    }
    if ([_mo isKindOfClass:[SalesCustomerMo class]]) {
        SalesCustomerMo *tmpMo = (SalesCustomerMo *)_mo;
        
        NSError *error = nil;
        SubSalesCustomerMo *subMo = [[SubSalesCustomerMo alloc] initWithDictionary:tmpMo.memberOfMember error:&error];
        self.labSort.hidden = YES;
        self.labSortType.hidden = YES;
        
        self.imgHeader.image = [UIImage imageNamed:(@"client_directsales")];
        [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:subMo.avatarUrl] placeholderImage:[UIImage imageNamed:(@"client_directsales")]];
        self.labName.text = subMo.abbreviation;
        self.labComplany.text = subMo.employeeSizeValue;
        self.labBusiness.text = subMo.customerDemand;

        [self.btnPurchase setTitle:tmpMo.purchaseCount forState:UIControlStateNormal];
        [self.btnProduction setTitle:tmpMo.productCount forState:UIControlStateNormal];
        [self.btnSale setTitle:tmpMo.salesCount forState:UIControlStateNormal];

        NSString *companyStr = @"";
        if (subMo.companyTypeValue.length > 0) companyStr = [companyStr stringByAppendingString:subMo.companyTypeValue];
        if (subMo.employeeSizeValue.length > 0 && companyStr.length > 0) companyStr = [companyStr stringByAppendingString:@"|"];
        if (subMo.employeeSizeValue.length > 0) companyStr = [companyStr stringByAppendingString:subMo.employeeSizeValue];
        if (subMo.provinceName.length > 0 && companyStr.length > 0) companyStr = [companyStr stringByAppendingString:@"|"];
        if (subMo.provinceName.length > 0) companyStr = [companyStr stringByAppendingString:subMo.provinceName];
        self.labComplany.text = companyStr.length==0?@"暂无相关信息":companyStr;
        self.labBusiness.text = [NSString stringWithFormat:@"业务范围:%@", subMo.businessScope.length==0?@"暂无":subMo.businessScope];
    }
    else if ([_mo isKindOfClass:[SupplierCustomerMo class]]) {
        SupplierCustomerMo *tmpMo = (SupplierCustomerMo *)_mo;
        
        NSError *error = nil;
        SubSupplierMo *subMo = [[SubSupplierMo alloc] initWithDictionary:tmpMo.supplier error:&error];
//        self.labSort.text = [NSString stringWithFormat:@"第%@名", tmpMo.rank];
//        self.labSortType.text = [NSString stringWithFormat:@"%@排名", TheCustomer.customerMo.abbreviation];
//        self.labSort.hidden = NO;
//        self.labSortType.hidden = NO;

        self.imgHeader.image = [UIImage imageNamed:(@"client_directsales")];
        [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:subMo.avatarUrl] placeholderImage:[UIImage imageNamed:(@"client_directsales")]];
        self.labName.text = subMo.abbreviation;
        self.labComplany.text = subMo.employeeSizeValue;
        self.labBusiness.text = subMo.customerDemand;
        
        [self.btnPurchase setTitle:tmpMo.salesCount forState:UIControlStateNormal];
        [self.btnProduction setTitle:tmpMo.productCount forState:UIControlStateNormal];
        [self.btnSale setTitle:tmpMo.salesCount forState:UIControlStateNormal];
        
        NSString *companyStr = @"";
        if (subMo.companyTypeValue.length > 0) companyStr = [companyStr stringByAppendingString:subMo.companyTypeValue];
        if (subMo.employeeSizeValue.length > 0 && companyStr.length > 0) companyStr = [companyStr stringByAppendingString:@"|"];
        if (subMo.employeeSizeValue.length > 0) companyStr = [companyStr stringByAppendingString:subMo.employeeSizeValue];
        if (subMo.provinceName.length > 0 && companyStr.length > 0) companyStr = [companyStr stringByAppendingString:@"|"];
        if (subMo.provinceName.length > 0) companyStr = [companyStr stringByAppendingString:subMo.provinceName];
        self.labComplany.text = companyStr.length==0?@"暂无相关信息":companyStr;
        self.labBusiness.text = [NSString stringWithFormat:@"业务范围:%@", subMo.businessScope.length==0?@"暂无":subMo.businessScope];
    }
    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-30, 150)];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 5;
        _baseView.layer.shadowColor = [[UIColor alloc] initWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:0.6].CGColor;
        _baseView.layer.shadowOffset = CGSizeMake(0, 4);
        _baseView.layer.shadowOpacity = 0.5;
        _baseView.layer.shadowRadius = 5;
    }
    return _baseView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 56)];
        _bottomView.layer.mask = [Utils drawContentFrame:_bottomView.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:5];
        _bottomView.backgroundColor = COLOR_F7F8F9;
        
        UILabel *topRisk = [UILabel new];
        topRisk.textColor = COLOR_B3;
        topRisk.font = FONT_F12;
        topRisk.text = @"采购状况";
        topRisk.textAlignment = NSTextAlignmentCenter;
        
        UILabel *topTime = [UILabel new];
        topTime.textColor = COLOR_B3;
        topTime.font = FONT_F12;
        topTime.text = @"生产状况";
        topTime.textAlignment = NSTextAlignmentCenter;
        
        UILabel *topInfo = [UILabel new];
        topInfo.textColor = COLOR_B3;
        topInfo.font = FONT_F12;
        topInfo.text = @"销售状况";
        topInfo.textAlignment = NSTextAlignmentCenter;
        
        [_bottomView addSubview:topRisk];
        [_bottomView addSubview:topTime];
        [_bottomView addSubview:topInfo];
        [_bottomView addSubview:self.btnPurchase];
        [_bottomView addSubview:self.btnProduction];
        [_bottomView addSubview:self.btnSale];
        
        [topTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView).offset(10);
            make.centerX.equalTo(_bottomView);
        }];
        
        [topRisk mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topTime);
            make.left.equalTo(_bottomView).offset(25);
        }];
        
        [topInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topTime);
            make.right.equalTo(_bottomView).offset(-25);
        }];
        
        [self.btnPurchase mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topRisk);
            make.top.equalTo(topRisk.mas_bottom).offset(5);
        }];
        
        [self.btnProduction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topTime);
            make.top.equalTo(topTime.mas_bottom).offset(5);
        }];
        
        [self.btnSale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topInfo);
            make.top.equalTo(topInfo.mas_bottom).offset(5);
        }];
    }
    return _bottomView;
}

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imgHeader.layer.mask = [Utils drawContentFrame:_imgHeader.bounds corners:UIRectCornerAllCorners cornerRadius:25.0];
    }
    return _imgHeader;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [UILabel new];
        _labName.textColor = COLOR_B1;
        _labName.font = FONT_F17;
    }
    return _labName;
}

- (UILabel *)labComplany {
    if (!_labComplany) {
        _labComplany = [UILabel new];
        _labComplany.textColor = COLOR_B2;
        _labComplany.font = FONT_F13;
    }
    return _labComplany;
}

- (UILabel *)labBusiness {
    if (!_labBusiness) {
        _labBusiness = [UILabel new];
        _labBusiness.textColor = COLOR_B2;
        _labBusiness.font = FONT_F13;
    }
    return _labBusiness;
}

- (UILabel *)labSortType {
    if (!_labSortType) {
        _labSortType = [UILabel new];
        _labSortType.textColor = COLOR_B3;
        _labSortType.font = FONT_F11;
    }
    return _labSortType;
}

- (UILabel *)labSort {
    if (!_labSort) {
        _labSort = [UILabel new];
        _labSort.textColor = COLOR_C2;
        _labSort.font = FONT_F13;
    }
    return _labSort;
}

- (UIButton *)btnPurchase {
    if (!_btnPurchase) {
        _btnPurchase = [[UIButton alloc] init];
        _btnPurchase.enabled = NO;
        [_btnPurchase setTitle:@"正常" forState:UIControlStateNormal];
        [_btnPurchase setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        _btnPurchase.titleLabel.font = FONT_F14;
//        [_btnPurchase setImage:[UIImage imageNamed:@"client_risk_normal"] forState:UIControlStateNormal];
    }
    return _btnPurchase;
}

- (UIButton *)btnProduction {
    if (!_btnProduction) {
        _btnProduction = [[UIButton alloc] init];
        _btnProduction.enabled = NO;
        [_btnProduction setTitle:@"时间" forState:UIControlStateNormal];
        [_btnProduction setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        _btnProduction.titleLabel.font = FONT_F14;
//        [_btnProduction setImage:[UIImage imageNamed:@"client_time"] forState:UIControlStateNormal];
    }
    return _btnProduction;
}

- (UIButton *)btnSale {
    if (!_btnSale) {
        _btnSale = [[UIButton alloc] init];
        _btnSale.enabled = NO;
        [_btnSale setTitle:@"0%" forState:UIControlStateNormal];
        [_btnSale setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        _btnSale.titleLabel.font = FONT_F14;
//        [_btnSale setImage:[UIImage imageNamed:@"client_information"] forState:UIControlStateNormal];
    }
    return _btnSale;
}

- (UIImageView *)imgComplany {
    if (!_imgComplany) {
        _imgComplany = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"client_transaction"]];
    }
    return _imgComplany;
}

- (UIImageView *)imgBusiness {
    if (!_imgBusiness) {
        _imgBusiness = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"client_office"]];
    }
    return _imgBusiness;
}

@end
