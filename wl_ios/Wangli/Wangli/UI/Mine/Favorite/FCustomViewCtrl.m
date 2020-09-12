//
//  FCustomViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "FCustomViewCtrl.h"
#import "CustomerMo.h"
#import "TabCustomerCell.h"
#import "CustomerCardViewCtrl.h"
#import "ChangeOwnerViewCtrl.h"

@interface FCustomViewCtrl ()

@property (nonatomic, strong) NSIndexPath *touchIndexPath;
@end

@implementation FCustomViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    [Utils showHUDWithStatus:nil];
    [self getListPage:self.page];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewHeaderRefreshAction) name:NOTIFI_MEMBER_CHANGE_OPERATOR object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 170 : 160;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TabCustomerCell";
    TabCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomerCardViewCtrl *vc = [[CustomerCardViewCtrl alloc] init];
    vc.mo = self.arrData[indexPath.row];
    vc.index = indexPath.row;
    vc.arrData = self.arrData;
    if (self.arrData.count == 1) {
        vc.forbidRefresh = YES;
    }
    TheCustomer.fromTab = 2;
    TheCustomer.page = self.page;
    [TheCustomer insertCustomer:vc.mo];
    vc.hidesBottomBarWhenPushed = YES;
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - private

- (void)getListPage:(NSInteger)page {
    [[JYUserApi sharedInstance] getFavoriteMemberPage:page success:^(id responseObject) {
        [Utils dismissHUD];
        [self tableViewEndRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [CustomerMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                self.page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self tableViewEndRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
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
    TheCustomer.fromTab = 2;
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
    
    [[Utils topViewController] showViewController:viewControllerToCommit sender:self];
}


@end
