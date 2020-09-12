//
//  OrgContactViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "OrgContactViewCtrl.h"
#import "ContactTableView.h"
#import "SearchTopView.h"
#import "MyCompanyViewCtrl.h"
#import "MyContactViewCtrl.h"
#import "ChatSearchViewCtrl.h"
#import "ContactDetailViewCtrl.h"
#import "ContactSearchViewCtrl.h"

@interface OrgContactViewCtrl () <ContactTableViewDelegate, SearchTopViewDelegate>

@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) ContactTableView *contactTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *headerTitle;

@end

@implementation OrgContactViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"机构通讯录";
    [self setUI];
    [self reloadRecentData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadRecentData];
    });
}

- (void)reloadRecentData {
    [_arrData removeAllObjects];
    _arrData = nil;
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < self.arrData.count; i++) {
        [arr addObject:self.arrData[i][@"value"]];
    }
    self.contactTableView.arrData = arr;
}

- (void)setUI {
    [self.view addSubview:self.contactTableView];
    [self.view addSubview:self.searchView];
    
    [self.searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(7.5);
        make.left.equalTo(self.naviView).offset(15);
        make.height.equalTo(@28);
        make.right.equalTo(self.naviView).offset(-15);
    }];
    
    [self.contactTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(7.5);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - ContactTableViewDelegate

- (void)contactTableView:(ContactTableView *)contactTableView didSelectIndexPath:(NSIndexPath *)indexPath userMo:(id)userMo {
    ContactDetailViewCtrl *vc = [[ContactDetailViewCtrl alloc] init];
    if ([userMo isKindOfClass:[ContactMo class]]) {
        vc.mo = userMo;
    } else if ([userMo isKindOfClass:[JYUserMo class]]){
        vc.userMo = userMo;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)contactTableView:(ContactTableView *)contactTableView didDeleteIndexPath:(NSIndexPath *)indexPath userMo:(id)userMo {
    
    [Utils commonDeleteTost:@"提示" msg:@"确定删除该记录？" cancelTitle:@"取消" confirmTitle:@"确定" confirm:^{
        [Utils showHUDWithStatus:nil];
        [self deleteContact:userMo];
    } cancel:^{
        
    }];
}

- (void)deleteContact:(id)userMo {
    if ([userMo isKindOfClass:[ContactMo class]]) {
        // 查找是否存在 联系人
        ContactMo *contactMo = (ContactMo *)userMo;
        [self.arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = obj[@"key"];
            if ([key isEqualToString:@"1"]) {
                ContactMo *tmpMo = obj[@"value"];
                if (tmpMo.id == contactMo.id) {
                    [self.arrData removeObject:obj];
                    *stop = YES;
                }
            }
        }];
    } else if ([userMo isKindOfClass:[JYUserMo class]]) {
        // 查找是否存在 操作员
        JYUserMo *jyMo = (JYUserMo *)userMo;
        [self.arrData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = obj[@"key"];
            if ([key isEqualToString:@"2"]) {
                JYUserMo *tmpMo = obj[@"value"];
                if (tmpMo.id == jyMo.id) {
                    [self.arrData removeObject:obj];
                    *stop = YES;
                }
            }
        }];
    }
    
    static BOOL save = YES;
    if (save) {
        save = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *newArr = [NSMutableArray new];
            
            NSInteger total = self.arrData.count <= 10 ? self.arrData.count : 10;
            for (int i = 0; i < total; i++) {
                NSDictionary *dic = self.arrData[i];
                if ([dic[@"key"] isEqualToString:@"1"]) {
                    ContactMo *tmpMo = dic[@"value"];
                    [newArr addObject:@{@"key":@"1",
                                        @"value":[tmpMo toJSONString]}];
                } else {
                    JYUserMo *tmpMo = dic[@"value"];
                    [newArr addObject:@{@"key":@"2",
                                        @"value":[tmpMo toJSONString]}];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:newArr forKey:CONTACT_RECENT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            save = YES;
            
            [self reloadRecentData];
            [Utils showToastMessage:@"删除成功"];
            [Utils dismissHUD];
        });
    }
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:NO];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
    [self.searchView.searchTxtField resignFirstResponder];
    [self pushToSearchVC:YES];
}

