//
//  RiskTotalCollectionView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/17.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "RiskTotalCollectionView.h"
#import "RiskTotalCell.h"

static NSString *identifier = @"riskTotalCell";

@interface RiskTotalCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

{
    CGFloat _cellWidth;
    CGFloat _cellHeight;
}

@end
@implementation RiskTotalCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        _cellWidth = (SCREEN_WIDTH - 30) / 3.0;
        _cellHeight = 100;
        [self registerClass:[RiskTotalCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RiskTotalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell loadDataWith:self.arrData[indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_viewDelegate && [_viewDelegate respondsToSelector:@selector(riskTotalCollectionView:didSelectIndexPath:)]) {
        [_viewDelegate riskTotalCollectionView:self didSelectIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( _cellWidth, _cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - setter getter

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
