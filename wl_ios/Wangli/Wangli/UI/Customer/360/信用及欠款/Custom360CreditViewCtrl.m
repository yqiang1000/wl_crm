//
//  Custom360CreditViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360CreditViewCtrl.h"
#import "WSDatePickerView.h"
#import "WebDetailViewCtrl.h"
#import "360CreditCellView.h"
#import "CreditDebtMo.h"
#import "UIButton+ShortCut.h"
#import "CustDeptMo.h"

@interface Custom360CreditViewCtrl ()

@property (nonatomic, strong) NSMutableDictionary *dicData;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CreditFirstCell *firstView;
@property (nonatomic, strong) CreditSecondCell *secondView;
@property (nonatomic, strong) CreditThirdCell *thirdView;
@property (nonatomic, strong) CreditFouthCell *fouthView;
@property (nonatomic, strong) CreditFiftyCell *fiftyView;
@property (nonatomic, strong) CreditSixthCell *sixthView;

@property (nonatomic, strong) UIButton *btnChange;

@property (nonatomic, strong) NSMutableArray *arrDebt;
@property (nonatomic, strong) CustDeptMo *custDeptMo;

@end

@implementation Custom360CreditViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = COLOR_CLEAR;
    [self setUI];
    [Utils showHUDWithStatus:nil];
    [self refreshView];
    [self refreshFiftyView];
    [self refreshSixthView];
    [self loadData];
}

- (void)setUI {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.btnChange];
    
    [self.scrollView addSubview:self.firstView];
    [self.scrollView addSubview:self.secondView];
    [self.scrollView addSubview:self.fiftyView];
    [self.scrollView addSubview:self.thirdView];
    [self.scrollView addSubview:self.fouthView];
    [self.scrollView addSubview:self.sixthView];
    
    [self.btnChange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(44+KMagrinBottom));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnChange.mas_top);
    }];
    
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.fiftyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.sixthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fiftyView.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sixthView.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.fouthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdView.mas_bottom);
        make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView).offset(-15);
    }];
}

#pragma mark - network

- (void)loadData {
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    [Utils showHUDWithStatus:nil];
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getCreditData];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getSameCompany];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getCreditSixData];
    });
    //当所有的任务都完成后会发送这个通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [Utils dismissHUD];
        [self refreshLayout:NO];
    });
}

- (void)getHeaderAndFooter {
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    [Utils showHUDWithStatus:nil];
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getHeaderData];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getFooterData];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getSameCompany];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [self getCreditSixData];
    });
    //当所有的任务都完成后会发送这个通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [Utils dismissHUD];
        [self refreshLayout:YES];
    });
}

