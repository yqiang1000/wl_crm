//
//  FinancialArrearsDetailCardView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditTableView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^BtnDetailBlock)(void);

@interface FinancialArrearsDetailCardView : UIView

@property (nonatomic, copy) BtnDetailBlock btnDetailBlock;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) CreditTableView *tableView;
@property (nonatomic, strong) UIButton *btnDetail;

- (void)loadDataWith:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
