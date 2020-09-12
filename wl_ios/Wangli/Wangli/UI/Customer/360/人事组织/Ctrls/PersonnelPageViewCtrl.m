//
//  PersonnelPageViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PersonnelPageViewCtrl.h"
#import "PersonnelPageBusinessViewCtrl.h"
#import "PersonnelPageDemandViewCtrl.h"
#import "PersonCardView.h"

@interface PersonnelPageViewCtrl () <UIScrollViewDelegate, PersonCardViewDelegate>

@property (nonatomic, strong) PersonCardView *cardView;
@property (nonatomic, strong) NSMutableArray *arrCardData;
@property (nonatomic, assign) NSInteger currentTag;

@property (nonatomic, strong) UIView *midleButtonView;
@property (nonatomic, strong) UIButton *btnBusiness;
@property (nonatomic, strong) UIButton *btnDemand;

@property (nonatomic, assign) long long officeId;
@property (nonatomic, assign) NSInteger officePage;

@end

@implementation PersonnelPageViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _officeId = 0;
    _officePage = 0;
    _currentTag = 0;
    self.view.backgroundColor = COLOR_B0;
    self.pageScrollView.mainTableView.backgroundColor = COLOR_B4;
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.pageScrollView reloadData];
    self.cardView.arrData = self.arrCardData;
    
    __weak typeof(self) weakself = self;
    self.pageScrollView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongself = weakself;
        [strongself refreshData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountCountChange) name:NOTIFI_CONTACT_UPDATE object:nil];
}

- (void)accountCountChange {
    self.officePage = 0;
    [self getNewOfficeId:self.officeId page:self.officePage];
}

- (void)refreshData {
    //创建队列组
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//        self.officePage = 0;
//        [self getNewOfficeId:self.officeId page:self.officePage];
//    });
//    //当所有的任务都完成后会发送这个通知
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.pageScrollView.mainTableView.mj_header endRefreshing];
        
//        [self.cardView resetView];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            PersonnelPageBusinessViewCtrl *vc0 = _childVCs[0];
//            PersonnelPageDemandViewCtrl *vc1 = _childVCs[1];
//            [self.btnBusiness setTitle:[NSString stringWithFormat:@"关联商机(%ld)",(long)vc0.totalElements] forState:UIControlStateNormal];
//            [self.btnDemand setTitle:[NSString stringWithFormat:@"关键需求(%ld)",(long)vc1.totalElements] forState:UIControlStateNormal];
//        });
//    });
    [self resetCurrentMo];
    PersonnelPageDemandViewCtrl *vc0 = _childVCs[0];
    PersonnelPageBusinessViewCtrl *vc1 = _childVCs[1];
    vc0.contactMo = self.currentMo;
    vc1.contactMo = self.currentMo;
    [vc0 addHeaderRefresh];
    [vc1 addHeaderRefresh];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.btnDemand setTitle:[NSString stringWithFormat:@"关键需求(%ld)",(long)vc0.totalElements] forState:UIControlStateNormal];
        [self.btnBusiness setTitle:[NSString stringWithFormat:@"关联商机(%ld)",(long)vc1.totalElements] forState:UIControlStateNormal];
    });
}

#pragma mark - GKPageScrollViewDelegate

- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@235.0);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    return self.cardView;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.pageView;
}

- (NSArray<id<GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.childVCs;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
    if (_contentScrollView == scrollView) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        if (index >= 0 && index < self.arrCardData.count) {
            _currentTag = index;
            self.btnBusiness.selected = _currentTag == 0 ? NO : YES;
            self.btnDemand.selected = !self.btnBusiness.selected;
        }
    }
}

#pragma mark - PersonCardViewDelegate

- (void)personCardViewLoadMoreData:(PersonCardView *)personCardView needLoadMore:(BOOL)needLoadMore completeBlock:(void (^)(void))completeBlock {
    if (needLoadMore && self.cardView.canGetNewData) {
        [self getNewOfficeId:self.officeId page:self.officePage+1];
    }
}

- (void)personCardView:(PersonCardView *)personCardView didShowIndexPath:(NSIndexPath *)indexPath {
    self.currentMo = self.arrCardData[indexPath.item];
    PersonnelPageDemandViewCtrl *vc0 = _childVCs[0];
    PersonnelPageBusinessViewCtrl *vc1 = _childVCs[1];
    vc0.contactMo = self.currentMo;
    vc1.contactMo = self.currentMo;
    [vc0 addHeaderRefresh];
    [vc1 addHeaderRefresh];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.btnDemand setTitle:[NSString stringWithFormat:@"关键需求(%ld)",(long)vc0.totalElements] forState:UIControlStateNormal];
        [self.btnBusiness setTitle:[NSString stringWithFormat:@"关联商机(%ld)",(long)vc1.totalElements] forState:UIControlStateNormal];
    });
}

#pragma mark - event

- (void)itemAddClick:(UIButton *)sender {
    NSArray *arr = @[@"新建关键人",@"新建需求"];
    BaseViewCtrl *vc = [BaseViewCtrl new];
    vc.title = [NSString stringWithFormat:@"新建%@", arr[_currentTag]];
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)btnBusinessClick:(UIButton *)sender {
    _currentTag = 1;
    self.btnBusiness.selected = YES;
    self.btnDemand.selected = NO;
    [self.contentScrollView setContentOffset:CGPointMake(_currentTag*kScreenW, 0) animated:NO];
}

- (void)btnDemandClick:(UIButton *)sender {
    _currentTag = 0;
    self.btnBusiness.selected = NO;
    self.btnDemand.selected = YES;
    [self.contentScrollView setContentOffset:CGPointMake(_currentTag*kScreenW, 0) animated:NO];
}

