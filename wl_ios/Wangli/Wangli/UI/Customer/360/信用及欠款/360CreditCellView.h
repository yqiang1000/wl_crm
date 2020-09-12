//
//  360CreditCellView.h
//  Wangli
//
//  Created by yeqiang on 2018/8/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditTableView.h"
#import "CreditDebtTableView.h"

@class CustDeptMo;

#pragma mark - CreditFirstCell

@interface CreditFirstCell : UIView

@property (nonatomic, strong) NSMutableArray *arrData;

- (void)loadDataWith:(NSArray *)model;

@end

#pragma mark - CreditSecondCell

@interface CreditSecondCell : UIView

@property (nonatomic, strong) NSMutableArray *arrData;

- (void)loadDataWith:(NSDictionary *)model;

@end

#pragma mark - CreditThirdCell

@interface CreditThirdCell : UIView

@property (nonatomic, strong) NSMutableArray *arrData;
- (void)loadDataWith:(NSDictionary *)model;

@end

#pragma mark - CreditFouthCell

typedef void(^BtnDetailBlock)(void);

@interface CreditFouthCell : UIView

@property (nonatomic, copy) BtnDetailBlock btnDetailBlock;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) CreditTableView *tableView;
@property (nonatomic, strong) UIButton *btnDetail;

- (void)loadDataWith:(NSDictionary *)model;

@end


#pragma mark - CreditFiftyCell

@interface CreditFiftyCell : UIView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) CreditDebtTableView *tableView;

- (void)creditFiftyRefreshView;

@end


#pragma mark - CreditSixthCell

@interface CreditSixthCell : UIView

@property (nonatomic, strong) NSMutableArray *arrData;

- (void)loadDataWith:(CustDeptMo *)model;

@end
