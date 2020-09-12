//
//  CardView.m
//  Wangli
//
//  Created by yeqiang on 2018/7/31.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CardView.h"
#import "LJInstrumentView.h"
#import "Wangli-Bridging-Header.h"
#import "Wangli-Swift.h"
#import "Charts-Swift.h"
#import "UIButton+ShortCut.h"
#import "XValueFormatter.h"
#import "AvatorViewCtrl.h"
#import "AddTagViewCtrl.h"
#import "RadarMo.h"
#import "RadarMapView.h"
#import "RadarMapCompleteView.h"
#import "BaseWebViewCtrl.h"
#import "TestViewController.h"

#pragma mark - SquaredCardView

@interface SquaredCardView ()

{
    CGFloat _cellWidth;
    CGFloat _cellHeight;
}

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *btnBaseView;

@end

@implementation SquaredCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellWidth = (SCREEN_WIDTH - 30) / 3.0;
        _cellHeight = 65.0;
        [self setUI];
        self.backgroundColor = COLOR_CLEAR;
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.topView];
    [self.baseView addSubview:self.labInfo];
    [self.baseView addSubview:self.collectionView];
    [self addSubview:self.imgHeader];
    [self addSubview:self.btnCollect];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(94);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView);
        make.left.right.equalTo(self.baseView);
    }];
    
    [self.labInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.baseView);
        make.height.equalTo(@25);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labInfo.mas_bottom);
        make.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-25);
        make.height.equalTo(@(_cellHeight * 2));
    }];
    
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.baseView.mas_top).offset(-7);
        make.height.width.equalTo(@78);
    }];
    
    [self.btnCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView).offset(13);
        make.right.equalTo(_topView).offset(3);
        make.width.equalTo(@64);
        make.height.equalTo(@28);
    }];
}

- (void)refreshView:(CustomerMo *)mo {
    _mo = mo;
    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:[Utils imgUrlWithKey:_mo.avatarUrl]] placeholderImage:[UIImage imageNamed:(@"client_directsales")]];
    self.labCompanyName.text = _mo.orgName;
    self.labCode.text = _mo.cnumber;
    self.labInfo.text = [NSString stringWithFormat:@"信息完整度：%@", _mo.completeness.length == 0 ? @"0%": _mo.completeness];
    NSArray *arr = [TagMo arrayOfModelsFromDictionaries:_mo.labels error:nil];
    
    // testData
//    NSMutableArray *arr = [NSMutableArray new];
//    for (int i = 0 ; i < 2; i++) {
//        TagMo *mo = [[TagMo alloc] init];
//        mo.desp = [NSString stringWithFormat:@"标签啊啊啊啊%d", i];
//        [arr addObject:mo];
//    }
    
    if (arr.count == 0) {
        self.labTag.text = @"标签:暂无";
        [self addBtnBaseViewArrow:NO];
    } else {
        if (arr.count == 1) {
            TagMo *tmpMo = arr[0];
            self.labTag.text = [NSString stringWithFormat:@"标签:%@",tmpMo.desp];
            [self addBtnBaseViewArrow:NO];
        } else {
            self.labTag.text = [NSString stringWithFormat:@"标签:%@",[Utils pieceStringByArray:arr appendString:@"\n"]];
            [self addBtnBaseViewArrow:YES];
        }
    }
    self.labMsg.text = [Utils memberState:_mo.status];
    self.btnCollect.selected = TheCustomer.centerMo.favorite > 0 ? YES : NO;
    [self.collectionView reloadData];
    [self layoutIfNeeded];
}

- (void)addBtnBaseViewArrow:(BOOL)arrow  {
    
    [self.btnBaseView addSubview:self.btnEdit];
    if (arrow) {
        [self.btnBaseView addSubview:self.btnTag];
        [_btnTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btnBaseView);
            make.left.equalTo(self.btnBaseView);
            make.height.width.equalTo(@20);
        }];
    } else {
        [_btnTag removeFromSuperview];
        _btnTag = nil;
    }

    [_btnEdit mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnBaseView);
        make.left.equalTo(arrow ? self.btnTag.mas_right : self.btnBaseView);
        make.right.equalTo(self.btnBaseView);
        make.height.width.equalTo(@20);
    }];
}

#pragma mark - public

- (void)setArrData:(NSMutableArray *)arrData {
    if (_arrData != arrData) {
        _arrData = arrData;
    }
    self.collectionView.arrData = _arrData;
}

- (void)btnCollectClick:(UIButton *)sender {
    [Utils showHUDWithStatus:nil];
    if (TheCustomer.centerMo.favorite > 0) {
        [[JYUserApi sharedInstance] deleteFavoriteId:TheCustomer.centerMo.favorite success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"取消成功"];
            TheCustomer.centerMo.favorite = 0;
            sender.selected = !sender.selected;
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createFavoriteTypeId:@"MEMBER" favoriteId:_mo.id success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"收藏成功"];
            TheCustomer.centerMo.favorite = [responseObject[@"id"] longLongValue];
            sender.selected = !sender.selected;
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)clickChange:(UITapGestureRecognizer *)tap {
    //    TheCustomer.customerMo
    AvatorViewCtrl *vc = [[AvatorViewCtrl alloc] init];
    vc.type = AvatorTypeMember;
    vc.hidesBottomBarWhenPushed = YES;
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)btnTagClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.labTag.numberOfLines = 0;
    } else {
        self.labTag.numberOfLines = 1;
    }
    [self layoutIfNeeded];
}