- (void)getNewOfficeId:(long long)officeId page:(NSInteger)page {
    _officeId = officeId;
    _officePage = page;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(50) forKey:@"size"];
    [param setObject:@"DESC" forKey:@"direction"];
    [param setObject:@"id" forKey:@"property"];
    [param setObject:@(page) forKey:@"number"];
    
    // 获取公司的人员列表
    if (officeId == 0) {
        [param setObject:@[@{@"field":@"member.id",
                             @"option":@"EQ",
                             @"values":@[@(TheCustomer.customerMo.id)]}] forKey:@"rules"];
        
        [[JYUserApi sharedInstance] getLinkManListByMemberParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            NSMutableArray *tmpArr = [ContactMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            if (page == 0) {
                [self.arrCardData removeAllObjects];
                self.arrCardData = nil;
                self.arrCardData = tmpArr;
                self.cardView.canGetNewData = YES;
                self.cardView.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            } else {
                if (tmpArr.count > 0) {
                    self.cardView.canGetNewData = YES;
                    [self.arrCardData addObjectsFromArray:tmpArr];
                } else {
                    self.cardView.canGetNewData = NO;
                }
            }
            self.officePage = page;
            self.cardView.arrData = self.arrCardData;
            [self resetCurrentMo];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
    // 获取部门人员列表
    else {
        [param setObject:@[@{@"field":@"office.id",
                             @"option":@"EQ",
                             @"values":@[@(_officeId)]}] forKey:@"rules"];
        [[JYUserApi sharedInstance] getLinkManListByOfficeParam:param success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            NSMutableArray *tmpArr = [ContactMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            if (page == 0) {
                [self.arrCardData removeAllObjects];
                self.arrCardData = nil;
                self.arrCardData = tmpArr;
                self.cardView.canGetNewData = YES;
                self.cardView.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            } else {
                if (tmpArr.count > 0) {
                    self.cardView.canGetNewData = YES;
                    [self.arrCardData addObjectsFromArray:tmpArr];
                } else {
                    self.cardView.canGetNewData = NO;
                }
            }
            self.officePage = page;
            self.cardView.arrData = self.arrCardData;
            [self resetCurrentMo];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)resetCurrentMo {
    if (self.arrCardData.count > 0) {
        if (!self.cardView.currentIndexPath) {
            self.currentMo = self.arrCardData[0];
        }
    } else {
        self.currentMo = nil;
    }
}

#pragma mark - 懒加载

- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageScrollView.ceilPointHeight = 0;
        _pageScrollView.backgroundColor = COLOR_B0;
    }
    return _pageScrollView;
}

- (UIView *)midleButtonView {
    if (!_midleButtonView) {
        _midleButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _midleButtonView.backgroundColor = COLOR_B0;
        
        [_midleButtonView addSubview:self.btnBusiness];
        [_midleButtonView addSubview:self.btnDemand];
        
        [_btnDemand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_midleButtonView);
            make.left.equalTo(_midleButtonView).offset(15);
        }];
        
        [_btnBusiness mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_midleButtonView);
            make.left.equalTo(_btnDemand.mas_right).offset(37);
        }];
    }
    return _midleButtonView;
}

- (UIButton *)btnBusiness {
    if (!_btnBusiness) {
        _btnBusiness = [UIButton new];
        _btnBusiness.titleLabel.font = FONT_F15;
        [_btnBusiness setTitle:@"关联商机(0)" forState:UIControlStateNormal];
        [_btnBusiness setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        [_btnBusiness setTitleColor:COLOR_C1 forState:UIControlStateSelected];
        [_btnBusiness addTarget:self action:@selector(btnBusinessClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnBusiness.hidden = YES;
    }
    return _btnBusiness;
}

- (UIButton *)btnDemand {
    if (!_btnDemand) {
        _btnDemand = [UIButton new];
        _btnDemand.selected = YES;
        _btnDemand.titleLabel.font = FONT_F15;
        [_btnDemand setTitle:@"关键需求(0)" forState:UIControlStateNormal];
        [_btnDemand setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        [_btnDemand setTitleColor:COLOR_C1 forState:UIControlStateSelected];
        [_btnDemand addTarget:self action:@selector(btnDemandClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDemand;
}

- (UIView *)pageView {
    if (!_pageView) {
        _pageView = [UIView new];
        [_pageView addSubview:self.midleButtonView];
        [_pageView addSubview:self.contentScrollView];
    }
    return _pageView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        CGFloat scrollW = kScreenW;
        CGFloat scrollH = kScreenH - kNavBarHeight - kBaseSegmentHeight-kBaseSwitchHeight-KMagrinBottom-44;
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kBaseSegmentHeight, scrollW, scrollH)];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
        
        [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:vc];
            [self->_contentScrollView addSubview:vc.view];
            
            vc.view.frame = CGRectMake(idx * scrollW, 0, scrollW, scrollH);
        }];
        _contentScrollView.contentSize = CGSizeMake(scrollW * self.childVCs.count, 0);
    }
    return _contentScrollView;
}

- (NSArray *)childVCs {
    if (!_childVCs) {
        PersonnelPageDemandViewCtrl *page0 = [PersonnelPageDemandViewCtrl new];
        PersonnelPageBusinessViewCtrl *page1 = [PersonnelPageBusinessViewCtrl new];
        _childVCs = @[page0, page1];
    }
    return _childVCs;
}


- (PersonCardView *)cardView {
    if (!_cardView) {
        _cardView = [[PersonCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 235)];
        _cardView.delegate = self;
        _cardView.canGetNewData = YES;
    }
    return _cardView;
}

- (NSMutableArray *)arrCardData {
    if (!_arrCardData) {
        _arrCardData = [NSMutableArray new];
    }
    return _arrCardData;
}


@end
