//
//  JGGImageView.m
//  Wangli
//
//  Created by yeqiang on 2018/7/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "JGGImageView.h"
#import "ImagePreviewViewCtrl.h"

static NSString *jggCell = @"jggCell";

#pragma mark - JGGImageView

@interface JGGImageView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation JGGImageView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = COLOR_B4;
        [self registerClass:[JGGCell class] forCellWithReuseIdentifier:jggCell];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrImgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JGGCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:jggCell forIndexPath:indexPath];
    cell.indexPath = indexPath;
    [cell showImage:self.arrImgs[indexPath.row]];
    cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImagePreviewViewCtrl *ctrl = [[ImagePreviewViewCtrl alloc] initWithArrImage:self.arrImgs currIndex:indexPath.row];
    ctrl.hidenDelete = YES;
    ctrl.hidesBottomBarWhenPushed = YES;
//    ctrl.imgPrevCtrlDelegate = self;
    [[Utils topViewController].navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - lazy

- (NSMutableArray *)arrImgs {
    if (!_arrImgs) {
        _arrImgs = [NSMutableArray new];
    }
    return _arrImgs;
}

@end


#pragma mark - JGGCell

@implementation JGGCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - public

- (void)showImage:(id)image {
    if ([image isKindOfClass:[UIImage class]]) {
        self.imgView.image = image;
    } else if ([image isKindOfClass:[QiniuFileMo class]]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:((QiniuFileMo *)image).thumbnail] placeholderImage:[UIImage imageNamed:@"riskImage_empty"]];
    }
}

#pragma mark - setter getter

- (BaseImageView *)imgView {
    if (!_imgView) {
        _imgView = [[BaseImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

@end
