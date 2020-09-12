//
//  TabTrendsTableViewCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendFeedItemMo.h"
#import "TrendsFeedMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabTrendsTableViewCell : UITableViewCell

@property (nonatomic, strong) TrendFeedItemMo *source;
@property (nonatomic, strong) TrendsFeedMo *model;
- (void)loadDataModel:(TrendsFeedMo *)model source:(TrendFeedItemMo *)source;

@end

NS_ASSUME_NONNULL_END
