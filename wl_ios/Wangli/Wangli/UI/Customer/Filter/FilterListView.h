//
//  FilterListView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCollectionView.h"

@class FilterListView;
@protocol FilterListViewDelegate <NSObject>

@optional
- (void)filterListViewDismiss:(FilterListView *)filterListView;

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath filterTag:(NSInteger)filterTag;


@end

@interface FilterListView : UIView

// sourceType 0:默认列表 1:筛选
@property (nonatomic, assign) NSInteger sourceType;

@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) FilterCollectionView *collectionView;

@property (nonatomic, assign) NSInteger filterTag; // 存在多个FilterListView标记

- (instancetype)initWithSourceType:(NSInteger)sourceType;

- (void)loadData:(NSArray *)data;

// viewHeight : 整个高度
- (void)updateViewHeight:(CGFloat)viewHeight bottomHeight:(CGFloat)bottomHeight;


@property (nonatomic, weak) id <FilterListViewDelegate> delegate;

@end
