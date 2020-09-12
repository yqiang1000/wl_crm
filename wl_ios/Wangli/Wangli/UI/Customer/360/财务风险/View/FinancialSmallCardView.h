//
//  FinancialSmallCardView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditMo.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - FinancialSmallCardView

@interface FinancialSmallCardView : UIView

@property (nonatomic, strong) NSMutableArray *arrSmallData;
@property (nonatomic, copy) NSString *msg;

- (void)refreshView;

@end

#pragma mark - FinancialSmallCell

@interface FinancialSmallCell : UICollectionViewCell

@property (nonatomic, strong) CreditMo *model;
- (void)loadDataWith:(CreditMo *)model;

@end

NS_ASSUME_NONNULL_END
