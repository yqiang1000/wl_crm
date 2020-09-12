//
//  PurchaseSupplierCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesCustomerMo.h"
#import "SupplierCustomerMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseSupplierCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labComplany;
@property (nonatomic, strong) UILabel *labBusiness;

@property (nonatomic, strong) UILabel *labSort;
@property (nonatomic, strong) UILabel *labSortType;

@property (nonatomic, strong) UIButton *btnPurchase;
@property (nonatomic, strong) UIButton *btnProduction;
@property (nonatomic, strong) UIButton *btnSale;

@property (nonatomic, strong) JSONModel *mo;

- (void)loadData:(JSONModel *)mo;

@end

NS_ASSUME_NONNULL_END
