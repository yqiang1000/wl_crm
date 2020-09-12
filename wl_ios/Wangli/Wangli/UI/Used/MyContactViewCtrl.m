//
//  MyContactViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "MyContactViewCtrl.h"
#import "ContactTableView.h"
#import "ContactDetailViewCtrl.h"
#import "EmptyView.h"

@interface MyContactViewCtrl () <ContactTableViewDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) ContactTableView *contactTableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation MyContactViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    [self setUI];
    [self getPersonList:YES];
    
    if (_type == ContactImport || _type == ContactCustomer) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonList:) name:NOTIFI_CONTACT_UPDATE object:nil];
        
    }
}

- (void)setUI {
    [self.view addSubview:self.contactTableView];
    [self.contactTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
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

- (void)getPersonList:(BOOL)showHUD {
//    ContactMyPart       = 0,
//    ContactCompany,
//    ContactMyFollow,
//    ContactImport,
//    ContactCustomer
    if (showHUD) [Utils showHUDWithStatus:nil];
    NSMutableArray *rules = [NSMutableArray new];
    if (_type == ContactMyPart) {
        self.contactTableView.canDelete = NO;
        [rules addObject:@{@"field":@"department.id",
                           @"option":@"EQ",
                           @"values":@[STRING(TheUser.userMo.department[@"id"])]}];
    } else if (_type == ContactMyFollow) {
        self.contactTableView.canDelete = NO;
        [rules addObject:@{@"field":@"superiorOperator.id",
                           @"option":@"EQ",
                           @"values":@[@(TheUser.userMo.id)]}];
    } else if (_type == ContactImport) {
        [self getContactList:_page];
        return;
    } else if (_type == ContactCustomer) {
        [self getContactList:_page];
        return;
    }
    
    [[JYUserApi sharedInstance] getDepartmentPersonRules:rules success:^(id responseObject) {
        NSError *error = nil;
        [Utils dismissHUD];
        self.arrData = [JYUserMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        self.contactTableView.arrData = self.arrData;
        [self addEmptyView];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self addEmptyView];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getContactList:(NSInteger)page {
    
    NSString *boolStr = nil;
    if (_type == ContactImport) {
        boolStr = @"true";
    } else if (_type == ContactCustomer) {
        boolStr = @"false";
    }
    self.contactTableView.canDelete = YES;
    NSDictionary *param = @{@"number":@(page),
                            @"size":@"20"};
    
    [[JYUserApi sharedInstance] getImportPersonParam:param rules:nil trueOrFalse:boolStr success:^(id responseObject) {
        [Utils dismissHUD];
        [self.contactTableView.mj_header endRefreshing];
        [self.contactTableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpData = [ContactMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpData;
        } else {
            if (tmpData.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpData];
            } else {
                [self.contactTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        self.contactTableView.arrData = self.arrData;
        [self addEmptyView];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self addEmptyView];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
    return;
}

#pragma mark - ContactTableViewDelegate

- (void)contactTableView:(ContactTableView *)contactTableView didSelectIndexPath:(NSIndexPath *)indexPath userMo:(id)userMo {
    ContactDetailViewCtrl *vc = [[ContactDetailViewCtrl alloc] init];
    if (_type == ContactCustomer || _type == ContactImport) {
        vc.mo = userMo;
    } else {
        vc.userMo = userMo;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)contactTableView:(ContactTableView *)contactTableView didDeleteIndexPath:(NSIndexPath *)indexPath userMo:(id)userMo {
    if ([userMo isKindOfClass:[ContactMo class]]) {
        
        [Utils commonDeleteTost:@"提示" msg:@"确定删除该联系人？" cancelTitle:nil confirmTitle:nil confirm:^{
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] deleteContactDetailById:((CustomerMo *)userMo).id success:^(id responseObject) {
                [Utils dismissHUD];
                [Utils showToastMessage:@"删除成功"];
                for (int i = 0; i < self.arrData.count; i++) {
                    ContactMo *tmpMo = self.arrData[i];
                    if (tmpMo.id == ((CustomerMo *)userMo).id) {
                        [self.arrData removeObject:tmpMo];
                        break;
                    }
                }
                self.contactTableView.arrData = self.arrData;
            } failure:^(NSError *error) {
                [Utils dismissHUD];
                [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            }];
        } cancel:^{
            
        }];
    }
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getContactList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getContactList:_page+1];
}

#pragma mark - setter getter

- (ContactTableView *)contactTableView {
    if (!_contactTableView) {
        _contactTableView = [[ContactTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        if (_type == ContactImport || _type == ContactCustomer) {
            _contactTableView.showHeader = NO;
            _contactTableView.hideAllHeader = YES;
            _contactTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
            _contactTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        } else {
            _contactTableView.showHeader = YES;
            _contactTableView.hideAllHeader = NO;
        }
        
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



@end
