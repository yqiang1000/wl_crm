
//
//  TrendsOrderCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsOrderCollectionCell.h"
#import "TrendsOrderTableView.h"

@interface TrendsOrderCollectionCell ()

@property (nonatomic, strong) TrendsOrderTableView *tableView;

@end

@implementation TrendsOrderCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark - TrendsBaseCollectionCellDataSourceDelegate

- (id)trendsCollectionCell:(TrendsBaseCollectionCell *)trendsCollectionCell tableViewForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView;
}


#pragma mark - lazy

- (TrendsOrderTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsOrderTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
