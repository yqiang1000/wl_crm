//
//  GKBasePageViewController.h
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKPageScrollView.h"
#import "GKBaseListViewController.h"
#import "JXCategoryView.h"

#define kBaseHeaderHeight  kScreenW * 385.0f / 704.0f
#define kBaseSegmentHeight 40.0f

NS_ASSUME_NONNULL_BEGIN

@interface GKBasePageViewController : GKBaseViewController <GKPageScrollViewDelegate>

// pageScrollView
@property (nonatomic, strong) GKPageScrollView  *pageScrollView;

@property (nonatomic, strong) JXCategoryTitleView   *segmentView;
@property (nonatomic, strong) UIScrollView          *contentScrollView;

@property (nonatomic, strong) NSArray           *childVCs;

@end


NS_ASSUME_NONNULL_END
