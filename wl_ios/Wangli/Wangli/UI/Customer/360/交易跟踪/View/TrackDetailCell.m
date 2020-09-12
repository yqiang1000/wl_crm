//
//  TrackDetailCell.m
//  Wangli
//
//  Created by yeqiang on 2018/6/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrackDetailCell.h"
//#import "MLLinkLabel.h"
#import "WebDetailViewCtrl.h"

@interface TrackDetailCell ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UILabel *labRight;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation TrackDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.contentView addSubview:self.labLeft];
    [self.contentView addSubview:self.labRight];
    [self.contentView addSubview:self.lineView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(110);
        make.bottom.top.equalTo(self.baseView);
        make.width.equalTo(@0.5);
    }];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView);
        make.centerY.equalTo(self.baseView);
        make.right.equalTo(self.lineView.mas_left).offset(-11);
    }];
    
    [self.labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView);
        make.centerY.equalTo(self.baseView);
        make.left.equalTo(self.lineView.mas_right).offset(11);
    }];
}

- (void)loadData:(CusInfoDetailMo *)mo {
    if (_mo != mo) {
        _mo = mo;
    }
    self.labLeft.text = _mo.leftContent;
    self.labRight.text = _mo.rightContent;
    self.labRight.textColor = COLOR_B1;
    // 司机电话
    if ([_mo.field isEqualToString:@"driverPhone"]) {
        self.labRight.textColor = COLOR_C1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _labRight.userInteractionEnabled = YES;
        [_labRight addGestureRecognizer:tap];

//        [self.labRight addLinkWithType:MLLinkTypeOther value:nil range:NSMakeRange(0, self.labRight.text.length)];
//        [self.labRight setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//            NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@", linkText];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
//        }];
    }
    else if (_mo.url.length != 0) {
        self.labRight.textColor = COLOR_C1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _labRight.userInteractionEnabled = YES;
        [_labRight addGestureRecognizer:tap];
        
//        [self.labRight addLinkWithType:MLLinkTypeOther value:nil range:NSMakeRange(0, self.labRight.text.length)];
//        __weak typeof(self) weakSelf = self;
//
//        [self.labRight setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//            NSLog(@"long ---- %@", linkText);
//            [weakSelf pushToH5:linkText];
//        }];
    }
}

- (void)tapAction:(UIGestureRecognizer *)tap {
    if ([_mo.field isEqualToString:@"driverPhone"]) {
        NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@", _labRight.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    } else {
        [self pushToH5:_labRight.text];
    }
}
                                       
- (void)pushToH5:(NSString *)url {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@loginid=%ld&officeName=%@&token=%@", url,[url containsString:@"?"]?@"&":@"?", (long)TheUser.userMo.id, [Utils officeName], [Utils token]];
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.urlStr = urlStr;
    vc.titleStr = _mo.leftContent;
    vc.hidesBottomBarWhenPushed = YES;
    UIViewController *viewCtrl = [Utils topViewController];
    if (viewCtrl.navigationController) {
        [viewCtrl.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.borderColor = COLOR_LINE.CGColor;
        _baseView.layer.borderWidth = 0.5;
    }
    return _baseView;
}

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [[UILabel alloc] init];
//        _labLeft.dataDetectorTypes = MLDataDetectorTypeNone;
        _labLeft.font = FONT_F12;
        _labLeft.textColor = COLOR_B2;
        _labLeft.numberOfLines = 0;
        _labLeft.textAlignment = NSTextAlignmentRight;
    }
    return _labLeft;
}

- (UILabel *)labRight {
    if (!_labRight) {
        _labRight = [[UILabel alloc] init];
//        _labRight.dataDetectorTypes = MLDataDetectorTypeNone;
        _labRight.font = FONT_F12;
        _labRight.textColor = COLOR_B1;
    }
    return _labRight;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

@end
