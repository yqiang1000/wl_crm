//
//  ChatSearchViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/11.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "ChatSearchViewCtrl.h"
#import "TabCustomerCell.h"
#import "CustomerCardViewCtrl.h"
#import "EmptyView.h"

@interface ChatSearchViewCtrl () 

{
    EmptyView *_emptyView;
}

@property (nonatomic, strong) NSIndexPath *touchIndexPath;

@end

@implementation ChatSearchViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = COLOR_EEF0F1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewHeaderRefreshAction) name:NOTIFI_MEMBER_CHANGE_OPERATOR object:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 170 : 160;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.tableView);
            make.width.height.equalTo(self.tableView);
        }];
    }
    return self.arrData.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SearchHeaderView *headerView = [[SearchHeaderView alloc] init];
    headerView.labTitle.text = [NSString stringWithFormat:@"共找到%@个和关键词\"%@\"有关的客户", self.totalElements, self.searchKey];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"customerCell";
    TabCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TabCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    // 注册 3Dtouch
    if ([self respondsToSelector:@selector(traitCollection)]) {
        
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                
                [self registerForPreviewingWithDelegate:(id)self sourceView:cell];
            }
        }
    }
    return cell;
}

- (void)searchPage:(NSInteger)page searchKey:(NSString *)searchKey {
    [JYUserApi releaseSearchParamsCache];
    NSMutableArray *arrSpecialConditions = [[NSMutableArray alloc] initWithObjects:searchKey, nil];
    
    [[JYUserApi sharedInstance] searchCustomerListPage:page size:10 rules:@[] keyword:searchKey specialConditions:arrSpecialConditions success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [CustomerMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        self.totalElements = responseObject[@"totalElements"];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                self.page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        TheCustomer.page = page;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerCardViewCtrl *vc = [[CustomerCardViewCtrl alloc] init];
    vc.mo = self.arrData[indexPath.row];
    vc.index = indexPath.row;
    vc.arrData = self.arrData;
    TheCustomer.fromTab = 1;
    TheCustomer.page = self.page;
    [TheCustomer insertCustomer:vc.mo];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 3Dtouch

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    _touchIndexPath = indexPath;
    //创建要预览的控制器
    CustomerCardViewCtrl *vc = [[CustomerCardViewCtrl alloc] init];
    CustomerMo *mo = self.arrData[indexPath.row];
    mo.avatarUrl = mo.headUrl;
    vc.mo = mo;
    if (self.arrData.count == 1) {
        vc.forbidRefresh = YES;
    }
    vc.index = indexPath.row;
    vc.arrData = self.arrData;
    TheCustomer.fromTab = 1;
    TheCustomer.page = self.page;
    [TheCustomer insertCustomer:mo];
    vc.hidesBottomBarWhenPushed = YES;
    [vc delayGotoCurrentIndex];
    
    //指定当前上下文视图Rect
    CGRect rect = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width-30, 160);
    previewingContext.sourceRect = rect;
    
    return vc;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
    
    [self showViewController:viewControllerToCommit sender:self];
}

@end
