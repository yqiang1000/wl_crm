//
//  FilterListView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "FilterListView.h"

@interface FilterListView () <FilterCollectionViewDelegate>

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation FilterListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.backgroundColor = [UIColor clearColor];
//        self.collectionView.backgroundColor = COLOR_CLEAR;
        [UIView animateWithDuration:0.35 animations:^{
            self.backgroundColor = COLOR_MASK;
//            self.collectionView.backgroundColor = COLOR_B4;
        }];
    }
    return self;
}

- (instancetype)initWithSourceType:(NSInteger)sourceType {
    self = [super init];
    if (self) {
        _sourceType = sourceType;
        self.collectionView.sourceType = _sourceType;
        
        [self setUI];
        self.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.35 animations:^{
            self.backgroundColor = COLOR_MASK;
        }];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(filterListViewDismiss:)]) {
        [_delegate filterListViewDismiss:self];
    }
}

- (void)dealloc {
    NSLog(@"filterListView 释放");
}

#pragma mark - event
- (void)btnResetClick:(UIButton *)sender
{
    [_collectionView.indexPathArr removeAllObjects];
    [_collectionView reloadData];
    
    [self btnOKClick:nil];
}

- (void)btnOKClick:(UIButton *)sender
{
}

#pragma mark - FilterCollectionViewDelegate

- (void)filterCollectionView:(FilterCollectionView *)filterCollectionView didSelectIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(filterListView:didSelectIndexPath:filterTag:)]) {
        [_delegate filterListView:self didSelectIndexPath:indexPath filterTag:self.filterTag];
    } else if (_delegate && [_delegate respondsToSelector:@selector(filterListView:didSelectIndexPath:)]) {
        [_delegate filterListView:self didSelectIndexPath:indexPath];
    }
}

#pragma mark - public

- (void)loadData:(NSArray *)data {
    _arrData = data;
    self.collectionView.arrData = _arrData;
    [self.collectionView reloadData];
}

- (void)updateViewHeight:(CGFloat)viewHeight bottomHeight:(CGFloat)bottomHeight {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat collectionH = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
        if (collectionH > viewHeight-bottomHeight) {
            self.collectionView.scrollEnabled = YES;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(viewHeight));
                make.bottom.lessThanOrEqualTo(self).offset(-bottomHeight);
            }];
        } else {
            self.collectionView.scrollEnabled = NO;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionH));
                make.bottom.lessThanOrEqualTo(self).offset(-bottomHeight);
            }];
        }
        
        if (_sourceType == 1 && _bottomView == nil) {
            [self addSubview:self.bottomView];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self.collectionView.mas_bottom);
                make.height.equalTo(@45);
            }];
        }
        [self layoutIfNeeded];
    });
}

#pragma mark - setter getter

- (FilterCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[FilterCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = COLOR_B4;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 15, 30, 15);
        _collectionView.filterCollectionViewDelegate = self;
    }
    return _collectionView;
}

- (NSArray *)arrData {
    if (!_arrData) {
        _arrData = [NSArray new];
    }
    return _arrData;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = COLOR_C1;
        
        UIButton *btnReset = [[UIButton alloc] init];
        [btnReset setTitle:@"重置" forState:UIControlStateNormal];
        [btnReset setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        [btnReset setBackgroundColor:COLOR_B3];
        btnReset.titleLabel.font = FONT_F13;
        [btnReset addTarget:self action:@selector(btnResetClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btnReset];
        
        UIButton *btnOK = [[UIButton alloc] init];
        [btnOK setTitle:@"确定" forState:UIControlStateNormal];
        [btnOK setTitleColor:COLOR_B3 forState:UIControlStateNormal];
        [btnOK setBackgroundColor:COLOR_C1];
        btnOK.titleLabel.font = FONT_F13;
        [btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:btnOK];
        
        [btnReset mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.equalTo(_bottomView);
            make.centerY.equalTo(_bottomView);
        }];
        
        [btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnReset.mas_right);
            make.centerY.equalTo(_bottomView);
            make.right.equalTo(_bottomView);
            make.height.equalTo(btnReset);
            make.width.equalTo(btnReset);
        }];
    }
    return _bottomView;
}

@end
