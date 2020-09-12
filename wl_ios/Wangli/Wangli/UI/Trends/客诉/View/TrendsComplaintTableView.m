
//
//  TrendsComplaintTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsComplaintTableView.h"
#import "TrendsComplaintCell.h"

@interface TrendsComplaintTableView ()


@end

@implementation TrendsComplaintTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
    }
    return self;
}


#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"TrendsComplaintCell";
    TrendsComplaintCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TrendsComplaintCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendsBaseMo *tmpMo = self.arrData[indexPath.row];
    tmpMo.read = YES;
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    [self.arrData removeAllObjects];
    self.arrData = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self headerFooterEndRefreshing];
        NSInteger count = self.arrData.count;
        for (int i = 0; i < 5; i++) {
            TrendsBaseMo *mo = [[TrendsBaseMo alloc] init];
            mo.title = [NSString stringWithFormat:@"客户：%@ 晶科 | 需要报告 %ld", self.sourceString, i+count];
            mo.content = @"单面PERC单晶 22.5%在客户制程环节出现断删问题";
            mo.person = @"销售部：刘芳";
            mo.date = @"3分钟前";
            mo.read = NO;
            mo.state = self.sourceString;
            [self.arrData addObject:mo];
        }
        [self reloadData];
    });
}

- (void)tableViewFooterRefreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self headerFooterEndRefreshing];
        NSInteger count = self.arrData.count;
        for (int i = 0; i < 5; i++) {
            TrendsBaseMo *mo = [[TrendsBaseMo alloc] init];
            mo.title = [NSString stringWithFormat:@"客户：%@ 晶科 | 需要报告 %ld", self.sourceString, i+count];
            mo.content = @"单面PERC单晶 22.5%在客户制程环节出现断删问题";
            mo.person = @"销售部：刘芳";
            mo.date = @"3分钟前";
            mo.read = NO;
            mo.state = self.sourceString;
            [self.arrData addObject:mo];
        }
        [self reloadData];
    });
}

@end
