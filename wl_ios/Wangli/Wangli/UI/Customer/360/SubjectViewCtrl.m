//
//  SubjectViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "SubjectViewCtrl.h"

@interface SubjectViewCtrl ()

@end

@implementation SubjectViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden = YES;
    self.view.backgroundColor = COLOR_B0;
}

- (void)dealloc {
    
}

#pragma mark - public

- (void)addTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(self.view);
    }];
}

- (void)addUnAuthortyView:(BOOL)author {
    if (author) {
        [_authorityView removeFromSuperview];
        _authorityView = nil;
    } else {
        [self.view addSubview:self.authorityView];
        [self.authorityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.equalTo(self.view);
        }];
    }
}

- (void)addBtnNew {
    [self.view addSubview:self.btnNew];
    [self.btnNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10-Height_TabBar);;
        make.right.equalTo(self.view).offset(-20);
        make.height.width.equalTo(@58.0);
    }];
}

- (void)setHeaderRefresh:(BOOL)headerRefresh {
    _headerRefresh = headerRefresh;
    if (_headerRefresh) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
    }
}

- (void)setFooterRefresh:(BOOL)footerRefresh {
    _footerRefresh = footerRefresh;
    if (_footerRefresh) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFooterRefreshAction)];
    }
}

- (void)btnNewClick:(UIButton *)sender {
    
}

- (void)tableViewHeaderRefreshAction {
    
}

- (void)tableViewFooterRefreshAction {
    
}

- (void)tableViewEndRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        [self handleDeleteCell:indexPath];
    }
}

- (void)handleDeleteCell:(NSIndexPath *)sender {//删除cell
    NSLog(@"父类长按操作 cell %ld", sender.row);
    
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
        
        [_tableView addGestureRecognizer:longPressGesture];
    }
    return _tableView;
}

- (UIButton *)btnNew {
    if (!_btnNew) {
        _btnNew = [[UIButton alloc] init];
        [_btnNew setImage:[UIImage imageNamed:@"details_page_add"] forState:UIControlStateNormal];
        [_btnNew addTarget:self action:@selector(btnNewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNew;
}

- (UIView *)authorityView {
    if (!_authorityView) {
        _authorityView = [UIView new];
        _authorityView.backgroundColor = COLOR_B0;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_authoritycopy"]];
        [_authorityView addSubview:imgView];
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = COLOR_B3;
        lab.font = FONT_F14;
        lab.text = @"该功能将于19年4月1日上线";
        [_authorityView addSubview:lab];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorityView).offset(140);
            make.centerX.equalTo(_authorityView);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(30);
            make.centerX.equalTo(_authorityView);
        }];
    }
    return _authorityView;
}

@end