- (void)btnEditClick:(UIButton *)sender {
    AddTagViewCtrl *vc = [[AddTagViewCtrl alloc] init];
    vc.data0 = [TagMo arrayOfModelsFromDictionaries:_mo.labels error:nil];
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 10;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UILabel *)labInfo {
    if (!_labInfo) {
        _labInfo = [[UILabel alloc] init];
        _labInfo.textColor = COLOR_B2;
        _labInfo.font = FONT_F12;
        _labInfo.backgroundColor = COLOR_F8F8F8;
        _labInfo.text = @"信息完整度：0%";
        _labInfo.textAlignment = NSTextAlignmentCenter;
    }
    return _labInfo;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = COLOR_B4;
        
        [_topView addSubview:self.labCompanyName];
        [_labCompanyName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topView);
            make.top.equalTo(_topView.mas_top).offset(44);
            make.left.greaterThanOrEqualTo(_topView).offset(10);
        }];
        
        UIView *tmpView = [UIView new];
        [_topView addSubview:tmpView];
        [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topView);
            make.left.greaterThanOrEqualTo(_topView);
            make.top.equalTo(_labCompanyName);
            make.height.equalTo(@0);
        }];
        
        [_topView addSubview:self.labCode];
        [_labCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tmpView);
            make.top.equalTo(_labCompanyName.mas_bottom).offset(12);
            make.bottom.lessThanOrEqualTo(_topView.mas_bottom).offset(-15);
        }];
        
        [_topView addSubview:self.labMsg];
        [_labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labCode.mas_right).offset(12);
            make.right.equalTo(tmpView);
            make.top.equalTo(_labCompanyName.mas_bottom).offset(12);
        }];
        
        [_topView addSubview:self.labTag];
        [_labTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topView);
            make.top.equalTo(_labCode.mas_bottom).offset(8);
            make.left.greaterThanOrEqualTo(_topView).offset(10);
            make.bottom.lessThanOrEqualTo(_topView.mas_bottom).offset(-15);
        }];
        
        [_topView addSubview:self.btnBaseView];
        [_btnBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labTag.mas_top).offset(-3);
            make.left.equalTo(_labTag.mas_right).offset(0);
            make.height.equalTo(@20);
//            make.width.equalTo(@20);
        }];
    }
    return _topView;
}

- (CustomerCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[CustomerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = COLOR_B4;
    }
    return _collectionView;
}

- (UILabel *)labCompanyName {
    if (!_labCompanyName) {
        _labCompanyName = [UILabel new];
        _labCompanyName.font = FONT_F16;
        _labCompanyName.textColor = COLOR_B1;
    }
    return _labCompanyName;
}

- (UILabel *)labCode {
    if (!_labCode) {
        _labCode = [UILabel new];
        _labCode.font = FONT_F12;
        _labCode.textColor = COLOR_B1;
        [_labCode sizeToFit];
    }
    return _labCode;
}

- (UILabel *)labMsg {
    if (!_labMsg) {
        _labMsg = [UILabel new];
        _labMsg.font = FONT_F12;
        _labMsg.textColor = COLOR_C3;
        [_labMsg sizeToFit];
    }
    return _labMsg;
}

- (UILabel *)labTag {
    if (!_labTag) {
        _labTag = [UILabel new];
        _labTag.font = FONT_F12;
        _labTag.textColor = COLOR_B2;
        _labTag.numberOfLines = 1;
        _labTag.textAlignment = NSTextAlignmentCenter;
    }
    return _labTag;
}

- (UIButton *)btnTag {
    if (!_btnTag) {
        _btnTag = [[UIButton alloc] init];
        [_btnTag setImage:[UIImage imageNamed:@"client_down_n"] forState:UIControlStateNormal];
        [_btnTag setImage:[UIImage imageNamed:@"drop_down_s"] forState:UIControlStateSelected];
        [_btnTag addTarget:self action:@selector(btnTagClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnTag;
}

- (UIButton *)btnEdit {
    if (!_btnEdit) {
        _btnEdit = [[UIButton alloc] init];
        [_btnEdit setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        [_btnEdit addTarget:self action:@selector(btnEditClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnEdit;
}

- (UIView *)btnBaseView {
    if (!_btnBaseView) {
        _btnBaseView = [UIView new];
    }
    return _btnBaseView;
}

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] init];
        _imgHeader.image = [UIImage imageNamed:@"headerBg"];
        _imgHeader.layer.cornerRadius = 40;
        _imgHeader.clipsToBounds = YES;
        _imgHeader.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChange:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _imgHeader.userInteractionEnabled = YES;
        [_imgHeader addGestureRecognizer:tap];
    }
    return _imgHeader;
}

- (UIButton *)btnCollect {
    if (!_btnCollect) {
        _btnCollect = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 28)];
        [_btnCollect setTitle:@"收藏" forState:UIControlStateNormal];
        [_btnCollect setTitle:@"取消" forState:UIControlStateSelected];
        [_btnCollect setBackgroundColor:COLOR_F2F3F5];
        _btnCollect.titleLabel.font = FONT_F13;
        [_btnCollect setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btnCollect setTitleColor:COLOR_C3 forState:UIControlStateSelected];
        [_btnCollect setImage:[UIImage imageNamed:@"360_collect"] forState:UIControlStateNormal];
        [_btnCollect setImage:[UIImage imageNamed:@"orderassistant_collection_s"] forState:UIControlStateSelected];
        [_btnCollect sideImageLeftWithFix:5];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_btnCollect.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(14, 14)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _btnCollect.bounds;
        maskLayer.path = maskPath.CGPath;
        _btnCollect.layer.mask = maskLayer;
        [_btnCollect addTarget:self action:@selector(btnCollectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCollect;
}

@end

#pragma mark - DashboardCardView

@interface DashboardCardView ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) LJInstrumentView *checkMeter;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labDetail;
@property (nonatomic, strong) UIView *silderDetail;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UILabel *labTotal;
@property (nonatomic, strong) UILabel *labArrear;
@property (nonatomic, strong) UIButton *btnNoti;
@property (nonatomic, strong) CALayer *layermin;
@property (nonatomic, strong) NSMutableArray *arrContenBeans;

@end

@implementation DashboardCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
        self.backgroundColor = COLOR_CLEAR;
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.labTitle];
    [self.baseView addSubview:self.labDetail];
    [self.baseView addSubview:self.checkMeter];
    [self.baseView addSubview:self.silderDetail];
    [self.baseView addSubview:self.btnNoti];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(10);
    }];
    
    [self.labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.labTitle.mas_bottom).offset(5);
    }];
    
    [self.checkMeter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labDetail.mas_bottom).offset(10);
        make.centerX.equalTo(self.baseView);
        make.width.height.equalTo(@150);
    }];
    
    [self.silderDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.checkMeter.mas_bottom).offset(30);
        make.left.equalTo(self.baseView).offset(40);
        make.height.equalTo(@88);
    }];
    
    [self.btnNoti mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.silderDetail.mas_bottom).offset(15);
        make.height.equalTo(@28);
        make.width.equalTo(@115);
        make.bottom.equalTo(self.baseView).offset(-15);
    }];
}

