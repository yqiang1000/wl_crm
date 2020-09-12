//
//  TabCustomerCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/9.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TabCustomerCell.h"
#import "ChangeOwnerViewCtrl.h"
#import "UIButton+ShortCut.h"

@interface TabCustomerCell () <MGSwipeTableCellDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *imgCode;
@property (nonatomic, strong) UIImageView *imgBusiness;
@property (nonatomic, strong) UILabel *labIcon;


@end

@implementation TabCustomerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.delegate = self;
        self.leftExpansion.fillOnTrigger = NO;
        self.backgroundColor = COLOR_EEF0F1;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.imgHeader];
//    [self.baseView addSubview:self.labIcon];
    [self.baseView addSubview:self.labName];
    [self.baseView addSubview:self.imgCode];
    [self.baseView addSubview:self.imgBusiness];
    [self.baseView addSubview:self.labCode];
    [self.baseView addSubview:self.labBusiness];
    [self.baseView addSubview:self.labState];
    [self.baseView addSubview:self.bottomView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@(150.0));
    }];
    
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(DEVICE_VALUE(20));
        make.left.equalTo(self.baseView).offset(DEVICE_VALUE(28));
        make.height.width.equalTo(@(DEVICE_VALUE(50.0)));
    }];
    
//    [self.labIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.baseView).offset(DEVICE_VALUE(20));
//        make.left.equalTo(self.baseView).offset(DEVICE_VALUE(28));
//        make.height.width.equalTo(@(DEVICE_VALUE(50.0)));
//    }];
    
    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(16);
        make.right.equalTo(self.baseView).offset(-16);
        make.width.equalTo(@(0));
        make.height.equalTo(@(24.0));
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgHeader);
        make.left.equalTo(self.imgHeader.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.labState.mas_left);
        make.height.greaterThanOrEqualTo(@17);
    }];
    
    [self.imgCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labName);
        make.top.equalTo(self.labName.mas_bottom).offset(8);
        make.height.width.equalTo(@14.0);
    }];
    
    [self.labCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgCode);
        make.left.equalTo(self.imgCode.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.imgBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labName);
        make.height.width.equalTo(@14.0);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-12);
    }];
    
    [self.labBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgBusiness);
        make.left.equalTo(self.imgBusiness.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.baseView);
        make.height.equalTo(@(49.0));
    }];
}

#pragma mark - MGSwipeTableCellDelegate

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction {
    return YES;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings {
    
    swipeSettings.transition = MGSwipeTransitionBorder;
    if (direction == MGSwipeDirectionRightToLeft) {
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 1.1;
        CGFloat padding = 15;
        //        @property (nonatomic, assign) BOOL memberRelease;
        //        @property (nonatomic, assign) BOOL transfer;
        //        @property (nonatomic, assign) BOOL claim;
        
        NSMutableArray *arrBtn = [NSMutableArray new];
        if (_mo.claim) {
            MGSwipeButton *flag = [MGSwipeButton buttonWithTitle:@"认领" backgroundColor:COLOR_EEF0F1 padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
                NSLog(@"认领");
                ChangeOwnerViewCtrl *vc = [[ChangeOwnerViewCtrl alloc] init];
                vc.ownerType = OwnerClaimType;
                vc.mo = self.mo;
                vc.hidesBottomBarWhenPushed = YES;
                [[Utils topViewController].navigationController pushViewController:vc animated:YES];
                [cell refreshContentView];
                return NO;
            }];
            [flag setTitleColor:COLOR_0089D1 forState:UIControlStateNormal];
            [arrBtn addObject:flag];
        }
        if (_mo.memberRelease) {
            MGSwipeButton * trash = [MGSwipeButton buttonWithTitle:@"释放" backgroundColor:COLOR_EEF0F1 padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
                NSLog(@"释放");
                ChangeOwnerViewCtrl *vc = [[ChangeOwnerViewCtrl alloc] init];
                vc.ownerType = OwnerReleaseType;
                vc.mo = _mo;
                vc.hidesBottomBarWhenPushed = YES;
                [[Utils topViewController].navigationController pushViewController:vc animated:YES];
                return NO;
            }];
            [trash setTitleColor:COLOR_C2 forState:UIControlStateNormal];
            [arrBtn addObject:trash];
        }
        if (_mo.transfer) {
            MGSwipeButton * change = [MGSwipeButton buttonWithTitle:@"转移" backgroundColor:COLOR_EEF0F1 padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
                NSLog(@"转移");
                ChangeOwnerViewCtrl *vc = [[ChangeOwnerViewCtrl alloc] init];
                vc.ownerType = OwnerChangeType;
                vc.mo = _mo;
                vc.hidesBottomBarWhenPushed = YES;
                [[Utils topViewController].navigationController pushViewController:vc animated:YES];
                //            MailData * mail = [me mailForIndexPath:[me.tableView indexPathForCell:sender]];
                //            mail.flag = !mail.flag;
                //            [me updateCellIndicactor:mail cell:(MailTableCell*)sender];
                [cell refreshContentView]; //needed to refresh cell contents while swipping
                return NO;
            }];
            [change setTitleColor:COLOR_B3 forState:UIControlStateNormal];
            [arrBtn addObject:change];
        }
        return arrBtn;
    }
    
    return nil;
    
}
//"id": 310,
//"orgName": "抚州市临川区安然建材经营部",
//"legalName": "邹志波",
//"abbreviation": null,
//"crmNumber": "2000777",
//"statusKey": "frozen",
//"statusValue": "冻结",
//"cooperationTypeKey": "straight_pin",
//"cooperationType": "直销客户",
//"memberLevelKey": "ordinary",
//"memberLevelValue": "普通",
//"straightShow": "普通 2000777",
//"operatorId": null,
//"operatorName": "未分配",
//"creditLevelKey": "A",
//"creditLevelValue": "A",
//"brand": null,
//"businessScope": null,
//"avatarUrl": null,
//"stras": null

