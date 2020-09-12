//
//  TrendsBaseViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseViewCtrl.h"
#import "TrendsBaseCollectionCell.h"

//#import "TrendsSegmentView.h"
//#import "SwitchView.h"
//#import "SearchTopView.h"
//#import "TrendsInteligenceViewCollectionCell.h"
//#import "FilterListView.h"
//#import "WSDatePickerView.h"

@interface TrendsBaseViewCtrl ()

//@property (nonatomic, strong) TrendsSegmentView *segmentView;
//@property (nonatomic, strong) SearchTopView *searchView;
//@property (nonatomic, strong) SwitchView *switchView;
//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) FilterListView *filterListView;
//
//@property (nonatomic, copy) NSString *selectDate;
//@property (nonatomic, strong) NSMutableArray *arrTitles;
//
//@property (nonatomic, assign) NSInteger titleId;     // 大类Id
//@property (nonatomic, assign) NSInteger switchId;    // 当前筛选Id
//@property (nonatomic, assign) NSInteger sortTag1;    // 业务类型筛选位置
//@property (nonatomic, assign) NSInteger sortTag2;    // 信息类别筛选位置
//@property (nonatomic, assign) NSInteger sortTag3;    // 搜索日期筛选位置
//
//@property (nonatomic, copy) NSString *keyword;
//@property (nonatomic, strong) NSMutableArray *arrSort;

@property (nonatomic, strong) DicMo *dicDefault;

@end

//static NSString *identifier = @"TrendsInteligenceViewCollectionCell";

@implementation TrendsBaseViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TrendsBaseView";
    _titleId = 0;
    _sortTag1 = -1;
    _sortTag2 = -1;
    _sortTag3 = -1;
    _keyword = @"";
    [self setUI];
    [self loadNewTitles];
    self.currentDic = self.dicDefault;
    self.sortDic1 = self.dicDefault;
    self.sortDic2 = self.dicDefault;
    
    self.view.backgroundColor = COLOR_B4;
    [self.rightBtn setImage:[UIImage imageNamed:@"dynamic_order_add"] forState:UIControlStateNormal];
    self.rightBtn.hidden = YES;
}

// 获取默认的切换标题
- (void)loadNewTitles {
    if (self.switchDicName.length > 0) {
        [[JYUserApi sharedInstance] getConfigDicByName:self.switchDicName success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            [_arrTitleDics removeAllObjects];
            _arrTitleDics = nil;
            NSMutableArray *tmpArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
            [self.arrTitleDics addObjectsFromArray:tmpArr];
            [self configTitle];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [self configTitle];
        }];
    }
    
    if (self.sortKey1.length > 0) {
        [[JYUserApi sharedInstance] getConfigDicByName:self.sortKey1 success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            [_arrSort1 removeAllObjects];
            _arrSort1 = nil;
            NSMutableArray *tmpArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
            [self.arrSort1 addObjectsFromArray:tmpArr];
        } failure:^(NSError *error) {
        }];
    }
    
    if (self.sortKey2.length > 0) {
        [[JYUserApi sharedInstance] getConfigDicByName:self.sortKey2 success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            [_arrSort2 removeAllObjects];
            _arrSort2 = nil;
            NSMutableArray *tmpArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:&error];
            [self.arrSort2 addObjectsFromArray:tmpArr];
        } failure:^(NSError *error) {
        }];
    }
}

- (void)configTitle {
    [_arrTitles removeAllObjects];
    _arrTitles = nil;
    [self updateSegmentTitles:self.arrTitles];
    [self.collectionView reloadData];
    [self.view layoutIfNeeded];
}

- (void)setUI {
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.switchView];
    [self.view addSubview:self.collectionView];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@49.0);
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@28.0);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchView.mas_bottom);
        make.height.equalTo(@49.0);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchView.searchTxtField resignFirstResponder];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrTitles.count;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    TrendsInteligenceViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    [cell loadSourceType:indexPath.item currentDic:self.currentDic];