- (void)refreshView:(CustomerMo *)mo centerMo:(MemberCenterMo *)centerMo {
    _mo = mo;
    _centerMo = centerMo;
    if (STRING(_mo.riskLevel).length != 0) {
        self.labDetail.hidden = NO;
        UIColor *riskColor = COLOR_B1;
        if ([_mo.riskLevel isEqualToString:@"高危"]) {
            riskColor = COLOR_EC675D;
        } else if ([_mo.riskLevel isEqualToString:@"危险"]) {
            riskColor = COLOR_E78A36;
        } else if ([_mo.riskLevel isEqualToString:@"预警"]) {
            riskColor = COLOR_FBD35E;
        } else if ([_mo.riskLevel isEqualToString:@"正常"]) {
            riskColor = COLOR_B1;
        }
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"风险等级：%@", _mo.riskLevel]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:riskColor range:NSMakeRange(attrStr.length-_mo.riskLevel.length, _mo.riskLevel.length)];
        self.labDetail.attributedText = attrStr;
    } else {
        self.labDetail.hidden = YES;
    }
    
    self.checkMeter.speedValue = _centerMo.riskShip * 100;
    [self.checkMeter runSpeedProgress];
    
    self.labTotal.text = [NSString stringWithFormat:@"¥%@", [Utils getPrice:TheCustomer.customerMo.owedTotalAmount]];
    self.labArrear.text = [NSString stringWithFormat:@"¥%@", [Utils getPrice:TheCustomer.customerMo.dueTotalAmount]];
    
    if (IS_IPHONE5) {
        self.labTotal.font = FONT_F13;
        self.labArrear.font = FONT_F13;
    }
}

- (void)btnNotiClick:(UIButton *)sender {
    [[JYUserApi sharedInstance] dunningFailure:@[@(TheCustomer.customerMo.id)] success:^(id responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            [Utils showToastMessage:@"提醒成功"];
        } else {
            NSString *str = STRING(responseObject[@"errMsgDesp"]);
            if (str.length > 0) {
                [Utils showToastMessage:str];
            }
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - setter getter

- (LJInstrumentView *)checkMeter {
    if (!_checkMeter) {
        _checkMeter = [[LJInstrumentView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _checkMeter.backgroundColor=[UIColor whiteColor];
        _checkMeter.timeInterval=0.3;
        //弧线
        [_checkMeter drawArcWithStartAngle:-M_PI*5/4 endAngle:M_PI/4 lineWidth:15.0f fillColor:[UIColor clearColor] strokeColor:COLOR_EDEEF2];
        // 计时器
        [NSTimer scheduledTimerWithTimeInterval:_checkMeter.timeInterval target:_checkMeter selector:@selector(runSpeedProgress) userInfo:nil repeats:NO];
        //刻度
        [_checkMeter drawScaleWithDivide:50 andRemainder:5 strokeColor:COLOR_DFE5EC filleColor:[UIColor clearColor]scaleLineNormalWidth:10 scaleLineBigWidth:20];
        // 增加刻度值
        [_checkMeter DrawScaleValueWithDivide:1];
        // 进度的曲线
        [_checkMeter drawProgressCicrleWithfillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor]];
        [_checkMeter setColorGrad:[NSArray arrayWithObjects:(id)[COLOR_12C2E9 CGColor],(id)[COLOR_C471ED CGColor], (id)[COLOR_F64F59 CGColor], nil]];
    }
    return _checkMeter;
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 10;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.text = @"客户风险仪表盘";
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UILabel *)labDetail {
    if (!_labDetail) {
        _labDetail = [[UILabel alloc] init];
        _labDetail.font = FONT_F13;
        _labDetail.textColor = COLOR_B1;
    }
    return _labDetail;
}

- (UIView *)silderDetail {
    if (!_silderDetail) {
        _silderDetail = [[UIView alloc] init];
        _silderDetail.backgroundColor = COLOR_B4;
        _silderDetail.layer.cornerRadius = 4;
        _silderDetail.layer.borderColor = COLOR_LINE.CGColor;
        _silderDetail.layer.borderWidth = 0.5;
        _silderDetail.clipsToBounds = YES;
        
        UIView *cir1 = [[UIView alloc] init];
        cir1.backgroundColor = COLOR_597AF4;
        cir1.layer.cornerRadius = 4;
        cir1.clipsToBounds = YES;
        UIView *cir2 = [[UIView alloc] init];
        cir2.backgroundColor = COLOR_E15465;
        cir2.layer.cornerRadius = 4;
        cir2.clipsToBounds = YES;
        
        UILabel *lab1 = [UILabel new];
        lab1.font = FONT_F15;
        lab1.textColor = COLOR_B1;
        lab1.text = @"总欠款:";
        UILabel *lab2 = [UILabel new];
        lab2.font = FONT_F15;
        lab2.textColor = COLOR_B1;
        lab2.text = @"到期欠款:";
        
        if (IS_IPHONE5) {
            lab1.font = FONT_F13;
            lab2.font = FONT_F13;
        }
        
        [_silderDetail addSubview:cir1];
        [_silderDetail addSubview:cir2];
        [_silderDetail addSubview:lab1];
        [_silderDetail addSubview:lab2];
        [_silderDetail addSubview:self.labTotal];
        [_silderDetail addSubview:self.labArrear];
        
        [cir1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_silderDetail.mas_left).offset(20);
            make.centerY.equalTo(_silderDetail.mas_top).offset(27);
            make.width.height.equalTo(@8);
        }];
        
        [cir2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_silderDetail.mas_left).offset(20);
            make.top.equalTo(cir1.mas_bottom).offset(25);
            make.width.height.equalTo(@8);
        }];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cir1);
            make.left.equalTo(cir1.mas_right).offset(10);
        }];
        
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cir2);
            make.left.equalTo(cir2.mas_right).offset(10);
        }];
        
        [self.labTotal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_silderDetail).offset(-15);
            make.centerY.equalTo(cir1);
            make.left.greaterThanOrEqualTo(lab1.mas_right).offset(10);
        }];
        
        [self.labArrear mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_silderDetail).offset(-15);
            make.centerY.equalTo(cir2);
            make.left.greaterThanOrEqualTo(lab2.mas_right).offset(10);
        }];
    }
    return _silderDetail;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [UILabel new];
        _labTime.textColor = COLOR_B4;
        _labTime.font = FONT_F13;
        _labTime.textAlignment = NSTextAlignmentCenter;
    }
    return _labTime;
}

