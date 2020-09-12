//
//  FilterCollectionView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterCollectionView;
@class FilterHeaderView;
@protocol FilterCollectionViewDelegate <NSObject>

@optional
- (void)filterCollectionView:(FilterCollectionView *)filterCollectionView didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)filterCollectionView:(FilterCollectionView *)filterCollectionView didSelectHeaderView:(FilterHeaderView *)headerView indexPath:(NSIndexPath *)indexPath defaultIndex:(NSInteger)defaultIndex;

@end

@interface FilterCollectionView : UICollectionView


// sourceType 0:默认列表 1:筛选
@property (nonatomic, assign) NSInteger sourceType;
@property (nonatomic, strong) NSArray *arrData;

@property (nonatomic, assign) NSInteger selectTag;
@property (nonatomic, strong) NSMutableArray *indexPathArr;

@property (nonatomic, weak) id <FilterCollectionViewDelegate> filterCollectionViewDelegate;

@end
