//
//  FinancialCompanyCardView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "FinancialCompanyCardView.h"

@interface FinancialCompanyCardView ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIButton *btnDetail;

@end

@implementation FinancialCompanyCardView

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
    [self.baseView addSubview:self.tableView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.baseView);
    }];
}

#pragma mark - public

- (void)creditFiftyRefreshView {
    self.tableView.arrData = self.arrData;
    CGFloat height = 0;
    for (int i = 0; i < self.arrData.count; i++) {
        CreditDebtMo *tmpMo = self.arrData[i];
        height = height+49+32+25*tmpMo.companyList.count+53+10;
        if (i == self.arrData.count - 1) {
            height = height - 10;
        }
    }
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    [self.tableView reloadData];
    [self layoutIfNeeded];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 4;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (CreditDebtTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CreditDebtTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = COLOR_B0;
    }
    return _tableView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}


@end
