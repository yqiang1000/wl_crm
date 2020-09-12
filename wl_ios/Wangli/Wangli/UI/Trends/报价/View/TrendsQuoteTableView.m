//
//  TrendsQuoteTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsQuoteTableView.h"
#import "TrendsQuoteCell.h"
#import "TrendsCreateQuoteViewCtrl.h"

@interface TrendsQuoteTableView ()


@end

@implementation TrendsQuoteTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
    }
    return self;
}


#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"TrendsQuoteCell";
    TrendsQuoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TrendsQuoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TrendsQuoteMo *item = self.arrData[indexPath.row];
    [UserLocalDataUtils saveRemark:item.id msgType:@"TrendsQuoteMo"];
    item.read = YES;
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([item.createOperator[@"id"] integerValue] != TheUser.userMo.id ||
        ![item.approvalStatus isEqualToString:@"submit"]) {
        WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
        vc.titleStr = @"报价详情";
        vc.urlStr = [NSString stringWithFormat:@"%@%@%lld&token=%@", H5_URL, H5_QUOTED_PRICE_URL, item.id, [Utils token]];
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        return;
    }
    
    TrendsCreateQuoteViewCtrl *vc = [[TrendsCreateQuoteViewCtrl alloc] init];
    vc.isUpdate = YES;
    vc.detailId = item.id;
    vc.title = @"报价详情";
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself tableViewHeaderRefreshAction];
    };
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
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
    
    [[JYUserApi sharedInstance] getFeedBigItemPageType:@"quoted_price" param:self.param success:^(id responseObject) {
        [Utils dismissHUD];
        [self headerFooterEndRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TrendsQuoteMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
