//
//  PurchaseListTitleView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchaseListTitleView.h"

@interface PurchaseListTitleView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation PurchaseListTitleView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.lineView];
    [self addSubview:self.labTitle];
    [self addSubview:self.btnAdd];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@3.0);
        make.height.equalTo(@14.0);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.lineView.mas_right).offset(5);
    }];
    
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
}

#pragma mark - public

- (void)setupTitle:(NSString *)title count:(NSInteger)count {
    self.labTitle.text = [NSString stringWithFormat:@"%@(%ld)", title, (long)count];
}

- (void)itemAddClick:(UIButton *)sender {
    NSLog(@"---点击了");
}

#pragma mark - lazy

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [[UIButton alloc] init];
        _btnAdd.titleLabel.font = FONT_F14;
        [_btnAdd setImage:[UIImage imageNamed:@"purchasePlus"] forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(itemAddClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAdd;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = COLOR_B1;
        _labTitle.font = FONT_F15;
    }
    return _labTitle;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 14)];
        _lineView.backgroundColor = COLOR_C1;
        _lineView.layer.mask = [Utils drawContentFrame:_lineView.bounds corners:UIRectCornerAllCorners cornerRadius:1.5];
    }
    return _lineView;
}

@end
