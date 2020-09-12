
//
//  TrendsInteligenceViewCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsInteligenceViewCollectionCell.h"
#import "TrendsInteligenceTableView.h"

@interface TrendsInteligenceViewCollectionCell ()

@property (nonatomic, strong) TrendsInteligenceTableView *tableView;

@end

@implementation TrendsInteligenceViewCollectionCell

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

- (void)loadSourceType:(NSInteger)sourceType currentDic:(DicMo *)currentDic {
    _sourceType = sourceType;
    _currentDic = currentDic;
    self.tableView.sourceType = _sourceType;
    self.tableView.currentDic = _currentDic;
    [self.tableView reloadData];
}

- (void)setParam:(NSMutableDictionary *)param {
    _param = param;
    self.tableView.param = _param;
}

- (void)refreshTableView {
    [self.tableView tableViewHeaderRefreshAction];
}

#pragma mark - lazy

- (TrendsInteligenceTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TrendsInteligenceTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
