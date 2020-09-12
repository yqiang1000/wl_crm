//
//  TrendsContractCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsContractCollectionCell.h"
#import "TrendsContractTableView.h"

@interface TrendsContractCollectionCell ()

@property (nonatomic, strong) TrendsContractTableView *tableView;

@end

@implementation TrendsContractCollectionCell

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

- (TrendsContractTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsContractTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
