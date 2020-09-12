//
//  TrendsMoreView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsMoreView.h"
#import "TrendsMoreCell.h"

@interface TrendsMoreView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *identifier = @"TrendsMoreCell";

@implementation TrendsMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self.collectionView registerClass:[TrendsMoreCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@0.0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [self.collectionView.layer convertPoint:point fromLayer:self.layer];
    if (![self.collectionView.layer containsPoint:point]) {
        if (_trendsMoreViewDelegate && [_trendsMoreViewDelegate respondsToSelector:@selector(trendsMoreView:didSelectIndex:title:)]) {
            [_trendsMoreViewDelegate trendsMoreView:self didSelectIndex:-1 title:@""];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrendsMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell loadData:self.arrData[indexPath.item]];
    if (_currentTag == indexPath.item) {
        cell.labText.textColor = COLOR_C1;
        cell.contentView.backgroundColor = [UIColor colorWithRed:COLOR_C1.red green:COLOR_C1.green blue:COLOR_C1.blue alpha:0.1];
    } else {
        cell.labText.textColor = COLOR_B1;
        cell.contentView.backgroundColor = COLOR_F4F4F4;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_trendsMoreViewDelegate && [_trendsMoreViewDelegate respondsToSelector:@selector(trendsMoreView:didSelectIndex:title:)]) {
        NSString *title = self.arrData[indexPath.row];
        [_trendsMoreViewDelegate trendsMoreView:self didSelectIndex:indexPath.item title:title];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(53, 32);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - public

- (void)showView {
    self.backgroundColor = COLOR_CLEAR;
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.35 animations:^{
            self.backgroundColor = COLOR_MASK;
            CGFloat height = _collectionView.collectionViewLayout.collectionViewContentSize.height;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height));
            }];
            [self layoutIfNeeded];
        }];
    });
}

- (void)hidenView {
    self.backgroundColor = COLOR_MASK;
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = COLOR_CLEAR;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.0);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (_trendsMoreViewDelegate && [_trendsMoreViewDelegate respondsToSelector:@selector(trendsMoreViewDismiss:)]) {
            [_trendsMoreViewDelegate trendsMoreViewDismiss:self];
        }
    }];
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_B4;
    }
    return _collectionView;
}

@end
