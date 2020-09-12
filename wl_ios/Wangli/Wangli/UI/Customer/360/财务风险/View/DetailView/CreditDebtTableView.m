//
//  CreditDebtTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/8/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreditDebtTableView.h"

#pragma mark - CreditDebtTableView

@interface CreditDebtTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CreditDebtTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditDebtMo *mo = self.arrData[indexPath.row];
    NSInteger count = mo.companyList.count;
    CGFloat padding = self.arrData.count -1 == indexPath.row ? 0 : 10;
    return 25*count+49+32+53+padding;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CreditDebtCell";
    CreditDebtCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CreditDebtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}

#pragma mark - lazy

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}


@end

#pragma mark - CreditDebtCell

@interface CreditDebtCell ()

@end

@implementation CreditDebtCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COLOR_F8F8F8;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.bottomView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@49);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@32);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@100);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@53);
    }];
}

- (void)loadData:(CreditDebtMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = [NSString stringWithFormat:@"公司代码:%@", _model.companyCode[@"companyCode"]];
    self.labTotal.text = [NSString stringWithFormat:@"汇总|%@:%@", _model.companyCode[@"companyCode"], _model.companyCode[@"amount"]];
    self.tableView.arrData = _model.companyList;
    [self.tableView reloadData];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_model.companyList.count * 25));
    }];
    [self layoutIfNeeded];
}

#pragma mark - lazy

- (UILabel *)labTotal {
    if (!_labTotal) {
        _labTotal = [[UILabel alloc] init];
        _labTotal.font = FONT_F13;
        _labTotal.textColor = COLOR_B1;
    }
    return _labTotal;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = COLOR_B4;
        [_titleView addSubview:self.labTitle];
        
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
            make.right.lessThanOrEqualTo(_titleView).offset(-10);
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

- (DebtListTableView *)tableView {
    if (!_tableView) {
        _tableView = [[DebtListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = COLOR_C2;
    }
    return _tableView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = COLOR_B4;
        
        UILabel *labNum = [[UILabel alloc] init];
        labNum.textColor = COLOR_B1;
        labNum.font = FONT_F13;
        labNum.textAlignment = NSTextAlignmentCenter;
        labNum.text = @"客户编号";
        [_topView addSubview:labNum];
        UILabel *labName = [[UILabel alloc] init];
        labName.textColor = COLOR_B1;
        labName.font = FONT_F13;
        labName.textAlignment = NSTextAlignmentCenter;
        labName.text = @"客户名称";
        [_topView addSubview:labName];
        UILabel *labCreditNum = [[UILabel alloc] init];
        labCreditNum.textColor = COLOR_B1;
        labCreditNum.font = FONT_F13;
        labCreditNum.textAlignment = NSTextAlignmentCenter;
        labCreditNum.text = @"信贷号";
        [_topView addSubview:labCreditNum];
        UILabel *labMoney = [[UILabel alloc] init];
        labMoney.textColor = COLOR_B1;
        labMoney.font = FONT_F13;
        labMoney.textAlignment = NSTextAlignmentCenter;
        labMoney.text = @"欠款总额";
        [_topView addSubview:labMoney];
        
        UIView *lineView = [Utils getLineView];
        [_topView addSubview:lineView];
        UIView *lineView1 = [Utils getLineView];
        [_topView addSubview:lineView1];
        
        [labNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_topView);
            make.height.equalTo(_topView);
            make.left.equalTo(_topView);
        }];
        
        [labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_topView);
            make.left.equalTo(labNum.mas_right);
            make.height.width.equalTo(labNum);
        }];
        
        [labCreditNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_topView);
            make.left.equalTo(labName.mas_right);
            make.height.width.equalTo(labNum);
        }];
        
        [labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_topView);
            make.left.equalTo(labCreditNum.mas_right);
            make.height.width.equalTo(labNum);
            make.right.equalTo(_topView);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_topView);
            make.height.equalTo(@0.5);
        }];
        
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_topView);
            make.height.equalTo(@0.5);
        }];
    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = COLOR_B4;
        
        UIView *lineView = [Utils getLineView];
        [_bottomView addSubview:lineView];
        [_bottomView addSubview:self.labTotal];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView).offset(20);
            make.left.right.equalTo(_bottomView);
            make.height.equalTo(@0.5);
        }];
        
        [self.labTotal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bottomView.mas_bottom).offset(-16.5);
            make.left.equalTo(_bottomView).offset(15);
            make.right.lessThanOrEqualTo(_bottomView).offset(-15);
        }];
    }
    return _bottomView;
}

@end
