//
//  TrendsReceiptCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsReceiptCollectionCell.h"
#import "TrendsReceiptTableView.h"

@interface TrendsReceiptCollectionCell ()

@property (nonatomic, strong) TrendsReceiptTableView *tableView;

@end

@implementation TrendsReceiptCollectionCell

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

- (TrendsReceiptTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsReceiptTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
