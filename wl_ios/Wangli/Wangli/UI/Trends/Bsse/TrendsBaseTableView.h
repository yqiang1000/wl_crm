//
//  TrendsBaseTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLocalDataUtils.h"
#import "WebDetailViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsBaseTableView : UITableView

@property (nonatomic, strong) NSMutableDictionary *param;
// 分类DicMo
@property (nonatomic, strong) DicMo *currentDic;
// 分类DicMo
@property (nonatomic, copy) NSString *sourceString;
// 分类type
@property (nonatomic, assign) NSInteger sourceType;

@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, assign) NSInteger page;

- (void)tableViewHeaderRefreshAction;

- (void)tableViewFooterRefreshAction;

- (void)headerFooterEndRefreshing;

@end

NS_ASSUME_NONNULL_END
