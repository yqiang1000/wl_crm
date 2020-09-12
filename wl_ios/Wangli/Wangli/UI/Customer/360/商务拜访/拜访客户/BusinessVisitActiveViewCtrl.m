//
//  BusinessVisitActiveViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BusinessVisitActiveViewCtrl.h"
#import "BottomView.h"
#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"
#import "YXTabView.h"
#import "YX.h"
#import "YXTabItemBaseView.h"
#import "VisitNoteView.h"
#import "VisitProcessView.h"
#import "VisitAnnexView.h"
#import "BusinessHeaderView.h"
#import "VisitNoteMo.h"
#import "BusinessCommonCreateViewCtrl.h"

@interface BusinessVisitActiveViewCtrl () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *tableView;
@property (nonatomic, strong) UIView *finishView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) YXTabView *tabView;
@property (nonatomic, strong) BusinessHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray <YXTabConfigMo *> *tabConfigArray;
@property (nonatomic, strong) VisitProcessView *visitProcessView;
@property (nonatomic, strong) VisitNoteView *visitNoteView;
@property (nonatomic, strong) VisitAnnexView *visitAnnexView;

@property (nonatomic, strong) UIButton *btnFinish;

@end

@implementation BusinessVisitActiveViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拜访活动";
    [self.rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [self initUI];
    [self refreshHeader];
    [self refreshSubView];
    [self getDetail];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
    [self addBackBlock];
}

-(void)initUI{
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.finishView];
    
    [self.finishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(KMagrinBottom+44));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.finishView.mas_top);
    }];
}

- (void)getDetail {
    [[JYUserApi sharedInstance] getBusinessVisitActivityDetailByDetailId:self.model.id param:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        NSError *error = nil;
        self.model = [[BusinessVisitActivityMo alloc] initWithDictionary:responseObject error:&error];
        [self.model configAttachmentList];
        [self refreshHeader];
        [self refreshSubView];
        [self refreshBtnFinish];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)addBackBlock {
    __weak typeof(self) weakself = self;
    self.visitProcessView.updateReportBlock = ^{
        [weakself getDetail];
    };
    self.visitNoteView.updateRemarkBlock = ^{
        [weakself refreshSubView];
    };
}

// 刷新头部
- (void)refreshHeader {
    
    self.tableView.tableHeaderView = self.headerView;
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_tableView);
    }];
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithArray:@[@[[self configLeftTxt:@"开始时间：" rightTxt:STRING(self.model.beginDate) status:NO isFinish:NO],
                                                                     [self configLeftTxt:@"结束时间：" rightTxt:STRING(self.model.endDate) status:NO isFinish:NO],
                                                                     [self configLeftTxt:@"拜访状态：" rightTxt:[self.model.status isEqualToString:@"end"]?@"已完成":@"未完成" status:YES isFinish:NO]],
                                                                   @[[self configLeftTxt:@"目标：" rightTxt:STRING(TheCustomer.customerMo.orgName) status:NO isFinish:NO],
                                                                     [self configLeftTxt:@"定位：" rightTxt:STRING(self.model.address) status:NO isFinish:NO]]]];
    _headerView.labTitle.text = _model.purpose;
    _headerView.arrData = data;
    [_headerView.tableView reloadData];
    [_headerView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_headerView.tableView.contentSize.height));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _headerView.tableView.layer.mask = [Utils drawContentFrame:_headerView.tableView.bounds corners:UIRectCornerAllCorners cornerRadius:5];
    });
    [_headerView layoutIfNeeded];
    self.tableView.tableHeaderView = _headerView;
}

- (NSMutableAttributedString *)configLeftTxt:(NSString *)leftTxt rightTxt:(NSString *)rightTxt status:(BOOL)status isFinish:(BOOL)isFinish {
    rightTxt = rightTxt.length > 0 ? rightTxt : @"暂无";
    NSString *orgStr = [leftTxt stringByAppendingString:rightTxt];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:orgStr];
    if (status) {
        [mutStr addAttribute:NSForegroundColorAttributeName value:COLOR_C2 range:NSMakeRange(leftTxt.length, rightTxt.length)];
    }
    return mutStr;
}

