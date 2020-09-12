//
//  ContractPageInvoiceViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ContractPageInvoiceViewCtrl.h"
#import "SwitchView.h"
#import "FilterListView.h"
#import "ContractOrderCell.h"
#import "WSDatePickerView.h"

@interface ContractPageInvoiceViewCtrl () <SwitchViewDelegate, FilterListViewDelegate>

@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) FilterListView *filterListView;
@property (nonatomic, assign) NSInteger sortTag1;
@property (nonatomic, assign) NSInteger sortTag2;
@property (nonatomic, assign) NSInteger sortTag3;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) NSString *selectDate;

@property (nonatomic, strong) NSMutableArray *arrSort;

@end

@implementation ContractPageInvoiceViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentTag = 0;
    [self setUI];
    [self loadData];
}

- (void)setUI {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.top.equalTo(self.view);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)loadData {
    for (int i = 0; i < 10; i++) {
        [self.arrData addObject:@"11"];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *identifier = @"haaderView";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        [headerView.contentView addSubview:self.switchView];
        [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(headerView.contentView);
        }];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ContractOrderCell";
    ContractOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ContractOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.labTitle.text = @"NO.10029181 | ZOR2 | 1100";
    cell.labYear.text = @"2018";
    cell.labMonth.text = @"11";
    cell.labTotalSend.text = @"单面 PERC 21.2%";
    cell.labRealSend.text = @"27,010";
    cell.labTotalNote.text = @"100289-晶科";
    cell.labRealNote.text = @"发货中(MW)";
    return cell;
}

#pragma mark - UITableViewDelegate


#pragma mark - SwitchViewDelegate

- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
    // 任何已经处于选择情况下，清空选择列表，重置按钮
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        for (int i = 0; i < 3; i++) {
            [switchView updateTitle:@"" index:i switchState:SwitchStateNormal];
        }
        return;
    }
    _currentTag = index;
    // 只设置当前的选中状态，其他重置
    [switchView updateTitle:@"" index:index switchState:SwitchStateSelectSecond];
    
    if (_currentTag == 2) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *scrollToDate = [minDateFormater dateFromString:self.selectDate];
        
        __weak typeof(self) weakSelf = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            __strong typeof(self) strongSelf = weakSelf;
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",date);
            [weakSelf.switchView updateTitle:date index:weakSelf.currentTag switchState:SwitchStateNormal];
            if (![strongSelf.selectDate isEqualToString:date]) {
                strongSelf.selectDate = date;
                [strongSelf.tableView.mj_header beginRefreshing];
            }
        }];
        datepicker.btnCancelTitle = @"重置";
        datepicker.wsCancelBlock = ^{
            [weakSelf.switchView updateTitle:@"合同日期" index:weakSelf.currentTag switchState:SwitchStateNormal];
            weakSelf.selectDate = nil;
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    } else {
        if (!_filterListView) {
            _filterListView = [[FilterListView alloc] initWithSourceType:0];
            _filterListView.delegate = self;
        }
        
        [self.view addSubview:_filterListView];
        [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(44);
            make.left.right.bottom.equalTo(self.tableView);
            make.left.equalTo(self.tableView);
        }];
        self.arrSort = [[NSMutableArray alloc] initWithArray:@[@"董事长",@"CEO", @"总裁办", @"公共事业部",@"法务部",@"董事长",@"CEO", @"总裁办", @"公共事业部",@"法务部",@"董事长",@"CEO", @"总裁办", @"公共事业部",@"法务部"]];
        
        if (index == 0) {
            _filterListView.collectionView.selectTag = _sortTag1;
        } else if (index == 1) {
            _filterListView.collectionView.selectTag = _sortTag2;
        } else if (index == 2) {
            _filterListView.collectionView.selectTag = _sortTag3;
        }
        [_filterListView loadData:self.arrSort];
        [_filterListView updateViewHeight:(CGRectGetHeight(self.tableView.frame)-44) bottomHeight:0];
    }
}

#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    NSString *str = @"";
    if (_currentTag == 0) {
        _sortTag1 = indexPath.row;
        str = self.arrSort[_sortTag1];
    } else if (_currentTag == 1) {
        _sortTag2 = indexPath.row;
        str = self.arrSort[_sortTag2];
    }
    //    else if (_currentTag == 2) {
    //        _sortTag3 = indexPath.row;
    //        str = self.arrSort[_sortTag3];
    //    }
    [self.switchView updateTitle:str index:_currentTag switchState:SwitchStateNormal];
    [_filterListView removeFromSuperview];
    _filterListView = nil;
}

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [_filterListView removeFromSuperview];
    _filterListView = nil;
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateNormal];
}

#pragma mark - public

- (void)tableViewFooterRefreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
        int count = self.arrData.count;
        for (int i = 0; i < 5; i++) {
            [self.arrData addObject:@"11"];
        }
        [self.tableView reloadData];
    });
}

- (void)resetFilterAndSwitchView {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
    }
    [self.switchView updateTitle:@"" index:_currentTag switchState:SwitchStateNormal];
}

#pragma mark - lazy


- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 44)
                                                 titles:@[@"订单类型", @"销售组织", @"发票日期"]
                                              imgNormal:@[@"client_down_n", @"client_down_n", @"client_down_n"]
                                              imgSelect:@[@"drop_down_s", @"drop_down_s", @"drop_down_s"]];
        _switchView.delegate = self;
        [_switchView updateSelectViewHiden:YES];
        
    }
    return _switchView;
}

@end
