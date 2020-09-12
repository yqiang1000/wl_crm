//
//  BaseViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/3/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface BaseViewCtrl ()

@end

@implementation BaseViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = COLOR_B0;
    //    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.naviView];
    
    [_naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(44+STATUS_BAR_HEIGHT));
    }];
    
    [self.naviView.btnBack addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.naviView.btnBack.hidden = YES;
    if (self.navigationController == nil || self.navigationController.viewControllers.count > 1) {
        self.naviView.btnBack.hidden = NO;
    }
    self.leftBtn = self.naviView.btnBack;
    self.rightBtn = self.naviView.rightBtn;
    //右按钮
    [_rightBtn addTarget:self action:@selector(clickRightButton:)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightButton:(UIButton *)sender
{
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@----销毁", NSStringFromClass([self class]));
}

#pragma mark - public

- (void)setShowNavi:(BOOL)showNavi {
    _showNavi = showNavi;
    self.naviView.hidden = !_showNavi;
}

- (void)setTitle:(NSString *)title {
    super.title = title;
    self.naviView.labTitle.text = title;
}

- (BaseNaviView *)naviView {
    if (!_naviView) {
        _naviView = [[BaseNaviView alloc] init];
    }
    return _naviView;
}

@end
