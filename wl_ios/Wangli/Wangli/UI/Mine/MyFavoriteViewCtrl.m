//
//  MyFavoriteViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/9.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyFavoriteViewCtrl.h"
#import "ZJScrollSegmentView.h"
#import "FCustomViewCtrl.h"
#import "FTaskViewCtrl.h"
#import "FOrderViewCtrl.h"

@interface MyFavoriteViewCtrl () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ZJScrollSegmentView *segmentView;

@property (nonatomic, strong) FCustomViewCtrl *fCustomVC;
@property (nonatomic, strong) FTaskViewCtrl *fTaskVC;
@property (nonatomic, strong) FOrderViewCtrl *fOrderVC;

@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat dragStartX;
@property (nonatomic, assign) CGFloat dragEndX;

@end

static NSString *identifier = @"favoriteCell";

@implementation MyFavoriteViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    _currentTag = 0;
    [self setUI];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
}

- (void)setUI {
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.collectionView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.fCustomVC.view];
        [self.fCustomVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(cell.contentView);
        }];
//    } else if (indexPath.row == 1) {
//        [cell.contentView addSubview:self.fOrderVC.view];
//        [self.fOrderVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.equalTo(cell.contentView);
//        }];
    } else if (indexPath.row == 1) {
        [cell.contentView addSubview:self.fTaskVC.view];
        [self.fTaskVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(cell.contentView);
        }];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame),CGRectGetHeight(collectionView.frame) );
}

//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.collectionView.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _currentTag -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _currentTag += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    _currentTag = _currentTag <= 0 ? 0 : _currentTag;
    _currentTag = _currentTag >= maxIndex ? maxIndex : _currentTag;
    [self scrollToCenter];
}

//滚动到中间
- (void)scrollToCenter {
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentTag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.segmentView setSelectedIndex:_currentTag animated:YES enBlock:NO];
}

#pragma mark - lazy

- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        // 缩放标题
        style.scaleTitle = YES;
        // 颜色渐变
        style.gradualChangeTitleColor = YES;
        style.normalTitleColor = COLOR_B1;
        style.selectedTitleColor = COLOR_C1;
        style.titleFont = FONT_F13;
        style.titleMargin = 25;
        style.segmentHeight = 49;
        style.showLine = YES;
        style.scrollLineColor = COLOR_C1;
        style.autoAdjustTitlesWidth = YES;
        __weak typeof(self) weakSelf = self;
        _segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(40, STATUS_BAR_HEIGHT , SCREEN_WIDTH, style.segmentHeight) segmentStyle:style delegate:nil titles:@[@"客户", @"任务"] titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.currentTag = index;
            [strongSelf scrollToCenter];
        }];
        _segmentView.backgroundColor = COLOR_B4;
        UIView *lineView = [Utils getLineView];
        [_segmentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_segmentView);
            make.height.equalTo(@0.5);
        }];
    }
    return _segmentView;
}

- (FCustomViewCtrl *)fCustomVC {
    if (!_fCustomVC) {
        _fCustomVC = [[FCustomViewCtrl alloc] init];
    }
    return _fCustomVC;
}

- (FOrderViewCtrl *)fOrderVC {
    if (!_fOrderVC) {
        _fOrderVC = [[FOrderViewCtrl alloc] init];
    }
    return _fOrderVC;
}

- (FTaskViewCtrl *)fTaskVC {
    if (!_fTaskVC) {
        _fTaskVC = [[FTaskViewCtrl alloc] init];
    }
    return _fTaskVC;
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
        _collectionView.backgroundColor = COLOR_B0;
    }
    return _collectionView;
}

@end
