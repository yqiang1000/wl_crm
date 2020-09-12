//
//  CustomerCollectionView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/3.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "CustomerCollectionView.h"
#import "CustomerCell.h"

static NSString *customerCell = @"customerCell";


@interface CustomerCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

{
    CGFloat _cellWidth;
    CGFloat _cellHeight;
}

@end
@implementation CustomerCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {

        self.delegate = self;
        self.dataSource = self;
        _cellWidth = (SCREEN_WIDTH - 30) / 3.0;
        _cellHeight = 65.0;
        [self registerClass:[CustomerCell class] forCellWithReuseIdentifier:customerCell];
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
    CustomerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerCell forIndexPath:indexPath];
    [cell loadDataWith:self.arrData[indexPath.item] touchEnable:[TheCustomer.authoritys[indexPath.row] boolValue]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CUSTOMER_360_SELECT object:nil userInfo:@{@"section": [NSNumber numberWithInteger:indexPath.section],@"item": [NSNumber numberWithInteger:indexPath.item]}];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( _cellWidth, _cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - setter getter

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
