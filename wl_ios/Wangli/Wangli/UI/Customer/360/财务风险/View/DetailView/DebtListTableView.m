//
//  DebtListTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/8/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "DebtListTableView.h"

#pragma mark - DebtListTableView

@interface DebtListTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DebtListTableView

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
    return 25;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DebtListCell";
    DebtListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DebtListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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

#pragma mark - DebtListCell

@interface DebtListCell ()

@end

@implementation DebtListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labNum];
    [self.contentView addSubview:self.labName];
    [self.contentView addSubview:self.labCreditNum];
    [self.contentView addSubview:self.labMoney];
    
    [self.labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.labNum.mas_right);
        make.width.equalTo(self.labNum);
    }];
    
    [self.labCreditNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.labName.mas_right);
        make.width.equalTo(self.labNum);
    }];
    
    [self.labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.labCreditNum.mas_right);
        make.width.equalTo(self.labNum);
        make.right.equalTo(self.contentView);
    }];
}

- (void)loadData:(CustomerMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labNum.text = _model.cnumber;
    self.labName.text = _model.abbreviation;
    self.labCreditNum.text = _model.knkli;
    self.labMoney.text = [NSString stringWithFormat:@"%.2lf", _model.owedTotalAmount];
    [self layoutIfNeeded];
}

- (UILabel *)labNum {
    if (!_labNum) {
        _labNum = [[UILabel alloc] init];
        _labNum.font = FONT_F12;
        _labNum.textColor = COLOR_B2;
        _labNum.textAlignment = NSTextAlignmentCenter;
    }
    return _labNum;
}

- (UILabel *)labName {
    if (!_labName) {
        _labName = [[UILabel alloc] init];
        _labName.font = FONT_F12;
        _labName.textColor = COLOR_B2;
        _labName.textAlignment = NSTextAlignmentCenter;
    }
    return _labName;
}

- (UILabel *)labCreditNum {
    if (!_labCreditNum) {
        _labCreditNum = [[UILabel alloc] init];
        _labCreditNum.font = FONT_F12;
        _labCreditNum.textColor = COLOR_B2;
        _labCreditNum.textAlignment = NSTextAlignmentCenter;
    }
    return _labCreditNum;
}

- (UILabel *)labMoney {
    if (!_labMoney) {
        _labMoney = [[UILabel alloc] init];
        _labMoney.font = FONT_F12;
        _labMoney.textColor = COLOR_B2;
        _labMoney.textAlignment = NSTextAlignmentCenter;
    }
    return _labMoney;
}

@end
