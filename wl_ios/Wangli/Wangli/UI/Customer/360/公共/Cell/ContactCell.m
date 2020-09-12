//
//  ContactCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ContactCell.h"

#pragma mark - ContactCell

@interface ContactCell ()

@end

@implementation ContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_B4;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgHeader];
    [self.contentView addSubview:self.labName];
    [self.contentView addSubview:self.labOrg];
    [self.contentView addSubview:self.labPart];
    [self.contentView addSubview:self.labJob];
    [self.contentView addSubview:self.lineView];
    
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@50);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14);
        make.left.equalTo(self.imgHeader.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.labJob.mas_left).offset(-10);
    }];
    
    [self.labOrg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-14);
        make.left.equalTo(self.labName);
        make.right.lessThanOrEqualTo(self.labPart.mas_left).offset(-10);
    }];
    
    [self.labJob mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labName);
        make.left.equalTo(self.contentView.mas_right).offset(-100);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    [self.labPart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labOrg);
        make.left.equalTo(self.contentView.mas_right).offset(-100);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - public

- (void)loadDataWith:(id)model {
    if (_model != model) {
        _model = model;
    }
    
    if ([_model isKindOfClass:[ContactMo class]]) {
        ContactMo *mo = (ContactMo *)_model;
        NSLog(@"---deleteMo11---%@", mo.name);
        //    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:_model.avator] placeholderImage:nil];
        self.imgHeader.image = [UIImage imageNamed:@"client_default_avatar"];
        self.labName.text = mo.name;
        self.labOrg.text = mo.memberReadBean[@"orgName"];
        self.labPart.text = mo.office[@"name"];
        self.labJob.text = mo.duty;
    } else if ([_model isKindOfClass:[JYUserMo class]]) {
        JYUserMo *mo = (JYUserMo *)_model;
        NSLog(@"---deleteMo22---%@", mo.name);
        //    [self.imgHeader sd_setImageWithURL:[NSURL URLWithString:_model.avator] placeholderImage:nil];
        self.imgHeader.image = [UIImage imageNamed:@"client_default_avatar"];
        self.labName.text = mo.name;
        self.labOrg.text = @"浙江王力集团有限公司";
        self.labPart.text = STRING(mo.department[@"name"]);
        self.labJob.text = STRING(mo.position[@"desp"]);
    }
}

#pragma mark - setter and getter

- (UIImageView *)imgHeader {
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        CAShapeLayer *layer = [Utils drawContentFrame:_imgHeader.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft
                               | UIRectCornerBottomRight cornerRadius:25];
        _imgHeader.layer.mask = layer;
        _imgHeader.backgroundColor = COLOR_B0;
    }
    return _imgHeader;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [[UILabel alloc] init];
        _labName.textColor = COLOR_B1;
        _labName.font = FONT_F17;
    }
    return _labName;
}

- (UILabel *)labOrg {
    if (!_labOrg) {
        _labOrg = [[UILabel alloc] init];
        _labOrg.textColor = COLOR_B2;
        _labOrg.font = FONT_F14;
        _labOrg.numberOfLines = 0;
    }
    return _labOrg;
}

- (UILabel *)labPart {
    if (!_labPart) {
        _labPart = [[UILabel alloc] init];
        _labPart.textColor = COLOR_336699;
        _labPart.font = FONT_F12;
        _labPart.numberOfLines = 0;
    }
    return _labPart;
}

- (UILabel *)labJob {
    if (!_labJob) {
        _labJob = [[UILabel alloc] init];
        _labJob.textColor = COLOR_B3;
        _labJob.font = FONT_F12;
    }
    return _labJob;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end


#pragma mark - MyCommonHeaderView

@interface MyCommonHeaderView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation MyCommonHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier isHidenLine:(BOOL)isHidenLine {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _isHidenLine = isHidenLine;
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    if (!_isHidenLine) {
        [self.contentView addSubview:self.lineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@17.5);
            make.width.equalTo(@3);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
    }
    
    [self.contentView addSubview:self.labLeft];
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        if (_isHidenLine) {
            make.left.equalTo(self.contentView).offset(15);
        } else {
            make.left.equalTo(self.lineView.mas_right).offset(7);
        }
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
}

- (void)setIsHidenLine:(BOOL)isHidenLine {
    self.lineView.hidden = isHidenLine;
}

#pragma mark - setter getter

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [[UILabel alloc] init];
        _labLeft.textColor = COLOR_B1;
        _labLeft.font = FONT_F16;
    }
    return _labLeft;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_C1;
        _lineView.layer.cornerRadius = 1.5;
        _lineView.clipsToBounds = YES;
    }
    return _lineView;
}

@end

