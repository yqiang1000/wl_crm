//
//  RiskTotalCollectionView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/17.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RiskTotalCollectionView;
@protocol RiskTotalCollectionViewDelegate <NSObject>
@optional
- (void)riskTotalCollectionView:(RiskTotalCollectionView *)riskTotalCollectionView didSelectIndexPath:(NSIndexPath *)indexPath;
@end

@interface RiskTotalCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, weak) id <RiskTotalCollectionViewDelegate> viewDelegate;

@end