// 刷新底下三个列表
- (void)refreshSubView {
    // 第一个列表
    self.visitProcessView.model = self.model;
    self.visitProcessView.arrData = [[NSMutableArray alloc] initWithArray:@[STRING(self.model.signInInfo),
                                                                            STRING(self.model.showText),
                                                                            STRING(self.model.visitReport)]];
    // 第二个列表
    VisitNoteMo *mo = [[VisitNoteMo alloc] init];
    mo.title = @"拜访备注";
    mo.content = self.model.remark;
    self.visitNoteView.model = self.model;
    self.visitNoteView.arrData = [[NSMutableArray alloc] initWithObjects:mo, nil];
    
    // 第三个列表
    self.visitAnnexView.model = self.model;
    VisitNoteMo *mo1 = [[VisitNoteMo alloc] init];
    mo1.title = @"拜访附件";
    mo1.model = self.model;
    mo1.content = @"暂无附件";
    self.visitAnnexView.arrData = [[NSMutableArray alloc] initWithObjects:mo1, nil];
    
    [self.visitProcessView.tableView reloadData];
    [self.visitNoteView.tableView reloadData];
    [self.visitAnnexView.tableView reloadData];
}

- (void)refreshBtnFinish {
    self.btnFinish.enabled = [self.model.status isEqualToString:@"end"] ? NO : YES;
}

