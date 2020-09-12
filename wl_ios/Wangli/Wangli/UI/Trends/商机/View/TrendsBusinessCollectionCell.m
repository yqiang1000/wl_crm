//
//  TrendsBusinessCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsBusinessCollectionCell.h"
#import "TrendsBusinessTableView.h"

@interface TrendsBusinessCollectionCell ()

@property (nonatomic, strong) TrendsBusinessTableView *tableView;

@end

@implementation TrendsBusinessCollectionCell

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

- (TrendsBusinessTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsBusinessTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
