//
//  Custom360ServiceViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "Custom360ServiceViewCtrl.h"
#import "ServicePageViewCtrl.h"

@interface Custom360ServiceViewCtrl ()

@property (nonatomic, strong) ServicePageViewCtrl *pageViewCtrl;

@end

@implementation Custom360ServiceViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    [self.view addSubview:self.pageViewCtrl.view];
    [self.pageViewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - lazy

- (ServicePageViewCtrl *)pageViewCtrl {
    if (!_pageViewCtrl) {
        _pageViewCtrl = [[ServicePageViewCtrl alloc] init];
    }
    return _pageViewCtrl;
}


@end
