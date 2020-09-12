//
//  BusinessHeaderView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/16.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BusinessHeaderView.h"

#pragma mark - BusinessHeaderView

@interface BusinessHeaderView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *titleView;

@end

@implementation BusinessHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-5);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.arrData.count) {
        NSArray *arr = self.arrData[section];
        return arr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.arrData.count) {
        NSArray *arr = self.arrData[indexPath.section];
        NSMutableAttributedString *str = arr[indexPath.row];
        NSString *text = str.string;
        CGSize size = [Utils getStringSize:text font:FONT_F13 maxSize:CGSizeMake(SCREEN_WIDTH-60, 1000)];
        return size.height + 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 50 : 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleView;
    } else {
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50, 30)];
        head.backgroundColor = COLOR_B4;
        UIView *lineView = [Utils getLineView];
        [head addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(head);
            make.left.equalTo(head).offset(15);
            make.top.equalTo(head).offset(5);
            make.height.equalTo(@0.5);
        }];
        return head;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"topCell";
    BusinessHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BusinessHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section < self.arrData.count) {
        NSArray *arr = self.arrData[indexPath.section];
        cell.labContent.attributedText = arr[indexPath.row];
        cell.labContent.font = FONT_F13;
    }
    return cell;
}

#pragma mark - public

//- (void)loadData {
//    self.labTitle.text = @"拜访晶科商务部洽谈合同";
//}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLOR_C1;
        lineView.layer.cornerRadius = 1.5;
        lineView.clipsToBounds = YES;
        [_titleView addSubview:lineView];
        [_titleView addSubview:self.labTitle];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(_titleView).offset(15);
            make.height.equalTo(@15);
            make.width.equalTo(@3);
        }];
        
        [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleView);
            make.left.equalTo(lineView.mas_right).offset(7);
            make.right.equalTo(_titleView).offset(-15);
        }];
    }
    return _titleView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.font = FONT_F14;
        _labTitle.textColor = COLOR_B1;
        _labTitle.text = @"本月计划指标";
    }
    return _labTitle;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end

#pragma mark - BusinessHeaderCell

@interface BusinessHeaderCell ()

@end

@implementation BusinessHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labContent];
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [UILabel new];
        _labContent.font = FONT_F13;
        _labContent.textColor = COLOR_B1;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

@end
