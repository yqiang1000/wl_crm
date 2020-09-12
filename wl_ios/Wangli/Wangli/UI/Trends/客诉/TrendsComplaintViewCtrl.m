//
//  TrendsComplaintViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsComplaintViewCtrl.h"
#import "TrendsComplaintCollectionCell.h"

@interface TrendsComplaintViewCtrl ()

@end

static NSString *identifier = @"TrendsComplaintCollectionCell";

@implementation TrendsComplaintViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客诉申请";
    self.placeHoder = @"请输入客户或情报关键字等";
//    self.arrTitles = [NSMutableArray arrayWithArray:@[@"所有",
//                                                      @"立案中",
//                                                      @"处理中",
//                                                      @"结案中",
//                                                      @"已结案",
//                                                      @"未立案"]];
    [self updateSegmentTitles:self.arrTitles];
    [self updateSwitchTitles:@[@"责任工厂", @"需要报告", @"申请日期"]];
    [self.collectionView registerClass:[TrendsComplaintCollectionCell class] forCellWithReuseIdentifier:identifier];
    [self refreshView];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrendsComplaintCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell loadSourceType:indexPath.item currentDic:self.currentDic];
    return cell;
}

#pragma mark - SwitchViewDelegate

- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state {
    // 隐藏键盘
    [self hidenKeyBoard];
    // 任何已经处于选择情况下，清空选择列表，重置按钮
    if (self.filterListView) {
        [self releaseFilterListView];
        return;
    }
    self.switchId = index;
    // 只设置当前的选中状态，其他重置
    [switchView updateTitle:@"" index:index switchState:SwitchStateSelectSecond];
    
    if (self.switchId == 2) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *scrollToDate = [minDateFormater dateFromString:self.selectDate];
        
        __weak typeof(self) weakSelf = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            __strong typeof(self) strongSelf = weakSelf;
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",date);
            [weakSelf.switchView updateTitle:date index:weakSelf.switchId switchState:SwitchStateNormal];
            if (![strongSelf.selectDate isEqualToString:date]) {
                strongSelf.selectDate = date;
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:weakSelf.titleId inSection:0]]];
            }
        }];
        datepicker.btnCancelTitle = @"重置";
        datepicker.wsCancelBlock = ^{
            [weakSelf.switchView updateTitle:@"申请日期" index:weakSelf.switchId switchState:SwitchStateNormal];
            weakSelf.selectDate = nil;
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:weakSelf.titleId inSection:0]]];
        };
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
    } else {
        if (!self.filterListView) {
            self.filterListView = [[FilterListView alloc] initWithSourceType:0];
            self.filterListView.delegate = self;
        }
        
        [self.view addSubview:self.filterListView];
        [self.filterListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(CGRectGetMaxY(self.switchView.frame));
            make.left.right.bottom.equalTo(self.view);
        }];
        if (self.switchId == 0) {
            self.arrSort = [[NSMutableArray alloc] initWithArray:@[@"浙江工厂",
                                                                   @"广东工厂",
                                                                   @"天津工厂"]];
        } else if (self.switchId == 1) {
            self.arrSort = [[NSMutableArray alloc] initWithArray:@[@"需要",
                                                                   @"不需要"]];
        }
        
        if (index == 0) {
            self.filterListView.collectionView.selectTag = self.sortTag1;
        } else if (index == 1) {
            self.filterListView.collectionView.selectTag = self.sortTag2;
        } else if (index == 2) {
            self.filterListView.collectionView.selectTag = self.sortTag3;
        }
        [self.filterListView loadData:self.arrSort];
        [self.filterListView updateViewHeight:CGRectGetHeight(self.collectionView.frame) bottomHeight:0];
    }
}

#pragma mark - FilterListViewDelegate

- (void)filterListView:(FilterListView *)filterListView didSelectIndexPath:(NSIndexPath *)indexPath {
    NSString *str = @"";
    if (self.switchId == 0) {
        self.sortTag1 = indexPath.row;
        str = self.arrSort[self.sortTag1];
    } else if (self.switchId == 1) {
        self.sortTag2 = indexPath.row;
        str = self.arrSort[self.sortTag2];
    }
    [self releaseFilterListView];
    [self.switchView updateTitle:STRING(str) index:self.switchId switchState:SwitchStateNormal];
}

@end
