//
//  UsedCollectionCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsedMo.h"

#pragma mark - UsedCollectionCell

@interface UsedCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UsedMo *mo;
- (void)loadDataWith:(UsedMo *)model;

@end

#pragma mark - UsedHeaderView

@interface UsedHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *labText;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *imgView;

@end

#pragma mark - UsedFooterView

@interface UsedFooterView : UICollectionReusableView


@end
