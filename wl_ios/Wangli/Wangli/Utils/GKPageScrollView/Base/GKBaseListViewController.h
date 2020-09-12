//
//  GKBaseListViewController.h
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "GKBaseTableViewController.h"
#import "GKPageScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKBaseListViewController : GKBaseTableViewController<GKPageListViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger totalElements;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *segTitle;

@property (nonatomic, strong) DicMo *currentDic;

- (void)addHeaderRefresh;

- (void)tableViewFooterRefreshAction;

@end

NS_ASSUME_NONNULL_END
