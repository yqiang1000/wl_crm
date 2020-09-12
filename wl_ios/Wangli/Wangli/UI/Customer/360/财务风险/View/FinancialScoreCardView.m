//
//  FinancialScoreCardView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "FinancialScoreCardView.h"

@interface FinancialScoreCardView ()

@property (nonatomic, strong) UIButton *btnScore;

@end

@implementation FinancialScoreCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)setUI {
    [self addSubview:self.btnScore];
    
    [self.btnScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@40.0);
    }];
}

#pragma mark - lazy

- (UIButton *)btnScore {
    if (!_btnScore) {
        _btnScore = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 40)];
        NSString *str = [NSString stringWithFormat:@"客户信用评级:%@", TheCustomer.centerMo.creditLevelValue.length == 0 ? @"暂无" : TheCustomer.centerMo.creditLevelValue];
        [_btnScore setTitle:str forState:UIControlStateNormal];
        [_btnScore setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btnScore setBackgroundColor:COLOR_B4];
        _btnScore.titleLabel.font = FONT_F14;
        _btnScore.layer.mask = [Utils drawContentFrame:_btnScore.bounds corners:UIRectCornerAllCorners cornerRadius:5];
        _btnScore.clipsToBounds = YES;
    }
    return _btnScore;
}

@end
