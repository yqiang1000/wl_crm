//
//  TrendsMarketActiveCollectioniCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsMarketActiveCollectioniCell.h"
#import "TrendsMarketActiveTableView.h"

@interface TrendsMarketActiveCollectioniCell ()

@property (nonatomic, strong) TrendsMarketActiveTableView *tableView;

@end

@implementation TrendsMarketActiveCollectioniCell

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

- (TrendsMarketActiveTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsMarketActiveTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