- (UILabel *)labTotal {
    if (!_labTotal) {
        _labTotal = [UILabel new];
        _labTotal.font = FONT_F15;
        _labTotal.textColor = COLOR_B1;
        //        _labTotal.text = @"¥ 120万";
    }
    return _labTotal;
}

- (UILabel *)labArrear {
    if (!_labArrear) {
        _labArrear = [UILabel new];
        _labArrear.font = FONT_F15;
        _labArrear.textColor = COLOR_B1;
        //        _labArrear.text = @"¥ 90万";
    }
    return _labArrear;
}

- (NSMutableArray *)arrContenBeans {
    if (!_arrContenBeans) {
        _arrContenBeans = [NSMutableArray new];
    }
    return _arrContenBeans;
}

- (UIButton *)btnNoti {
    if (!_btnNoti) {
        _btnNoti = [[UIButton alloc] init];
        [_btnNoti setTitle:@"多次催款未成功" forState:UIControlStateNormal];
        [_btnNoti addTarget:self action:@selector(btnNotiClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnNoti.titleLabel.font = FONT_F13;
        [_btnNoti setTitleColor:COLOR_1893D5 forState:UIControlStateNormal];
        _btnNoti.layer.cornerRadius = 14.0;
        _btnNoti.layer.borderColor = COLOR_1893D5.CGColor;
        _btnNoti.layer.borderWidth = 0.5;
        _btnNoti.clipsToBounds = YES;
    }
    return _btnNoti;
}


@end

#pragma mark - TrendsCardView

@interface TrendsCardView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *baseView;

@end

@implementation TrendsCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self addSubview:self.titleView];
    [self addSubview:self.tableView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(16);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.baseView);
        make.top.equalTo(self.titleView.mas_bottom).offset(12.5);
        make.bottom.equalTo(self.baseView.mas_bottom).offset(-12.5);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mo.intelligenceItemBeans.count == 0? 1 : _mo.intelligenceItemBeans.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TrendsCardCell";
    TrendsCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TrendsCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (_mo.intelligenceItemBeans.count == 0) {
        cell.labLeft.text = @"暂无";
        cell.labRight.text = @"";
    } else {
        IntelligenceItemBeanMo *riskMo = _mo.intelligenceItemBeans[indexPath.row];
        cell.labLeft.text = riskMo.intelligenceInfoValue;
        cell.labRight.text = riskMo.content;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CUSTOMER_360_SELECT object:nil userInfo:@{@"section": [NSNumber numberWithInteger:0],@"item": [NSNumber numberWithInteger:5]}];
}

- (void)refreshView:(MemberCenterMo *)mo {
    _mo = mo;
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_mo.intelligenceItemBeans.count==0 ? 30 : 30*_mo.intelligenceItemBeans.count));
    }];
    [self.tableView reloadData];
    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 10;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        UILabel *lab = [UILabel new];
        lab.font = FONT_F14;
        lab.textColor = COLOR_B1;
        lab.text = @"企业动态";
        [_titleView addSubview:lab];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView);
            make.height.equalTo(@15);
            make.width.equalTo(@3);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.equalTo(_titleView);
        }];
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end

#pragma mark - MonthCardView

@interface MonthCardView () <ChartViewDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *labItem1;
@property (nonatomic, strong) UIView *labItem2;
@property (nonatomic, strong) UIView *labItem3;
@property (nonatomic, strong) UIView *labItem4;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) BarChartView *chartView;
@property (nonatomic, strong) NSArray *arrColor;

@end

@implementation MonthCardView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        _arrColor = @[COLOR_EDBB57, COLOR_5BAAF9, COLOR_6BCE6C, COLOR_ED7674];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.titleView];
    [self.baseView addSubview:self.labItem1];
    [self.baseView addSubview:self.labItem2];
    [self.baseView addSubview:self.labItem3];
    [self.baseView addSubview:self.labItem4];
    [self.baseView addSubview:self.chartView];
    [self.baseView addSubview:self.labTitle];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.height.equalTo(@285);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(16);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@15);
    }];
    
    [self.labItem1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(25);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.baseView.mas_centerX).offset(-5);
        make.height.equalTo(@40);
    }];
    
    [self.labItem2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labItem1.mas_bottom).offset(15);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.labItem1);
        make.height.equalTo(self.labItem1);
    }];
    
    [self.labItem3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labItem2.mas_bottom).offset(15);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.labItem1);
        make.height.equalTo(self.labItem1);
    }];

    [self.labItem4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labItem3.mas_bottom).offset(15);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.labItem1);
        make.height.equalTo(self.labItem1);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labItem1);
        make.centerX.equalTo(self.chartView);
    }];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.equalTo(self.baseView.mas_centerX);
        make.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-10);
    }];
}

