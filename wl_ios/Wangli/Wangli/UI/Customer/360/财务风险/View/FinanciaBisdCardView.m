//
//  FinanciaBisdCardView.m
//  Wangli
//
//  Created by yeqiang on 2019/1/27.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "FinanciaBisdCardView.h"


@interface FinanciaBisdCardView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation FinanciaBisdCardView

- (instancetype)init {
    self = [super init];
    if (self) {
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
        make.height.equalTo(@49.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.baseView).offset(5);
        make.right.equalTo(self.baseView).offset(-5);
        make.bottom.equalTo(self.baseView).offset(-10);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"BisdCell";
    BisdCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BisdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.labCode.text = @"公司代码";
        cell.labName.text = @"公司名称";
        cell.labUnit.text = @"币种";
        cell.labAmount.text = @"余额(万)";
    } else {
        [cell loadData:self.arrData[indexPath.row-1]];
    }
    cell.lineView.hidden = (indexPath.row == self.arrData.count) ? YES : NO;
    return cell;
}

- (void)refreshView:(NSMutableArray *)arrData {
    self.arrData = arrData;
    [self.tableView reloadData];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.arrData.count+1)*45));
    }];
    [self layoutIfNeeded];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.borderColor = COLOR_LINE.CGColor;
        _tableView.layer.borderWidth = 0.5;
    }
    return _tableView;
}

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
        
        UILabel *labTitle = [[UILabel alloc] init];
        labTitle.font = FONT_F14;
        labTitle.textColor = COLOR_B1;
        labTitle.text = @"分子公司应收余额";
        [_titleView addSubview:labTitle];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView).offset(13);
            make.height.equalTo(@15.0);
            make.width.equalTo(@3.0);
        }];
        
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(_titleView).offset(-10);
        }];
    }
    return _titleView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

@end



@interface BisdCell ()

@end


@implementation BisdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labCode];
    [self.contentView addSubview:self.labName];
    [self.contentView addSubview:self.labUnit];
    [self.contentView addSubview:self.labAmount];
    
    UIView *lineL = [Utils getLineView];
    UIView *lineM = [Utils getLineView];
    UIView *lineR = [Utils getLineView];
    [self.contentView addSubview:lineL];
    [self.contentView addSubview:lineM];
    [self.contentView addSubview:lineR];
    
    [self.contentView addSubview:self.lineView];
    
    [self.labCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
    }];
    
    [self.labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.equalTo(self.labCode);
        make.left.equalTo(self.labCode.mas_right);
    }];
    
    [self.labUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.equalTo(self.labCode);
        make.left.equalTo(self.labName.mas_right);
    }];
    
    [self.labAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.top.equalTo(self.labUnit);
        make.left.equalTo(self.labUnit.mas_right);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.labCode);
        make.width.equalTo(@0.5);
    }];
    
    [lineM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.labName);
        make.width.equalTo(@0.5);
    }];
    
    [lineR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.labUnit);
        make.width.equalTo(@0.5);
    }];
}

- (void)loadData:(CreditMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labCode.text = _model.field;
    self.labName.text = _model.unit;
    self.labUnit.text = _model.fieldTitle;
    CGFloat amount = [_model.fieldValue floatValue] / 10000.0;
    self.labAmount.text = [NSString stringWithFormat:@"%.2lf", amount];
}

#pragma mark - lazy

- (UILabel *)labCode {
    if (!_labCode) _labCode = [self getNewLabel];
    return _labCode;
}

- (UILabel *)labName {
    if (!_labName) _labName = [self getNewLabel];
    return _labName;
}

- (UILabel *)labUnit {
    if (!_labUnit) _labUnit = [self getNewLabel];
    return _labUnit;
}

- (UILabel *)labAmount {
    if (!_labAmount) _labAmount = [self getNewLabel];
    return _labAmount;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (UILabel *)getNewLabel {
    UILabel *lab = [UILabel new];
    lab.font = FONT_F13;
    lab.textColor = COLOR_B1;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

@end
