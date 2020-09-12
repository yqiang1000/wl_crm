//
//  TrendsBaseCollectionCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@class TrendsBaseCollectionCell;
@protocol TrendsBaseCollectionCellDataSourceDelegate <NSObject>
@required
@optional
- (TrendsBaseTableView *)trendsCollectionCell:(TrendsBaseCollectionCell *)trendsCollectionCell tableViewForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TrendsBaseCollectionCell : UICollectionViewCell <TrendsBaseCollectionCellDataSourceDelegate>

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *sourceString;
@property (nonatomic, assign) NSInteger sourceType;

@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic, weak) id <TrendsBaseCollectionCellDataSourceDelegate> trendsBaseCollectionCellDataSourceDelegate;

@property (nonatomic, strong) DicMo *currentDic;
- (void)loadSourceType:(NSInteger)sourceType currentDic:(DicMo *)currentDic;

// 刷新tableView数据
- (void)refreshTableView;

@end

NS_ASSUME_NONNULL_END
