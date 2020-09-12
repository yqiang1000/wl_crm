//
//  SubjectViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ZJScrollPageViewDelegate.h"
#import "BottomView.h"
#import "RiskFollowCell.h"
#import "TrendsFeedMo.h"

@interface SubjectViewCtrl : BaseViewCtrl <ZJScrollPageViewChildVcDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnNew;
@property (nonatomic, strong) UIView *authorityView;

/** 是否需要刷新 */
@property (nonatomic, assign) BOOL headerRefresh;

/** 是否需要刷新 */
@property (nonatomic, assign) BOOL footerRefresh;

/** 添加tableview */
- (void)addTableView;

/** 新建按钮 */
- (void)addBtnNew;

/** 无权限 YES:有权限 NO:没权限 */
- (void)addUnAuthortyView:(BOOL)author;

/** 新建按钮方法 */
- (void)btnNewClick:(UIButton *)sender;

/** 下拉刷新 */
- (void)tableViewHeaderRefreshAction;

/** 上拉刷新 */
- (void)tableViewFooterRefreshAction;

/** 结束刷新 */
- (void)tableViewEndRefresh;

/** 长按删除 */
- (void)handleDeleteCell:(NSIndexPath *)sender;

@end
