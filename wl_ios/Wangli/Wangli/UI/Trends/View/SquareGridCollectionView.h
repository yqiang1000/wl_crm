//
//  SquareGridCollectionView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kCellRate (75/93.0)
#define kCellWidth (SCREEN_WIDTH/4.0)


@class SquareGridCollectionView;
@protocol SquareGridCollectionViewDelegate <NSObject>
@optional
- (void)squareGridCollectionView:(SquareGridCollectionView *)squareGridCollectionView didSelectIndex:(NSInteger)index title:(NSString *)title;

@end

@interface SquareGridCollectionView : UICollectionView

// 是否是竖直
- (void)updateDirection:(BOOL)vertical;

@property (nonatomic, weak) id <SquareGridCollectionViewDelegate> squareGridCollectionViewDelegate;

@end

NS_ASSUME_NONNULL_END
