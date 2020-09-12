//
//  RecordImageView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordImageView.h"
#import "RecordImageCell.h"

@interface RecordImageView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecordImageCellDelegate>

@end

static NSString *identifier = @"RecordImageCell";

@implementation RecordImageView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.backgroundColor = COLOR_B0;
        [self registerClass:[RecordImageCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecordImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.recordImageCellDelegate = self;
    cell.indexPath = indexPath;
    cell.unDelete = self.unDelete;
    [cell showImage:self.imageData[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_recordImageViewDelegate && [_recordImageViewDelegate respondsToSelector:@selector(recordImageView:didSelectedIndexPath:)]) {
        [_recordImageViewDelegate recordImageView:self didSelectedIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [RecordUtils shareInstance].record_width;
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

#pragma mark - RecordImageCellDelegate

- (void)recordImageCell:(RecordImageCell *)recordImageCell deleteIndexPath:(NSIndexPath *)indexPath {
    if (_recordImageViewDelegate && [_recordImageViewDelegate respondsToSelector:@selector(recordImageView:didDeleteIndexPath:)]) {
        [_recordImageViewDelegate recordImageView:self didDeleteIndexPath:indexPath];
    }
}

@end
