//
//  AttachmentCollectionView.m
//  Wangli
//
//  Created by yeqiang on 2018/5/30.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "AttachmentCollectionView.h"
#import "AttachmentCollectionCell.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "PhotoPickerManager.h"
#import "ImagePreviewViewCtrl.h"

static NSString *identifier = @"AttachmentCollectionCell";

@interface AttachmentCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, AttachmentCollectionCellDelegate, ImagePreviewCtrlDelegate>

@end

@implementation AttachmentCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.scrollEnabled = YES;
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = COLOR_B4;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[AttachmentCollectionCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_forbidDelete) {
        return self.attachments.count < _count ? self.attachments.count : _count;
    }
    return self.attachments.count < _count ? self.attachments.count + 1 : _count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AttachmentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.cellDelegate = self;
    if (indexPath.row == self.attachments.count) {
        cell.imgView.image = [UIImage imageNamed: _lastImgName == nil ? @"enclosure" : _lastImgName];
        cell.btnDelete.hidden = YES;
        cell.imgView.contentMode = UIViewContentModeCenter;
    } else {
        cell.btnDelete.hidden = _forbidDelete;
        [cell showImage:self.attachments[indexPath.row]];
        cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.attachments.count) {
        
        if (_attachmentCollectionViewDelegate && [_attachmentCollectionViewDelegate respondsToSelector:@selector(attachmentCollectionView:didSelectedIndexPath:)]) {
            // 只有拍照选项
            [_attachmentCollectionViewDelegate attachmentCollectionView:self didSelectedIndexPath:indexPath];
        } else {
            [[PhotoPickerManager shared] showActionSheetInView:[Utils topViewController].view fromController:[Utils topViewController] maxCount:_count-self.attachments.count completion:^(NSArray *photos) {
                for (int i = 0; i < photos.count; i++) {
                    [self.attachments addObject:photos[i]];
                }
                [self updateUI];
            } cancelBlock:^{
                
            }];
        }
    } else {
        ImagePreviewViewCtrl *ctrl = [[ImagePreviewViewCtrl alloc] initWithArrImage:self.attachments currIndex:indexPath.row];
        ctrl.hidenDelete = _forbidDelete;
        ctrl.imgPrevCtrlDelegate = self;
        [[Utils topViewController].navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark - AttachmentCollectionCellDelegate

- (void)cell:(AttachmentCollectionCell *)cell deleteIndexPath:(NSIndexPath *)indexPath {
    [self.attachments removeObjectAtIndex:indexPath.row];
    [self updateUI];
}

#pragma mark - ImagePreviewCtrlDelegate

- (void)deleteImageIndexes:(NSArray *)arrIndex {
    for (NSNumber *i in arrIndex) {
        [self.attachments removeObjectAtIndex:[i integerValue]];
    }
    [self updateUI];
}


- (void)updateUI {
    if (self.countChange) {
        self.countChange(self.attachments.count);
    }
    [self reloadData];
}

#pragma mark - setter getter

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [NSMutableArray new];
    }
    return _attachments;
}


@end