- (void)getCreditData {
    [[JYUserApi sharedInstance] getCreditCountByCustomerId:TheCustomer.customerMo.id yearStr:[[NSDate date] stringWithFormat:@"yyyy"] success:^(id responseObject) {
        self.dicData = responseObject[@"content"];
        [self refreshView];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getCreditSixData {
    [[JYUserApi sharedInstance] getCreditDeptAccountByCustomerId:TheCustomer.customerMo.id success:^(id responseObject) {
        NSError *error = nil;
        self.custDeptMo = [[CustDeptMo alloc] initWithDictionary:responseObject error:&error];
        [self refreshSixthView];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getSameCompany {
    [[JYUserApi sharedInstance] getCreditSameCompanyByCustomerId:TheCustomer.customerMo.id yearStr:[[NSDate date] stringWithFormat:@"yyyy"] success:^(id responseObject) {
        NSError *err = nil;
        self.arrDebt = [CreditDebtMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&err];
        [self refreshFiftyView];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getHeaderData {
    [[JYUserApi sharedInstance] getCreditHeaderByCustomerId:TheCustomer.customerMo.id success:^(id responseObject) {
        [self.firstView loadDataWith:responseObject[@"firstItem"]];
        [self.view layoutIfNeeded];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getFooterData {
    [[JYUserApi sharedInstance] getCreditFooterByCustomerId:TheCustomer.customerMo.id success:^(id responseObject) {
        [self.fouthView loadDataWith:responseObject];
        [self.view layoutIfNeeded];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)refreshView {
    [self.firstView loadDataWith:self.dicData[@"firstItem"]];
    [self.secondView loadDataWith:self.dicData[@"secondItem"]];
    [self.thirdView loadDataWith:self.dicData[@"thirdItem"]];
    [self.fouthView loadDataWith:self.dicData[@"forthItem"]];
    [self.view layoutIfNeeded];
}

- (void)refreshSixthView {
    [self.sixthView loadDataWith:self.custDeptMo];
}

- (void)refreshLayout:(BOOL)hidenSecond {
    if (hidenSecond) {
        self.secondView.hidden = YES;
        self.thirdView.hidden = YES;
        
        [self.fiftyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.firstView.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        
        [self.sixthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fiftyView.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        
        [self.fouthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sixthView.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView).offset(-15);
        }];
    } else {
        self.secondView.hidden = NO;
        self.thirdView.hidden = NO;
        
        [self.fiftyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.secondView.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        
        [self.sixthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fiftyView.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        
        [self.thirdView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sixthView.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        
        [self.fouthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thirdView.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView).offset(-15);
        }];
    }
    [self.view layoutIfNeeded];
}

- (void)refreshFiftyView {
    if (self.arrDebt.count == 0) {
        self.fiftyView.hidden = YES;
        [self.sixthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.secondView.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        [self.btnChange mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } else {
        self.fiftyView.hidden = NO;
        [self.sixthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fiftyView.mas_bottom);
            make.left.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        [self.btnChange mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(44+KMagrinBottom));
        }];
    }
    self.fiftyView.arrData = self.arrDebt;
    [self.fiftyView creditFiftyRefreshView];
    [self.view layoutIfNeeded];
}

- (void)btnChangeClick:(UIButton *)sender {
    _btnChange.selected = !_btnChange.selected;
    if (_btnChange.selected) {
        [self getHeaderAndFooter];
        self.fouthView.btnDetail.hidden = YES;
    } else {
        [self loadData];
        self.fouthView.btnDetail.hidden = NO;
    }
}

#pragma mark - lazy

- (NSMutableDictionary *)dicData {
    if (!_dicData) {
        _dicData = [NSMutableDictionary new];
    }
    return _dicData;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.contentSize = CGSizeZero;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (CreditFirstCell *)firstView {
    if (!_firstView) {
        _firstView = [[CreditFirstCell alloc] init];
    }
    return _firstView;
}

- (CreditSecondCell *)secondView {
    if (!_secondView) {
        _secondView = [[CreditSecondCell alloc] init];
    }
    return _secondView;
}

- (CreditThirdCell *)thirdView {
    if (!_thirdView) {
        _thirdView = [[CreditThirdCell alloc] init];
    }
    return _thirdView;
}

- (CreditFouthCell *)fouthView {
    if (!_fouthView) {
        _fouthView = [[CreditFouthCell alloc] init];
        __weak typeof(self) weakSelf = self;
        _fouthView.btnDetailBlock = ^{
            NSString *urlStr = [NSString stringWithFormat:@"%@kunnr=%ld&token=%@", CREDIT_URL, TheCustomer.customerMo.id, [Utils token]];
            WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
            vc.urlStr = urlStr;
            vc.titleStr = @"欠款明细表";
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _fouthView;
}

- (CreditFiftyCell *)fiftyView {
    if (!_fiftyView) {
        _fiftyView = [[CreditFiftyCell alloc] init];
    }
    return _fiftyView;
}

- (CreditSixthCell *)sixthView {
    if (!_sixthView) {
        _sixthView = [[CreditSixthCell alloc] init];
    }
    return _sixthView;
}

- (NSMutableArray *)arrDebt {
    if (!_arrDebt) {
        _arrDebt = [NSMutableArray new];
    }
    return _arrDebt;
}

- (UIButton *)btnChange {
    if (!_btnChange) {
        _btnChange = [[UIButton alloc] init];
        [_btnChange setTitle:@"信贷号查看" forState:UIControlStateNormal];
        [_btnChange setTitle:@"客户号查看" forState:UIControlStateSelected];
        [_btnChange setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        
        [_btnChange setImage:[UIImage imageNamed:@"client"] forState:UIControlStateNormal];
        [_btnChange setImage:[UIImage imageNamed:@"credit"] forState:UIControlStateSelected];
        
        [_btnChange setBackgroundColor:COLOR_B4];
        _btnChange.titleLabel.font = FONT_F16;
        [_btnChange addTarget:self action:@selector(btnChangeClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [Utils getLineView];
        [_btnChange addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_btnChange);
            make.height.equalTo(@0.5);
        }];
        [_btnChange imageLeftWithTitleFix:5];
    }
    return _btnChange;
}

- (CustDeptMo *)custDeptMo {
    if (!_custDeptMo) {
        _custDeptMo = [[CustDeptMo alloc] init];
    }
    return _custDeptMo;
}

@end
