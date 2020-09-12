//
//  PurchaseCollectionView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseItemMo.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - PurchaseCollectionView
@class PurchaseCollectionView;
@protocol PurchaseCollectionViewDelegate <NSObject>

@optional
- (void)purchaseCollectionView:(PurchaseCollectionView *)purchaseCollectionView didSelectedIndexPath:(NSIndexPath *)indexPath purchaseItemMo:(PurchaseItemMo *)purchaseItemMo;

@end

@interface PurchaseCollectionView : UICollectionView

@property (nonatomic, weak) id <PurchaseCollectionViewDelegate> purchaseCollectionViewDelegate;
@property (nonatomic, strong) NSMutableArray *arrCardData;

@end

#pragma mark - PurchaseCollectionCell 每行两个

@interface PurchaseCollectionCell : UICollectionViewCell;

@property (nonatomic, strong) PurchaseItemMo *model;

- (void)loadDataWith:(PurchaseItemMo *)model;

@end


#pragma mark - PurchaseCollectionThreeCell 每行三个

@interface PurchaseCollectionThreeCell : UICollectionViewCell;

@property (nonatomic, strong) PurchaseItemMo *model;

- (void)loadDataWith:(PurchaseItemMo *)model;

@end



NS_ASSUME_NONNULL_END
