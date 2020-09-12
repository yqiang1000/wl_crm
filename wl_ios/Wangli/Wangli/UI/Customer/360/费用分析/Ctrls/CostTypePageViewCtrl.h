//
//  CostTypePageViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "GKBasePageViewController.h"
#import "GKPageScrollView.h"
#import "GKBaseListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CostTypePageViewCtrl : GKBaseViewController <GKPageScrollViewDelegate>

// pageScrollView
@property (nonatomic, strong) GKPageScrollView *pageScrollView;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIView *topHeader;

@property (nonatomic, strong) UIView *pageView;

@property (nonatomic, strong) NSArray *childVCs;

@end

NS_ASSUME_NONNULL_END
