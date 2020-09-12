//
//  PlanTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/6/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PlanTableView.h"
#import "EmptyView.h"
#import "PayPlanCell.h"
#import "PayPlanMo.h"
#import "DealPlanCell.h"
#import "DealPlanMo.h"

@interface PlanTableView () <UITableViewDelegate, UITableViewDataSource>
{
    EmptyView *_emptyView;
}

@end

@implementation PlanTableView

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
    return 111;
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
    JSONModel *mo = self.arrData[indexPath.row];
    
    if ([mo isKindOfClass:[PayPlanMo class]]) {
        static NSString *cellId = @"payPlanCell";
        PayPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[PayPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        PayPlanMo *tmpMo = (PayPlanMo *)mo;
        [cell loadDataWith:self.arrData[indexPath.row] orgName:STRING(tmpMo.member[@"orgName"])];
        return cell;
    } else {
        static NSString *cellId = @"dealPlanCell";
        DealPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[DealPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        DealPlanMo *tmpMo = (DealPlanMo *)mo;
        [cell loadDataWith:tmpMo orgName:tmpMo.member[@"abbreviation"]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_planDelegate && [_planDelegate respondsToSelector:@selector(planTableView:didSelectIndexPath:)]) {
        [_planDelegate planTableView:self didSelectIndexPath:indexPath];
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
