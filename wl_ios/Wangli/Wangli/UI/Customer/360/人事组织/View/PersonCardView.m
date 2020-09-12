//
//  PersonCardView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PersonCardView.h"
#import "PersonCardCell.h"
#import "PersonnelCreateViewCtrl.h"

static NSString *identifier = @"personCardCell";

@interface PersonCardView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate>

@property (nonatomic, strong) UIButton *btnPrevious;
@property (nonatomic, strong) UIButton *btnNext;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PersonCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.collectionView registerClass:[PersonCardCell class] forCellWithReuseIdentifier:identifier];
        [self setUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.collectionView registerClass:[PersonCardCell class] forCellWithReuseIdentifier:identifier];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.collectionView];
    [self addSubview:self.btnPrevious];
    [self addSubview:self.btnNext];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.btnPrevious mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(@40.0);
        make.height.equalTo(self);
    }];
    
    [self.btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(@40.0);
        make.height.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGFloat offsetX = self.collectionView.contentOffset.x;
        NSInteger index = offsetX / CGRectGetWidth(self.collectionView.frame);
        _currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        NSLog(@"减速滑动到----%ld", (long)index);
        if (_delegate && [_delegate respondsToSelector:@selector(personCardViewLoadMoreData:needLoadMore:completeBlock:)]) {
            // 滑动到某一页,是否需要请求新数据
            // 0 - n-1 不需要加载更多，n需要加载更多
            BOOL needLoadMore = (index >= 0 && index < self.arrData.count-1) ? NO : YES;
            [_delegate personCardViewLoadMoreData:self needLoadMore:needLoadMore completeBlock:^{
                
            }];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrData.count == 0) {
        return;
    }
     NSLog(@"将要显示 --- %ld", indexPath.item);
    _currentIndexPath = indexPath;
    if (indexPath.row == self.arrData.count-1) {
        if (_delegate && [_delegate respondsToSelector:@selector(personCardViewLoadMoreData:needLoadMore:completeBlock:)]) {
            [_delegate personCardViewLoadMoreData:self needLoadMore:NO completeBlock:^{
            }];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(personCardView:didShowIndexPath:)]) {
        [_delegate personCardView:self didShowIndexPath:_currentIndexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    // 滑动到一半的时候又滑回去的场景，需要重新计算偏移量
//    NSLog(@"完成显示 --- %ld", indexPath.item);
//    if (_currentIndexPath != indexPath) {
//        _currentIndexPath = indexPath;
//        CGFloat offsetX = self.collectionView.contentOffset.x;
//        NSInteger index = offsetX / CGRectGetWidth(self.collectionView.frame);
//        if (index >= 0 && index < self.arrData.count) {
//            if (_delegate && [_delegate respondsToSelector:@selector(personCardView:didShowIndexPath:)]) {
//                [_delegate personCardView:self didShowIndexPath:_currentIndexPath];
//            }
//        }
//    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrData.count == 0) {
        return;
    }
    ContactMo *contactMo = self.arrData[indexPath.item];
    PersonnelCreateViewCtrl *vc = [[PersonnelCreateViewCtrl alloc] init];
    vc.mo = contactMo;
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(ContactMo *obj) {
        __strong typeof(self) strongself = weakself;
        [strongself.arrData replaceObjectAtIndex:indexPath.item withObject:obj];
        [strongself.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    };
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrData.count == 0 ? 1 : self.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PersonCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];;
    if (self.arrData.count == 0) {
        [cell loadData:[[ContactMo alloc] init]];
    } else {
        [cell loadData:self.arrData[indexPath.row]];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, 235);
}

#pragma mark - UICollectionViewDragDelegate


#pragma mark - public

- (void)setArrData:(NSMutableArray *)arrData {
    _arrData = arrData;
    [self.collectionView reloadData];
}

- (void)resetView {
    _currentIndexPath = nil;
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - event

- (void)btnPreviousClick:(UIButton *)sender {
    if (_currentIndexPath.item == 0) {
        return;
    }
    
    CGPoint point = CGPointMake(CGRectGetWidth(self.collectionView.frame)*(_currentIndexPath.item-1), 0);
    [self.collectionView setContentOffset:point animated:YES];
}

- (void)btnNextClick:(UIButton *)sender {
    if (self.arrData.count == 0) {
        return;
    }
    // 滑动到下一页
    if (_currentIndexPath.item < self.arrData.count-1) {
        CGPoint point = CGPointMake(CGRectGetWidth(self.collectionView.frame)*(_currentIndexPath.item+1), 0);
        [self.collectionView setContentOffset:point animated:YES];
    }
    
    // 滑动到倒数第二页时，加载下一页数据
    if (_currentIndexPath.item == self.arrData.count-2) {
        if (self.canGetNewData && _delegate && [_delegate respondsToSelector:@selector(personCardViewLoadMoreData:needLoadMore:completeBlock:)]) {
            NSLog(@"请求新数据");
            [_delegate personCardViewLoadMoreData:self needLoadMore:YES completeBlock:^{
            }];
        }
    }
}

#pragma mark - lazy

- (UIButton *)btnPrevious {
    if (!_btnPrevious) {
        _btnPrevious = [UIButton new];
        [_btnPrevious setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
        [_btnPrevious addTarget:self action:@selector(btnPreviousClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPrevious;
}

- (UIButton *)btnNext {
    if (!_btnNext) {
        _btnNext = [UIButton new];
        [_btnNext setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_btnNext addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNext;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = COLOR_B4;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
