//
//  BaseSearchViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/6/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "SearchStyle.h"
#import "SearchHeaderView.h"

@interface BaseSearchViewCtrl : BaseViewCtrl

@property (nonatomic, assign) BOOL showIFly;//是否一进来就显示语音

@property (nonatomic, strong) SearchStyle *searchStyle;

@property (nonatomic, copy) NSString *searchKey;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *totalElements;

- (void)searchPage:(NSInteger)page searchKey:(NSString *)searchKey;

@end
