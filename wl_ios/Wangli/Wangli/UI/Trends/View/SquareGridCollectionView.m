//
//  SquareGridCollectionView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "SquareGridCollectionView.h"
#import "SquareGridCollectionCell.h"

@interface SquareGridCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UIButton *btnArrow;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

static NSString *identifier = @"SquareGridCollectionCell";

@implementation SquareGridCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    _layout = (UICollectionViewFlowLayout *)layout;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = COLOR_C1;
        [self registerClass:[SquareGridCollectionCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

- (void)updateDirection:(BOOL)vertical {
    _layout.scrollDirection = vertical ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SquareGridCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell loadData:self.arrData[indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_squareGridCollectionViewDelegate && [_squareGridCollectionViewDelegate respondsToSelector:@selector(squareGridCollectionView:didSelectIndex:title:)]) {
        SquareMo *mo = self.arrData[indexPath.row];
        [_squareGridCollectionViewDelegate squareGridCollectionView:self didSelectIndex:indexPath.item title:mo.title];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kCellWidth, kCellWidth*kCellRate);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - lazy

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"情报",
                            @"活动",
                            @"线索",
                            @"商机",
                            
                            @"样品",
                            @"报价",
                            @"合同",
                            @"订单",
                            
                            @"发货",
                            @"发票",
                            @"收款",
                            @"客诉"];
        NSArray *images = @[@"dynamic_intelligence",
                            @"dynamic_activity",
                            @"dynamic_clue",
                            @"dynamic_business ",
                            
                            @"dynamic_sample",
                            @"dynamic_offer",
                            @"dynamic_contract",
                            @"dynamic_order",
                            
                            @"dynamic_delivery",
                            @"dynamic_invoice",
                            @"dynamic_receivables",
                            @"dynamic_complaint"];
        for (int i = 0; i < titles.count; i++) {
            SquareMo *mo = [[SquareMo alloc] init];
            mo.title = titles[i];
            mo.image = images[i];
            [_arrData addObject:mo];
        }
        
    }
    return _arrData;
}

@end
