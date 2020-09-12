//
//  TrendsBaseCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseCollectionCell.h"
#import "TrendsBaseTableView.h"

@interface TrendsBaseCollectionCell ()

@property (nonatomic, strong) TrendsBaseTableView *tableView;

@end

@implementation TrendsBaseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.trendsBaseCollectionCellDataSourceDelegate = self;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - public

- (void)loadSourceType:(NSInteger)sourceType currentDic:(DicMo *)currentDic {
    _sourceType = sourceType;
    _currentDic = currentDic;
    self.tableView.sourceType = _sourceType;
    self.tableView.currentDic = _currentDic;
}

- (void)setParam:(NSMutableDictionary *)param {
    _param = param;
    self.tableView.param = _param;
}

- (void)refreshTableView {
    [self.tableView tableViewHeaderRefreshAction];
}

#pragma mark - TrendsBaseCollectionCellDataSourceDelegate

- (id)trendsCollectionCell:(TrendsBaseCollectionCell *)trendsCollectionCell tableViewForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView;
}

#pragma mark - lazy

- (TrendsBaseTableView *)tableView {
    if (!_tableView) {
        if (_trendsBaseCollectionCellDataSourceDelegate && [_trendsBaseCollectionCellDataSourceDelegate respondsToSelector:@selector(trendsCollectionCell:tableViewForRowAtIndexPath:)]) {
            _tableView = [_trendsBaseCollectionCellDataSourceDelegate trendsCollectionCell:self tableViewForRowAtIndexPath:self.indexPath];
        }
    }
    return _tableView;
}

@end
