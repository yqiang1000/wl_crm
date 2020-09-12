//
//  PersonnelPageViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKPageScrollView.h"
#import "GKBaseListViewController.h"
#import "ContactMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonnelPageViewCtrl : GKBaseViewController <GKPageScrollViewDelegate>

// pageScrollView
@property (nonatomic, strong) GKPageScrollView *pageScrollView;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIView *topHeader;

@property (nonatomic, strong) UIView *pageView;

@property (nonatomic, strong) NSArray *childVCs;

// 获取人员列表
- (void)getNewOfficeId:(long long)officeId page:(NSInteger)page;

@property (nonatomic, strong) ContactMo *currentMo;

@end

NS_ASSUME_NONNULL_END