- (void)loadData:(CustomerMo *)mo {
    if (_mo != mo) {
        _mo = mo;
    }
    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:_mo.avatarUrl] placeholderImage:[UIImage imageNamed:(@"client_directsales")]];
//    NSString *iconText = _mo.cooperationType;
//    if (_mo.cooperationType.length > 2) iconText = [iconText substringWithRange:NSMakeRange(1, 2)];
//    if ([_mo.cooperationTypeKey isEqualToString:@"direct_selling"]) {
//        self.labIcon.backgroundColor = [UIColor colorWithRed:253/255.0 green:167/255.0 blue:40/255.0 alpha:1];
//    } else if ([_mo.cooperationTypeKey isEqualToString:@"competitor"]) {
//        self.labIcon.backgroundColor = [UIColor colorWithRed:50/255.0 green:197/255.0 blue:86/255.0 alpha:1];
//    } else if ([_mo.cooperationTypeKey isEqualToString:@"supplier"]) {
//        self.labIcon.backgroundColor = COLOR_C1;//[UIColor colorWithRed:26/255.0 green:126/255.0 blue:248/255.0 alpha:1];
//    } else if ([_mo.cooperationTypeKey isEqualToString:@"terminal/design_institute"]) {
//        iconText = @"终端";
//        self.labIcon.backgroundColor = [UIColor colorWithRed:40/255.0 green:204/255.0 blue:157/255.0 alpha:1];
//    } else if ([_mo.cooperationTypeKey isEqualToString:@"double_distribution"]) {
//        self.labIcon.backgroundColor = [UIColor colorWithRed:238/255.0 green:92/255.0 blue:78/255.0 alpha:1];
//    }
//    self.labIcon.text = iconText;
    
    self.labName.text = _mo.abbreviation.length != 0 ? _mo.abbreviation : _mo.orgName;
    self.labState.text = _mo.statusValue.length==0?@"暂无":_mo.statusValue;
    self.labCode.text = _mo.cooperationType;
    self.labBusiness.text = _mo.legalName.length==0?@"暂无":[NSString stringWithFormat:@"%@", _mo.legalName];
    [self.btnSR setTitle:_mo.operatorName.length==0?@"无":_mo.operatorName forState:UIControlStateNormal];
    [self.btnAR setTitle:_mo.creditLevelValue.length==0?@"无":_mo.creditLevelValue forState:UIControlStateNormal];
    [self.btnFR setTitle:_mo.brand.length==0?@"无":_mo.brand forState:UIControlStateNormal];
    [self.btnAR imageLeftWithTitleFix:5];
    [self.btnSR imageLeftWithTitleFix:5];
    [self.btnFR imageLeftWithTitleFix:5];
    
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
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 49)];
        _bottomView.layer.mask = [Utils drawContentFrame:_bottomView.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:5];
        _bottomView.backgroundColor = COLOR_F7F8F9;
        
        UILabel *labAR1 = [UILabel new];
        labAR1.text = @"信用等级";
        labAR1.font = FONT_F12;
        labAR1.textColor = COLOR_B3;
        [_bottomView addSubview:labAR1];
        
        UILabel *labSR1 = [UILabel new];
        labSR1.text = @"业务员";
        labSR1.font = FONT_F12;
        labSR1.textColor = COLOR_B3;
        [_bottomView addSubview:labSR1];
        
        UILabel *labFR1 = [UILabel new];
        labFR1.text = @"品牌";
        labFR1.font = FONT_F12;
        labFR1.textColor = COLOR_B3;
        [_bottomView addSubview:labFR1];
        
        [_bottomView addSubview:self.btnAR];
        [_bottomView addSubview:self.btnSR];
        [_bottomView addSubview:self.btnFR];
        
        [labSR1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomView);
            make.top.equalTo(_bottomView).offset(3);
        }];
        
        [labAR1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labSR1);
            make.left.equalTo(_bottomView).offset(25);
        }];
        
        [labFR1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labSR1);
            make.right.equalTo(_bottomView).offset(-25);
        }];
        
        [self.btnSR mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_bottomView).offset(-7);
            make.centerX.equalTo(_bottomView);
        }];
        
        [self.btnAR mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnSR);
            make.left.equalTo(_bottomView).offset(20);
        }];
        
        [self.btnFR mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnSR);
            make.right.equalTo(_bottomView).offset(-20);
            make.width.lessThanOrEqualTo(@((SCREEN_WIDTH-20)/3.0));
        }];
    }
    return _bottomView;
}

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,DEVICE_VALUE(50),DEVICE_VALUE(50))];
        _imgHeader.layer.cornerRadius = DEVICE_VALUE(50) / 2.0;
        _imgHeader.layer.borderWidth = 0.5;
        _imgHeader.layer.borderColor = COLOR_EEEEEE.CGColor;
        _imgHeader.clipsToBounds = YES;

