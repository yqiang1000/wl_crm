//
//  GKBasePageViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKPageScrollView.h"
#import "GKBaseListViewController.h"

NS_ASSUME_NONNULL_BEGIN

#define kBaseHeaderHeight  kScreenW * 385.0f / 704.0f
#define kBaseSegmentHeight 30.0f

@interface GKBasePageViewCtrl : GKBaseViewController <GKPageScrollViewDelegate>

// pageScrollView
@property (nonatomic, strong) GKPageScrollView  *pageScrollView;

@property (nonatomic, strong) UIScrollView          *contentScrollView;

@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, strong) UIImageView           *headerView;

@property (nonatomic, strong) UIView                *pageView;

@property (nonatomic, strong) NSArray           *childVCs;

@end

NS_ASSUME_NONNULL_END
