//
//  Base360TableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "Base360TableView.h"

@interface Base360TableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation Base360TableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = COLOR_B0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
        self.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return self;
}

- (void)tableViewHeaderRefreshAction {
    
}

- (void)tableViewFooterRefreshAction {
    
}

@end
