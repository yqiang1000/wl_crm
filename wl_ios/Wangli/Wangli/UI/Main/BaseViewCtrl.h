//
//  BaseViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/3/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNaviView.h"
#import "BaseNavigationCtrl.h"

typedef void(^UpdateSuccess)(id obj);

@interface BaseViewCtrl : UIViewController

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) BaseNaviView *naviView;

@property (nonatomic, assign) BOOL showNavi;

@property (nonatomic, copy) UpdateSuccess updateSuccess;

- (void)clickLeftButton:(UIButton *)sender;
- (void)clickRightButton:(UIButton *)sender;



@end
