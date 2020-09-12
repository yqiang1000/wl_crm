//
//  TrendsInteligenceTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsInteligenceTableView.h"
#import "EmptyView.h"
#import "TrendsInteligenceCell.h"
#import "TrendsInteligenceMo.h"
#import "UpdateIntelligenceViewCtrl.h"
#import "WebDetailViewCtrl.h"

@interface TrendsInteligenceTableView () <UITableViewDelegate, UITableViewDataSource, TrendsInteligenceCellDelegate>
{
    EmptyView *_emptyView;
}

@property (nonatomic, assign) NSInteger page;

@end

@implementation TrendsInteligenceTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = COLOR_B0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        self.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.width.height.equalTo(self);
        }];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"TrendsInteligenceCell";
    TrendsInteligenceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TrendsInteligenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendsInteligenceMo *item = self.arrData[indexPath.row];
    [UserLocalDataUtils saveRemark:item.id msgType:@"TrendsInteligenceMo"];
    item.read = YES;
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self createRecord:item];
    
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.titleStr = @"情报详情";
    vc.urlStr = [NSString stringWithFormat:@"%@%@%lld&token=%@", H5_URL, H5_INTELLIGENCE_URL, item.id, [Utils token]];
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    
    
//    if ([item.operator[@"id"] integerValue] != TheUser.userMo.id ||
//        ![item.itemStatusKey isEqualToString:@"draft"]) {
//        return;
//    }
    
//    UpdateIntelligenceViewCtrl *vc = [[UpdateIntelligenceViewCtrl alloc] init];
//    IntelligenceItemSet *set = [[IntelligenceItemSet alloc] init];
//    set.id = item.id;
//    vc.title = @"修改情报详情";
//    // 拿单个的id
//    vc.itemSet = set;
//    __weak typeof(self) weakself = self;
//    vc.updateSuccess = ^(id obj) {
//        __strong typeof(self) strongself = weakself;
//        [strongself tableViewHeaderRefreshAction];
//    };
//    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)createRecord:(TrendsInteligenceMo *)item {
    [[JYUserApi sharedInstance] viewRecordCreate:@{@"fkType":@"PATENT_CERTIFICATION",
                                                   @"fkIds":@[@(item.id)]} success:^(id responseObject) {
        
    } failure:^(NSError *error) {
    }];
}

#pragma mark - TrendsInteligenceCellDelegate

- (void)trendsInteligenceCell:(TrendsInteligenceCell *)trendsInteligenceCell didSelectIndexPaht:(NSIndexPath *)indexPath urlStr:(NSString *)urlStr {
    if (urlStr.length == 0) {
        [self tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - event

- (void)tableViewHeaderRefreshAction {
    self.page = 0;
    [self getList:self.page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:self.page+1];
}

- (void)getList:(NSInteger)page {
    [self.param setObject:@(page) forKey:@"number"];
    [[JYUserApi sharedInstance] getFeedBigItemPageType:@"market-intelligence-item" param:self.param success:^(id responseObject) {
        [Utils dismissHUD];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [TrendsInteligenceMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.mj_footer endRefreshingWithNoMoreData];
            }
        }
        self.page = page;
        [self reloadData];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - lazy

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
