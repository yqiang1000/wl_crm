//
//  TrendsComplaintCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsComplaintCollectionCell.h"
#import "TrendsComplaintTableView.h"

@interface TrendsComplaintCollectionCell ()

@property (nonatomic, strong) TrendsComplaintTableView *tableView;

@end

@implementation TrendsComplaintCollectionCell

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

- (TrendsComplaintTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsComplaintTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