-(void)acceptMsg : (NSNotification *)notification{
    //NSLog(@"%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        return CGRectGetHeight(self.tableView.frame)+kTabTitleViewHeight;
    }
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"YXTabViewContentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = COLOR_B0;
    }
   if(indexPath.section == 0 && indexPath.row == 0) {
        [cell.contentView addSubview:self.tabView];
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y-kTopBarHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

- (void)clickRightButton:(UIButton *)sender {
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:@[@"编辑", @"删除"] defaultItem:-1 itemClick:^(NSInteger index) {
        if (index == 0) {
            [self gotoEditModel];
        } else if (index == 1) {
            [Utils commonDeleteTost:@"系统提示" msg:@"是否删除?" cancelTitle:@"取消" confirmTitle:@"确定" confirm:^{
                [Utils showHUDWithStatus:nil];
                [[JYUserApi sharedInstance] deleteBusinessVisitActivityByDetailId:self.model.id param:nil success:^(id responseObject) {
                    [Utils dismissHUD];
                    [Utils showToastMessage:@"删除成功"];
                    if (self.updateSuccess) {
                        self.updateSuccess(nil);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSError *error) {
                    [Utils dismissHUD];
                    [Utils showToastMessage:STRING(error.userInfo[@"message"])];
                }];
            } cancel:^{
            }];
        }
    } cancelClick:^(BottomView *obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    [bottomView show];
}

- (void)gotoEditModel {
    BusinessCommonCreateViewCtrl *vc = [[BusinessCommonCreateViewCtrl alloc] init];
    vc.isUpdate = YES;
    vc.fromTab = NO;
    vc.dynamicId = @"visit-activity";
    vc.detailId = self.model.id;
    vc.title = @"编辑拜访活动";
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        __strong typeof(self) strongself = weakself;
        [strongself getDetail];
    };
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)gotoDeleteMo {
    [[JYUserApi sharedInstance] deleteBusinessVisitActivityByDetailId:self.model.id param:nil success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"删除成功"];
        if (self.updateSuccess) {
            self.updateSuccess(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)tableViewHeaderRefreshAction {
    [self getDetail];
}

- (void)tableViewFooterRefreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.visitProcessView.tableView.mj_footer endRefreshing];
        [self.visitNoteView.tableView.mj_footer endRefreshing];
        [self.visitAnnexView.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)clickLeftButton:(UIButton *)sender {
    if (self.updateSuccess) {
        self.updateSuccess(nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fiinishClick:(UIButton *)sender {
    [Utils commonDeleteTost:@"系统提示" msg:@"是否完成拜访?" cancelTitle:@"取消" confirmTitle:@"完成" confirm:^{
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] updateVisitActivityStatus:@"status" param:@{@"id":@(self.model.id)} success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"状态更新成功"];
            [self getDetail];
            sender.enabled = NO;
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } cancel:^{
    }];
}

#pragma mark - lazy

- (YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *)tableView {
    if (!_tableView) {
        _tableView = [[YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-kBottomBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_B0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
    }
    return _tableView;
}

- (UIView *)finishView {
    if (!_finishView) {
        _finishView = [[UIView alloc] init];
        _finishView.backgroundColor = COLOR_B4;
        
        UIView *topLineView = [Utils getLineView];
        
        [_finishView addSubview:self.btnFinish];
        [_finishView addSubview:topLineView];
        
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_finishView);
            make.height.equalTo(@0.5);
        }];
        
        [_btnFinish mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLineView.mas_bottom);
            make.left.right.equalTo(_finishView);
            make.height.equalTo(@44.0);
        }];
    }
    return _finishView;
}

- (UIButton *)btnFinish {
    if (!_btnFinish) {
        _btnFinish = [[UIButton alloc] init];
        [_btnFinish setTitle:@"完成拜访" forState:UIControlStateNormal];
        [_btnFinish setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [_btnFinish setTitle:@"拜访已完成" forState:UIControlStateDisabled];
        [_btnFinish setTitleColor:COLOR_B3 forState:UIControlStateDisabled];
        [_btnFinish addTarget:self action:@selector(fiinishClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFinish;
}

- (YXTabView *)tabView {
    if (!_tabView) {
        _tabView = [[YXTabView alloc] initWithTabConfigArray:self.tabConfigArray];
    }
    return _tabView;
}

- (BusinessHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[BusinessHeaderView alloc] init];
        _headerView.backgroundColor = COLOR_B0;
    }
    return _headerView;
}

- (NSMutableArray<YXTabConfigMo *> *)tabConfigArray {
    if (!_tabConfigArray) {
        _tabConfigArray = [NSMutableArray new];
        
        YXTabConfigMo *mo0 = [[YXTabConfigMo alloc] init];
        mo0.yxTabItemBaseView = self.visitProcessView;
        [_tabConfigArray addObject:mo0];
        
        YXTabConfigMo *mo1 = [[YXTabConfigMo alloc] init];
        mo1.yxTabItemBaseView = self.visitNoteView;
        [_tabConfigArray addObject:mo1];
        
        YXTabConfigMo *mo2 = [[YXTabConfigMo alloc] init];
        mo2.yxTabItemBaseView = self.visitAnnexView;
        [_tabConfigArray addObject:mo2];
    }
    return _tabConfigArray;
}

- (VisitProcessView *)visitProcessView {
    if (!_visitProcessView) {
        _visitProcessView = [[VisitProcessView alloc] init];
        [_visitProcessView renderUIWithInfo:@{@"title":@"拜访过程",
                                              @"view":@"VisitProcessView",
                                              @"data":@"拜访过程的数据",
                                              @"position":@0}];
    }
    return _visitProcessView;
}

- (VisitNoteView *)visitNoteView {
    if (!_visitNoteView) {
        _visitNoteView = [[VisitNoteView alloc] init];
        [_visitNoteView renderUIWithInfo:@{@"title":@"拜访备注",
                                           @"view":@"VisitNoteView",
                                           @"data":@"拜访备注的数据",
                                           @"position":@1}];
    }
    return _visitNoteView;
}

- (VisitAnnexView *)visitAnnexView {
    if (!_visitAnnexView) {
        _visitAnnexView = [[VisitAnnexView alloc] init];
        [_visitAnnexView renderUIWithInfo:@{@"title":@"附件",
                                            @"view":@"VisitAnnexView",
                                            @"data":@"附件的数据",
                                            @"position":@2}];
    }
    return _visitAnnexView;
}


@end
