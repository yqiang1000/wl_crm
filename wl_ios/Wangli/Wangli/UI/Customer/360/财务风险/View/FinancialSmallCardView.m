//
//  FinancialSmallCardView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "FinancialSmallCardView.h"

#pragma mark - FinancialSmallCardView

static NSString *identifier = @"FinancialSmallCell";

@interface FinancialSmallCardView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *btnAuthor;

@end

@implementation FinancialSmallCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR_CLEAR;
        [self.collectionView registerClass:[FinancialSmallCell class] forCellWithReuseIdentifier:identifier];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.collectionView];
    [self addSubview:self.btnAuthor];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    [self.btnAuthor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@40.0);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrSmallData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FinancialSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell loadDataWith:self.arrSmallData[indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate



#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake((SCREEN_WIDTH-20)/2.0, 100);
//}

#pragma mark - event

- (void)refreshView {
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.arrSmallData.count == 0) {
                make.height.equalTo(@10.0);
            } else {
                make.height.equalTo(@(_collectionView.collectionViewLayout.collectionViewContentSize.height));
            }
        }];
        [self layoutIfNeeded];
    });
}

- (void)setMsg:(NSString *)msg {
    _msg = msg;
    [_btnAuthor setTitle:(_msg.length == 0 ? @"暂无更新信息" : _msg) forState:UIControlStateNormal];
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-40)/2.0, 100);
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = COLOR_B0;
    }
    return _collectionView;
}

- (UIButton *)btnAuthor {
    if (!_btnAuthor) {
        _btnAuthor = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 40)];
        [_btnAuthor setTitle:@"暂无相关信息" forState:UIControlStateNormal];
        [_btnAuthor setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        [_btnAuthor setBackgroundColor:COLOR_B4];
        _btnAuthor.titleLabel.font = FONT_F14;
        _btnAuthor.layer.mask = [Utils drawContentFrame:_btnAuthor.bounds corners:UIRectCornerAllCorners cornerRadius:5];
        _btnAuthor.clipsToBounds = YES;
    }
    return _btnAuthor;
}

- (NSMutableArray *)arrSmallData {
    if (!_arrSmallData) _arrSmallData = [[NSMutableArray alloc] init];
    return _arrSmallData;
}

@end


#pragma mark - FinancialSmallCell

@interface FinancialSmallCell ()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labNum;
@property (nonatomic, strong) UILabel *labUnit;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labMsg;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *baseView;

@end

@implementation FinancialSmallCell

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
        make.left.equalTo(self.baseView).offset(10);
        make.height.width.equalTo(@43.0);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.baseView);
        make.left.equalTo(self.imgIcon.mas_right).offset(12);
        make.right.equalTo(self.baseView);
    }];
}

#pragma mark - public

- (void)loadDataWith:(CreditMo *)model {
    if (_model != model) {
        _model = model;
    }
    
//    "field": "资产总额",
//    "fieldTitle": "负债率：0.00%",
//    "fieldValue": 0,
//    "unit": "万",
//    "iconUrl": ""
    self.labNum.text = _model.fieldValue;
    self.labUnit.text = _model.unit;
    self.labTitle.text = _model.field;
    self.labMsg.text = _model.fieldTitle;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:@"c_poduct_capacity"]];
    
    if (_model.fieldTitle.length == 0) {
        self.labMsg.hidden = YES;
        [_labTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labNum.mas_bottom).offset(10);
            make.left.equalTo(_labNum);
            make.right.lessThanOrEqualTo(_rightView);
            make.bottom.equalTo(_rightView);
        }];
        
        [_labMsg mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
    } else {
        self.labMsg.hidden = NO;
        [_labTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labNum.mas_bottom).offset(10);
            make.left.equalTo(_labNum);
            make.right.lessThanOrEqualTo(_rightView);
        }];
        
        [_labMsg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labTitle.mas_bottom).offset(10);
            make.left.equalTo(_labNum);
            make.right.lessThanOrEqualTo(_rightView);
            make.bottom.equalTo(_rightView);
        }];
    }
    [self layoutIfNeeded];
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
        [_rightView addSubview:self.labUnit];
        [_rightView addSubview:self.labTitle];
        [_rightView addSubview:self.labMsg];
        
        [_labNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rightView);
            make.left.equalTo(_rightView);
            make.right.lessThanOrEqualTo(_rightView);
        }];
        
        [_labUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_labNum);
            make.left.equalTo(_labNum.mas_right).offset(2);
            make.right.lessThanOrEqualTo(_rightView);
        }];
        
        [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labNum.mas_bottom).offset(10);
            make.left.equalTo(_labNum);
            make.right.lessThanOrEqualTo(_rightView);
        }];
        
        [_labMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labTitle.mas_bottom).offset(10);
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
    }
    return _labTitle;
}

- (UILabel *)labNum {
    if (!_labNum) {
        _labNum = [[UILabel alloc] init];
        _labNum.font = FONT_F18;
        _labNum.textColor = COLOR_B1;
        _labNum.numberOfLines = 0;
    }
    return _labNum;
}

- (UILabel *)labUnit {
    if (!_labUnit) {
        _labUnit = [[UILabel alloc] init];
        _labUnit.font = FONT_F12;
        _labUnit.textColor = COLOR_B3;
    }
    return _labUnit;
}

- (UILabel *)labMsg {
    if (!_labMsg) {
        _labMsg = [[UILabel alloc] init];
        _labMsg.font = FONT_F12;
        _labMsg.textColor = COLOR_B3;
    }
    return _labMsg;
}

@end
