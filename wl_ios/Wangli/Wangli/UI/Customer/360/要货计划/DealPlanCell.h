//
//  DealPlanCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealPlanMo.h"
#import "UAProgressView.h"

@interface DealPlanCell : UITableViewCell

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labFrom;
@property (nonatomic, strong) UILabel *labState;

@property (nonatomic, strong) UILabel *labYear;
@property (nonatomic, strong) UILabel *labMonth;

@property (nonatomic, strong) UILabel *labLevel;
@property (nonatomic, strong) UILabel *labWeight;
@property (nonatomic, strong) UILabel *labTotalSend;
@property (nonatomic, strong) UILabel *labRealSend;

@property (nonatomic, strong) UAProgressView *progressView;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) DealPlanMo *model;

- (void)loadDataWith:(DealPlanMo *)model orgName:(NSString *)orgName;

@end
