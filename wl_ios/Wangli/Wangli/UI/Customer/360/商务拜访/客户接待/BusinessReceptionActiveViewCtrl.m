//
//  BusinessReceptionActiveViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BusinessReceptionActiveViewCtrl.h"
#import "BottomView.h"
#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"
#import "YXTabView.h"
#import "YX.h"
#import "YXTabItemBaseView.h"
#import "ReceptionHotelView.h"
#import "BusinessHeaderView.h"

@interface BusinessReceptionActiveViewCtrl () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *tableView;
@property (nonatomic, strong) UIView *finishView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) YXTabView *tabView;
@property (nonatomic, strong) BusinessHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray <YXTabConfigMo *> *tabConfigArray;
@property (nonatomic, strong) ReceptionHotelView *receptionHotelView;
@property (nonatomic, strong) ReceptionHotelView *receptionLunchView;
@property (nonatomic, strong) ReceptionHotelView *receptionCarView;
@property (nonatomic, strong) ReceptionHotelView *receptionGiftView;
@property (nonatomic, strong) ReceptionHotelView *receptionReceptionView;
@property (nonatomic, strong) ReceptionHotelView *receptionMeetingView;

@end

@implementation BusinessReceptionActiveViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"接待活动";
    [self.rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [self initUI];
    [self initHeader];
    [self initRefresh];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
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

- (void)initHeader {
    
    self.tableView.tableHeaderView = self.headerView;
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_tableView);
    }];
    NSMutableArray *data = @[@[@"来访时间：2018年11月13日 - 2018年11月15日",
                               @"接待状态：未完成"],
                             @[@"客户名称: 晶科",
                               @"来访对象: 晶科副总裁",
                               @"随同人员: 晶科品质部经理、晶科技术部经理",
                               @"接待等级: S",
                               @"来访原因: 考察浙江地区工厂",
                               @"拜访地区: 浙江爱旭",
                               @"拜访对象: 销售副总",
                               @"参观车间: 否"]];
    _headerView.arrData = data;
    [_headerView.tableView reloadData];
    [_headerView.tableView layoutIfNeeded];
    [_headerView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_headerView.tableView.contentSize.height));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _headerView.tableView.layer.mask = [Utils drawContentFrame:_headerView.tableView.bounds corners:UIRectCornerAllCorners cornerRadius:5];
    });
    [_headerView layoutIfNeeded];
    self.tableView.tableHeaderView = _headerView;
}

- (void)initData {
    self.receptionHotelView.arrData = @[@"五星级酒店（爱旭支付）第一天",
                                        @"五星级酒店（爱旭支付）第二天"];
    self.receptionLunchView.arrData = @[@"五星级酒店（爱旭支付）中餐",
                                        @"五星级酒店（爱旭支付）晚餐"];
    self.receptionCarView.arrData = @[@"五星级酒店（爱旭支付）奔驰",
                                      @"五星级酒店（爱旭支付）宝马"];
    self.receptionGiftView.arrData = @[@"五星级酒店（爱旭支付）礼品1",
                                       @"五星级酒店（爱旭支付）礼品2"];
    self.receptionReceptionView.arrData = @[@"五星级酒店（爱旭支付）张三负责接待",
                                            @"五星级酒店（爱旭支付）李四负责接待"];
    self.receptionMeetingView.arrData = @[@"五星级酒店（爱旭支付）会议室1",
                                          @"五星级酒店（爱旭支付）会议室2"];
    [self.receptionHotelView.tableView reloadData];
    [self.receptionLunchView.tableView reloadData];
    [self.receptionCarView.tableView reloadData];
    [self.receptionGiftView.tableView reloadData];
    [self.receptionReceptionView.tableView reloadData];
    [self.receptionMeetingView.tableView reloadData];
}

- (void)initRefresh {
    __weak typeof(self) weakself = self;
    //    self.visitProcessView.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        NSLog(@"拜访过程上拉刷新");
    //        [weakself tableViewFooterRefreshAction];
    //    }];
    
//    self.visitNoteView.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        NSLog(@"拜访备注上拉刷新");
//        [weakself tableViewFooterRefreshAction];
//    }];
    
    //    self.visitAnnexView.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        NSLog(@"拜访附件上拉刷新");
    //        [weakself tableViewFooterRefreshAction];
    //    }];
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
        
        if (index == 1) {
            [Utils commonDeleteTost:@"系统提示" msg:@"是否删除?" cancelTitle:@"取消" confirmTitle:@"确定" confirm:^{
                [Utils showHUDWithStatus:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [Utils dismissHUD];
                });
            } cancel:^{
                [Utils dismissHUD];
            }];
        }
    } cancelClick:^(BottomView *obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    [bottomView show];
}

