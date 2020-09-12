//
//  UsedCollectionView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "UsedCollectionView.h"
#import "UsedCollectionCell.h"

static NSString *identifier = @"usedCollectionCell";
static NSString *headerId = @"filterHeaderView";
static NSString *footerId = @"filterFooterView";

@interface UsedCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

{
    CGFloat _cellWidth;
    CGFloat _cellHeight;
}

@end
@implementation UsedCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        _cellWidth = SCREEN_WIDTH / 4.0;
        _cellHeight = 84;
        [self registerClass:[UsedCollectionCell class] forCellWithReuseIdentifier:identifier];
        [self registerClass:[UsedHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [self registerClass:[UsedFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.arrData.count;
}
//13819717688

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    TabUsedMo *dic = self.arrData[section];
    NSArray *arr = dic.items;
    NSInteger x = arr.count % 4;
    NSInteger y = arr.count / 4;
    return (x == 0) ? (y * 4) : (y * 4 + 4);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UsedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    TabUsedMo *dic = self.arrData[indexPath.section];
    NSArray *arr = dic.items;
    if (indexPath.row >= arr.count) {
        [cell loadDataWith:nil];
    } else {
        UsedMo *mo = [[UsedMo alloc] initWithDictionary:arr[indexPath.item] error:nil];
        [cell loadDataWith:mo];
//        NSLog(@"------section: %ld-----------row: %ld,",indexPath.section, indexPath.row);
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TabUsedMo *dic = self.arrData[indexPath.section];
    NSArray *arr = dic.items;
    if (indexPath.row >= arr.count) {
        return;
    } else {
        if (_usedDelegate && [_usedDelegate respondsToSelector:@selector(usedCollectionView:selected:indexPath:)]) {
            [_usedDelegate usedCollectionView:self selected:arr[indexPath.item] indexPath:indexPath];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_cellWidth, _cellHeight);
}

//footer的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    TabUsedMo *dic = self.arrData[section];
    NSArray *arr = dic.items;
    if (arr.count == 0) {
        return CGSizeMake(SCREEN_WIDTH,0.001);
    }
    return CGSizeMake(SCREEN_WIDTH,10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    TabUsedMo *dic = self.arrData[section];
    NSArray *arr = dic.items;
    if (arr.count == 0) {
        return CGSizeMake(SCREEN_WIDTH,0.001);
    }
    return CGSizeMake(SCREEN_WIDTH, 45);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UsedHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
        TabUsedMo *dic = self.arrData[indexPath.section];
        headerView.labText.text = dic.category;
        if (dic.items.count == 0) {
            headerView.hidden = YES;
        } else {
            headerView.hidden = NO;
        }
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UsedFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId forIndexPath:indexPath];
//        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
//        footerView.backgroundColor = COLOR_B0;
        return footerView;
    }
    
    return nil;
}

#pragma mark - setter getter

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
