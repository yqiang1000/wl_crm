//
//  TabTrendsTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendFeedItemMo.h"
#import "TrendsFeedMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabTrendsTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) TrendFeedItemMo *source;
@property (nonatomic, assign) NSInteger sourceType;

- (void)tableViewHeaderRefreshAction;
@end

NS_ASSUME_NONNULL_END
