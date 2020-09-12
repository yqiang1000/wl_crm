//
//  MenuTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/19.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "MenuTableView.h"
#import "MenuTableViewCell.h"

@interface MenuTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MenuTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selectIndex = 0;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"menuCell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.labTitle.text = self.arrData[indexPath.row];
    [cell loadDataWith:(_selectIndex == indexPath.row ? YES : NO)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_menuDelegate && [_menuDelegate respondsToSelector:@selector(menuTableView:didSelectItem:indexPath:)]) {
        [_menuDelegate menuTableView:self didSelectItem:self.arrData[indexPath.row] indexPath:indexPath];
    }
    _selectIndex = indexPath.row;
    [self reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self reloadData];
}

@end
