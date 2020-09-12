//
//  Custom360DealerViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/3/18.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "Custom360DealerViewCtrl.h"
#import "SearchTopView.h"
#import "SearchStyle.h"
#import "DealerCell.h"

@interface Custom360DealerViewCtrl () <SearchTopViewDelegate>

@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, assign) NSInteger page;

@end

@implementation Custom360DealerViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    _keyWord = @"";
    [self setUI];
    [self setFooterRefresh:YES];
    [self setHeaderRefresh:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setUI {
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).offset(15);
        make.right.equalTo(self.naviView).offset(-15);
        make.top.equalTo(self.view).offset(7.5);
        make.height.equalTo(@28.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(7.5);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.searchView.searchTxtField resignFirstResponder];
}

- (void)getList:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(page) forKey:@"number"];
    [param setObject:@(10) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    NSMutableArray *rules = [NSMutableArray new];
    if (self.keyWord.length != 0) {
        [rules addObject:@{@"field":@"searchContent",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[STRING(self.keyWord)]}];
    }
    
    [rules addObject:@{@"field": @"member.id",
                       @"values": @[@(TheCustomer.customerMo.id)],
                       @"option": @"EQ"}];
    
    if (rules.count > 0) [param setObject:rules forKey:@"rules"];
    
    [[JYUserApi sharedInstance] getPageDynmicFormDynamicId:@"dealer-plan" param:param success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSError *error = nil;
        NSMutableArray *tmpArr = [DealerMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        self.page = page;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79.0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DealerCell";
    DealerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DealerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    [self.searchView.searchTxtField resignFirstResponder];
    self.keyWord =  [searchTopView.searchTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self tableViewHeaderRefreshAction];
}

#pragma mark - event

- (void)hidenKeyBoard {
    [self.searchView.searchTxtField resignFirstResponder];
}

- (void)tableViewHeaderRefreshAction {
    _page = 0;
    [self getList:_page];
}

- (void)tableViewFooterRefreshAction {
    [self getList:_page+1];
}

#pragma mark - lazy

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = @"请输入经销商代码、名称、品牌";
    }
    return _searchView;
}

@end
