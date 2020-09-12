//
//  RecordVoiceView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordVoiceView.h"
#import "RecordVoiceCell.h"

@interface RecordVoiceView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecordVoiceCellDelegate>

@end

static NSString *identifier = @"RecordVoiceCell";

@implementation RecordVoiceView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.backgroundColor = COLOR_B0;
        [self registerClass:[RecordVoiceCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.voiceData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecordVoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.recordVoiceCellDelegate = self;
    cell.indexPath = indexPath;
    cell.unDelete = self.unDelete;
    [cell loadData:self.voiceData[indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_recordVoiceViewDelegate && [_recordVoiceViewDelegate respondsToSelector:@selector(recordVoiceView:didSelectedIndexPath:)]) {
        [_recordVoiceViewDelegate recordVoiceView:self didSelectedIndexPath:indexPath];
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

#pragma mark - RecordVoiceCellDelegate

- (void)recordVoiceCell:(RecordVoiceCell *)recordVoiceCell deleteIndexPath:(NSIndexPath *)indexPath {
    if (_recordVoiceViewDelegate && [_recordVoiceViewDelegate respondsToSelector:@selector(recordVoiceView:didDeleteIndexPath:)]) {
        [_recordVoiceViewDelegate recordVoiceView:self didDeleteIndexPath:indexPath];
    }
}

@end
