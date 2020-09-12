//
//  RecordVideoView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordVideoView.h"
#import "RecordVideoCell.h"

@interface RecordVideoView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecordVideoCellDelegate>

{
    dispatch_queue_t _queue;
}

@end

static NSString *identifier = @"RecordVideoCell";

@implementation RecordVideoView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.backgroundColor = COLOR_B0;
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);;
        [self registerClass:[RecordVideoCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videoData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecordVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.recordVideoCellDelegate = self;
    cell.indexPath = indexPath;
    cell.unDelete = self.unDelete;
    cell.btnDelete.hidden = self.unDelete;
    dispatch_async(_queue, ^{
        [cell showVideo:self.videoData[indexPath.row]];
    });
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_recordVideoViewDelegate && [_recordVideoViewDelegate respondsToSelector:@selector(recordVideoView:didSelectedIndexPath:)]) {
        [_recordVideoViewDelegate recordVideoView:self didSelectedIndexPath:indexPath];
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

- (void)recordVideoCell:(RecordVideoCell *)recordVideoCell deleteIndexPath:(NSIndexPath *)indexPath {
    if (_recordVideoViewDelegate && [_recordVideoViewDelegate respondsToSelector:@selector(recordVideoView:didDeleteIndexPath:)]) {
        [_recordVideoViewDelegate recordVideoView:self didDeleteIndexPath:indexPath];
    }
}

- (void)recordVideoCell:(RecordVideoCell *)recordVideoCell playIndexPath:(NSIndexPath *)indexPath {
    if (_recordVideoViewDelegate && [_recordVideoViewDelegate respondsToSelector:@selector(recordVideoView:didSelectedIndexPath:)]) {
        [_recordVideoViewDelegate recordVideoView:self didSelectedIndexPath:indexPath];
    }
}

@end
