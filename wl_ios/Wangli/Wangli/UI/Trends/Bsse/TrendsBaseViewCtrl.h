//
//  TrendsBaseViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "TrendsSegmentView.h"
#import "SwitchView.h"
#import "SearchTopView.h"
//#import "TrendsInteligenceViewCollectionCell.h"
#import "FilterListView.h"
#import "WSDatePickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsBaseViewCtrl : BaseViewCtrl <TrendsSegmentViewDelegate, SwitchViewDelegate, SearchTopViewDelegate, FilterListViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/** 子类需要实现 SwitchViewDelegate, SearchTopViewDelegate, FilterListViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource 协议 */

@property (nonatomic, strong) TrendsSegmentView *segmentView;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) SwitchView *switchView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FilterListView *filterListView;

@property (nonatomic, copy) NSString *selectDate;
@property (nonatomic, strong) NSMutableArray *arrTitles;

@property (nonatomic, copy) NSString *switchDicName;
@property (nonatomic, strong) NSMutableArray *arrTitleDics; // 字典数组
@property (nonatomic, strong) NSMutableDictionary *param;   // page参数

@property (nonatomic, strong) DicMo *currentDic;
@property (nonatomic, strong) DicMo *sortDic1;
@property (nonatomic, strong) DicMo *sortDic2;

@property (nonatomic, assign) NSInteger titleId;     // 大类Id
@property (nonatomic, assign) NSInteger switchId;    // 当前筛选Id
@property (nonatomic, assign) NSInteger sortTag1;    // 业务类型筛选位置
@property (nonatomic, assign) NSInteger sortTag2;    // 信息类别筛选位置
@property (nonatomic, assign) NSInteger sortTag3;    // 搜索日期筛选位置

@property (nonatomic, strong) NSMutableArray *arrSort1;
@property (nonatomic, strong) NSMutableArray *arrSort2;

@property (nonatomic, copy) NSString *sortKey1;
@property (nonatomic, copy) NSString *sortKey2;

@property (nonatomic, copy) NSString *placeHoder;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, strong) NSMutableArray *arrSort;

/** 合同跟踪传进来客户id */
@property (nonatomic, assign) long long memberId;

/** 设置头部滑动试图滚动到某个位置 */
- (void)selectIndex:(NSInteger)index;
/** 释放筛选列表 */
- (void)releaseFilterListView;
/** 隐藏键盘 */
- (void)hidenKeyBoard;
/** 清除关键字 */
- (void)clearKeyword;
/** 更新筛选标题 */
- (void)updateSwitchTitles:(NSArray *)titles;
/** 更新滚动标题 */
- (void)updateSegmentTitles:(NSArray *)titles;
/** 更新视图(必须执行) */
- (void)refreshView;
/** 获取默认的字典项 */
- (void)loadNewTitles;
/** 搜索条件改变刷新列表 */
- (void)reloadDataWithParam;

@end

NS_ASSUME_NONNULL_END
