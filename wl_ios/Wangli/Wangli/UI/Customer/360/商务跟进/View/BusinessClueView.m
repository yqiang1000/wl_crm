//
//  BusinessClueView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BusinessClueView.h"


@interface BusinessClueView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *baseView;

@end

@implementation BusinessClueView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.baseView];
    [self addSubview:self.titleView];
    [self addSubview:self.tableView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.baseView);
        make.height.equalTo(@45.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.baseView).offset(10);
        make.right.equalTo(self.baseView).offset(-10);
        make.bottom.equalTo(self.baseView).offset(-10);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"BusinessClueCell";
    BusinessClueCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BusinessClueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == self.arrData.count-1) {
        cell.lineView.hidden = NO;
    } else {
        cell.lineView.hidden = YES;
    }
    [cell loadData:@""];
    return cell;
}

#pragma mark - UITableViewDelegate


#pragma mark - public

- (void)loadData:(NSMutableArray *)data {
    self.arrData = data;
    [self.tableView reloadData];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(37*self.arrData.count));
    }];
    [self layoutIfNeeded];
}

#pragma mark - lazy

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        
        UILabel *labText = [UILabel new];
        labText.text = @"线索转换";
        labText.font = FONT_F14;
        labText.textColor = COLOR_B1;
        [_titleView addSubview:labText];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView).offset(10);
            make.height.equalTo(@15);
            make.width.equalTo(@3);
        }];
        
        [labText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(_titleView).offset(-10);
        }];
    }
    return _titleView;
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 5;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B4;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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



@interface BusinessClueCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labContent;

@end

@implementation BusinessClueCell

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
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labContent];
    [self.contentView addSubview:self.lineView];
    
    UIView *leftLine = [Utils getLineView];
    UIView *midLine = [Utils getLineView];
    UIView *rightLine = [Utils getLineView];
    UIView *topLine = [Utils getLineView];
    [self.contentView addSubview:leftLine];
    [self.contentView addSubview:midLine];
    [self.contentView addSubview:rightLine];
    [self.contentView addSubview:topLine];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.equalTo(@0.5);
    }];
    
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(90);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@0.5);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.width.equalTo(@0.5);
    }];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@90.0);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midLine.mas_right).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(rightLine.mas_left);
    }];
}

- (void)loadData:(id)model {
    self.labTitle.text = @"线索转商机";
    self.labContent.text = @"40%(20 / 50)";
}

#pragma mark - lazy

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.textColor = COLOR_B1;
        _labTitle.font = FONT_F13;
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [UILabel new];
        _labContent.textColor = COLOR_B1;
        _labContent.font = FONT_F13;
    }
    return _labContent;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

@end