//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_imgHeader.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(25, 25)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = _imgHeader.bounds;
//        maskLayer.path = maskPath.CGPath;
//        maskLayer.borderColor = COLOR_EEEEEE.CGColor;
//        maskLayer.borderWidth = 0.5;
//        _imgHeader.layer.mask = maskLayer;
    }
    return _imgHeader;
}


- (UILabel *)labIcon {
    if (!_labIcon) {
        _labIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_VALUE(50),DEVICE_VALUE(50))];
        _labIcon.layer.mask = [Utils drawContentFrame:_labIcon.bounds corners:UIRectCornerAllCorners cornerRadius:CGRectGetWidth(_labIcon.frame)/2.0];
        _labIcon.textColor = COLOR_B4;
        _labIcon.font = FONT_F14;
        _labIcon.backgroundColor = COLOR_C1;
        _labIcon.textAlignment = NSTextAlignmentCenter;
    }
    return _labIcon;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [UILabel new];
        _labName.textColor = COLOR_B1;
        _labName.font = FONT_F17;
    }
    return _labName;
}

- (UILabel *)labCode {
    if (!_labCode) {
        _labCode = [UILabel new];
        _labCode.textColor = COLOR_B2;
        _labCode.font = FONT_F13;
    }
    return _labCode;
}

- (UILabel *)labBusiness {
    if (!_labBusiness) {
        _labBusiness = [UILabel new];
        _labBusiness.textColor = COLOR_B2;
        _labBusiness.font = FONT_F13;
    }
    return _labBusiness;
}

- (UILabel *)labState {
    if (!_labState) {
        _labState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 24)];
        _labState.hidden = YES;
        _labState.font = FONT_F12;
        _labState.textColor = COLOR_B2;
        _labState.backgroundColor = COLOR_F2F3F5;
        _labState.textAlignment = NSTextAlignmentCenter;
        _labState.layer.mask = [Utils drawContentFrame:_labState.bounds corners:UIRectCornerAllCorners cornerRadius:3];
    }
    return _labState;
}

- (UIButton *)btnAR {
    if (!_btnAR) {
        _btnAR = [[UIButton alloc] init];
        _btnAR.enabled = NO;
        [_btnAR setTitle:@"正常" forState:UIControlStateNormal];
        [_btnAR setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        _btnAR.titleLabel.font = FONT_F14;
        [_btnAR setImage:[UIImage imageNamed:@"c_credit_rating"] forState:UIControlStateNormal];
    }
    return _btnAR;
}

- (UIButton *)btnSR {
    if (!_btnSR) {
        _btnSR = [[UIButton alloc] init];
        _btnSR.enabled = NO;
        [_btnSR setTitle:@"时间" forState:UIControlStateNormal];
        [_btnSR setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        _btnSR.titleLabel.font = FONT_F14;
        [_btnSR setImage:[UIImage imageNamed:@"c_salesman"] forState:UIControlStateNormal];
    }
    return _btnSR;
}

- (UIButton *)btnFR {
    if (!_btnFR) {
        _btnFR = [[UIButton alloc] init];
        _btnFR.enabled = NO;
        _btnFR.titleLabel.numberOfLines = 0;
        [_btnFR setTitle:@"0%" forState:UIControlStateNormal];
        [_btnFR setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        _btnFR.titleLabel.font = FONT_F14;
        [_btnFR setImage:[UIImage imageNamed:@"c_brand"] forState:UIControlStateNormal];
    }
    return _btnFR;
}

- (UIImageView *)imgCode {
    if (!_imgCode) {
        _imgCode = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"client_transaction"]];
    }
    return _imgCode;
}

- (UIImageView *)imgBusiness {
    if (!_imgBusiness) {
        _imgBusiness = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c_legal_person"]];
    }
    return _imgBusiness;
}

@end
