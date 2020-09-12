//
//  UsedCollectionView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UsedCollectionView;
@protocol UsedCollectionViewDelegate <NSObject>

@optional
- (void)usedCollectionView:(UsedCollectionView *)usedCollectionView selected:(NSDictionary *)item indexPath:(NSIndexPath *)indexPath;

@end

@interface UsedCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, weak) id <UsedCollectionViewDelegate> usedDelegate;

@end
