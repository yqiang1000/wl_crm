//
//  CreditTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/8/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreditTableView.h"

#pragma mark - CreditTableView

@interface CreditTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CreditTableView

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
    static NSString *identifier = @"CreditTableViewCell";
    CreditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CreditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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

#pragma mark - CreditTableViewCell

@interface CreditTableViewCell ()

@end

@implementation CreditTableViewCell

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
        make.left.equalTo(self.contentView).offset(24);
    }];
    
    [self.labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-23);
    }];
}

- (void)loadData:(CreditMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labLeft.text = _model.field;
    self.labRight.text = _model.fieldValue;
}

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [[UILabel alloc] init];
        _labLeft.font = FONT_F13;
        _labLeft.textColor = COLOR_B2;
    }
    return _labLeft;
}

- (UILabel *)labRight {
    if (!_labRight) {
        _labRight = [[UILabel alloc] init];
        _labRight.font = FONT_F13;
        _labRight.textColor = COLOR_EC675D;
    }
    return _labRight;
}

@end