//    return cell;
//}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    _titleId = indexPath.item;
    //    NSLog(@"即将显示 ---- %ld" ,(long)indexPath.item);
    [self.segmentView selectIndex:_titleId];
    [self releaseFilterListView];
    [self hidenKeyBoard];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"完成显示 ---- %ld" ,(long)indexPath.item);
    // 滑动到一半的时候又滑回去的场景，需要重新计算偏移量
    if (_titleId == indexPath.item) {
        CGFloat offsetX = self.collectionView.contentOffset.x;
        NSInteger index = offsetX / CGRectGetWidth(self.collectionView.frame);
        if (index >= 0 && index < self.arrTitles.count) {
            _titleId = index;
            [self.segmentView selectIndex:_titleId];
            [self releaseFilterListView];
            [self hidenKeyBoard];
        }
    } else {
        [self clearKeyword];
    }
    self.currentDic = self.arrTitleDics[_titleId];
    [self reloadDataWithParam];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
    [self releaseFilterListView];
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    _keyword = textField.text;
//    [Utils showToastMessage:@"搜索中..."];
    [self.searchView.searchTxtField resignFirstResponder];
    [self releaseFilterListView];
    [self reloadDataWithParam];
}

#pragma mark - TrendsSegmentViewDelegate

- (void)trendsSegmentView:(TrendsSegmentView *)trendsSegmentView didSelectIndex:(NSInteger)index title:(NSString *)title {
    NSLog(@"index:%ld,title:%@", index, title);
    _titleId = index;
    self.currentDic = self.arrTitleDics[_titleId];
    [self selectIndex:_titleId];
    [self releaseFilterListView];
    [self hidenKeyBoard];
    [self clearKeyword];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadDataWithParam];
    });
}

//#pragma mark - SwitchViewDelegate
//
//- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
//    // 隐藏键盘
//    [self hidenKeyBoard];
//    // 任何已经处于选择情况下，清空选择列表，重置按钮
//    if (_filterListView) {
//        [self releaseFilterListView];
//        [_filterListView removeFromSuperview];
//        _filterListView = nil;
//        for (int i = 0; i < 3; i++) {
//            [switchView updateTitle:@"" index:i switchState:SwitchStateNormal];
//        }
//        return;
//    }
//    _switchId = index;
//    // 只设置当前的选中状态，其他重置
//    [switchView updateTitle:@"" index:index switchState:SwitchStateSelectSecond];
//    
//    if (_switchId == 2) {
//        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
//        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
//        NSDate *scrollToDate = [minDateFormater dateFromString:self.selectDate];
//        
//        __weak typeof(self) weakSelf = self;
//        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
//            __strong typeof(self) strongSelf = weakSelf;
//            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
//            NSLog(@"选择的日期：%@",date);
//            [weakSelf.switchView updateTitle:date index:weakSelf.switchId switchState:SwitchStateNormal];
//            if (![strongSelf.selectDate isEqualToString:date]) {
//                strongSelf.selectDate = date;
//                [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:weakSelf.titleId inSection:0]]];
//            }
//        }];
//        datepicker.btnCancelTitle = @"重置";
//        datepicker.wsCancelBlock = ^{
//            [weakSelf.switchView updateTitle:@"搜集日期" index:weakSelf.switchId switchState:SwitchStateNormal];
//            weakSelf.selectDate = nil;
//            [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:weakSelf.titleId inSection:0]]];
//        };
//        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
//        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
//        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
//        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
//        [datepicker show];
//    } else {
//        if (!_filterListView) {
//            _filterListView = [[FilterListView alloc] initWithSourceType:0];
//            _filterListView.delegate = self;
//        }
//        
//        [self.view addSubview:_filterListView];
//        [_filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(CGRectGetMaxY(self.switchView.frame));
//            make.left.right.bottom.equalTo(self.view);
//        }];
//        if (_switchId == 0) {
//            self.arrSort = [[NSMutableArray alloc] initWithArray:@[@"组件厂",@"电池厂", @"硅片厂", @"电站"]];
//        } else if (_switchId == 1) {
//            self.arrSort = [[NSMutableArray alloc] initWithArray:@[@"人事情报",@"财务情报", @"采购情报", @"生产情报", @"销售情报", @"研发情报"]];
//        }
//        
//        if (index == 0) {
//            _filterListView.collectionView.selectTag = _sortTag1;
//        } else if (index == 1) {
//            _filterListView.collectionView.selectTag = _sortTag2;
//        } else if (index == 2) {
//            _filterListView.collectionView.selectTag = _sortTag3;
//        }
//        [_filterListView loadData:self.arrSort];
//        [_filterListView updateViewHeight:CGRectGetHeight(self.collectionView.frame) bottomHeight:0];
//    }
//}

#pragma mark - FilterListViewDelegate

- (void)filterListViewDismiss:(FilterListView *)filterListView {
    [self releaseFilterListView];
}

//- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
//    NSString *str = @"";
//    if (_switchId == 0) {
//        _sortTag1 = indexPath.row;
//        str = self.arrSort[_sortTag1];
//    } else if (_switchId == 1) {
//        _sortTag2 = indexPath.row;
//        str = self.arrSort[_sortTag2];
//    }
//    [self releaseFilterListView];
//    [self.switchView updateTitle:STRING(str) index:_switchId switchState:SwitchStateNormal];
//}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    NSLog(@"TrendsBaseViewCtrl 执行");
}

- (void)selectIndex:(NSInteger)index {
    if (index >= 0 && index < self.arrTitles.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (void)releaseFilterListView {
    if (_filterListView) {
        [_filterListView removeFromSuperview];
        _filterListView = nil;
        [self.switchView updateTitle:@"" index:_switchId switchState:SwitchStateNormal];
    }
}

- (void)hidenKeyBoard {
    [self.searchView.searchTxtField resignFirstResponder];
}

- (void)clearKeyword {
    self.keyword = @"";
    self.searchView.searchTxtField.text = @"";
}

- (void)updateSwitchTitles:(NSArray *)titles {
    [self.switchView updateTitles:titles];
}

- (void)updateSegmentTitles:(NSArray *)titles {
    [self.segmentView refreshTitles:[NSMutableArray arrayWithArray:titles]];
}

- (void)refreshView {
    [self.collectionView reloadData];
//    [self.view layoutIfNeeded];
}

- (void)setPlaceHoder:(NSString *)placeHoder {
    self.searchView.searchTxtField.placeholder = STRING(placeHoder);
}

- (void)reloadDataWithParam {
    TrendsBaseCollectionCell *cell = (TrendsBaseCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.titleId inSection:0]];
    cell.param = self.param;
    [cell refreshTableView];
}

#pragma mark - lazy

- (TrendsSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[TrendsSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49) showBtn:NO];
        _segmentView.trendsSegmentViewDelegate = self;
        UIView *lineView = [Utils getLineView];
        [_segmentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_segmentView);
            make.height.equalTo(@0.5);
        }];
    }
    return _segmentView;
}

- (SwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[SwitchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)
                                                 titles:@[@"业务类型", @"信息类别",@"搜集日期"]
                                              imgNormal:@[@"client_down_n", @"client_down_n", @"client_down_n"]
                                              imgSelect:@[@"drop_down_s", @"drop_down_s", @"drop_down_s"]];
        _switchView.delegate = self;
        [_switchView updateSelectViewHiden:YES];
    }
    return _switchView;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = @"请输入客户或情报关键字等";
        _searchView.btnSearch.layer.borderColor = COLOR_LINE.CGColor;
        _searchView.btnSearch.layer.borderWidth = 0.5;
    }
    return _searchView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_B0;
    }
    return _collectionView;
}

- (NSMutableArray *)arrTitles {
    if (!_arrTitles) {
        _arrTitles = [NSMutableArray new];
        for (DicMo *tmpDic in self.arrTitleDics) {
            [_arrTitles addObject:STRING(tmpDic.value)];
        }
    }
    return _arrTitles;
}

- (NSMutableArray *)arrTitleDics {
    if (!_arrTitleDics) {
        _arrTitleDics = [NSMutableArray new];
        [_arrTitleDics addObject:self.dicDefault];
    }
    return _arrTitleDics;
}

- (NSMutableArray *)arrSort1 {
    if (!_arrSort1) {
        _arrSort1 = [NSMutableArray new];
        [_arrSort1 addObject:self.dicDefault];
    }
    return _arrSort1;
}

- (NSMutableArray *)arrSort2 {
    if (!_arrSort2) {
        _arrSort2 = [NSMutableArray new];
        [_arrSort2 addObject:self.dicDefault];
    }
    return _arrSort2;
}

- (DicMo *)dicDefault {
    if (!_dicDefault) {
        _dicDefault = [[DicMo alloc] init];
        _dicDefault.name = self.switchDicName;
        _dicDefault.key = @"";
        _dicDefault.value = @"所有";
        _dicDefault.remark = @"所有";
    }
    return _dicDefault;
}

- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary new];
        [_param setObject:@(10) forKey:@"size"];
        [_param setObject:@"DESC" forKey:@"direction"];
        [_param setObject:@"createdDate" forKey:@"property"];
    }
    return _param;
}

@end
