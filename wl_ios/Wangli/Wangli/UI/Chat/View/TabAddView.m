//
//  TabAddView.m
//  Wangli
//
//  Created by yeqiang on 2018/5/3.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "TabAddView.h"
#import "UIButton+ShortCut.h"
#import "CreateCustomerViewCtrl.h"
#import "TrendsCreateCircleViewCtrl.h"
#import "PersonnelCreateViewCtrl.h"
#import "CreateTaskViewCtrl.h"
#import "WebDetailViewCtrl.h"
#import "MemberSelectViewCtrl.h"
#import "RetailWorkPlanViewCtrl.h"
#import "DevelopWorkPlanViewCtrl.h"
#import "MarketWorkPlanViewCtrl.h"
#import "StrategicWorkPlanViewCtrl.h"
#import "DirectWorkPlanViewCtrl.h"
#import "CreateTravelViewCtrl.h"
#import "NengchengWorkPlanViewCtrl.h"
#import "HuajueWorkPlanViewCtrl.h"
#import "JinMuMenWorkPlanViewCtrl.h"
#import "CreateStoreViewCtrl.h"
#import "JYWorkPlanViewCtrl.h"
#import "TabAddCollectionCell.h"
#import "MuMenWorkPlanViewCtrl.h"
#import "DicMo.h"

typedef void(^ClickBlock)(NSInteger index);

typedef void(^CancelBlock)(TabAddView *obj);

@interface TabAddView () <MemberSelectViewCtrlDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) ClickBlock clickBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *usedTotal;

@end

@implementation TabAddView

- (instancetype)initWithFrame:(CGRect)frame btnClick:(void (^)(NSInteger))clickBlock cancel:(void (^)(TabAddView *obj))cancelBlock {
    self = [super initWithFrame:frame];
    if (self) {
        [self doFirst];
        self.backgroundColor = COLOR_B4;
        _clickBlock = clickBlock;
        _cancelBlock = cancelBlock;
        [self.collectionView registerClass:[TabAddCollectionCell class] forCellWithReuseIdentifier:@"TabAddCollectionCell"];
        [self setUI];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"TabAddView释放");
}

- (void)doFirst {
    NSArray *tmpImages = @[@"add_activity",
                           @"add_clue",
                           @"add_busine",
                           @"add_offer",
                           @"add_demand",
                           @"add_complaint"];
    NSInteger count = 0;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USED_TOTAL];
    NSArray *totalArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    for (int i = 0; i < totalArr.count; i++) {
        NSDictionary *categoryDic = totalArr[i];
        NSMutableArray *items = categoryDic[@"items"];
        if (items.count > 0) {
            for (int k = 0; k < items.count; k++) {
                NSDictionary *item = items[k];
                if (count >= tmpImages.count) count = 0;
                if ([item[@"url"] isEqualToString:@"action:7110"] ||
                    [item[@"url"] isEqualToString:@"action:7120"] ||
                    [item[@"url"] isEqualToString:@"action:7130"] ||
                    [item[@"url"] isEqualToString:@"action:7140"] ||
                    [item[@"url"] isEqualToString:@"action:7150"] ||
                    [item[@"url"] isEqualToString:@"action:7160"] ||
                    [item[@"url"] isEqualToString:@"action:7170"] ||
                    [item[@"url"] isEqualToString:@"action:7180"] ||
                    [item[@"url"] isEqualToString:@"action:7190"] ||
                    [item[@"url"] isEqualToString:@"action:7200"] ||
                    [item[@"url"] isEqualToString:@"action:7210"] ||
                    [item[@"url"] isEqualToString:@"action:7220"]) {
                    DicMo *tmpMo = [[DicMo alloc] init];
                    tmpMo.name = item[@"name"];
                    tmpMo.key = tmpImages[count];
                    tmpMo.value = item[@"url"];
                    [self.usedTotal addObject:tmpMo];
                    count++;
                }
            }
        }
    }
}

