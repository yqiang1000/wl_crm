//
//  DebtListTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/8/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerMo.h"

@interface DebtListTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrData;

@end

@interface DebtListCell : UITableViewCell

@property (nonatomic, strong) UILabel *labNum;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labCreditNum;
@property (nonatomic, strong) UILabel *labMoney;
@property (nonatomic, strong) CustomerMo *model;

- (void)loadData:(CustomerMo *)model;

@end
