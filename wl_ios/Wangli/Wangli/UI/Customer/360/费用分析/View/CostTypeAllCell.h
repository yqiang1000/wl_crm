//
//  CostTypeAllCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoastAllMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CostTypeAllCell : UITableViewCell

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labMsg;
@property (nonatomic, strong) UILabel *labPerson;
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) UILabel *labState;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) CoastAllMo *model;

- (void)loadData:(CoastAllMo *)model;

@end

NS_ASSUME_NONNULL_END
