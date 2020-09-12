//
//  PurchasePageViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKPageScrollView.h"
#import "GKBaseListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PurchasePageViewCtrl : GKBaseViewController <GKPageScrollViewDelegate>

// pageScrollView
@property (nonatomic, strong) GKPageScrollView *pageScrollView;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIView *topHeader;

@property (nonatomic, strong) UIView *pageView;

@property (nonatomic, strong) NSArray *childVCs;

@property (nonatomic, strong) DicMo *currentDic;

@end

NS_ASSUME_NONNULL_END