#pragma mark - ChartViewDelegate

- (NSArray *)chartViewAtIndexes:(NSIndexSet *)indexes {
    return @[@"计划", @"实发" , @"开票", @"回款"];
}

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    
}

- (void)chartTranslated:(ChartViewBase *)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
    
}


- (void)chartValueNothingSelected:(ChartViewBase *)chartView {
    
}

- (void)chartScaled:(ChartViewBase *)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    
}

- (void)setupItem:(UIView *)itemView circleColor:(UIColor *)circleColor title:(NSString *)title msg:(NSString *)msg {
    UIView *circle = [itemView viewWithTag:1];
    circle.backgroundColor = circleColor;
    UILabel *labTitle = [itemView viewWithTag:2];
    labTitle.text = title;
    UILabel *labMsg = [itemView viewWithTag:3];
    labMsg.text = msg;
}

- (void)refreshView:(MemberCenterMo *)mo {
    _mo = mo;
    
    
    NSArray *months = @[@"合同", @"发货"];
//    NSArray *dataY = @[@(100), @(_mo.contractShip * 100)];
    NSArray *dataY = @[@(_mo.contractSumMonth), @(_mo.orderSumMounth)];
    
    [self setDataX:months dataY:dataY];
    [self setupItem:self.labItem1 circleColor:_arrColor[0] title:@"合同数量" msg:[NSString stringWithFormat:@"%.fMW", _mo.contractSumMonth]];
    [self setupItem:self.labItem2 circleColor:_arrColor[1] title:@"发货数量" msg:[NSString stringWithFormat:@"%.fMW", _mo.orderSumMounth]];
    
//    NSArray *months = @[@"合同", @"订单" , @"开票", @"回款"];
//    NSArray *dataY = @[@(_mo.contractShip * 100), @(_mo.orderShip * 100), @(_mo.billingShip * 100), @(_mo.receivedShip * 100)];
//
//    [self setDataX:months dataY:dataY];
//    [self setupItem:self.labItem1 circleColor:_arrColor[0] title:@"合同总量" msg:[NSString stringWithFormat:@"%.fMW", _mo.contractSumMonth]];
//    [self setupItem:self.labItem2 circleColor:_arrColor[1] title:@"订单数量" msg:[NSString stringWithFormat:@"%.fMW", _mo.orderSumMounth]];
//    [self setupItem:self.labItem3 circleColor:_arrColor[2] title:@"开票数量" msg:[NSString stringWithFormat:@"%.f元", _mo.billingSumMonth]];
//    [self setupItem:self.labItem4 circleColor:_arrColor[3] title:@"回款数量" msg:[NSString stringWithFormat:@"%.f元", _mo.receivedSumMonth]];
    self.labTitle.text = _mo.title;
}

#pragma mark - setter getter

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B3;
    }
    return _labTitle;
}
- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 10;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        UILabel *lab = [UILabel new];
        lab.font = FONT_F14;
        lab.textColor = COLOR_B1;
        lab.text = @"本月合同执行情况";
        [_titleView addSubview:lab];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView);
            make.height.equalTo(@15);
            make.width.equalTo(@3);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.equalTo(_titleView);
        }];
    }
    return _titleView;
}

- (BarChartView *)chartView {
    if (!_chartView) {
        _chartView = [[BarChartView alloc] init];
        _chartView.delegate = self;
        _chartView.noDataText = @"暂无数据";//没有数据时的文字提示
        _chartView.drawBarShadowEnabled = NO;
        _chartView.drawValueAboveBarEnabled = YES;
        _chartView.dragEnabled = NO;
        _chartView.rightAxis.enabled = NO;//不绘制右边轴
        [_chartView setScaleEnabled:NO];
        
        _chartView.chartDescription.enabled = NO;
        _chartView.maxVisibleCount = 60;
        
        ChartXAxis *xAxis = _chartView.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.labelFont = [UIFont systemFontOfSize:10.f];
        xAxis.drawGridLinesEnabled = NO;
        xAxis.granularity = 1.0; // only intervals of 1 day
        xAxis.labelCount = 7;
        
        //        xAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithValues:@[@"计划", @"实发" , @"开票", @"回款"]];
        //        xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:_chartView];
        
        NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
        leftAxisFormatter.minimumFractionDigits = 0;
        leftAxisFormatter.maximumFractionDigits = 1;
        leftAxisFormatter.minimumIntegerDigits = 1;
//        leftAxisFormatter.negativeSuffix = @"%";
//        leftAxisFormatter.positiveSuffix = @"%";
        
        NSNumberFormatter *rightAxisFormatter = [[NSNumberFormatter alloc] init];
        rightAxisFormatter.minimumFractionDigits = 0;
        rightAxisFormatter.maximumFractionDigits = 2;
        rightAxisFormatter.minimumIntegerDigits = 1;
        
        ChartYAxis *leftAxis = _chartView.leftAxis;
        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
        leftAxis.labelCount = 8;
        
//        ChartYAxis *rightAxis = _chartView.rightAxis;
//        rightAxis.drawGridLinesEnabled = NO;
//        rightAxis.axisMinimum = 0.0;
//        rightAxis.drawGridLinesEnabled = NO;
//        rightAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:rightAxisFormatter];
        //        rightAxis.axisMaximum = 50;
        
        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        leftAxis.spaceTop = 0.15;
        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
//        leftAxis.axisMaximum = 100.0;
        
        //        ChartYAxis *rightAxis = _chartView.rightAxis;
        //        rightAxis.enabled = YES;
        //        rightAxis.drawGridLinesEnabled = NO;
        //        rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
        //        rightAxis.labelCount = 8;
        //        rightAxis.valueFormatter = leftAxis.valueFormatter;
        //        rightAxis.spaceTop = 0.15;
        //        rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
        
        ChartLegend *l = _chartView.legend;
        //        l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
        //        l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
        //        l.orientation = ChartLegendOrientationHorizontal;
        //        l.drawInside = NO;
        l.form = ChartLegendFormNone;
        
        //        l.formSize = 9.0;
        //        l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
        //        l.xEntrySpace = 4.0;
        
        //        _chartView.data = setData];
        
        //        XYMarkerView *marker = [[XYMarkerView alloc]
        //                                initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
        //                                font: [UIFont systemFontOfSize:12.0]
        //                                textColor: UIColor.whiteColor
        //                                insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
        //                                xAxisValueFormatter: _chartView.xAxis.valueFormatter];
        //        marker.chartView = _chartView;
        //        marker.minimumSize = CGSizeMake(80.f, 40.f);
        //        _chartView.marker = marker;
        //
        //        _sliderX.value = 12.0;
        //        _sliderY.value = 50.0;
        //        [self slidersValueChanged:nil];
    }
    return _chartView;
}

