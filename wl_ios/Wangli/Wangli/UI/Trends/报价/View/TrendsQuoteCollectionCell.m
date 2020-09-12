//
//  TrendsQuoteCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsQuoteCollectionCell.h"
#import "TrendsQuoteTableView.h"

@interface TrendsQuoteCollectionCell ()

@property (nonatomic, strong) TrendsQuoteTableView *tableView;

@end

@implementation TrendsQuoteCollectionCell

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

- (TrendsQuoteTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsQuoteTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
