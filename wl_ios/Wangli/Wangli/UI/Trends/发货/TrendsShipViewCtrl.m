//
//  TrendsShipViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsShipViewCtrl.h"
#import "TrendsShipCollectionCell.h"

@interface TrendsShipViewCtrl ()

@end

static NSString *identifier = @"TrendsShipCollectionCell";

@implementation TrendsShipViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发货清单";
    self.rightBtn.hidden = YES;
    self.placeHoder = @"请输入发货单号、客户号或客户名称";
//    self.arrTitles = [NSMutableArray arrayWithArray:@[@"所有",
//                                                      @"未过账",
//                                                      @"已过账",
//                                                      @"部分开票",
//                                                      @"已开票"]];
//    [self updateSegmentTitles:self.arrTitles];
//    [self updateSwitchTitles:@[@"订单类型", @"销售组织", @"发货日期"]];
    [self.collectionView registerClass:[TrendsShipCollectionCell class] forCellWithReuseIdentifier:identifier];
    [self refreshView];
    [self.view layoutIfNeeded];
    [self reloadDataWithParam];
}

- (void)setUI {
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.searchView];
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
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrendsShipCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell loadSourceType:indexPath.item currentDic:self.currentDic];
    return cell;
}

//#pragma mark - SwitchViewDelegate
//
//- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
//    // 隐藏键盘
//    [self hidenKeyBoard];
//    // 任何已经处于选择情况下，清空选择列表，重置按钮
//    if (self.filterListView) {
//        [self releaseFilterListView];
//        return;
//    }
//    self.switchId = index;
//    // 只设置当前的选中状态，其他重置
//    [switchView updateTitle:@"" index:index switchState:SwitchStateSelectSecond];
//
//    if (self.switchId == 2) {
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
//            [weakSelf.switchView updateTitle:@"发货日期" index:weakSelf.switchId switchState:SwitchStateNormal];
//            weakSelf.selectDate = nil;
//            [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:weakSelf.titleId inSection:0]]];
//        };
//        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
//        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
//        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
//        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
//        [datepicker show];
//    } else {
//        if (!self.filterListView) {
//            self.filterListView = [[FilterListView alloc] initWithSourceType:0];
//            self.filterListView.delegate = self;
//        }
//
//        [self.view addSubview:self.filterListView];
//        [self.filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(CGRectGetMaxY(self.switchView.frame));
//            make.left.right.bottom.equalTo(self.view);
//        }];
//        NSMutableArray *arrSort = [NSMutableArray new];
//        if (self.switchId == 0) {
//            self.filterListView.collectionView.selectTag = self.sortTag1;
//            for (DicMo *tmpDic in self.arrSort1) {
//                [arrSort addObject:STRING(tmpDic.value)];
//            }
//        } else if (self.switchId == 1) {
//            self.filterListView.collectionView.selectTag = self.sortTag2;
//            for (DicMo *tmpDic in self.arrSort2) {
//                [arrSort addObject:STRING(tmpDic.value)];
//            }
//        } else if (self.switchId == 2) {
//            self.filterListView.collectionView.selectTag = self.sortTag3;
//        }
//        [self.filterListView loadData:arrSort];
//        [self.filterListView updateViewHeight:CGRectGetHeight(self.collectionView.frame) bottomHeight:0];
//    }
//}
//
//#pragma mark - FilterListViewDelegate
//
//- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
//    NSString *str = @"";
//    if (self.switchId == 0) {
//        self.sortTag1 = indexPath.row;
//        self.sortDic1 = self.arrSort1[self.sortTag1];
//        str = self.sortDic1.value;
//    } else if (self.switchId == 1) {
//        self.sortTag2 = indexPath.row;
//        self.sortDic2 = self.arrSort2[self.sortTag2];
//        str = self.sortDic2.value;
//    }
//    [self releaseFilterListView];
//    [self.switchView updateTitle:str index:self.switchId switchState:SwitchStateNormal];
//    [self reloadDataWithParam];
//}

- (void)reloadDataWithParam {
    [self.param removeAllObjects];
    self.param = nil;
    NSMutableArray *rules = [NSMutableArray new];
    if (self.currentDic.key.length > 0) {
        [rules addObject:@{@"field":@"statusKey",
                           @"option":@"EQ",
                           @"values":@[STRING(self.currentDic.key)]}];
    }
//    if (self.sortDic1.key.length > 0) {
//        [rules addObject:@{@"field":@"activityTypeKey",
//                           @"option":@"EQ",
//                           @"values":@[STRING(self.sortDic1.key)]}];
//    }
//    if (self.sortDic2.key.length > 0) {
//        [rules addObject:@{@"field":@"importantKey",
//                           @"option":@"EQ",
//                           @"values":@[STRING(self.sortDic2.key)]}];
//    }
//    if (self.selectDate.length > 0) {
//        [rules addObject:@{@"field":@"createdDate",
//                           @"option":@"BTD",
//                           @"values":@[[NSString stringWithFormat:@"%@ 00:00:00", self.selectDate],
//                                       [NSString stringWithFormat:@"%@ 23:59:59", self.selectDate]]}];
//    }
    if (self.keyword.length > 0) {
        [rules addObject:@{@"field":@"searchContent",
                           @"option":@"LIKE_ANYWHERE",
                           @"values":@[STRING(self.keyword)]}];
    }
    if (self.memberId != 0) {
        [rules addObject:@{@"field":@"member.id",
                           @"option":@"EQ",
                           @"values":@[@(TheCustomer.customerMo.id)]}];
    }
    if (rules.count > 0) {
        [self.param setObject:rules forKey:@"rules"];
    }
    [super reloadDataWithParam];
}

@end