//为柱形图设置数据
- (void)setDataX:(NSArray *)dataX dataY:(NSArray *)dataY {
    
    _chartView.xAxis.valueFormatter = [[XValueFormatter alloc] initWithArr:dataX];
    
    NSMutableArray<BarChartDataEntry *> *entries1 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < dataX.count; i++)
    {
        [entries1 addObject:[[BarChartDataEntry alloc] initWithX:i y:[dataY[i] floatValue]]];
    }
    
    BarChartDataSet *set1 = nil;
    
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set1.values = entries1;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:entries1 label:@""];
        set1.valueTextColor = COLOR_B2;
        set1.colors = _arrColor;
        set1.valueFont = [UIFont systemFontOfSize:10.f];
        set1.axisDependency = AxisDependencyLeft;
        
//        BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithValues:entries2 label:@""];
//        set2.stackLabels = @[@"Stack 1", @"Stack 2"];
//        set2.valueColors = @[_arrColor[2], _arrColor[3]];
//        set2.colors = @[_arrColor[2], _arrColor[3]];
//        set2.valueFont = [UIFont systemFontOfSize:10.f];
//        set2.axisDependency = AxisDependencyRight;
        BarChartData *data = [[BarChartData alloc] initWithDataSet:set1];
        _chartView.data = data;
    }
}

- (UIView *)labItem1 {
    if (!_labItem1) {
        _labItem1 = [self setupItem];
    }
    return _labItem1;
}

- (UIView *)labItem2 {
    if (!_labItem2) {
        _labItem2 = [self setupItem];
    }
    return _labItem2;
}

- (UIView *)labItem3 {
    if (!_labItem3) {
        _labItem3 = [self setupItem];
    }
    return _labItem3;
}

- (UIView *)labItem4 {
    if (!_labItem4) {
        _labItem4 = [self setupItem];
    }
    return _labItem4;
}

- (UIView *)setupItem {
    UIView *item = [[UIView alloc] init];
    UIView *circle = [UIView new];
    circle.layer.cornerRadius = 4;
    circle.clipsToBounds = YES;
    circle.tag = 1;
    [item addSubview:circle];
    
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.font = FONT_F14;
    labTitle.textColor = COLOR_B2;
    labTitle.tag = 2;
    [item addSubview:labTitle];
    
    UILabel *labMsg = [[UILabel alloc] init];
    labMsg.font = FONT_F14;
    labMsg.textColor = COLOR_B1;
    labMsg.tag = 3;
    [item addSubview:labMsg];
    
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(item);
        make.centerY.equalTo(labTitle);
        make.width.height.equalTo(@8);
    }];
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circle.mas_right).offset(9);
        make.top.equalTo(item);
        make.right.equalTo(item);
    }];
    
    [labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(labTitle);
        make.top.equalTo(labTitle.mas_bottom).offset(10);
        make.bottom.equalTo(item);
    }];
    
    return item;
}

@end



#pragma mark - TrendsCardCell

@interface TrendsCardCell ()

@end

@implementation TrendsCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labLeft];
    [self.contentView addSubview:self.labRight];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(27);
        make.width.equalTo(@70);
    }];
    
    [self.labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.labLeft.mas_right).offset(5);
        make.right.lessThanOrEqualTo(self.contentView).offset(-27);
    }];
}

#pragma mark - lazy

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [UILabel new];
        _labLeft.textColor = COLOR_B1;
        _labLeft.font = FONT_F14;
    }
    return _labLeft;
}

- (UILabel *)labRight {
    if (!_labRight) {
        _labRight = [UILabel new];
        _labRight.textColor = COLOR_B2;
        _labRight.font = FONT_F14;
    }
    return _labRight;
}


@end

#pragma mark - RadarCardView

@interface RadarCardView () <ChartViewDelegate, IChartAxisValueFormatter, IChartMarker>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *labTitle;
//@property (nonatomic, strong) RadarChartView *chartView;
@property (nonatomic, strong) RadarMapCompleteView *radarView;
@property (nonatomic, strong) ElementItem *item;
@property (nonatomic, strong) NSMutableArray *arrTitles;
@property (nonatomic, strong) UIButton *btnAssist;
@end

@implementation RadarCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
        [self setChartData];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.labTitle];
    [self.baseView addSubview:self.radarView];
    [self.baseView addSubview:self.btnAssist];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(25);
    }];
    
    [self.radarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.labTitle.mas_bottom).offset(5);
        make.left.equalTo(self.baseView).offset(5);
        make.right.equalTo(self.baseView).offset(-5);
        make.bottom.equalTo(self.baseView).offset(0);
        make.height.equalTo(_radarView.mas_width).multipliedBy(0.8);
    }];
    
    [self.btnAssist mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTitle);
        make.width.height.equalTo(@40);
        make.left.equalTo(self.labTitle.mas_right).offset(30);
    }];
        
