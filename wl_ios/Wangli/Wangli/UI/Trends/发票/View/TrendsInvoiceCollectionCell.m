//
//  TrendsInvoiceCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsInvoiceCollectionCell.h"
#import "TrendsInvoiceTableView.h"

@interface TrendsInvoiceCollectionCell ()

@property (nonatomic, strong) TrendsInvoiceTableView *tableView;

@end

@implementation TrendsInvoiceCollectionCell

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

- (TrendsInvoiceTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsInvoiceTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
