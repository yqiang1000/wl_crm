//
//  PurchaseCollectionView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchaseCollectionView.h"

#pragma mark - PurchaseCollectionView

static NSString *identifier = @"PurchaseCollectionCell";
static NSString *identifier1 = @"PurchaseCollectionThreeCell";

@interface PurchaseCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end


@implementation PurchaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.backgroundColor = COLOR_B0;
        [self registerClass:[PurchaseCollectionCell class] forCellWithReuseIdentifier:identifier];
        [self registerClass:[PurchaseCollectionThreeCell class] forCellWithReuseIdentifier:identifier1];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrCardData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrCardData.count >= 5) {
        PurchaseCollectionThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
        [cell loadDataWith:self.arrCardData[indexPath.item]];
        return cell;
    } else {
        PurchaseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell loadDataWith:self.arrCardData[indexPath.item]];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_purchaseCollectionViewDelegate && [_purchaseCollectionViewDelegate respondsToSelector:@selector(purchaseCollectionView:didSelectedIndexPath:purchaseItemMo:)]) {
        [_purchaseCollectionViewDelegate purchaseCollectionView:self didSelectedIndexPath:indexPath purchaseItemMo:self.arrCardData[indexPath.item]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.arrCardData.count >= 5 ? CGSizeMake((SCREEN_WIDTH-30)/3.0, 100) : CGSizeMake((SCREEN_WIDTH-40)/2.0, 90);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.arrCardData.count >= 5 ? 5 : 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.arrCardData.count >= 5 ? 5 : 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.arrCardData.count >= 5 ? UIEdgeInsetsMake(15, 10, 0, 10) : UIEdgeInsetsMake(15, 15, 0, 10);
}

@end

#pragma mark - PurchaseCollectionCell 每行两个

@interface PurchaseCollectionCell ()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labNum;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *baseView;

@end

@implementation PurchaseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.imgIcon];
    [self.baseView addSubview:self.rightView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baseView);
        make.left.equalTo(self.baseView).offset(15);
        make.height.width.equalTo(@43.0);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baseView);
        make.left.equalTo(self.imgIcon.mas_right).offset(12);
        make.right.equalTo(self.baseView);
    }];
}

#pragma mark - public

- (void)loadDataWith:(PurchaseItemMo *)model {
    if (_model != model) {
        _model = model;
    }
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:_model.iconUrl]];
    self.labNum.text = [NSString stringWithFormat:@"%ld", _model.count];
    self.labTitle.text = _model.fieldValue;
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 5;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        
        [_rightView addSubview:self.labNum];
        [_rightView addSubview:self.labTitle];
        
        [_labNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rightView);
            make.left.equalTo(_rightView);
            make.right.lessThanOrEqualTo(_rightView);
        }];
        
        [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labNum.mas_bottom).offset(12);
            make.left.equalTo(_labNum);
            make.right.lessThanOrEqualTo(_rightView);
            make.bottom.equalTo(_rightView);
        }];
    }
    return _rightView;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
        _imgIcon.layer.mask = [Utils drawContentFrame:_imgIcon.bounds corners:UIRectCornerAllCorners cornerRadius:21.5];
        _imgIcon.clipsToBounds = YES;
        _imgIcon.backgroundColor = COLOR_B4;
    }
    return _imgIcon;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F14;
        _labTitle.textColor = COLOR_B2;
        _labTitle.numberOfLines = 0;
    }
    return _labTitle;
}

- (UILabel *)labNum {
    if (!_labNum) {
        _labNum = [[UILabel alloc] init];
        _labNum.font = FONT_F18;
        _labNum.textColor = COLOR_B1;
    }
    return _labNum;
}

@end



#pragma mark - PurchaseCollectionThreeCell 每行三个


@interface PurchaseCollectionThreeCell ()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIView *baseView;

@end

@implementation PurchaseCollectionThreeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.imgIcon];
    [self.baseView addSubview:self.labTitle];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(16);
        make.height.width.equalTo(@43);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.imgIcon.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(5);
    }];
}

#pragma mark - public

- (void)loadDataWith:(PurchaseItemMo *)model {
    if (_model != model) {
        _model = model;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld", _model.fieldValue, _model.count]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_B1 range:NSMakeRange(_model.fieldValue.length, attrStr.length - _model.fieldValue.length)];
    self.labTitle.attributedText = attrStr;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:_model.iconUrl]];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.cornerRadius = 4;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
        _imgIcon.layer.mask = [Utils drawContentFrame:_imgIcon.bounds corners:UIRectCornerAllCorners cornerRadius:21.5];
        _imgIcon.clipsToBounds = YES;
        _imgIcon.backgroundColor = COLOR_B4;
    }
    return _imgIcon;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B2;
        _labTitle.numberOfLines = 0;
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}


@end