//    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.baseView);
//        make.top.equalTo(self.labTitle.mas_bottom).offset(5);
//        make.left.equalTo(self.baseView).offset(5);
//        make.right.equalTo(self.baseView).offset(-5);
//        make.bottom.equalTo(self.baseView).offset(60);
//        make.height.equalTo(_chartView.mas_width);
//    }];
}

- (void)refreshView:(NSMutableArray *)radar {
    if (radar.count == 0) {
        self.arrRadar = nil;
    } else {
        self.arrRadar = radar;
    }
    [self setChartData];
}

- (void)setChartData {
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *arrtitle = [NSMutableArray new];
    for (int i = 0; i < self.arrRadar.count; i++) {
        RadarMo *radarMo = self.arrRadar[i];
        NSString *str = [NSString stringWithFormat:@"%.2f", radarMo.fieldValue/100];
        [arr addObject:str];
        [arrtitle addObject:STRING(radarMo.field)];
    }
    self.item.itemPercent = arr;
    self.arrTitles = arrtitle;
    [self.radarView updateItemName:self.arrTitles];
    [self.radarView addAbilitysWithElements:@[self.item]];
    [self layoutIfNeeded];
}

//- (void)setChartData {
//    NSMutableArray *entries1 = [[NSMutableArray alloc] init];
//    for (int i = 0; i < self.arrRadar.count; i++)
//    {
//        RadarMo *radarMo = self.arrRadar[i];
//        [entries1 addObject:[[RadarChartDataEntry alloc] initWithValue:radarMo.fieldValue]];
//    }
//
//    RadarChartDataSet *set1 = nil;
//
//    if (_chartView.data.dataSetCount > 0) {
//        set1 = (RadarChartDataSet *)_chartView.data.dataSets[0];
//        set1.values = entries1;
//        [_chartView.data notifyDataChanged];
//        [_chartView notifyDataSetChanged];
//    } else {
//
//        RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithValues:entries1 label:@""];
//
//        [set1 setColor:COLOR_4290F7];
//        set1.fillColor = COLOR_4290F7;
//        set1.drawFilledEnabled = YES;
//        set1.fillAlpha = 0.3;
//        set1.lineWidth = 2.0;
//        set1.drawHighlightCircleEnabled = YES;
//        [set1 setDrawHighlightIndicators:NO];
//
//        RadarChartData *data = [[RadarChartData alloc] initWithDataSets:@[set1]];
//        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue" size:10.f]];
//        [data setDrawValues:YES];
//        data.valueTextColor = COLOR_4290F7;
//        _chartView.data = data;
//    }
//    [_chartView setNeedsDisplay];
//}

#pragma mark - ChartViewDelegate

//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//    NSLog(@"chartValueSelected");
//}
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//    NSLog(@"chartValueNothingSelected");
//}

#pragma mark - IAxisValueFormatter

//- (NSString *)stringForValue:(double)value
//                        axis:(ChartAxisBase *)axis
//{
//    RadarMo *radarMo = self.arrRadar[(int) value % self.arrRadar.count];
//    return radarMo.field;
//}

#pragma mark - IChartMarker

#pragma mark - event

