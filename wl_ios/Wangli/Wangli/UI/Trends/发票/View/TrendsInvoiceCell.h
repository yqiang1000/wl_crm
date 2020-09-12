//
//  TrendsInvoiceCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsBillingMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsInvoiceCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labYear;
@property (nonatomic, strong) UILabel *labMonth;
@property (nonatomic, strong) UILabel *labProduct;
@property (nonatomic, strong) UILabel *labCode;
//@property (nonatomic, strong) UILabel *labNum;
@property (nonatomic, strong) UILabel *labState;

@property (nonatomic, strong) TrendsBillingMo *model;

- (void)loadDataWith:(TrendsBillingMo *)model;

@end

NS_ASSUME_NONNULL_END
