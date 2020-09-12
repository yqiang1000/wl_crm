//
//  TabCustomerCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/9.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "MGSwipeTableCell.h"
#import "CustomerMo.h"

@interface TabCustomerCell : MGSwipeTableCell

@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labCode;
@property (nonatomic, strong) UILabel *labBusiness;
@property (nonatomic, strong) UILabel *labState;

@property (nonatomic, strong) UIButton *btnAR;
@property (nonatomic, strong) UIButton *btnSR;
@property (nonatomic, strong) UIButton *btnFR;

@property (nonatomic, strong) CustomerMo *mo;

- (void)loadData:(CustomerMo *)mo;

@end
