//
//  FavoriteViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface FavoriteViewCtrl : BaseViewCtrl

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;

- (void)getListPage:(NSInteger)page;
- (void)tableViewEndRefreshing;

@end
