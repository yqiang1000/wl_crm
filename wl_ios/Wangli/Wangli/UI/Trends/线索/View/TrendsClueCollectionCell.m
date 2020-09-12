//
//  TrendsClueCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsClueCollectionCell.h"
#import "TrendsClueTableView.h"

@interface TrendsClueCollectionCell ()

@property (nonatomic, strong) TrendsClueTableView *tableView;

@end

@implementation TrendsClueCollectionCell

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

- (TrendsClueTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsClueTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
