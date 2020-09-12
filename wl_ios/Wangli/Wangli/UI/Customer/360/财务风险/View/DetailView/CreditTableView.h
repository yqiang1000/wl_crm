//
//  CreditTableView.h
//  Wangli
//
//  Created by yeqiang on 2018/8/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditMo.h"

@interface CreditTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrData;

@end

@interface CreditTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UILabel *labRight;
@property (nonatomic, strong) CreditMo *model;

- (void)loadData:(CreditMo *)model;

@end
