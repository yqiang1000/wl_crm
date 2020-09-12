//
//  TrendsMarketActiveTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsMarketActiveTableView.h"
#import "TrendsMarketActiveCell.h"
#import "TrendsCreateActivityViewCtrl.h"
#import "WebDetailViewCtrl.h"

@interface TrendsMarketActiveTableView ()


@end

@implementation TrendsMarketActiveTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
    }
    return self;
}


#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"TrendsMarketActiveCell";
    TrendsMarketActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TrendsMarketActiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrendMarketActivityMo *item = self.arrData[indexPath.row];
    [UserLocalDataUtils saveRemark:item.id msgType:@"TrendMarketActivityMo"];
    item.read = YES;
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.titleStr = @"活动详情";
    vc.urlStr = [NSString stringWithFormat:@"%@%@%lld&token=%@", H5_URL, H5_MARKET_ACTIVITY_URL, item.id, [Utils token]];
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    
//    if ([item.createOperator[@"id"] integerValue] != TheUser.userMo.id ||
//        ![item.status isEqualToString:@"draft"]) {
//        return;
//    }
//
//    TrendsCreateActivityViewCtrl *vc = [[TrendsCreateActivityViewCtrl alloc] init];
//    vc.isUpdate = YES;
//    vc.fromTab = NO;
//    vc.dynamicId = K_MARKET_ACTIVITY;
//    vc.detailId = item.id;
//    vc.title = @"市场活动详情";
//    __weak typeof(self) weakself = self;
//    vc.updateSuccess = ^(id obj) {
//        __strong typeof(self) strongself = weakself;
//        [strongself tableViewHeaderRefreshAction];
//    };
//    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    self.page = 0;
    [self getList:self.page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:self.page+1];
}

- (void)getList:(NSInteger)page {
    [self.param setObject:@(page) forKey:@"number"];
    
    [[JYUserApi sharedInstance] getFeedBigItemPageType:@"market-activity" param:self.param success:^(id responseObject) {
        [Utils dismissHUD];
        [self headerFooterEndRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TrendMarketActivityMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.mj_footer endRefreshingWithNoMoreData];
            }
        }
        self.page = page;
        [self reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self headerFooterEndRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}


@end
