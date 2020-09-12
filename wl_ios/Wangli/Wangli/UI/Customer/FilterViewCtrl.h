//
//  FilterViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"

@class FilterViewCtrl;
@protocol FilterViewCtrlDelegate <NSObject>

@optional
- (void)filterViewCtrlDismiss:(FilterViewCtrl *)filterViewCtrl;

- (void)filterView:(FilterViewCtrl *)filterView btnOKClick:(NSMutableArray *)arrIndexPath;
- (void)filterView:(FilterViewCtrl *)filterView btnReSetClick:(NSMutableArray *)arrIndexPath;

@end

@interface FilterViewCtrl : BaseViewCtrl

@property (nonatomic, assign) CGFloat topPadding;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) NSMutableArray *indexPathArr;

@property (nonatomic, weak) id <FilterViewCtrlDelegate> filterViewCtrlDelegate;

- (void)refreshCollectionView;

@end
