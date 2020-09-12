//
//  TrendsShipCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsShipCollectionCell.h"
#import "TrendsShipTableView.h"

@interface TrendsShipCollectionCell ()

@property (nonatomic, strong) TrendsShipTableView *tableView;

@end

@implementation TrendsShipCollectionCell

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

- (TrendsShipTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsShipTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
