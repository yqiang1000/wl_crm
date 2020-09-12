//
//  TabTrendsCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TabTrendsCollectionCell.h"
#import "TabTrendsTableView.h"

@interface TabTrendsCollectionCell ()

@property (nonatomic, strong) TabTrendsTableView *tableView;

@end

@implementation TabTrendsCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

- (void)loadSourceType:(NSInteger)sourceType source:(TrendFeedItemMo *)source isChange:(BOOL)isChange {
    if (_trendFeedItemMo != source) {
        _trendFeedItemMo = source;
    }
    _sourceType = sourceType;
    self.tableView.sourceType = _sourceType;
    self.tableView.source = _trendFeedItemMo;
//    if (isChange) {
//        [self.tableView tableViewHeaderRefreshAction];
//    }
}

- (void)refreshTableView {
    [self.tableView tableViewHeaderRefreshAction];
}

#pragma mark - lazy

- (TabTrendsTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TabTrendsTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
