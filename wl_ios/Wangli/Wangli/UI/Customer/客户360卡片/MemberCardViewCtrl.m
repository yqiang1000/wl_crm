//
//  MemberCardViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/3/18.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "MemberCardViewCtrl.h"
#import "JYMemberCollectionView.h"
#import "JYMemberCollectionCell.h"
#import "Custom360ViewCtrl.h"

static NSString *identifier = @"JYMemberCollectionCell";

@interface MemberCardViewCtrl () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    CGFloat _dragStartX;
    CGFloat _dragEndX;
}

@property (nonatomic, strong) JYMemberCollectionView *collectionView;

@end

@implementation MemberCardViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[JYMemberCollectionCell class] forCellWithReuseIdentifier:identifier];
    self.view.backgroundColor = COLOR_B4;
    [self setUI];
    [self scrollToCenter];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToCenter];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNaviAlpha:) name:NOTIFI_CUSTOMER_360_SCROLL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCollectionIndexPath:) name:NOTIFI_CUSTOMER_360_SELECT object:nil];
}

- (void)changeNaviAlpha:(NSNotification *)noti {
    CGFloat offsetY = [[noti.userInfo objectForKey:@"offsetY"] floatValue];
    // 渐变动画
    if (offsetY < 50) {
        [self.naviView setAlpha:0];
    } else if (offsetY < 150) {
        CGFloat alpha = (offsetY - 50) / 100;
        [self.naviView setAlpha:alpha];
    } else {
        [self.naviView setAlpha:1];
    }
    self.title = TheCustomer.customerMo.abbreviation;
}

- (void)selectCollectionIndexPath:(NSNotification *)noti {
    NSInteger item = [[noti.userInfo objectForKey:@"item"] integerValue];
    
    if ([TheCustomer.authoritys[item] boolValue]) {
        Custom360ViewCtrl *vc = [[Custom360ViewCtrl alloc] init];
        vc.selectIndex = item;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (item == 10 || item == 11) {
            [Utils showToastMessage:@"该功能将于19年4月1日上线"];
        } else {
            [Utils showToastMessage:@"暂无权限"];
        }
    }
}

- (void)setUI {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - networking

- (void)loadNewDataWithHeader
{
    // 重新加载数据
    NSLog(@"重新加载数据");
    TheCustomer.page = 0;
    [self getList:TheCustomer.page];
}

- (void)loadMoreDataWithFooter
{
    // 下一页
    NSLog(@"加载数据下一页");
    [self getList:TheCustomer.page+1];
}

- (void)getList:(NSInteger)page {
//    [Utils showHUDWithStatus:nil];
    
    if (TheCustomer.fromTab == 0) {
        [[JYUserApi sharedInstance] getCustomerListDirection:nil property:nil size:10 rules:nil page:page specialDirection:nil specialConditions:nil success:^(id responseObject) {
            [self dealwithResultPage:page success:responseObject fialed:nil];
        } failure:^(NSError *error) {
            [self dealwithResultPage:page success:nil fialed:error];
        }];
    } else if(TheCustomer.fromTab == 1) {
        [[JYUserApi sharedInstance] searchCustomerListPage:page size:10 rules:nil keyword:nil specialConditions:nil success:^(id responseObject) {
            [self dealwithResultPage:page success:responseObject fialed:nil];
        } failure:^(NSError *error) {
            [self dealwithResultPage:page success:nil fialed:nil];
        }];
    } else if(TheCustomer.fromTab == 2) {
        [[JYUserApi sharedInstance] getFavoriteMemberPage:page success:^(id responseObject) {
            [self dealwithResultPage:page success:responseObject fialed:nil];
        } failure:^(NSError *error) {
            [self dealwithResultPage:page success:nil fialed:nil];
        }];
    }
}

- (void)dealwithResultPage:(NSInteger)page success:(id)responseObject fialed:(NSError *)error {
    [Utils dismissHUD];
    if (error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    } else {
        NSError *error = nil;
        NSMutableArray *tmpArr = [CustomerMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [self.arrData removeAllObjects];
            self.arrData = tmpArr;
            _index = 0;
        } else {
            if (tmpArr.count > 0) {
                [self.arrData addObjectsFromArray:tmpArr];
            }
        }
        TheCustomer.page = page;
        [self.collectionView reloadData];
    }
}
    
    
#pragma mark - UICollectionViewDataSource
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrData.count;
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYMemberCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    CustomerMo *model = nil;
//    model = self.arrData[indexPath.item];
//    [cell loadData:model];
    
    // 是否需要刷新下一页
    if (!_forbidRefresh) {
        if (indexPath.item == self.arrData.count-1) {
            [self loadMoreDataWithFooter];
        }
    }
    return cell;
}

//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.collectionView.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _index -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _index += 1;//向左
    }
    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    _index = _index <= 0 ? 0 : _index;
    _index = _index >= maxIndex ? maxIndex : _index;
    [self scrollToCenter];
}

// 滚动到中间
- (void)scrollToCenter {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    CustomerMo *model = nil;
    model = self.arrData[_index];
    JYMemberCollectionCell *cell = (JYMemberCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    [cell loadData:model];
    
//    [TheCustomer updateCustomer:cell.model];
//    TheCustomer.centerMo = cell.centerMo;
//    TheCustomer.authorityBean = cell.authorityBean;
    
    NSLog(@"--cell --- scrollToCenter : %ld %@", _index, model.orgName);
}

#pragma mark - event

- (void)delayGotoCurrentIndex {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToCenter];
    });
}

#pragma mark - lazy

- (JYMemberCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.view.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[JYMemberCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_B0;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

@end
