//
//  PurchaseCatalogCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseCatalogMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseCatalogCell : UITableViewCell

@property (nonatomic, strong) PurchaseCatalogMo *model;
- (void)loadData:(PurchaseCatalogMo *)model;

@end

NS_ASSUME_NONNULL_END
