//
//  MyPlanCollectionTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/7/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyPlanCollectionTableView.h"
#import "EmptyView.h"
#import "DealPlanCollectionMo.h"
#import "PlanCollectionCell.h"

@interface MyPlanCollectionTableView () <UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}

@end

@implementation MyPlanCollectionTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.width.height.equalTo(self);
        }];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 116;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"PlanCollectionCell";
    PlanCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PlanCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    DealPlanCollectionMo *mo = self.arrData[indexPath.row];
    [cell loadDataWith:mo orgName:[mo.type isEqualToString:@"MEMBER"]?mo.name:mo.batchNumber];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_myPlanCollectionTableViewDelegate && [_myPlanCollectionTableViewDelegate respondsToSelector:@selector(myPlanCollectionTableView:didSelectIndexPath:)]) {
        [_myPlanCollectionTableViewDelegate myPlanCollectionTableView:self didSelectIndexPath:indexPath];
    }
}

#pragma mark - public

- (void)headerFooterEndRefreshing {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

#pragma mark - lazy

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
