//
//  MyTableView.h
//  CustomTableView
//
//  Created by yeqiang on 2018/4/19.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewHeader.h"

@class MyTableView;
@protocol MyTableViewDelegate <NSObject>

@optional
/** 点击某一格 */
- (void)myTableView:(MyTableView *)myTableView selectItemIndexPath:(NSIndexPath *)indexPath;
/** 点击某一列标题 */
- (void)myTableView:(MyTableView *)myTableView selectTopIndex:(NSInteger)index;
/** 下拉刷新 */
- (void)myTableViewHeaderRefresh:(MyTableView *)myTableView;
/** 上拉加载更多 */
- (void)myTableViewFooterRefresh:(MyTableView *)myTableView;

@end

@interface MyTableView : UIView

/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *arrTopTitle;
/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *arrData;

/** 表格单位高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/** 表格单位宽度 */
@property (nonatomic, assign, readonly) CGFloat cellWidth;
@property (nonatomic, weak) id <MyTableViewDelegate> myViewDelegate;

/** 刷新数据 */
- (void)initSetting;
/** 结束刷新动画 */
- (void)endRefresh;
/** 没有更多数据 */
- (void)nomoreData;

@end
