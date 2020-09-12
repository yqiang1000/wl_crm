//
//  SquareGridCollectionCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SquareMo

@interface SquareMo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;

@end

#pragma mark - SquareGridCollectionCell

@interface SquareGridCollectionCell : UICollectionViewCell

@property (nonatomic, strong) SquareMo *model;
- (void)loadData:(SquareMo *)model;

@end

NS_ASSUME_NONNULL_END
