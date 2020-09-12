
//
//  Custom360ContactViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360ContactViewCtrl.h"
#import "ContactTableView.h"
#import "ContactDetailViewCtrl.h"
#import "EmptyView.h"
#import "UIButton+ShortCut.h"
#import "NewContactViewCtrl.h"

@interface Custom360ContactViewCtrl () <ContactTableViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) ContactTableView *contactTableView;
@property (nonatomic, strong) UIButton *btnAdd;

@end

@implementation Custom360ContactViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviView.hidden = YES;
    [self setUI];
    [self getList];
    self.headerRefresh = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getList) name:NOTIFI_CONTACT_UPDATE object:nil];
}

- (void)setUI {
    [self.view addSubview:self.contactTableView];
    [self.view addSubview:self.btnAdd];
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(44+KMagrinBottom));
    }];
    
    [self.contactTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnAdd.mas_top);
    }];
}

- (void)addEmptyView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.contactTableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contactTableView);
            make.width.height.equalTo(self.contactTableView);
        }];
    }
}

- (void)tableViewHeaderRefreshAction {
    [self getList];
}

#pragma mark - network

- (void)getList {
    [[JYUserApi sharedInstance] getContentPageByCustomerId:TheCustomer.customerMo.id page:0 size:5000 direction:nil contentId:0 success:^(id responseObject) {
        self.arrData = [ContactMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
        self.contactTableView.arrData = self.arrData;
        [self addEmptyView];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - ContactTableViewDelegate

- (void)contactTableView:(ContactTableView *)contactTableView didSelectIndexPath:(NSIndexPath *)indexPath userMo:(id)userMo {
    ContactDetailViewCtrl *vc = [[ContactDetailViewCtrl alloc] init];
    if ([userMo isKindOfClass:[ContactMo class]]) {
        vc.mo = userMo;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - event

- (void)btnAddClick:(UIButton *)sender {
    NewContactViewCtrl *vc = [[NewContactViewCtrl alloc] init];
    vc.from360 = YES;
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        [weakself getList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setter getter

- (ContactTableView *)contactTableView {
    if (!_contactTableView) {
        _contactTableView = [[ContactTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contactTableView.showHeader = YES;
        _contactTableView.canDelete = NO;
        _contactTableView.contactDelegate = self;
    }
    return _contactTableView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [[UIButton alloc] init];
        [_btnAdd setBackgroundColor:COLOR_B4];
        _btnAdd.titleLabel.font = FONT_F16;
        [_btnAdd setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [_btnAdd setTitle:@"新建联系人" forState:UIControlStateNormal];
        [_btnAdd setImage:[UIImage imageNamed:@"client_add"] forState:UIControlStateNormal];
        [_btnAdd imageLeftWithTitleFix:5];
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [Utils getLineView];
        [_btnAdd addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_btnAdd);
            make.height.equalTo(@0.5);
        }];
    }
    return _btnAdd;
}

@end
