//
//  CustomerCardViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/9.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "CustomerCardViewCtrl.h"
#import "XLCardSwitch.h"
#import "Custom360ViewCtrl.h"
#import "ChangeOwnerViewCtrl.h"

@interface CustomerCardViewCtrl () <XLCardSwitchDelegate>

@property (nonatomic, strong) XLCardSwitch *cardSwitch;
@property (nonatomic, strong) UIButton *btnBack;

@end

@implementation CustomerCardViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cardSwitch];
    [self.view bringSubviewToFront:self.naviView];
    self.naviView.lineView.backgroundColor = COLOR_C1;
    
    [self.view addSubview:self.btnBack];
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.naviView.btnBack);
        make.width.height.equalTo(self.naviView.btnBack);
    }];
    
//    TheCustomer.customerMo = self.mo;
    
    [self.naviView setAlpha:0];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNaviAlpha:) name:NOTIFI_CUSTOMER_360_SCROLL object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCollectionIndexPath:) name:NOTIFI_CUSTOMER_360_SELECT object:nil];
}

- (void)dealloc {
    TheCustomer.authoritys = nil;
    [TheCustomer popCustomer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNaviAlpha:) name:NOTIFI_CUSTOMER_360_SCROLL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCollectionIndexPath:) name:NOTIFI_CUSTOMER_360_SELECT object:nil];
}

- (void)delayGotoCurrentIndex {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cardSwitch.selectedIndex = _index;
    });
}

- (void)changeNaviAlpha:(NSNotification *)noti {
    CGFloat offsetY = [[noti.userInfo objectForKey:@"offsetY"] floatValue];
    // 渐变动画
    if (offsetY < 50) {
        [self.naviView setAlpha:0];
    } else if (offsetY < 150) {
        CGFloat alpha = (offsetY - 50) / 100;
        [self.naviView setAlpha:alpha];
    } else {
        [self.naviView setAlpha:1];
    }
    self.title = TheCustomer.customerMo.abbreviation;
}

- (void)selectCollectionIndexPath:(NSNotification *)noti {
//    NSInteger section = [[noti.userInfo objectForKey:@"section"] integerValue];
    NSInteger item = [[noti.userInfo objectForKey:@"item"] integerValue];
    
    if ([TheCustomer.authoritys[item] boolValue]) {
        Custom360ViewCtrl *vc = [[Custom360ViewCtrl alloc] init];
        vc.selectIndex = item;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (item == 10 || item == 11) {
            [Utils showToastMessage:@"该功能将于19年4月1日上线"];
        } else {
            [Utils showToastMessage:@"暂无权限"];
        }
    }
}

-(void)XLCardSwitchDidSelectedAt:(NSInteger)index {
    [self.naviView setAlpha:0];
}

- (void)btnBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 3D Touch 预览Action代理

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    NSMutableArray *arrItem = [NSMutableArray new];
    CustomerMo *tmpMo = _mo;
        if (tmpMo.claim) {
            UIPreviewAction *previewAction0 = [UIPreviewAction actionWithTitle:@"认领" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                NSLog(@"认领");
                ChangeOwnerViewCtrl *vc = [[ChangeOwnerViewCtrl alloc] init];
                vc.ownerType = OwnerClaimType;
                vc.mo = tmpMo;
                vc.hidesBottomBarWhenPushed = YES;
                [[Utils topViewController].navigationController pushViewController:vc animated:YES];
            }];
            [arrItem addObject:previewAction0];
        }
        if (tmpMo.memberRelease) {
            UIPreviewAction *previewAction0 = [UIPreviewAction actionWithTitle:@"释放" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                NSLog(@"释放");
                ChangeOwnerViewCtrl *vc = [[ChangeOwnerViewCtrl alloc] init];
                vc.ownerType = OwnerReleaseType;
                vc.mo = tmpMo;
                vc.hidesBottomBarWhenPushed = YES;
                [[Utils topViewController].navigationController pushViewController:vc animated:YES];
            }];
            [arrItem addObject:previewAction0];
        }
        if (tmpMo.transfer) {
            UIPreviewAction *previewAction0 = [UIPreviewAction actionWithTitle:@"转移" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                NSLog(@"转移");
                ChangeOwnerViewCtrl *vc = [[ChangeOwnerViewCtrl alloc] init];
                vc.ownerType = OwnerChangeType;
                vc.mo = tmpMo;
                vc.hidesBottomBarWhenPushed = YES;
                [[Utils topViewController].navigationController pushViewController:vc animated:YES];
            }];
            [arrItem addObject:previewAction0];
        }
    UIPreviewAction *previewAction0 = [UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSLog(@"didClickCancel");
    }];
    [arrItem addObject:previewAction0];
    return arrItem;
}

#pragma mark - setter getter

- (XLCardSwitch *)cardSwitch {
    if (!_cardSwitch) {
        NSMutableArray *items = [NSMutableArray new];
        for (int i = 0; i < self.arrData.count; i++) {
            XLCardItem *item = [[XLCardItem alloc] init];
            item.mo = self.arrData[i];
            [items addObject:item];
        }
        //设置卡片浏览器
        _cardSwitch = [[XLCardSwitch alloc] initWithFrame:self.view.bounds];
        _cardSwitch.forbidRefresh = _forbidRefresh;
        _cardSwitch.items = items;
        _cardSwitch.delegate = self;
        //分页切换
        _cardSwitch.pagingEnabled = YES;
        //设置初始位置，默认为0
        _cardSwitch.selectedIndex = _index;
    }
    return _cardSwitch;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
        [_btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_btnBack setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        _btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btnBack.titleLabel.font = SYSTEM_FONT(15);
        _btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _btnBack.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_btnBack addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

@end
