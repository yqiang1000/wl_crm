//
//  Custom360CostAnalysisViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "Custom360CostAnalysisViewCtrl.h"
#import "CostTypePageViewCtrl.h"

@interface Custom360CostAnalysisViewCtrl ()

@property (nonatomic, strong) CostTypePageViewCtrl *pageViewCtrl;

@end

@implementation Custom360CostAnalysisViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)dealloc {
    [_pageViewCtrl.view removeFromSuperview];
    _pageViewCtrl = nil;
}

- (void)setUI {
    [self.view addSubview:self.pageViewCtrl.view];
    [self.pageViewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - evnet

#pragma mark - lazy

- (CostTypePageViewCtrl *)pageViewCtrl {
    if (!_pageViewCtrl) {
        _pageViewCtrl = [[CostTypePageViewCtrl alloc] init];
    }
    return _pageViewCtrl;
}

@end
