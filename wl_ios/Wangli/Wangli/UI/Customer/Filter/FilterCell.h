//
//  FilterCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 排序cell

@interface ScortCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *labTxt;
@property (nonatomic, strong) UIImageView *imgArraw;
@property (nonatomic, strong) UIView *lineView;

@end

#pragma mark - 筛选cell

@interface FilterCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, assign) BOOL cellIsSelected;

@end

#pragma mark - 筛选sectionHeader

@class FilterHeaderView;
@protocol FilterHeaderViewDelegate <NSObject>

@optional
- (void)filterHeaderViewSelected:(FilterHeaderView *)filterHeaderView indexPath:(NSIndexPath *)indexPath;

@end

@interface FilterHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIButton *btnArrow;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL hidenLine;
@property (nonatomic, weak) id <FilterHeaderViewDelegate> headerDelegate;

- (void)leftText:(NSString *)text;
- (void)rightText:(NSString *)text;

@end