- (void)tableViewHeaderRefreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        NSLog(@"最外层刷新数据");
    });
}

- (void)tableViewFooterRefreshAction {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //        [self.visitProcessView.tableView.mj_footer endRefreshing];
//        [self.visitNoteView.tableView.mj_footer endRefreshing];
//        [self.visitAnnexView.tableView.mj_footer endRefreshing];
//        [self.tableView.mj_header endRefreshing];
//    });
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
        UIButton *btn1 = [[UIButton alloc] init];
        [btn1 setTitle:@"完成拜访" forState:UIControlStateNormal];
        [btn1 setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [_finishView addSubview:btn1];
        
        UIView *topLineView = [Utils getLineView];
        
        [_finishView addSubview:btn1];
        [_finishView addSubview:topLineView];
        
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_finishView);
            make.height.equalTo(@0.5);
        }];
        
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLineView.mas_bottom);
            make.left.right.equalTo(_finishView);
            make.height.equalTo(@44.0);
        }];
    }
    return _finishView;
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
        mo0.yxTabItemBaseView = self.receptionHotelView;
        [_tabConfigArray addObject:mo0];
        
        YXTabConfigMo *mo1 = [[YXTabConfigMo alloc] init];
        mo1.yxTabItemBaseView = self.receptionLunchView;
        [_tabConfigArray addObject:mo1];
        
        YXTabConfigMo *mo2 = [[YXTabConfigMo alloc] init];
        mo2.yxTabItemBaseView = self.receptionCarView;
        [_tabConfigArray addObject:mo2];
        
        YXTabConfigMo *mo3 = [[YXTabConfigMo alloc] init];
        mo3.yxTabItemBaseView = self.receptionGiftView;
        [_tabConfigArray addObject:mo3];
        
        YXTabConfigMo *mo4 = [[YXTabConfigMo alloc] init];
        mo4.yxTabItemBaseView = self.receptionReceptionView;
        [_tabConfigArray addObject:mo4];
        
        YXTabConfigMo *mo5 = [[YXTabConfigMo alloc] init];
        mo5.yxTabItemBaseView = self.receptionMeetingView;
        [_tabConfigArray addObject:mo5];
    }
    return _tabConfigArray;
}

- (ReceptionHotelView *)receptionHotelView {
    if (!_receptionHotelView) {
        _receptionHotelView = [[ReceptionHotelView alloc] init];
        [_receptionHotelView renderUIWithInfo:@{@"title":@"酒店",
                                                @"view":@"ReceptionHotelView",
                                                @"data":@"拜访过程的数据",
                                                @"position":@0}];
    }
    return _receptionHotelView;
}

- (ReceptionHotelView *)receptionLunchView {
    if (!_receptionLunchView) {
        _receptionLunchView = [[ReceptionHotelView alloc] init];
        [_receptionLunchView renderUIWithInfo:@{@"title":@"用餐",
                                                @"view":@"ReceptionHotelView",
                                                @"data":@"用餐的数据",
                                                @"position":@1}];
    }
    return _receptionLunchView;
}

- (ReceptionHotelView *)receptionCarView {
    if (!_receptionCarView) {
        _receptionCarView = [[ReceptionHotelView alloc] init];
        [_receptionCarView renderUIWithInfo:@{@"title":@"用车",
                                                @"view":@"ReceptionHotelView",
                                                @"data":@"用车的数据",
                                                @"position":@2}];
    }
    return _receptionCarView;
}

- (ReceptionHotelView *)receptionGiftView {
    if (!_receptionGiftView) {
        _receptionGiftView = [[ReceptionHotelView alloc] init];
        [_receptionGiftView renderUIWithInfo:@{@"title":@"礼品",
                                                @"view":@"ReceptionHotelView",
                                                @"data":@"礼品的数据",
                                                @"position":@3}];
    }
    return _receptionGiftView;
}

- (ReceptionHotelView *)receptionReceptionView {
    if (!_receptionReceptionView) {
        _receptionReceptionView = [[ReceptionHotelView alloc] init];
        [_receptionReceptionView renderUIWithInfo:@{@"title":@"接待",
                                                @"view":@"ReceptionHotelView",
                                                @"data":@"接待的数据",
                                                @"position":@4}];
    }
    return _receptionReceptionView;
}

- (ReceptionHotelView *)receptionMeetingView {
    if (!_receptionMeetingView) {
        _receptionMeetingView = [[ReceptionHotelView alloc] init];
        [_receptionMeetingView renderUIWithInfo:@{@"title":@"会议",
                                                @"view":@"ReceptionHotelView",
                                                @"data":@"会议的数据",
                                                @"position":@5}];
    }
    return _receptionMeetingView;
}

@end