- (void)pushToSearchVC:(BOOL)showIFly {
    SearchStyle *searchStyle = [[SearchStyle alloc] init];
    searchStyle.type = SearchContact;
    ContactSearchViewCtrl *vc = [[ContactSearchViewCtrl alloc] init];
    vc.showIFly = showIFly;
    vc.searchStyle = searchStyle;
    BaseNavigationCtrl *naviVC = [[BaseNavigationCtrl alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - event

- (void)btnHeaderClick:(UIButton *)sender {
    if (sender.tag == 1) {
        MyCompanyViewCtrl *vc = [[MyCompanyViewCtrl alloc] init];
        vc.title = self.headerTitle[sender.tag];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MyContactViewCtrl *vc = [[MyContactViewCtrl alloc] init];
        vc.title = self.headerTitle[sender.tag];
        if (sender.tag == 0) {
            vc.type = ContactMyPart;
        } else if (sender.tag == 2) {
            vc.type = ContactMyFollow;
        } else if (sender.tag == 3) {
            vc.type = ContactCustomer;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - setter getter

- (ContactTableView *)contactTableView {
    if (!_contactTableView) {
        _contactTableView = [[ContactTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contactTableView.showHeader = NO;
        _contactTableView.canDelete = YES;
        _contactTableView.contactDelegate = self;
        _contactTableView.tableHeaderView = self.headerView;
        _contactTableView.headerText = @"最近联系人";
        _contactTableView.showIndex = NO;
    }
    return _contactTableView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] initWithCapacity:10];
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:CONTACT_RECENT];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            // 联系人
            if ([dic[@"key"] isEqualToString:@"1"]) {
                ContactMo *mo = [[ContactMo alloc] initWithString:dic[@"value"] error:nil];
                [_arrData addObject:@{@"key":@"1",
                                      @"value":mo}];
            } else {
                // 操作员
                JYUserMo *mo = [[JYUserMo alloc] initWithString:dic[@"value"] error:nil];
                [_arrData addObject:@{@"key":@"2",
                                      @"value":mo}];
            }
        }
    }
    return _arrData;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = [SearchStyle placeholdString:SearchContact];
    }
    return _searchView;
}

- (UIView *)headerView {
    if (!_headerView) {
        NSArray *arrImgs = @[@"cn_contacts_department",
                             @"cn_contacts_company",
                             @"cn_contacts_subordinate",
//                             @"cn_contacts_important",
                             @"cn_contacts_client"];
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        _headerView.backgroundColor = COLOR_B4;
        CGFloat leftPadding = IS_IPHONE5 ? 20 : 35;
        for (int i = 0; i < self.headerTitle.count; i++) {
            int x = i % 2;
            int y = i / 2;
            UIButton *btnItem = [[UIButton alloc] init];
            [btnItem addTarget:self action:@selector(btnHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
            btnItem.tag = i;
            [_headerView addSubview:btnItem];
            
            UILabel *lab = [UILabel new];
            lab.text = self.headerTitle[i];
            lab.textColor = COLOR_B1;
            lab.font = FONT_F15;
            [btnItem addSubview:lab];
            
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arrImgs[i]]];
            [btnItem addSubview:img];
            
            [btnItem mas_makeConstraints:^(MASConstraintMaker *make) {
                if (x == 0) {
                    make.left.equalTo(_headerView);
                } else {
                    make.left.equalTo(_headerView.mas_centerX);
                }
                make.height.equalTo(@60);
                make.width.equalTo(_headerView.mas_width).multipliedBy(0.5);
                make.top.equalTo(_headerView).offset(y*60);
            }];
            
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(btnItem);
                make.left.equalTo(btnItem).offset(leftPadding);
                make.height.width.equalTo(@35);
            }];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(img.mas_right).offset(15);
                make.centerY.equalTo(btnItem);
                make.right.lessThanOrEqualTo(btnItem).offset(-10);
            }];
            
            UIView *lineView = [Utils getLineView];
            [btnItem addSubview:lineView];
            if (x == 0) {
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.right.equalTo(btnItem);
                    make.width.equalTo(@0.5);
                }];
            } else {
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(_headerView);
                    make.bottom.equalTo(btnItem.mas_bottom);
                    make.height.equalTo(@0.5);
                }];
            }
        }
    }
    return _headerView;
}

- (NSArray *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = @[@"我的部门",
                         @"公司通讯录",
                         @"我的下属",
//                         @"重要联系人",
                         @"客户联系人"];
    }
    return _headerTitle;
}

@end
