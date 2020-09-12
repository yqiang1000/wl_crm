//
//  RightTableView.m
//  CustomTableView
//
//  Created by yeqiang on 2018/4/19.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "RightTableView.h"
#import "TopScrollView.h"
#import "RightTableViewCell.h"
#import "EmptyView.h"

@interface RightTableView () <UITableViewDelegate, UITableViewDataSource, RightTableViewCellDelegate>
{
    EmptyView *_emptyView;
}
@end

@implementation RightTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        _cellHeight = kCELL_HEIGHT;
        _cellWidth = kCELL_WIDTH;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:NOTIF_TABLE_SCROLL object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.width.height.equalTo(self);
        }];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"leftCell";
    
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[RightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.rightTableViewCellDelegate = self;
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

#pragma mark - RightTableViewCellDelegate

- (void)rightTableViewCell:(RightTableViewCell *)rightTableViewCell selectIndex:(NSInteger)index {
    if (_rightTableViewDelegate && [_rightTableViewDelegate respondsToSelector:@selector(rightTableView:selectIndexPath:)]) {
        NSIndexPath *indexPath = [self indexPathForCell:rightTableViewCell];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index inSection:indexPath.row];
        [_rightTableViewDelegate rightTableView:self selectIndexPath:newIndexPath];
    }
}

@end
