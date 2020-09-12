//
//  SalesPriceCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesPriceMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SalesPriceCell : UITableViewCell

@property (nonatomic, strong) SalesPriceMo *model;

- (void)loadData:(SalesPriceMo *)model;

@end

NS_ASSUME_NONNULL_END
