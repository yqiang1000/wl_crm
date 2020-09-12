//
//  TabTrendsCollectionView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TabTrendsCollectionView.h"
#import "TabTrendsCollectionCell.h"

@interface TabTrendsCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

static NSString *identifier = @"TabTrendsCollectionCell";

@implementation TabTrendsCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    _layout = (UICollectionViewFlowLayout *)layout;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.isChange = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = COLOR_B4;
        [self registerClass:[TabTrendsCollectionCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TabTrendsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell loadSourceType:indexPath.item source:self.arrData[indexPath.item] isChange:self.isChange];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (_squareGridCollectionViewDelegate && [_squareGridCollectionViewDelegate respondsToSelector:@selector(squareGridCollectionView:didSelectIndex:title:)]) {
//        SquareMo *mo = self.arrData[indexPath.row];
//        [_squareGridCollectionViewDelegate squareGridCollectionView:self didSelectIndex:indexPath.item title:mo.title];
//    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentTag = indexPath.item;
    if (_tabTrendsCollectionViewDelegate && [_tabTrendsCollectionViewDelegate respondsToSelector:@selector(tabTrendsCollectionView:didScrollToIndex:title:)]) {
        [_tabTrendsCollectionViewDelegate tabTrendsCollectionView:self didScrollToIndex:indexPath.item title:self.arrData[indexPath.item]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"完成显示 ---- %ld" ,(long)indexPath.item);
    // 滑动到一半的时候又滑回去的场景，需要重新计算偏移量
    if (_currentTag == indexPath.item) {
        CGFloat offsetX = self.contentOffset.x;
        NSInteger index = offsetX / CGRectGetWidth(self.frame);
        if (index >= 0 && index < self.arrData.count) {
            _currentTag = index;
            if (_tabTrendsCollectionViewDelegate && [_tabTrendsCollectionViewDelegate respondsToSelector:@selector(tabTrendsCollectionView:didScrollToIndex:title:)]) {
                [_tabTrendsCollectionViewDelegate tabTrendsCollectionView:self didScrollToIndex:_currentTag title:self.arrData[_currentTag]];
            }
        }
    }
    [self reloadDataWithParam];
}

- (void)reloadDataWithParam {
    TabTrendsCollectionCell *cell = (TabTrendsCollectionCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentTag inSection:0]];
    [cell refreshTableView];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size;// CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - public

- (void)updateFrame {
    _layout.itemSize = self.frame.size;
}

- (void)selectIndex:(NSInteger)index {
    if (index >= 0 && index < self.arrData.count) {
        _currentTag = index;
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadDataWithParam];
    });
}

#pragma mark - lazy

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}


@end
