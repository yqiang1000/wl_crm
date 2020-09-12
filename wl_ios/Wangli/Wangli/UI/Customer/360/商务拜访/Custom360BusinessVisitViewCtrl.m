//
//  Custom360BusinessVisitViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "Custom360BusinessVisitViewCtrl.h"
#import "SwitchView.h"
#import "BusinessReceptionViewCtrl.h"
#import "BusinessVisitViewCtrl.h"
#import "BusinessCommonCreateViewCtrl.h"

@interface Custom360BusinessVisitViewCtrl () <SwitchViewDelegate>

@property (nonatomic, assign) BOOL initTableView;
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) BusinessVisitViewCtrl *visitVC;
@property (nonatomic, strong) BusinessReceptionViewCtrl *receptionVC;
@property (nonatomic, assign) NSInteger currentTag;

@end

@implementation Custom360BusinessVisitViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _currentTag = 0;
    [_switchView selectIndex:_currentTag];
    [_switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateSelectFirst];
}

- (void)dealloc {
    [_visitVC.view removeFromSuperview];
    _visitVC = nil;
    [_receptionVC.view removeFromSuperview];
    _receptionVC = nil;
}

- (void)setUI {
    [self.view addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49.0);
    }];
    [self initLeftView];
}

- (void)initLeftView {
    [self.view addSubview:self.visitVC.view];
    [self.visitVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
//        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self addBtnNew];
}

- (void)initRightView {
    [self.view addSubview:self.receptionVC.view];
    [self.receptionVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.view bringSubviewToFront:self.btnNew];
}

#pragma mark - SwitchViewDelegate

- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
    
    if (index == 1 && !_receptionVC) [self initRightView];
    // 相同按钮
    if (_currentTag == index) {
        // 重置原先的
        if (_currentTag == 0) {
            [switchView updateTitle:@"" index:1 switchState:SwitchStateNormal];
        } else if (_currentTag == 1) {
            [switchView updateTitle:@"" index:0 switchState:SwitchStateNormal];
        }
        // 更新当前的
        [switchView updateTitle:@"" index:index switchState:SwitchStateSelectFirst];
    } else {
        // 不同按钮 切换操作
        _currentTag = index;
        [switchView updateTitle:@"" index:index switchState:SwitchStateSelectFirst];
        self.visitVC.view.hidden = _currentTag == 0 ? NO : YES;
        if (_receptionVC) self.receptionVC.view.hidden = _currentTag == 1 ? NO : YES;
    }
    self.btnNew.hidden = (_currentTag == 0 ? NO : YES);
}

#pragma mark - evnet

- (void)btnNewClick:(UIButton *)sender {
    BusinessCommonCreateViewCtrl *vc = [[BusinessCommonCreateViewCtrl alloc] init];
    vc.fromTab = NO;
    vc.dynamicId = @"visit-activity";
    vc.title = _currentTag == 0 ? @"新建拜访活动":@"新建接待活动";;
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself.visitVC refreshView];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy

- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithTitles:@[@"拜访客户", @"客户接待"]
                                               imgNormal:@[@"", @""]
                                               imgSelect:@[@"", @""]];
        _switchView.delegate = self;
    }
    return _switchView;
}

- (BusinessVisitViewCtrl *)visitVC {
    if (!_visitVC) {
        _visitVC = [[BusinessVisitViewCtrl alloc] init];
        _visitVC.fromMy = NO;
    }
    return _visitVC;
}

- (BusinessReceptionViewCtrl *)receptionVC {
    if (!_receptionVC) {
        _receptionVC = [[BusinessReceptionViewCtrl alloc] init];
        _receptionVC.fromMy = NO;
    }
    return _receptionVC;
}

@end
