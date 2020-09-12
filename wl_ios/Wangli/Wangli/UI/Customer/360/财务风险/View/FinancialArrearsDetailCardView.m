//
//  FinancialArrearsDetailCardView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "FinancialArrearsDetailCardView.h"
#import "UIButton+ShortCut.h"

@interface FinancialArrearsDetailCardView ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation FinancialArrearsDetailCardView

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
    [self.baseView addSubview:self.titleView];
    [self.baseView addSubview:self.tableView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.baseView);
        make.height.equalTo(@49);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(-5);
        make.bottom.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-10);
    }];
}

#pragma mark - public

- (void)loadDataWith:(NSDictionary *)model {
    if (model.count == 0 || model.count != 2) {
        return;
    }
    CreditMo *titleMo = [[CreditMo alloc] initWithDictionary:model[@"title"] error:nil];
    NSMutableArray *arr = [CreditMo arrayOfModelsFromDictionaries:model[@"list"] error:nil];
    self.labTitle.text = titleMo.field;
    self.tableView.arrData = arr;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(25*arr.count));
    }];
    [self.tableView reloadData];
}

- (void)btnMoreClick:(UIButton *)sender {
    if (_btnDetailBlock) {
        _btnDetailBlock();
    }
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

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_titleView addSubview:self.labTitle];
        [_titleView addSubview:self.btnDetail];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView).offset(13);
            make.height.equalTo(@15);
            make.width.equalTo(@3);
        }];
        
        [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.equalTo(_btnDetail.mas_left).offset(-10);
        }];
        
        [self.btnDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.right.equalTo(_titleView).offset(-13);
        }];
    }
    return _titleView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F14;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UIButton *)btnDetail {
    if (!_btnDetail) {
        _btnDetail = [[UIButton alloc] init];
        _btnDetail.titleLabel.font = FONT_F13;
        [_btnDetail setTitle:@"欠款明细表" forState:UIControlStateNormal];
        [_btnDetail setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [_btnDetail setImage:[UIImage imageNamed:@"client_search"] forState:UIControlStateNormal];
        if (IS_IPHONE5) {
            [_btnDetail imageLeftWithTitleFix:3];
            _btnDetail.titleLabel.font = FONT_F12;
        } else {
            [_btnDetail imageLeftWithTitleFix:6];
        }
        [_btnDetail addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDetail;
}

- (CreditTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CreditTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


@end
