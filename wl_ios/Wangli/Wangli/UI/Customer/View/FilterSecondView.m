//
//  FilterSecondView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/12.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "FilterSecondView.h"
#import "BaseNaviView.h"
#import "ListSelectViewCtrl.h"

@interface FilterSecondView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BaseNaviView *secondNavi;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger defultIndex;

@end

@implementation FilterSecondView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.secondNavi];
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 内容
    static NSString *identifier = @"listCell";
    ListselectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListselectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.labText.text = self.arrData[indexPath.row];
    cell.imgArrow.hidden = self.defultIndex == indexPath.row ? NO : YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(filterSecondView:select:)]) {
        [_delegate filterSecondView:self select:indexPath.row];
        [self secondNaviBtnBackClick:nil];
    }
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(filterSecondView:select:)]) {
        [_delegate filterSecondView:self select:index];
        [self secondNaviBtnBackClick:nil];
    }
}

#pragma mark - public

- (void)updata:(NSMutableArray *)data selectTag:(NSInteger)selectTag title:(NSString *)title defaultIndex:(NSInteger)defaultIndex {
    self.secondNavi.labTitle.text = title;
    self.arrData = data;
    self.defultIndex = defaultIndex;
    [self.tableView reloadData];
}

#pragma mark - event

- (void)secondNaviBtnBackClick:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(filterSecondViewCancel:)]) {
        [_delegate filterSecondViewCancel:self];
    }
}

#pragma mark - setter getter

- (BaseNaviView *)secondNavi {
    if (!_secondNavi) {
        _secondNavi = [[BaseNaviView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 44+STATUS_BAR_HEIGHT)];
        [_secondNavi.btnBack addTarget:self action:@selector(secondNaviBtnBackClick:) forControlEvents:UIControlEventTouchUpInside];
        _secondNavi.lineView.backgroundColor = COLOR_C1;
    }
    return _secondNavi;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.secondNavi.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(self.secondNavi.frame)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