- (void)btnAssistClick:(UIButton *)sender {
//    TestViewController *vc = [[TestViewController alloc] init];
//    vc.createBlock = ^(id  _Nonnull param, id  _Nonnull attachement) {
//        NSLog(@"param = %@", param);
//        NSLog(@"attachement = %@", attachement);
//    };
//    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
//    return;
    
    [[JYUserApi sharedInstance] getConfigDicByName:@"radar_url" success:^(id responseObject) {
        NSArray *arr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
        for (int i = 0 ; i < arr.count; i++) {
            DicMo *dicMo = arr[i];
            if ([dicMo.key isEqualToString:@"radar_detail_url"]) {
                if (dicMo.value.length > 0) {
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@loginid=%ld&officeName=%@&token=%@", dicMo.value,[dicMo.value containsString:@"?"]?@"&":@"?", (long)TheUser.userMo.id, [Utils officeName], [Utils token]];
                    BaseWebViewCtrl *vc = [[BaseWebViewCtrl alloc] init];
                    vc.urlStr = urlStr;
                    vc.titleStr = @"客户信息总览说明";
                    vc.hidesBottomBarWhenPushed = YES;
                    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
                }
                return;
            }
        }
    } failure:^(NSError *error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - lazy

//- (RadarChartView *)chartView {
//    if (!_chartView) {
//        _chartView = [[RadarChartView alloc] init];
//        _chartView.delegate = self;
//
//        _chartView.chartDescription.enabled = NO;
//        _chartView.webLineWidth = 1.0;
//        _chartView.innerWebLineWidth = 1.0;
//        _chartView.webColor = COLOR_8998A4;
//        _chartView.innerWebColor = COLOR_8998A4;
//        _chartView.webAlpha = 0.5;
//
//        ChartXAxis *xAxis = _chartView.xAxis;
//        xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
//        xAxis.xOffset = 0.0;
//        xAxis.yOffset = 0.0;
//        xAxis.valueFormatter = self;
//        xAxis.labelTextColor = COLOR_B1;
//
//        ChartYAxis *yAxis = _chartView.yAxis;
//        yAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.f];
//        yAxis.labelCount = 5;
//        yAxis.axisMinimum = 0.0;
////        yAxis.axisMaximum = 60;
////        [yAxis resetCustomAxisMax];
//        yAxis.drawLabelsEnabled = YES;
//
//        ChartLegend *l = _chartView.legend;
//        l.form = ChartLegendFormNone;
//
////        [_chartView animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
//    }
//    return _chartView;
//}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 10;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.textColor = COLOR_B1;
        _labTitle.font = FONT_F16;
        _labTitle.text = @"客户信息总览";
    }
    return _labTitle;
}


- (NSMutableArray *)arrRadar {
    if (!_arrRadar) {
        _arrRadar = [[NSMutableArray alloc] init];
        NSArray *arr = @[@" ", @" ", @" ", @" ", @" "];
        for (int i = 0; i < arr.count; i++) {
            RadarMo *radar = [[RadarMo alloc] init];
            radar.field = arr[i];
            radar.fieldValue = 0;
            [_arrRadar addObject:radar];
        }
    }
    return _arrRadar;
}

- (ElementItem *)item {
    if (!_item) {
        _item = [[ElementItem alloc]init];
        _item.itemPercent = @[@"0",@"0",@"0",@"0",@"0"];
        _item.itemColor = COLOR_4290F7;
//        _item.itemName = @"基础综合";
    }
    return _item;
}
- (RadarMapCompleteView *)radarView {
    if (!_radarView) {
        _radarView = [[RadarMapCompleteView alloc] initWithRadarElements:self.arrTitles lengthColor:COLOR_8998A4];
//        radar.content = @"能力测评能力测评能力测评能力测评能力测评能力测评能力测评能力测评";
    }
    return _radarView;
}

- (NSMutableArray *)arrTitles {
    if (!_arrTitles){
        _arrTitles = [[NSMutableArray alloc] initWithObjects:@"信息完整度", @"用量", @"忠诚度", @"信贷得分", @"盈利贡献", nil];
    }
    return _arrTitles;
}

- (UIButton *)btnAssist {
    if (!_btnAssist) {
        _btnAssist = [[UIButton alloc] init];
        [_btnAssist setImage:[UIImage imageNamed:@"assist"] forState:UIControlStateNormal];
        [_btnAssist addTarget:self action:@selector(btnAssistClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAssist;
}

@end



#pragma mark - PostCardView

@interface PostCardView () <ChartViewDelegate>

@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIView *baseView;


@end

@implementation PostCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
        self.backgroundColor = COLOR_CLEAR;
    }
    return self;
}


- (void)setUI {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.labTitle];
    [self.baseView addSubview:self.chartView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(10);
    }];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.labTitle.mas_bottom).offset(5);
        make.left.equalTo(self.baseView).offset(5);
        make.height.equalTo(_chartView.mas_width).multipliedBy(0.6);
        make.bottom.equalTo(self.baseView);
    }];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
    
    [_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
    //[_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    //[_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

#pragma mark - public

- (void)loadDataWith:(NSDictionary *)model {
    NSMutableArray *months = [NSMutableArray new];
    NSMutableArray *dataY = [NSMutableArray new];
    
    for (NSDictionary *dic in model[@"list"]) {
        [months addObject:STRING(dic[@"field"])];
        [dataY addObject:STRING(dic[@"fieldValue"])];
    }
    
    [self setDataX:months dataY:dataY];
    self.labTitle.text = model[@"title"];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 10;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B2;
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}

- (LineChartView *)chartView {
    if (!_chartView) {
        _chartView = [[LineChartView alloc] init];
        _chartView.delegate = self;
        // 标题
        _chartView.chartDescription.enabled = NO;
        //        _chartView.chartDescription.text = @"2017年度月欠款走势图(万元)";
        //        _chartView.chartDescription.font = FONT_F4;
        
        _chartView.dragEnabled = NO;
        [_chartView setScaleEnabled:NO];
        _chartView.drawGridBackgroundEnabled = NO;
        _chartView.pinchZoomEnabled = NO;
        _chartView.rightAxis.enabled = NO;//不绘制右边轴
        
        _chartView.backgroundColor = [UIColor whiteColor];
        
        ChartLegend *l = _chartView.legend;
        l.form = ChartLegendFormNone;
        l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
        l.textColor = UIColor.blackColor;
        l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
        l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
        l.orientation = ChartLegendOrientationHorizontal;
        l.drawInside = NO;
        
        // x轴属性
        ChartXAxis *xAxis = _chartView.xAxis;
        xAxis.labelFont = [UIFont systemFontOfSize:11.f];
        xAxis.labelTextColor = [UIColor grayColor];
        xAxis.drawGridLinesEnabled = NO;
        xAxis.drawAxisLineEnabled = NO;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        
        // y轴属性
        ChartYAxis *leftAxis = _chartView.leftAxis;
        leftAxis.labelTextColor = [UIColor grayColor];
        //        leftAxis.axisMaximum = 200.0;
        leftAxis.axisMinimum = 0.0;
        leftAxis.drawGridLinesEnabled = YES;
        leftAxis.drawZeroLineEnabled = NO;
        leftAxis.granularityEnabled = YES;
        [_chartView animateWithXAxisDuration:2.5];
    }
    return _chartView;
}

- (void)setDataX:(NSArray *)dataX dataY:(NSArray *)dataY
{
    
    //X轴上面需要显示的数据
    _chartView.xAxis.valueFormatter = [[XValueFormatter alloc] initWithArr:dataX];
    
    // y轴需要显示的数据
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataX.count; i++) {
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i y:[dataY[i] floatValue]]];
    }
    
    LineChartDataSet *set1 = nil;
    
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals1;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:nil];
        set1.axisDependency = AxisDependencyLeft;
        [set1 setColor:[UIColor grayColor]];
        [set1 setCircleColor:[UIColor grayColor]];
        set1.lineWidth = 2.0;
        set1.circleRadius = 3.0;
        //        set1.circleHoleColor = [UIColor redColor];
        set1.fillAlpha = 65/255.0;
        set1.fillColor = [UIColor grayColor];
        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set1.drawCircleHoleEnabled = YES;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.blackColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];
        _chartView.data = data;
    }
}

@end
