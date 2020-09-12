//
//  TabTrendsCollectionView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendFeedItemMo.h"

NS_ASSUME_NONNULL_BEGIN

@class TabTrendsCollectionView;
@protocol TabTrendsCollectionViewDelegate <NSObject>
@optional
- (void)tabTrendsCollectionView:(TabTrendsCollectionView *)tabTrendsCollectionView didScrollToIndex:(NSInteger)index title:(NSString *)title;

@end

@interface TabTrendsCollectionView : UICollectionView

@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) NSMutableArray *arrData;
/** 是否需要刷新，YES：切换时需要刷新，NO：由于动态页展开收缩引起的reload不需要刷新 */
@property (nonatomic, assign) BOOL isChange;

@property (nonatomic, weak) id <TabTrendsCollectionViewDelegate> tabTrendsCollectionViewDelegate;

- (void)updateFrame;

- (void)selectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
