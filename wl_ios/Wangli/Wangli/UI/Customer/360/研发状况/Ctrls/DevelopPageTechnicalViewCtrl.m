//
//  DevelopPageTechnicalViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "DevelopPageTechnicalViewCtrl.h"
#import "DevelopCommonCreateViewCtrl.h"
#import "DevelopTechnicolCell.h"

@interface DevelopPageTechnicalViewCtrl ()

@end

@implementation DevelopPageTechnicalViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden = YES;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.top.equalTo(self.view);
    }];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.clipsToBounds = YES;
    [self.view layoutIfNeeded];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"DevelopTechnicolCell";
    DevelopTechnicolCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DevelopTechnicolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    DevelopTechnicalMo *model = self.arrData[indexPath.row];
    [cell loadData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DevelopTechnicalMo *model = self.arrData[indexPath.row];
    DevelopCommonCreateViewCtrl *vc = [[DevelopCommonCreateViewCtrl alloc] init];
    vc.isUpdate = YES;
    vc.fromTab = NO;
    vc.dynamicId = K_DEVELOP_TECHNICAL;
    vc.detailId = model.id;
    vc.title = [NSString stringWithFormat:@"%@", self.segTitle];
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself addHeaderRefresh];
    };
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - public

- (void)tableViewFooterRefreshAction {
    if (self.arrData.count == 0) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    [self getList:self.page+1];
}

- (void)addHeaderRefresh {
    self.page = 0;
    [self getList:self.page];
}

- (void)getList:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"10" forKey:@"size"];
    [param setObject:@"ASC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    [param setObject:@(page) forKey:@"number"];
    
    NSMutableArray *rules = [NSMutableArray new];
    [rules addObject:@{@"field":@"member.id",
                       @"option":@"EQ",
                       @"values":@[@(TheCustomer.customerMo.id)]}];
    
    if (![self.currentDic.key isEqualToString:@"all"] && self.currentDic.key.length > 0) {
        [rules addObject:@{@"field":@"businessTypeKey",
                           @"option":@"EQ",
                           @"values":@[self.currentDic.key]}];
    }
    [param setObject:rules forKey:@"rules"];
    
    [[JYUserApi sharedInstance] getPageDynmicFormDynamicId:K_DEVELOP_TECHNICAL param:param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
////        self.totalElements = [responseObject[@"totalElements"] integerValue];
        NSMutableArray *tmpArr = [DevelopTechnicalMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}
@end
