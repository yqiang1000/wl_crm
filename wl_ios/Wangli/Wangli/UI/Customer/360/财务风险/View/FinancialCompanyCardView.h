//
//  FinancialCompanyCardView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditDebtTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinancialCompanyCardView : UIView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) CreditDebtTableView *tableView;

- (void)creditFiftyRefreshView;

@end

NS_ASSUME_NONNULL_END
