//
//  PurchaseSupplierTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "PurchaseSupplierTableView.h"
#import "PurchaseSupplierCell.h"
#import "PurchaseCollectionView.h"
#import "PurchaseListTitleView.h"
#import "BaseViewCtrl.h"

@interface PurchaseSupplierTableView () <UITableViewDelegate, UITableViewDataSource, PurchaseCollectionViewDelegate>

@property (nonatomic, strong) PurchaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UIView *topHeader;
@property (nonatomic, strong) NSMutableArray *arrCardData;
@property (nonatomic, strong) PurchaseListTitleView *listTitleView;

@end

@implementation PurchaseSupplierTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _currentTag = 0;
        self.tableHeaderView = self.topHeader;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PersonBusinessCell";
    PurchaseSupplierCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PurchaseSupplierCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell loadData:self.arrData[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.listTitleView;
}

#pragma mark - UITableViewDelegate


#pragma mark - PurchaseCollectionViewDelegate

- (void)purchaseCollectionView:(PurchaseCollectionView *)purchaseCollectionView didSelectedIndexPath:(NSIndexPath *)indexPath purchaseItemMo:(PurchaseItemMo *)purchaseItemMo {
    _currentTag = indexPath.item;
//    [self reloadData];
//    if (indexPath.item == 0) {
//        if (_supplierTableView) [self initSupplierTableView];
//    } else if (indexPath.item == 1) {
//
//    } else if (indexPath.item == 2) {
//
//    } else if (indexPath.item == 3) {
//
//    }
    [_listTitleView setupTitle:purchaseItemMo.fieldValue count:purchaseItemMo.count];
    [self reloadData];
//    _supplierTableView.hidden = (indexPath.item == 0) ? NO : YES;
}


#pragma mark - event

- (void)setUpdateHiden:(BOOL)updateHiden {
    if (!updateHiden) {
        if (self.arrCardData.count > 0) {
            PurchaseItemMo *itemMo = self.arrCardData[0];
            [self.listTitleView setupTitle:itemMo.fieldValue count:itemMo.count];
        }
        self.collectionView.arrCardData = self.arrCardData;
        [self.collectionView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.topHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, _collectionView.collectionViewLayout.collectionViewContentSize.height);
            [self reloadData];
            [self layoutIfNeeded];
        });
    }
}

- (void)itemAddClick:(UIButton *)sender {
    BaseViewCtrl *vc = [BaseViewCtrl new];
    PurchaseItemMo *mo = self.arrCardData[_currentTag];
    vc.title = [NSString stringWithFormat:@"新建%@", mo.fieldValue];
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}


- (void)tableViewHeaderRefreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_arrData removeAllObjects];
        _arrData = nil;
        [self reloadData];
        [self.mj_header endRefreshing];
    });
}

- (void)tableViewFooterRefreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mj_footer endRefreshing];
        NSInteger count = self.arrData.count;
        for (int i = 0; i < 5; i++) {
            CustomerMo *mo = [[CustomerMo alloc] init];
            mo.headUrl = @"1";
            mo.abbreviation = [NSString stringWithFormat:@"通威---%ld", i+count];
            mo.transactionType = @"私企 | 大型 | 四川成都";
            mo.salesmanName = @"业务范围：硅片、电池片";
            mo.riskLevel = @"5";
            mo.lastTransactionDayCount = 20;
            mo.completeness = @"4";
            [_arrData addObject:mo];
        }
        [self reloadData];
    });
}

#pragma mark - lazy

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
        for (int i = 0; i < 10; i++) {
            CustomerMo *mo = [[CustomerMo alloc] init];
            mo.headUrl = @"1";
            mo.abbreviation = [NSString stringWithFormat:@"通威---%d", i];
            mo.transactionType = @"私企 | 大型 | 四川成都";
            mo.salesmanName = @"业务范围：硅片、电池片";
            mo.riskLevel = @"5";
            mo.lastTransactionDayCount = 20;
            mo.completeness = @"4";
            [_arrData addObject:mo];
        }
    }
    return _arrData;
}

- (PurchaseCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[PurchaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.purchaseCollectionViewDelegate = self;
    }
    return _collectionView;
}

- (UIView *)topHeader {
    if (!_topHeader) {
        _topHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _topHeader.backgroundColor = COLOR_C2;
        [_topHeader addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(_topHeader);
        }];
    }
    return _topHeader;
}

- (PurchaseListTitleView *)listTitleView {
    if (!_listTitleView) {
        _listTitleView  = [[PurchaseListTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [_listTitleView.btnAdd addTarget:self action:@selector(itemAddClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listTitleView;
}

- (NSMutableArray *)arrCardData {
    if (!_arrCardData) {
        _arrCardData = [NSMutableArray new];
        
        PurchaseItemMo *mo1 = [[PurchaseItemMo alloc] init];
        mo1.iconUrl = @"supplier_directory";
        mo1.fieldValue = @"供应商名录";
        mo1.count = 0;
        [_arrCardData addObject:mo1];
        
        PurchaseItemMo *mo2 = [[PurchaseItemMo alloc] init];
        mo2.iconUrl = @"purchasing_catalogue";
        mo2.fieldValue = @"采购目录";
        mo2.count = 1;
        [_arrCardData addObject:mo2];
        
        PurchaseItemMo *mo3 = [[PurchaseItemMo alloc] init];
        mo3.iconUrl = @"standard";
        mo3.fieldValue = @"准入/技检标准";
        mo3.count = 2;
        [_arrCardData addObject:mo3];
        
        PurchaseItemMo *mo4 = [[PurchaseItemMo alloc] init];
        mo4.iconUrl = @"checksystem";
        mo4.fieldValue = @"评价考核体系";
        mo4.count = 0;
        [_arrCardData addObject:mo4];
    }
    return _arrCardData;
}

@end
