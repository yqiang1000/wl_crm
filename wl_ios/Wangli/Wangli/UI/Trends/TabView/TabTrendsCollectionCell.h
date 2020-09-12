//
//  TabTrendsCollectionCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendFeedItemMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabTrendsCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSString *sourceString;
@property (nonatomic, assign) NSInteger sourceType;
@property (nonatomic, strong) TrendFeedItemMo *trendFeedItemMo;

- (void)loadSourceType:(NSInteger)sourceType source:(TrendFeedItemMo *)source isChange:(BOOL)isChange;

- (void)refreshTableView;

@end

NS_ASSUME_NONNULL_END