- (void)setUI {
    [self addSubview:self.labTitle];
    [self addSubview:self.collectionView];
    [self addSubview:self.btnCancel];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(30);
        make.left.right.equalTo(self);
        make.center.equalTo(self);
        make.bottom.lessThanOrEqualTo(self.btnCancel.mas_top).offset(-30);
    }];
    
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-60-KMagrinBottom);
        make.centerX.equalTo(self);
        make.height.width.equalTo(@42.0);
    }];
    
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat collectionH = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(collectionH));
            make.height.lessThanOrEqualTo(@(((IS_iPhoneX || IS_IPHONE6_PLUS) ? 100 : 80)*4));
        }];
        [self layoutIfNeeded];
    });
}

- (void)btnCancelClick:(UIButton *)sender {
    if (_cancelBlock) {
        _cancelBlock(self);
    }
}

#pragma mark - MemberSelectViewCtrlDelegate

- (void)memberSelectViewCtrl:(MemberSelectViewCtrl *)memberSelectViewCtrl selectedModel:(CustomerMo *)model indexPath:(NSIndexPath *)indexPath {
    if (model) {
        NSString *urlStr = [NSString stringWithFormat:@"%@id=%lld&token=%@", CREATE_ORDER_URL, model.id, [Utils token]];
        WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
        vc.urlStr = urlStr;
        vc.titleStr = @"新建订单";
        vc.iHiddenNav = YES;
        
        vc.hidesBottomBarWhenPushed = YES;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
    if (_cancelBlock) {
        _cancelBlock(self);
    }
}

- (void)memberSelectViewCtrlDismiss:(MemberSelectViewCtrl *)memberSelectViewCtrl {
    if (_cancelBlock) {
        _cancelBlock(self);
    }
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TabAddCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TabAddCollectionCell" forIndexPath:indexPath];
    DicMo *tmpDic = self.usedTotal[indexPath.item];
    cell.imgView.image = [UIImage imageNamed:tmpDic.key];
    cell.labText.text = tmpDic.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item;
    if (_clickBlock) {
        _clickBlock(index);
    }
    
    DicMo *tmpDic = self.usedTotal[indexPath.item];
    
    BaseViewCtrl *vc = nil;
    [TheCustomer releaseCustomers];
    if ([tmpDic.value isEqualToString:@"add_customer"]) {   // 新客户
        vc = [[CreateCustomerViewCtrl alloc] init];
    } else if ([tmpDic.value isEqualToString:@"add_contacts"]) { // 新建联系人
        PersonnelCreateViewCtrl *tmpVc = [[PersonnelCreateViewCtrl alloc] init];
        tmpVc.from360 = NO;
        vc = tmpVc;
    } else if ([tmpDic.value isEqualToString:@"add_task"]) { // 新任务
        vc = [[CreateTaskViewCtrl alloc] init];
    } else if ([tmpDic.value isEqualToString:@"add_intelligence"]) { // 门店
        CreateStoreViewCtrl *tmpVC = [[CreateStoreViewCtrl alloc] init];
        tmpVC.dynamicId = @"storme-manage-entity";
        tmpVC.isUpdate = NO;
        tmpVC.fromTab = YES;
        vc = tmpVC;
    } else if ([tmpDic.value isEqualToString:@"add_visit"]) {  // 差旅
        CreateTravelViewCtrl *tmpVC = [[CreateTravelViewCtrl alloc] init];
        tmpVC.dynamicId = @"travel-business";
        tmpVC.isUpdate = NO;
        tmpVC.detailId = -1;
        vc = tmpVC;
    } else if ([tmpDic.value isEqualToString:@"action:7110"]) {  // 零售
        RetailWorkPlanViewCtrl *tmpVC = [[RetailWorkPlanViewCtrl alloc] init];
        tmpVC.yesterdayData = YES;
        vc = tmpVC;
    } else if ([tmpDic.value isEqualToString:@"action:7120"]) {    // 渠道
        DevelopWorkPlanViewCtrl *tmpVC = [[DevelopWorkPlanViewCtrl alloc] init];
        tmpVC.yesterdayData = YES;
        vc = tmpVC;
    } else if ([tmpDic.value isEqualToString:@"action:7130"]) {    // 市场
        MarketWorkPlanViewCtrl *tmpVC = [[MarketWorkPlanViewCtrl alloc] init];
        tmpVC.yesterdayData = YES;
        vc = tmpVC;
    } else if ([tmpDic.value isEqualToString:@"action:7140"]) {    // 战略
        StrategicWorkPlanViewCtrl *tmpVC = [[StrategicWorkPlanViewCtrl alloc] init];
        tmpVC.yesterdayData = YES;
        vc = tmpVC;
    } else if ([tmpDic.value isEqualToString:@"action:7150"]) {   // 直营
        DirectWorkPlanViewCtrl *tmpVC = [[DirectWorkPlanViewCtrl alloc] init];
        vc = tmpVC;
    }  else if ([tmpDic.value isEqualToString:@"action:7160"]) {  // 能成
        NengchengWorkPlanViewCtrl *tmpVC = [[NengchengWorkPlanViewCtrl alloc] init];
        tmpVC.yesterdayData = YES;
        vc = tmpVC;
    } else if ([tmpDic.value isEqualToString:@"action:7170"]) {   // 华爵
        HuajueWorkPlanViewCtrl *tmpVC = [[HuajueWorkPlanViewCtrl alloc] init];
        tmpVC.yesterdayData = YES;
        vc = tmpVC;
    }
    else {
        JYWorkPlanViewCtrl *tmpVC = [[JYWorkPlanViewCtrl alloc] init];
        tmpVC.yesterdayData = YES;
        if ([tmpDic.value isEqualToString:@"action:7180"]) tmpVC.workType = JYWorkTypeJinMuMen;
        if ([tmpDic.value isEqualToString:@"action:7190"]) tmpVC.workType = JYWorkTypeMuMen;
        if ([tmpDic.value isEqualToString:@"action:7200"]) tmpVC.workType = JYWorkTypeLvMuMen;
        if ([tmpDic.value isEqualToString:@"action:7210"]) tmpVC.workType = JYWorkTypeTongMuMen;
        if ([tmpDic.value isEqualToString:@"action:7220"]) tmpVC.workType = JYWorkTypeZhiNengSuo;
        vc = tmpVC;
    }
    // 除了新建订单需要选择客户，其他都可以立马释放
    if (_cancelBlock) {
        _cancelBlock(self);
    }
    if (vc) {
        vc.title = tmpDic.name;
        vc.hidesBottomBarWhenPushed = YES;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.usedTotal.count;
}

#pragma mark - setter getter

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_B2;
        _labTitle.text = @"请点击下面图标新增业务对象";
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [[UIButton alloc] init];
        [_btnCancel setImage:[UIImage imageNamed:@"add_close"] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat btnHeight = (IS_iPhoneX || IS_IPHONE6_PLUS) ? 100 : 80;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH / 3.0), btnHeight);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = COLOR_B4;
        _collectionView.scrollEnabled = (self.usedTotal.count > 12) ? YES : NO;
    }
    return _collectionView;
}

- (NSMutableArray *)usedTotal {
    if (!_usedTotal) {
        _usedTotal = [NSMutableArray new];
        
        DicMo *mo1 = [[DicMo alloc] init];
        mo1.name = @"新客户";
        mo1.key = @"add_customer";
        mo1.value = @"add_customer";
        [_usedTotal addObject:mo1];
        
        DicMo *mo2 = [[DicMo alloc] init];
        mo2.name = @"新联系人";
        mo2.key = @"add_contacts";
        mo2.value = @"add_contacts";
        [_usedTotal addObject:mo2];
        
        DicMo *mo3 = [[DicMo alloc] init];
        mo3.name = @"新任务";
        mo3.key = @"add_task";
        mo3.value = @"add_task";
        [_usedTotal addObject:mo3];
        
        DicMo *mo5 = [[DicMo alloc] init];
        mo5.name = @"新建门店";
        mo5.key = @"add_intelligence";
        mo5.value = @"add_intelligence";
        [_usedTotal addObject:mo5];
        
        DicMo *mo6 = [[DicMo alloc] init];
        mo6.name = @"差旅计划";
        mo6.key = @"add_visit";
        mo6.value = @"add_visit";
        [_usedTotal addObject:mo6];
    }
    return _usedTotal;
}


@end
