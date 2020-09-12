//
//  TrendsClueTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsClueTableView.h"
#import "TrendsClueCell.h"
#import "TrendsCreateClueViewCtrl.h"
#import "ClueMo.h"

@interface TrendsClueTableView ()

@end

@implementation TrendsClueTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
    }
    return self;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"TrendsClueCell";
    TrendsClueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TrendsClueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell loadDataWith:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ClueMo *item = self.arrData[indexPath.row];
    [UserLocalDataUtils saveRemark:item.id msgType:@"TrendsClueMo"];
    item.read = YES;
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.titleStr = @"线索详情";
    vc.urlStr = [NSString stringWithFormat:@"%@%@%lld&token=%@", H5_URL, H5_CLUE_URL, item.id, [Utils token]];
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    
//    if ([item.submitter[@"id"] integerValue] != TheUser.userMo.id ||
//        ![item.statusKey isEqualToString:@"in_verification"]) {
//        return;
//    }
//
//    TrendsCreateClueViewCtrl *vc = [[TrendsCreateClueViewCtrl alloc] init];
//    vc.isUpdate = YES;
//    vc.detailId = item.id;
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
    
    [[JYUserApi sharedInstance] getFeedBigItemPageType:@"clue" param:self.param success:^(id responseObject) {
        [Utils dismissHUD];
        [self headerFooterEndRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [ClueMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
