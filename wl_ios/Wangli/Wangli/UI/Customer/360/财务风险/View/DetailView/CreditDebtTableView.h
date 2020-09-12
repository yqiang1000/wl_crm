//
//  CreditDebtTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/8/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditDebtMo.h"
#import "DebtListTableView.h"

@interface CreditDebtTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrData;

@end


@interface CreditDebtCell : UITableViewCell

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) DebtListTableView *tableView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labTotal;


@property (nonatomic, strong) CreditDebtMo *model;

- (void)loadData:(CreditDebtMo *)model;

@end
